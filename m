From: Coly Li <colyli@suse.de>
Subject: [PATCH v4 06/13] bcache: set error_limit correctly
Date: Sun, 28 Jan 2018 09:56:18 +0800
Message-ID: <20180128015625.128497-7-colyli@suse.de>
References: <20180128015625.128497-1-colyli@suse.de>
Return-path: <linux-bcache-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:49674 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751159AbeA1Gcu (ORCPT <rfc822;linux-bcache@vger.kernel.org>);
        Sun, 28 Jan 2018 01:32:50 -0500
In-Reply-To: <20180128015625.128497-1-colyli@suse.de>
Sender: linux-bcache-owner@vger.kernel.org
List-Id: linux-bcache@vger.kernel.org
To: linux-bcache@vger.kernel.org
Cc: linux-block@vger.kernel.org, Coly Li <colyli@suse.de>, Junhui Tang <tang.junhui@zte.com.cn>

Struct cache uses io_errors for two purposes,
- Error decay: when cache set error_decay is set, io_errors is used to
  generate a small piece of delay when I/O error happens.
- I/O errors counter: in order to generate big enough value for error
  decay, I/O errors counter value is stored by left shifting 20 bits (a.k.a
  IO_ERROR_SHIFT).

In function bch_count_io_errors(), if I/O errors counter reaches cache set
error limit, bch_cache_set_error() will be called to retire the whold cache
set. But current code is problematic when checking the error limit, see the
following code piece from bch_count_io_errors(),

 90     if (error) {
 91             char buf[BDEVNAME_SIZE];
 92             unsigned errors = atomic_add_return(1 << IO_ERROR_SHIFT,
 93                                                 &ca->io_errors);
 94             errors >>= IO_ERROR_SHIFT;
 95
 96             if (errors < ca->set->error_limit)
 97                     pr_err("%s: IO error on %s, recovering",
 98                            bdevname(ca->bdev, buf), m);
 99             else
100                     bch_cache_set_error(ca->set,
101                                         "%s: too many IO errors %s",
102                                         bdevname(ca->bdev, buf), m);
103     }

At line 94, errors is right shifting IO_ERROR_SHIFT bits, now it is real
errors counter to compare at line 96. But ca->set->error_limit is initia-
lized with an amplified value in bch_cache_set_alloc(),
1545         c->error_limit  = 8 << IO_ERROR_SHIFT;

It means by default, in bch_count_io_errors(), before 8<<20 errors happened
bch_cache_set_error() won't be called to retire the problematic cache
device. If the average request size is 64KB, it means bcache won't handle
failed device until 512GB data is requested. This is too large to be an I/O
threashold. So I believe the correct error limit should be much less.

This patch sets default cache set error limit to 8, then in
bch_count_io_errors() when errors counter reaches 8 (if it is default
value), function bch_cache_set_error() will be called to retire the whole
cache set. This patch also removes bits shifting when store or show
io_error_limit value via sysfs interface.

Nowadays most of SSDs handle internal flash failure automatically by LBA
address re-indirect mapping. If an I/O error can be observed by upper layer
code, it will be a notable error because that SSD can not re-indirect
map the problematic LBA address to an available flash block. This situation
indicates the whole SSD will be failed very soon. Therefore setting 8 as
the default io error limit value makes sense, it is enough for most of
cache devices.

Changelog:
v2: add reviewed-by from Hannes.
v1: initial version for review.

Signed-off-by: Coly Li <colyli@suse.de>
Reviewed-by: Hannes Reinecke <hare@suse.com>
Reviewed-by: Tang Junhui <tang.junhui@zte.com.cn>
Cc: Junhui Tang <tang.junhui@zte.com.cn>
---
 drivers/md/bcache/bcache.h | 1 +
 drivers/md/bcache/super.c  | 2 +-
 drivers/md/bcache/sysfs.c  | 4 ++--
 3 files changed, 4 insertions(+), 3 deletions(-)

diff --git a/drivers/md/bcache/bcache.h b/drivers/md/bcache/bcache.h
index 88d938c8d027..7d7512fa4f09 100644
--- a/drivers/md/bcache/bcache.h
+++ b/drivers/md/bcache/bcache.h
@@ -663,6 +663,7 @@ struct cache_set {
 		ON_ERROR_UNREGISTER,
 		ON_ERROR_PANIC,
 	}			on_error;
+#define DEFAULT_IO_ERROR_LIMIT 8
 	unsigned		error_limit;
 	unsigned		error_decay;
 
diff --git a/drivers/md/bcache/super.c b/drivers/md/bcache/super.c
index 6d888e8fea8c..a373648b5d4b 100644
--- a/drivers/md/bcache/super.c
+++ b/drivers/md/bcache/super.c
@@ -1583,7 +1583,7 @@ struct cache_set *bch_cache_set_alloc(struct cache_sb *sb)
 
 	c->congested_read_threshold_us	= 2000;
 	c->congested_write_threshold_us	= 20000;
-	c->error_limit	= 8 << IO_ERROR_SHIFT;
+	c->error_limit	= DEFAULT_IO_ERROR_LIMIT;
 
 	return c;
 err:
diff --git a/drivers/md/bcache/sysfs.c b/drivers/md/bcache/sysfs.c
index b7166c504cdb..ba62e987b503 100644
--- a/drivers/md/bcache/sysfs.c
+++ b/drivers/md/bcache/sysfs.c
@@ -560,7 +560,7 @@ SHOW(__bch_cache_set)
 
 	/* See count_io_errors for why 88 */
 	sysfs_print(io_error_halflife,	c->error_decay * 88);
-	sysfs_print(io_error_limit,	c->error_limit >> IO_ERROR_SHIFT);
+	sysfs_print(io_error_limit,	c->error_limit);
 
 	sysfs_hprint(congested,
 		     ((uint64_t) bch_get_congested(c)) << 9);
@@ -660,7 +660,7 @@ STORE(__bch_cache_set)
 	}
 
 	if (attr == &sysfs_io_error_limit)
-		c->error_limit = strtoul_or_return(buf) << IO_ERROR_SHIFT;
+		c->error_limit = strtoul_or_return(buf);
 
 	/* See count_io_errors() for why 88 */
 	if (attr == &sysfs_io_error_halflife)
-- 
2.15.1
