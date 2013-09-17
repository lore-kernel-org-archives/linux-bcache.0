From: Kent Overstreet <kmo-PEzghdH756F8UrSeD/g0lQ@public.gmane.org>
Subject: [PATCH] bcache: Possible flush fix
Date: Tue, 17 Sep 2013 14:40:43 -0700
Message-ID: <20130917214043.GF32037@kmo-pixel>
References: <loom.20130916T150548-751@post.gmane.org>
 <20130917020316.GC10907@kmo-pixel>
 <loom.20130917T122135-908@post.gmane.org>
 <20130917203741.GA32037@kmo-pixel>
 <loom.20130917T224603-574@post.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-bcache-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <loom.20130917T224603-574-eS7Uydv5nfjZ+VzJOa5vwg@public.gmane.org>
Sender: linux-bcache-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Hubert Kempkensteffen <hubert-39zlLzowylnAQEp6PLVxx6xOck334EZe@public.gmane.org>
Cc: linux-bcache-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-bcache@vger.kernel.org

Jens suggested that cloning the bio to issue a bare flush might be
copying some flags we don't want, and at least allocating a new bio
would be more correct. Worth a shot...

Signed-off-by: Kent Overstreet <kmo-PEzghdH756F8UrSeD/g0lQ@public.gmane.org>
---

On Tue, Sep 17, 2013 at 08:54:57PM +0000, Hubert Kempkensteffen wrote:
> Kent Overstreet <kmo@...> writes:
> Sorry, my english.
> I have no raid and no LVM. There are both ordinary machines.
> And I just want to speed up the data disk!
> 
> > 
> > I think this bug requires something else in the stack to trigger, I'm
> > trying to figure out what the common factor is.

Can you give this patch a try?

 drivers/md/bcache/request.c | 20 +++++++++++---------
 1 file changed, 11 insertions(+), 9 deletions(-)

diff --git a/drivers/md/bcache/request.c b/drivers/md/bcache/request.c
index afb9a99..c06840b 100644
--- a/drivers/md/bcache/request.c
+++ b/drivers/md/bcache/request.c
@@ -1053,19 +1053,21 @@ static void request_write(struct cached_dev *dc, struct search *s)
 		trace_bcache_writethrough(s->orig_bio);
 		closure_bio_submit(bio, cl, s->d);
 	} else {
+		s->op.cache_bio = bio;
 		trace_bcache_writeback(s->orig_bio);
 		bch_writeback_add(dc, bio_sectors(bio));
 
-		if (s->op.flush_journal) {
+		if (bio->bi_rw & REQ_FLUSH) {
 			/* Also need to send a flush to the backing device */
-			s->op.cache_bio = bio_clone_bioset(bio, GFP_NOIO,
-							   dc->disk.bio_split);
-
-			bio->bi_size = 0;
-			bio->bi_vcnt = 0;
-			closure_bio_submit(bio, cl, s->d);
-		} else {
-			s->op.cache_bio = bio;
+			struct bio *flush = bio_alloc_bioset(0, GFP_NOIO,
+							     dc->disk.bio_split);
+
+			flush->bi_rw	= WRITE_FLUSH;
+			flush->bi_bdev	= bio->bi_bdev;
+			flush->bi_end_io = request_endio;
+			flush->bi_private = cl;
+
+			closure_bio_submit(flush, cl, s->d);
 		}
 	}
 out:
-- 
1.8.4.rc3
