From: Coly Li <colyli@suse.de>
Subject: [PATCH v4 08/13] bcache: stop all attached bcache devices for a retired cache set
Date: Sun, 28 Jan 2018 09:56:20 +0800
Message-ID: <20180128015625.128497-9-colyli@suse.de>
References: <20180128015625.128497-1-colyli@suse.de>
Return-path: <linux-block-owner@vger.kernel.org>
In-Reply-To: <20180128015625.128497-1-colyli@suse.de>
Sender: linux-block-owner@vger.kernel.org
To: linux-bcache@vger.kernel.org
Cc: linux-block@vger.kernel.org, Coly Li <colyli@suse.de>, Junhui Tang <tang.junhui@zte.com.cn>, Michael Lyle <mlyle@lyle.org>
List-Id: linux-bcache@vger.kernel.org

When there are too many I/O errors on cache device, current bcache code
will retire the whole cache set, and detach all bcache devices. But the
detached bcache devices are not stopped, which is problematic when bcache
is in writeback mode.

If the retired cache set has dirty data of backing devices, continue
writing to bcache device will write to backing device directly. If the
LBA of write request has a dirty version cached on cache device, next time
when the cache device is re-registered and backing device re-attached to
it again, the stale dirty data on cache device will be written to backing
device, and overwrite latest directly written data. This situation causes
a quite data corruption.

This patch checkes whether cache_set->io_disable is true in
__cache_set_unregister(). If cache_set->io_disable is true, it means cache
set is unregistering by too many I/O errors, then all attached bcache
devices will be stopped as well. If cache_set->io_disable is not true, it
means __cache_set_unregister() is triggered by writing 1 to sysfs file
/sys/fs/bcache/<UUID>/bcache/stop. This is an exception because users do
it explicitly, this patch keeps existing behavior and does not stop any
bcache device.

Even the failed cache device has no dirty data, stopping bcache device is
still a desired behavior by many Ceph and data base users. Then their
application will report I/O errors due to disappeared bcache device, and
operation people will know the cache device is broken or disconnected.

Changelog:
v2: add reviewed-by from Hannes.
v1: initial version for review.

Signed-off-by: Coly Li <colyli@suse.de>
Reviewed-by: Hannes Reinecke <hare@suse.com>
Cc: Junhui Tang <tang.junhui@zte.com.cn>
Cc: Michael Lyle <mlyle@lyle.org>
---
 drivers/md/bcache/super.c | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/drivers/md/bcache/super.c b/drivers/md/bcache/super.c
index 4204d75aee7b..97e3bb8e1aee 100644
--- a/drivers/md/bcache/super.c
+++ b/drivers/md/bcache/super.c
@@ -1478,6 +1478,14 @@ static void __cache_set_unregister(struct closure *cl)
 				dc = container_of(c->devices[i],
 						  struct cached_dev, disk);
 				bch_cached_dev_detach(dc);
+				/*
+				 * If we come here by too many I/O errors,
+				 * bcache device should be stopped too, to
+				 * keep data consistency on cache and
+				 * backing devices.
+				 */
+				if (test_bit(CACHE_SET_IO_DISABLE, &c->flags))
+					bcache_device_stop(c->devices[i]);
 			} else {
 				bcache_device_stop(c->devices[i]);
 			}
-- 
2.15.1
