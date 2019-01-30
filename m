From: YueHaibing <yuehaibing@huawei.com>
Subject: [PATCH -next] bcache: Fix potential NULL pointer dereference
Date: Wed, 30 Jan 2019 18:21:12 +0800
Message-ID: <20190130102112.11228-1-yuehaibing@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: colyli@suse.de, kent.overstreet@gmail.com
Cc: linux-kernel@vger.kernel.org, linux-bcache@vger.kernel.org, YueHaibing <yuehaibing@huawei.com>
List-Id: linux-bcache@vger.kernel.org

There is a potential NULL pointer dereference in case
kzalloc() fails and returns NULL.

Fixes: bc082a55d25c ("bcache: fix inaccurate io state for detached bcache devices")
Signed-off-by: YueHaibing <yuehaibing@huawei.com>
---
 drivers/md/bcache/request.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/md/bcache/request.c b/drivers/md/bcache/request.c
index 1507041..a50afa4 100644
--- a/drivers/md/bcache/request.c
+++ b/drivers/md/bcache/request.c
@@ -1094,6 +1094,8 @@ static void detached_dev_do_request(struct bcache_device *d, struct bio *bio)
 	 * which would call closure_get(&dc->disk.cl)
 	 */
 	ddip = kzalloc(sizeof(struct detached_dev_io_private), GFP_NOIO);
+	if (!ddip)
+		return;
 	ddip->d = d;
 	ddip->start_time = jiffies;
 	ddip->bi_end_io = bio->bi_end_io;
-- 
2.7.0
