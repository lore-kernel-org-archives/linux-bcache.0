From: Coly Li <colyli@suse.de>
Subject: [PATCH v6 9/9] bcache: stop bcache device when backing device is offline
Date: Thu,  8 Feb 2018 23:45:03 +0800
Message-ID: <20180208154503.92463-10-colyli@suse.de>
References: <20180208154503.92463-1-colyli@suse.de>
Return-path: <linux-bcache-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:47818 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751094AbeBHPqc (ORCPT <rfc822;linux-bcache@vger.kernel.org>);
        Thu, 8 Feb 2018 10:46:32 -0500
In-Reply-To: <20180208154503.92463-1-colyli@suse.de>
Sender: linux-bcache-owner@vger.kernel.org
List-Id: linux-bcache@vger.kernel.org
To: linux-bcache@vger.kernel.org
Cc: linux-block@vger.kernel.org, Coly Li <colyli@suse.de>, Michael Lyle <mlyle@lyle.org>, Junhui Tang <tang.junhui@zte.com.cn>

Currently bcache does not handle backing device failure, if backing
device is offline and disconnected from system, its bcache device can still
be accessible. If the bcache device is in writeback mode, I/O requests even
can success if the requests hit on cache device. That is to say, when and
how bcache handles offline backing device is undefined.

This patch tries to handle backing device offline in a rather simple way,
- Add cached_dev->status_update_thread kernel thread to update backing
  device status in every 1 second.
- Add cached_dev->offline_seconds to record how many seconds the backing
  device is observed to be offline. If the backing device is offline for
  BACKING_DEV_OFFLINE_TIMEOUT (30) seconds, set dc->io_disable to 1 and
  call bcache_device_stop() to stop the bache device which linked to the
  offline backing device.

Now if a backing device is offline for BACKING_DEV_OFFLINE_TIMEOUT seconds,
its bcache device will be removed, then user space application writing on
it will get error immediately, and handler the device failure in time.

This patch is quite simple, does not handle more complicated situations.
Once the bcache device is stopped, users need to recovery the backing
device, register and attach it manually.

Changelog:
v2: remove "bcache: " prefix when calling pr_warn().
v1: initial version.

Signed-off-by: Coly Li <colyli@suse.de>
Reviewed-by: Hannes Reinecke <hare@suse.com>
Cc: Michael Lyle <mlyle@lyle.org>
Cc: Junhui Tang <tang.junhui@zte.com.cn>
---
 drivers/md/bcache/bcache.h |  2 ++
 drivers/md/bcache/super.c  | 55 ++++++++++++++++++++++++++++++++++++++++++++++
 2 files changed, 57 insertions(+)

diff --git a/drivers/md/bcache/bcache.h b/drivers/md/bcache/bcache.h
index dbc4fb48c754..e465a661f32e 100644
--- a/drivers/md/bcache/bcache.h
+++ b/drivers/md/bcache/bcache.h
@@ -344,6 +344,7 @@ struct cached_dev {
 
 	struct keybuf		writeback_keys;
 
+	struct task_struct	*status_update_thread;
 	/*
 	 * Order the write-half of writeback operations strongly in dispatch
 	 * order.  (Maintain LBA order; don't allow reads completing out of
@@ -391,6 +392,7 @@ struct cached_dev {
 #define DEFAULT_CACHED_DEV_ERROR_LIMIT	64
 	atomic_t		io_errors;
 	unsigned		error_limit;
+	unsigned		offline_seconds;
 };
 
 enum alloc_reserve {
diff --git a/drivers/md/bcache/super.c b/drivers/md/bcache/super.c
index 1c5b7074bd6c..ea25cef924ff 100644
--- a/drivers/md/bcache/super.c
+++ b/drivers/md/bcache/super.c
@@ -654,6 +654,11 @@ static int ioctl_dev(struct block_device *b, fmode_t mode,
 		     unsigned int cmd, unsigned long arg)
 {
 	struct bcache_device *d = b->bd_disk->private_data;
+	struct cached_dev *dc = container_of(d, struct cached_dev, disk);
+
+	if (dc->io_disable)
+		return -EIO;
+
 	return d->ioctl(d, mode, cmd, arg);
 }
 
@@ -864,6 +869,45 @@ static void calc_cached_dev_sectors(struct cache_set *c)
 	c->cached_dev_sectors = sectors;
 }
 
+#define BACKING_DEV_OFFLINE_TIMEOUT 5
+static int cached_dev_status_update(void *arg)
+{
+	struct cached_dev *dc = arg;
+	struct request_queue *q;
+	char buf[BDEVNAME_SIZE];
+
+	/*
+	 * If this delayed worker is stopping outside, directly quit here.
+	 * dc->io_disable might be set via sysfs interface, so check it
+	 * here too.
+	 */
+	while (!kthread_should_stop() && !dc->io_disable) {
+		q = bdev_get_queue(dc->bdev);
+		if (blk_queue_dying(q))
+			dc->offline_seconds++;
+		else
+			dc->offline_seconds = 0;
+
+		if (dc->offline_seconds >= BACKING_DEV_OFFLINE_TIMEOUT) {
+			pr_err("%s: device offline for %d seconds",
+				bdevname(dc->bdev, buf),
+				BACKING_DEV_OFFLINE_TIMEOUT);
+			pr_err("%s: disable I/O request due to backing "
+				"device offline", dc->disk.name);
+			dc->io_disable = true;
+			/* let others know earlier that io_disable is true */
+			smp_mb();
+			bcache_device_stop(&dc->disk);
+			break;
+		}
+
+		schedule_timeout_interruptible(HZ);
+	}
+
+	dc->status_update_thread = NULL;
+	return 0;
+}
+
 void bch_cached_dev_run(struct cached_dev *dc)
 {
 	struct bcache_device *d = &dc->disk;
@@ -906,6 +950,15 @@ void bch_cached_dev_run(struct cached_dev *dc)
 	if (sysfs_create_link(&d->kobj, &disk_to_dev(d->disk)->kobj, "dev") ||
 	    sysfs_create_link(&disk_to_dev(d->disk)->kobj, &d->kobj, "bcache"))
 		pr_debug("error creating sysfs link");
+
+	dc->status_update_thread = kthread_run(cached_dev_status_update,
+					       dc,
+					      "bcache_status_update");
+	if (IS_ERR(dc->status_update_thread)) {
+		pr_warn("failed to create bcache_status_update kthread, "
+			"continue to run without monitoring backing "
+			"device status");
+	}
 }
 
 /*
@@ -1128,6 +1181,8 @@ static void cached_dev_free(struct closure *cl)
 		kthread_stop(dc->writeback_thread);
 	if (dc->writeback_write_wq)
 		destroy_workqueue(dc->writeback_write_wq);
+	if (!IS_ERR_OR_NULL(dc->status_update_thread))
+		kthread_stop(dc->status_update_thread);
 
 	if (atomic_read(&dc->running))
 		bd_unlink_disk_holder(dc->bdev, dc->disk.disk);
-- 
2.16.1
