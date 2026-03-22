Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6BEC732D7FF;
	Sun, 22 Mar 2026 13:41:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774186870; cv=none; b=uI6RuFQd/d0XU4YS+VNlJIdAjZzAlsSJNmMGnpAjGbNBS9UWoeSeEn+EWxaOQYS1PcwQ61MnnuqpgORYYmx+8xJMgEEDChY5BSxPZ13HkqSY7Ot/HbwhR6GtBNLVbLxtEE71mYHxmdySaxn78QERyCG0QY8GN2P31KGazCMxhec=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774186870; c=relaxed/simple;
	bh=eCEkiN58Xyxy1hwGJsCam4Mju4eWxjo/7smrhQqR7BA=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=Sq1oi8oenxpb7KYz5z7pBxl1d0Wd9W2tuwBQql7uEVV3v6tvXX4GoLMkI1fEYMY8NZFcUbpFD7G9kctV6onA/xtr4dE31fZQTFzulEXyImGgnPsET+tnlL33M/9+NO7WMpg4IJ2EDGUg550svz8v+WON92Gb+v90LYSF/epoMFo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3112FC19424;
	Sun, 22 Mar 2026 13:41:06 +0000 (UTC)
From: colyli@fnnas.com
To: axboe@kernel.org
Cc: linux-bcache@vger.kernel.org,
	linux-block@vger.kernel.org,
	Mingzhe Zou <mingzhe.zou@easystack.cn>,
	stable@vger.kernel.org,
	Coly Li <colyli@fnnas.com>
Subject: [PATCH v2] bcache: fix cached_dev.sb_bio use-after-free and crash
Date: Sun, 22 Mar 2026 21:41:02 +0800
Message-ID: <20260322134102.480107-1-colyli@fnnas.com>
X-Mailer: git-send-email 2.47.3
Precedence: bulk
X-Mailing-List: linux-bcache@vger.kernel.org
List-Id: <linux-bcache.vger.kernel.org>
List-Subscribe: <mailto:linux-bcache+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcache+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

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

After analyzing the coredump file, we found that the address of
dc->sb_bio has been freed. We know that cached_dev is only freed when it
is stopped.

Since sb_bio is a part of struct cached_dev, rather than an alloc every
time.  If the device is stopped while writing to the superblock, the
released address will be accessed at endio.

This patch hopes to wait for sb_write to complete in cached_dev_free.

It should be noted that we analyzed the cause of the problem, then tell
all details to the QWEN and adopted the modifications it made.

Signed-off-by: Mingzhe Zou <mingzhe.zou@easystack.cn>
Fixes: cafe563591446 ("bcache: A block layer cache")
Cc: stable@vger.kernel.org # 3.10+
Signed-off-by: Coly Li <colyli@fnnas.com>
---
Change log,
v2, fix emiail address type to stable kerenl.
v1, initial version.

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
2.47.3

