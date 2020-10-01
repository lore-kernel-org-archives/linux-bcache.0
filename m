Return-Path: <SRS0=Ei6X=DI=vger.kernel.org=linux-bcache-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.7 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AD31BC4727E
	for <linux-bcache@archiver.kernel.org>; Thu,  1 Oct 2020 06:51:09 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 6FD322085B
	for <linux-bcache@archiver.kernel.org>; Thu,  1 Oct 2020 06:51:09 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730884AbgJAGvJ (ORCPT
        <rfc822;linux-bcache@archiver.kernel.org>);
        Thu, 1 Oct 2020 02:51:09 -0400
Received: from mx2.suse.de ([195.135.220.15]:33388 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725892AbgJAGvI (ORCPT <rfc822;linux-bcache@vger.kernel.org>);
        Thu, 1 Oct 2020 02:51:08 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id 0F604B012;
        Thu,  1 Oct 2020 06:51:06 +0000 (UTC)
From:   Coly Li <colyli@suse.de>
To:     axboe@kernel.dk
Cc:     linux-bcache@vger.kernel.org, linux-block@vger.kernel.org,
        Coly Li <colyli@suse.de>
Subject: [PATCH 01/15] bcache: share register sysfs with async register
Date:   Thu,  1 Oct 2020 14:50:42 +0800
Message-Id: <20201001065056.24411-2-colyli@suse.de>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20201001065056.24411-1-colyli@suse.de>
References: <20201001065056.24411-1-colyli@suse.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-bcache.vger.kernel.org>
X-Mailing-List: linux-bcache@vger.kernel.org

Previously the experimental async registration uses a separate sysfs
file register_async. Now the async registration code seems working well
for a while, we can do furtuher testing with it now.

This patch changes the async bcache registration shares the same sysfs
file /sys/fs/bcache/register (and register_quiet). Async registration
will be default behavior if BCACHE_ASYNC_REGISTRATION is set in kernel
configure. By default, BCACHE_ASYNC_REGISTRATION is not configured yet.

Signed-off-by: Coly Li <colyli@suse.de>
---
 drivers/md/bcache/super.c | 12 +++++++-----
 1 file changed, 7 insertions(+), 5 deletions(-)

diff --git a/drivers/md/bcache/super.c b/drivers/md/bcache/super.c
index 1bbdc410ee3c..61abd6499a11 100644
--- a/drivers/md/bcache/super.c
+++ b/drivers/md/bcache/super.c
@@ -2449,7 +2449,6 @@ static ssize_t bch_pending_bdevs_cleanup(struct kobject *k,
 
 kobj_attribute_write(register,		register_bcache);
 kobj_attribute_write(register_quiet,	register_bcache);
-kobj_attribute_write(register_async,	register_bcache);
 kobj_attribute_write(pendings_cleanup,	bch_pending_bdevs_cleanup);
 
 static bool bch_is_open_backing(struct block_device *bdev)
@@ -2572,6 +2571,11 @@ static ssize_t register_bcache(struct kobject *k, struct kobj_attribute *attr,
 	struct cache_sb_disk *sb_disk;
 	struct block_device *bdev;
 	ssize_t ret;
+	bool async_registration = false;
+
+#ifdef CONFIG_BCACHE_ASYNC_REGISTRATION
+	async_registration = true;
+#endif
 
 	ret = -EBUSY;
 	err = "failed to reference bcache module";
@@ -2625,7 +2629,8 @@ static ssize_t register_bcache(struct kobject *k, struct kobj_attribute *attr,
 		goto out_blkdev_put;
 
 	err = "failed to register device";
-	if (attr == &ksysfs_register_async) {
+
+	if (async_registration) {
 		/* register in asynchronous way */
 		struct async_reg_args *args =
 			kzalloc(sizeof(struct async_reg_args), GFP_KERNEL);
@@ -2888,9 +2893,6 @@ static int __init bcache_init(void)
 	static const struct attribute *files[] = {
 		&ksysfs_register.attr,
 		&ksysfs_register_quiet.attr,
-#ifdef CONFIG_BCACHE_ASYNC_REGISTRATION
-		&ksysfs_register_async.attr,
-#endif
 		&ksysfs_pendings_cleanup.attr,
 		NULL
 	};
-- 
2.26.2

