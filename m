Received: from mail-m49235.qiye.163.com (mail-m49235.qiye.163.com [45.254.49.235])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 79C35233149
	for <linux-bcache@vger.kernel.org>; Wed, 18 Mar 2026 15:17:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.254.49.235
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773847025; cv=none; b=DT8DSgbtQizaOkIRW3lgvYb6DTwgRbRORQ62sV8xYCBT6OUUfeCpLS2Opt0vvVB88FirDtz4188VMSv5ZVE3HeQvTfR2Z2WV8U33fNy2LaEPpdax8M3bPVuZXixK6b2AGca5KS5CDYD3+HV8Yz92XMs3MyM0fw/t5GBKbQNefjI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773847025; c=relaxed/simple;
	bh=V9Zq9AAR178SEwvhQUqNzjE1Rel44h3gK6ry/musLfA=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=EGBjWNRdnlZdkkl28Vy01XZ/eAoQtepw+7+Hh4MZhKJMe+QoofWZ8FZW+aqG8VcuSwF2QJp/RB1ozER/ImQPIF0l9mzU0dtm7j1WMFHdFrcE5YY1a/EWu6uQ/dZVM30zJSAbZJzkfZdWAwHxMqNRSAUjJFKtkSUaHrgpRo91TOI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=easystack.cn; spf=pass smtp.mailfrom=easystack.cn; arc=none smtp.client-ip=45.254.49.235
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=easystack.cn
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=easystack.cn
Received: from localhost.localdomain (unknown [218.94.118.90])
	by smtp.qiye.163.com (Hmail) with ESMTP id 17caea7ec;
	Wed, 18 Mar 2026 20:54:29 +0800 (GMT+08:00)
From: mingzhe.zou@easystack.cn
To: colyli@kernel.org
Cc: linux-bcache@vger.kernel.org,
	zoumingzhe@qq.com,
	zoumingzhe@outlook.com,
	Mingzhe Zou <mingzhe.zou@easystack.cn>
Subject: [PATCH] bcache: fix cached_dev.sb_bio use-after-free and crash
Date: Wed, 18 Mar 2026 20:53:49 +0800
Message-Id: <20260318125349.193622-1-mingzhe.zou@easystack.cn>
X-Mailer: git-send-email 2.34.1
Precedence: bulk
X-Mailing-List: linux-bcache@vger.kernel.org
List-Id: <linux-bcache.vger.kernel.org>
List-Subscribe: <mailto:linux-bcache+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcache+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-HM-Tid: 0a9d010308b2022bkunm91c4928b2ccc0c
X-HM-MType: 1
X-HM-Spam-Status: e1kfGhgUHx5ZQUpXWQgPGg8OCBgUHx5ZQUlOS1dZFg8aDwILHllBWSg2Ly
	tZV1koWUFJQjdXWS1ZQUlXWQ8JGhUIEh9ZQVkZSRhNVk4aSx1NQkIZGEhCTlYVFAkWGhdVGRETFh
	oSFyQUDg9ZV1kYEgtZQVlJSkNVQk9VSkpDVUJLWVdZFhoPEhUdFFlBWU9LSFVKS0lPT09IVUpLS1
	VKQktLWQY+

From: Mingzhe Zou <mingzhe.zou@easystack.cn>

In our production environment, we have received multiple crash reports
regarding libceph, which have caught our attention:

```
[6888366.280350] Call Trace:
[6888366.280452]  blk_update_request+0x14e/0x370
[6888366.280561]  blk_mq_end_request+0x1a/0x130
[6888366.280671]  rbd_img_handle_request+0x1a0/0x1b0 [rbd]
[6888366.280792]  rbd_obj_handle_request+0x32/0x40 [rbd]
[6888366.280903]  __complete_request+0x22/0x70 [libceph]
[6888366.281032]  osd_dispatch+0x15e/0xb40 [libceph]
[6888366.281164]  ? inet_recvmsg+0x5b/0xd0
[6888366.281272]  ? ceph_tcp_recvmsg+0x6f/0xa0 [libceph]
[6888366.281405]  ceph_con_process_message+0x79/0x140 [libceph]
[6888366.281534]  ceph_con_v1_try_read+0x5d7/0xf30 [libceph]
[6888366.281661]  ceph_con_workfn+0x329/0x680 [libceph]
```

After analyzing the coredump file, we found that the address of dc->sb_bio
has been freed. We know that cached_dev is only freed when it is stopped.

Since sb_bio is a part of struct cached_dev, rather than an alloc every time.
If the device is stopped while writing to the superblock, the released address
will be accessed at endio.

This patch hopes to wait for sb_write to complete in cached_dev_free.

It should be noted that we analyzed the cause of the problem, then tell
all details to the QWEN and adopted the modifications it made.

Signed-off-by: Mingzhe Zou <mingzhe.zou@easystack.cn>
---
 drivers/md/bcache/super.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/drivers/md/bcache/super.c b/drivers/md/bcache/super.c
index 64bb38c95895..6627a381f65a 100644
--- a/drivers/md/bcache/super.c
+++ b/drivers/md/bcache/super.c
@@ -1373,6 +1373,13 @@ static CLOSURE_CALLBACK(cached_dev_free)
 
 	mutex_unlock(&bch_register_lock);
 
+	/*
+	 * Wait for any pending sb_write to complete before free.
+	 * The sb_bio is embedded in struct cached_dev, so we must
+	 * ensure no I/O is in progress.
+	 */
+	closure_sync(&dc->sb_write);
+
 	if (dc->sb_disk)
 		folio_put(virt_to_folio(dc->sb_disk));
 
-- 
2.34.1

