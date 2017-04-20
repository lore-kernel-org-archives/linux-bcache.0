From: NeilBrown <neilb@suse.com>
Subject: [PATCH 09/11] bcache: use kmalloc to allocate bio in
 bch_data_verify()
Date: Thu, 20 Apr 2017 15:38:50 +1000
Message-ID: <149266673005.27388.9415706764616504556.stgit@noble>
References: <149266645258.27388.14083229348123176454.stgit@noble>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <149266645258.27388.14083229348123176454.stgit@noble>
Sender: linux-kernel-owner@vger.kernel.org
To: Jens Axboe <axboe@kernel.dk>
Cc: linux-block@vger.kernel.org, linux-kernel@vger.kernel.org, Kent Overstreet <kent.overstreet@gmail.com>, linux-bcache@vger.kernel.org
List-Id: linux-bcache@vger.kernel.org

This function allocates a bio, then a collection
of pages.  It copes with failure.

It currently uses a mempool() to allocate the bio,
but alloc_page() to allocate the pages.  These fail
in different ways, so the usage is inconsistent.

Change the bio_clone() to bio_clone_kmalloc()
so that no pool is used either for the bio or the pages.

Signed-off-by: NeilBrown <neilb@suse.com>
---
 drivers/md/bcache/debug.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/md/bcache/debug.c b/drivers/md/bcache/debug.c
index 06f55056aaae..35a5a7210e51 100644
--- a/drivers/md/bcache/debug.c
+++ b/drivers/md/bcache/debug.c
@@ -110,7 +110,7 @@ void bch_data_verify(struct cached_dev *dc, struct bio *bio)
 	struct bio_vec bv, cbv;
 	struct bvec_iter iter, citer = { 0 };
 
-	check = bio_clone(bio, GFP_NOIO);
+	check = bio_clone_kmalloc(bio, GFP_NOIO);
 	if (!check)
 		return;
 	check->bi_opf = REQ_OP_READ;
