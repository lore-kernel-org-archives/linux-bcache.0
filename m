From: kungf <wings.wyang@gmail.com>
Subject: [PATCH] bcache: add REQ_FUA to avoid data lost in writeback mode
Date: Mon,  2 Dec 2019 18:24:09 +0800
Message-ID: <20191202102409.3980-1-wings.wyang@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: colyli@suse.de
Cc: kent.overstreet@gmail.com, linux-bcache@vger.kernel.org, linux-kernel@vger.kernel.org, kungf <wings.wyang@gmail.com>
List-Id: linux-bcache@vger.kernel.org

data may lost when in the follow scene of writeback mode:
1. client write data1 to bcache
2. client fdatasync
3. bcache flush cache set and backing device
if now data1 was not writed back to backing, it was only guaranteed safe in cache.
4.then cache writeback data1 to backing with only REQ_OP_WRITE
So data1 was not guaranteed in non-volatile storage,  it may lost if  power interruption 

Signed-off-by: kungf <wings.wyang@gmail.com>
---
 drivers/md/bcache/writeback.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/md/bcache/writeback.c b/drivers/md/bcache/writeback.c
index 4a40f9eadeaf..e5cecb60569e 100644
--- a/drivers/md/bcache/writeback.c
+++ b/drivers/md/bcache/writeback.c
@@ -357,7 +357,7 @@ static void write_dirty(struct closure *cl)
 	 */
 	if (KEY_DIRTY(&w->key)) {
 		dirty_init(w);
-		bio_set_op_attrs(&io->bio, REQ_OP_WRITE, 0);
+		bio_set_op_attrs(&io->bio, REQ_OP_WRITE | REQ_FUA, 0);
 		io->bio.bi_iter.bi_sector = KEY_START(&w->key);
 		bio_set_dev(&io->bio, io->dc->bdev);
 		io->bio.bi_end_io	= dirty_endio;
-- 
2.17.1
