From: tang.junhui@zte.com.cn
Subject: [PATCH] bcache: increase the number of open buckets
Date: Sat, 24 Jun 2017 14:35:34 +0800
Message-ID: <1498286134-8252-1-git-send-email-tang.junhui@zte.com.cn>
Return-path: <linux-bcache-owner@vger.kernel.org>
Received: from out1.zte.com.cn ([202.103.147.172]:42839 "EHLO out1.zte.com.cn"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751258AbdFXGgt (ORCPT <rfc822;linux-bcache@vger.kernel.org>);
        Sat, 24 Jun 2017 02:36:49 -0400
Sender: linux-bcache-owner@vger.kernel.org
List-Id: linux-bcache@vger.kernel.org
To: kent.overstreet@gmail.com, i@coly.li, bcache@lists.ewheeler.net
Cc: linux-bcache@vger.kernel.org, tang.junhui@zte.com.cn

From: Tang Junhui <tang.junhui@zte.com.cn>

In currently, we only alloc 6 open buckets for each cache set,
but in usually, we always attach about 10 or so backend devices for
each cache set, and the each bcache device are always accessed by
about 10 or so threads in top application layer. So 6 open buckets
are too few, It has led to that each of the same thread write data
to different buckets, which would cause low efficiency write-back,
and also cause buckets inefficient, and would be Very easy to run
out of.

I add debug message in bch_open_buckets_alloc() to print alloc bucket
info, and test with ten bcache devices with a cache set, and each
bcache device is accessed by ten threads, before the modification,
the result is (only take one thread for example):
Jun 24 10:51:52 ceph192-9-9-153 kernel: [  525.627798]
task:ffff880328b99700, get open bucket ffff880c4f12e660, sectors_free=224
Jun 24 10:51:52 ceph192-9-9-153 kernel: [  525.638391]
task:ffff880328b99700, get open bucket ffff880c4f12e6c0, sectors_free=344
Jun 24 10:51:52 ceph192-9-9-153 kernel: [  525.650905]
task:ffff880328b99700, get open bucket ffff880c4f12e6c0, sectors_free=328
Jun 24 10:51:52 ceph192-9-9-153 kernel: [  525.656232]
task:ffff880328b99700, get open bucket ffff880c4f12e6c0, sectors_free=296
Jun 24 10:51:52 ceph192-9-9-153 kernel: [  525.661658]
task:ffff880328b99700, get open bucket ffff880c4f12e780, sectors_free=32
Jun 24 10:51:52 ceph192-9-9-153 kernel: [  525.662294]
task:ffff880328b99700, get open bucket ffff880c4f12e780, sectors_free=0
Jun 24 10:51:52 ceph192-9-9-153 kernel: [  525.662830]
task:ffff880328b99700, get open bucket ffff880c4f12e780, sectors_free=512
Jun 24 10:51:52 ceph192-9-9-153 kernel: [  525.667510]
task:ffff880328b99700, get open bucket ffff880c4f12e6c0, sectors_free=248
Jun 24 10:51:52 ceph192-9-9-153 kernel: [  525.671484]
task:ffff880328b99700, get open bucket ffff880c4f12e6c0, sectors_free=240
Jun 24 10:51:52 ceph192-9-9-153 kernel: [  525.681018]
task:ffff880328b99700, get open bucket ffff880c4f12e660, sectors_free=0
Jun 24 10:51:52 ceph192-9-9-153 kernel: [  525.687103]
task:ffff880328b99700, get open bucket ffff880c4f12e6c0, sectors_free=160
Jun 24 10:51:52 ceph192-9-9-153 kernel: [  525.694447]
task:ffff880328b99700, get open bucket ffff880c4f12e7e0, sectors_free=224
Jun 24 10:51:52 ceph192-9-9-153 kernel: [  525.698684]
task:ffff880328b99700, get open bucket ffff880c4f12e6c0, sectors_free=72
Jun 24 10:51:52 ceph192-9-9-153 kernel: [  525.701150]
task:ffff880328b99700, get open bucket ffff880c4f12e6c0, sectors_free=56
Jun 24 10:51:52 ceph192-9-9-153 kernel: [  525.703619]
task:ffff880328b99700, get open bucket ffff880c4f12e6c0, sectors_free=40

after the modification, the result is (only take one thread for example):
Jun 24 11:08:38 ceph192-9-9-153 kernel: [  486.015541]
task:ffff88032e221700, get open bucket ffff880bfe1fdde0, sectors_free=504
Jun 24 11:08:38 ceph192-9-9-153 kernel: [  486.026745]
task:ffff88032e221700, get open bucket ffff880bfe1fdde0, sectors_free=488
Jun 24 11:08:38 ceph192-9-9-153 kernel: [  486.035999]
task:ffff88032e221700, get open bucket ffff880bfe1fdde0, sectors_free=472
Jun 24 11:08:38 ceph192-9-9-153 kernel: [  486.064842]
task:ffff88032e221700, get open bucket ffff880bfe1fdde0, sectors_free=456
Jun 24 11:08:38 ceph192-9-9-153 kernel: [  486.072830]
task:ffff88032e221700, get open bucket ffff880bfe1fdde0, sectors_free=448
Jun 24 11:08:38 ceph192-9-9-153 kernel: [  486.078606]
task:ffff88032e221700, get open bucket ffff880bfe1fdde0, sectors_free=432
Jun 24 11:08:38 ceph192-9-9-153 kernel: [  486.083057]
task:ffff88032e221700, get open bucket ffff880bfe1fdde0, sectors_free=416
Jun 24 11:08:38 ceph192-9-9-153 kernel: [  486.086987]
task:ffff88032e221700, get open bucket ffff880bfe1fdde0, sectors_free=400
Jun 24 11:08:38 ceph192-9-9-153 kernel: [  486.091003]
task:ffff88032e221700, get open bucket ffff880bfe1fdde0, sectors_free=384
Jun 24 11:08:38 ceph192-9-9-153 kernel: [  486.093364]
task:ffff88032e221700, get open bucket ffff880bfe1fdde0, sectors_free=368
Jun 24 11:08:38 ceph192-9-9-153 kernel: [  486.095656]
task:ffff88032e221700, get open bucket ffff880bfe1fdde0, sectors_free=352
Jun 24 11:08:38 ceph192-9-9-153 kernel: [  486.097968]
task:ffff88032e221700, get open bucket ffff880bfe1fdde0, sectors_free=336
Jun 24 11:08:38 ceph192-9-9-153 kernel: [  486.100257]
task:ffff88032e221700, get open bucket ffff880bfe1fdde0, sectors_free=320

From the debug message, we can see that, after the modification, One
bucket is more likely to assign to the same thread, and the data from
the same thread are more likely to write the same bucket. Usually the
same thread always write/read the same backend device, so it is good
for write-back and also promote the usage efficiency of buckets.

Signed-off-by: Tang Junhui <tang.junhui@zte.com.cn>
---
 drivers/md/bcache/alloc.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/md/bcache/alloc.c b/drivers/md/bcache/alloc.c
index ca4abe1..cacbe2d 100644
--- a/drivers/md/bcache/alloc.c
+++ b/drivers/md/bcache/alloc.c
@@ -68,6 +68,8 @@
 #include <linux/random.h>
 #include <trace/events/bcache.h>
 
+#define MAX_OPEN_BUCKETS 128
+
 /* Bucket heap / gen */
 
 uint8_t bch_inc_gen(struct cache *ca, struct bucket *b)
@@ -671,7 +673,7 @@ int bch_open_buckets_alloc(struct cache_set *c)
 
 	spin_lock_init(&c->data_bucket_lock);
 
-	for (i = 0; i < 6; i++) {
+	for (i = 0; i < MAX_OPEN_BUCKETS; i++) {
 		struct open_bucket *b = kzalloc(sizeof(*b), GFP_KERNEL);
 		if (!b)
 			return -ENOMEM;
-- 
2.8.1.windows.1
