From: Kent Overstreet <kent.overstreet@gmail.com>
Subject: [PATCH 08/12] block: Add some exports for bcachefs
Date: Mon, 10 Jun 2019 15:14:16 -0400
Message-ID: <20190610191420.27007-9-kent.overstreet@gmail.com>
References: <20190610191420.27007-1-kent.overstreet@gmail.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20190610191420.27007-1-kent.overstreet@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org, linux-bcache@vger.kernel.org
Cc: Kent Overstreet <kent.overstreet@gmail.com>
List-Id: linux-bcache@vger.kernel.org

Signed-off-by: Kent Overstreet <kent.overstreet@gmail.com>
---
 block/bio.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/block/bio.c b/block/bio.c
index 716510ecd7..a67aa6e0de 100644
--- a/block/bio.c
+++ b/block/bio.c
@@ -958,6 +958,7 @@ int bio_iov_iter_get_pages(struct bio *bio, struct iov_iter *iter)
 
 	return 0;
 }
+EXPORT_SYMBOL_GPL(bio_iov_iter_get_pages);
 
 static void submit_bio_wait_endio(struct bio *bio)
 {
@@ -1658,6 +1659,7 @@ void bio_set_pages_dirty(struct bio *bio)
 			set_page_dirty_lock(bvec->bv_page);
 	}
 }
+EXPORT_SYMBOL_GPL(bio_set_pages_dirty);
 
 static void bio_release_pages(struct bio *bio)
 {
@@ -1731,6 +1733,7 @@ void bio_check_pages_dirty(struct bio *bio)
 	spin_unlock_irqrestore(&bio_dirty_lock, flags);
 	schedule_work(&bio_dirty_work);
 }
+EXPORT_SYMBOL_GPL(bio_check_pages_dirty);
 
 void update_io_ticks(struct hd_struct *part, unsigned long now)
 {
-- 
2.20.1
