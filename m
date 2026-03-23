Received: from mail-m19731114.qiye.163.com (mail-m19731114.qiye.163.com [220.197.31.114])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 46B923A8752
	for <linux-bcache@vger.kernel.org>; Mon, 23 Mar 2026 13:35:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=220.197.31.114
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774272924; cv=none; b=ZyNM4HqiF9+mjUy2Aketv3pGoCFJymSLFDGXwB4TTHr23Icfq6trXLFzjWuR5tws852xtS9OEja66cNhAj0H3RFMTUbM2Ct1W5wmG2FWQ8rX812wpjxi34/vtxXg8zBpmrDWFfv9EwAdRaMLNyDNyju992PXEv2Up4rqPnbdeBA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774272924; c=relaxed/simple;
	bh=V9Zq9AAR178SEwvhQUqNzjE1Rel44h3gK6ry/musLfA=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=lj56h6kpT/GdAP01sLGQCWCM7HnHDZHHX0wjX7Si7TFdUdBTOXJRpYDIo5tp1wZYA4f8Hfh39Gpg/Y5brf/+fl/Fakt0F5cRUOOhEyrJ/WbL/eqaIdrIUZxvougy46/iFdl+wlR+waZTyo1OktwJ9PFYJYGVvT0sZhXeRJzD6eg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=easystack.cn; spf=pass smtp.mailfrom=easystack.cn; arc=none smtp.client-ip=220.197.31.114
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=easystack.cn
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=easystack.cn
Received: from localhost.localdomain (unknown [218.94.118.90])
	by smtp.qiye.163.com (Hmail) with ESMTP id 17fa12b1a;
	Mon, 23 Mar 2026 20:59:44 +0800 (GMT+08:00)
From: mingzhe.zou@easystack.cn
To: colyli@kernel.org,
	colyli@fnnas.com
Cc: linux-bcache@vger.kernel.org,
	zoumingzhe@qq.com,
	zoumingzhe@outlook.com,
	Mingzhe Zou <mingzhe.zou@easystack.cn>
Subject: [PATCH] bcache: fix cached_dev.sb_bio use-after-free and crash
Date: Mon, 23 Mar 2026 20:59:12 +0800
Message-Id: <20260323125912.220486-1-mingzhe.zou@easystack.cn>
X-Mailer: git-send-email 2.34.1
Precedence: bulk
X-Mailing-List: linux-bcache@vger.kernel.org
List-Id: <linux-bcache.vger.kernel.org>
List-Subscribe: <mailto:linux-bcache+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcache+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-HM-Tid: 0a9d1ac7a2e2022bkunm103e3af34a6c7c
X-HM-MType: 1
X-HM-Spam-Status: e1kfGhgUHx5ZQUpXWQgPGg8OCBgUHx5ZQUlOS1dZFg8aDwILHllBWSg2Ly
	tZV1koWUFJQjdXWS1ZQUlXWQ8JGhUIEh9ZQVlDT0hOVh1ITx4aGExMQx5MQ1YVFAkWGhdVGRETFh
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

