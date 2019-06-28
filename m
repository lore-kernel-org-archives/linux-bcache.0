From: Coly Li <colyli@suse.de>
Subject: [PATCH 20/37] bcache: fix mistaken sysfs entry for io_error counter
Date: Fri, 28 Jun 2019 19:59:43 +0800
Message-ID: <20190628120000.40753-21-colyli@suse.de>
References: <20190628120000.40753-1-colyli@suse.de>
Return-path: <stable-owner@vger.kernel.org>
In-Reply-To: <20190628120000.40753-1-colyli@suse.de>
Sender: stable-owner@vger.kernel.org
To: axboe@kernel.dk
Cc: linux-bcache@vger.kernel.org, linux-block@vger.kernel.org, Coly Li <colyli@suse.de>, stable@vger.kernel.org
List-Id: linux-bcache@vger.kernel.org

In bch_cached_dev_files[] from driver/md/bcache/sysfs.c, sysfs_errors is
incorrectly inserted in. The correct entry should be sysfs_io_errors.

This patch fixes the problem and now I/O errors of cached device can be
read from /sys/block/bcache<N>/bcache/io_errors.

Fixes: c7b7bd07404c5 ("bcache: add io_disable to struct cached_dev")
Signed-off-by: Coly Li <colyli@suse.de>
Cc: stable@vger.kernel.org
---
 drivers/md/bcache/sysfs.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/md/bcache/sysfs.c b/drivers/md/bcache/sysfs.c
index eb678e43ac00..dddb8d4048ce 100644
--- a/drivers/md/bcache/sysfs.c
+++ b/drivers/md/bcache/sysfs.c
@@ -176,7 +176,7 @@ SHOW(__bch_cached_dev)
 	var_print(writeback_percent);
 	sysfs_hprint(writeback_rate,
 		     wb ? atomic_long_read(&dc->writeback_rate.rate) << 9 : 0);
-	sysfs_hprint(io_errors,		atomic_read(&dc->io_errors));
+	sysfs_printf(io_errors,		"%i", atomic_read(&dc->io_errors));
 	sysfs_printf(io_error_limit,	"%i", dc->error_limit);
 	sysfs_printf(io_disable,	"%i", dc->io_disable);
 	var_print(writeback_rate_update_seconds);
@@ -463,7 +463,7 @@ static struct attribute *bch_cached_dev_files[] = {
 	&sysfs_writeback_rate_p_term_inverse,
 	&sysfs_writeback_rate_minimum,
 	&sysfs_writeback_rate_debug,
-	&sysfs_errors,
+	&sysfs_io_errors,
 	&sysfs_io_error_limit,
 	&sysfs_io_disable,
 	&sysfs_dirty_data,
-- 
2.16.4
