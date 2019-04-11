From: jglisse@redhat.com
Subject: [PATCH v1 03/15] block: introduce bvec_page()/bvec_set_page() to get/set bio_vec.bv_page
Date: Thu, 11 Apr 2019 17:08:22 -0400
Message-ID: <20190411210834.4105-4-jglisse@redhat.com>
References: <20190411210834.4105-1-jglisse@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20190411210834.4105-1-jglisse@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-kernel@vger.kernel.org
Cc: =?UTF-8?q?J=C3=A9r=C3=B4me=20Glisse?= <jglisse@redhat.com>, linux-fsdevel@vger.kernel.org, linux-block@vger.kernel.org, linux-mm@kvack.org, John Hubbard <jhubbard@nvidia.com>, Jan Kara <jack@suse.cz>, Dan Williams <dan.j.williams@intel.com>, Alexander Viro <viro@zeniv.linux.org.uk>, Johannes Thumshirn <jthumshirn@suse.de>, Christoph Hellwig <hch@lst.de>, Jens Axboe <axboe@kernel.dk>, Ming Lei <ming.lei@redhat.com>, Dave Chinner <david@fromorbit.com>, Jason Gunthorpe <jgg@ziepe.ca>, Matthew Wilcox <willy@infradead.org>, Coly Li <colyli@suse.de>, Kent Overstreet <kent.overstreet@gmail.com>, linux-bcache@vger.kernel.org
List-Id: linux-bcache@vger.kernel.org

From: Jérôme Glisse <jglisse@redhat.com>

This add an helper to lookup the page a bvec struct points to. We want
to convert all direct dereference of bvec->page to call to those helpers
so that we can change the bvec->page fields.

To make coccinelle convertion (in latter patch) easier this patch also
do update some macro and some code that coccinelle is not able to match.

Signed-off-by: Jérôme Glisse <jglisse@redhat.com>
Cc: linux-fsdevel@vger.kernel.org
Cc: linux-block@vger.kernel.org
Cc: linux-mm@kvack.org
Cc: John Hubbard <jhubbard@nvidia.com>
Cc: Jan Kara <jack@suse.cz>
Cc: Dan Williams <dan.j.williams@intel.com>
Cc: Alexander Viro <viro@zeniv.linux.org.uk>
Cc: Johannes Thumshirn <jthumshirn@suse.de>
Cc: Christoph Hellwig <hch@lst.de>
Cc: Jens Axboe <axboe@kernel.dk>
Cc: Ming Lei <ming.lei@redhat.com>
Cc: Dave Chinner <david@fromorbit.com>
Cc: Jason Gunthorpe <jgg@ziepe.ca>
Cc: Matthew Wilcox <willy@infradead.org>
Cc: Coly Li <colyli@suse.de>
Cc: Kent Overstreet <kent.overstreet@gmail.com>
Cc: linux-bcache@vger.kernel.org
---
 block/bounce.c            |  2 +-
 drivers/block/rbd.c       |  2 +-
 drivers/md/bcache/btree.c |  2 +-
 include/linux/bvec.h      | 14 ++++++++++++--
 lib/iov_iter.c            | 32 ++++++++++++++++----------------
 5 files changed, 31 insertions(+), 21 deletions(-)

diff --git a/block/bounce.c b/block/bounce.c
index 47eb7e936e22..d6ba1cac969f 100644
--- a/block/bounce.c
+++ b/block/bounce.c
@@ -85,7 +85,7 @@ static void bounce_copy_vec(struct bio_vec *to, unsigned char *vfrom)
 #else /* CONFIG_HIGHMEM */
 
 #define bounce_copy_vec(to, vfrom)	\
-	memcpy(page_address((to)->bv_page) + (to)->bv_offset, vfrom, (to)->bv_len)
+	memcpy(page_address(bvec_page(to)) + (to)->bv_offset, vfrom, (to)->bv_len)
 
 #endif /* CONFIG_HIGHMEM */
 
diff --git a/drivers/block/rbd.c b/drivers/block/rbd.c
index 2210c1b9491b..aa3b82be5946 100644
--- a/drivers/block/rbd.c
+++ b/drivers/block/rbd.c
@@ -2454,7 +2454,7 @@ static bool is_zero_bvecs(struct bio_vec *bvecs, u32 bytes)
 	};
 
 	ceph_bvec_iter_advance_step(&it, bytes, ({
-		if (memchr_inv(page_address(bv.bv_page) + bv.bv_offset, 0,
+		if (memchr_inv(page_address(bvec_page(&bv)) + bv.bv_offset, 0,
 			       bv.bv_len))
 			return false;
 	}));
diff --git a/drivers/md/bcache/btree.c b/drivers/md/bcache/btree.c
index 64def336f053..b5f3168dc5ff 100644
--- a/drivers/md/bcache/btree.c
+++ b/drivers/md/bcache/btree.c
@@ -435,7 +435,7 @@ static void do_btree_node_write(struct btree *b)
 		struct bvec_iter_all iter_all;
 
 		bio_for_each_segment_all(bv, b->bio, j, iter_all)
-			memcpy(page_address(bv->bv_page),
+			memcpy(page_address(bvec_page(bv)),
 			       base + j * PAGE_SIZE, PAGE_SIZE);
 
 		bch_submit_bbio(b->bio, b->c, &k.key, 0);
diff --git a/include/linux/bvec.h b/include/linux/bvec.h
index f6275c4da13a..44866555258a 100644
--- a/include/linux/bvec.h
+++ b/include/linux/bvec.h
@@ -51,6 +51,16 @@ struct bvec_iter_all {
 	unsigned	done;
 };
 
+static inline struct page *bvec_page(const struct bio_vec *bvec)
+{
+	return bvec->bv_page;
+}
+
+static inline void bvec_set_page(struct bio_vec *bvec, struct page *page)
+{
+	bvec->bv_page = page;
+}
+
 static inline struct page *bvec_nth_page(struct page *page, int idx)
 {
 	return idx == 0 ? page : nth_page(page, idx);
@@ -64,7 +74,7 @@ static inline struct page *bvec_nth_page(struct page *page, int idx)
 
 /* multi-page (mp_bvec) helpers */
 #define mp_bvec_iter_page(bvec, iter)				\
-	(__bvec_iter_bvec((bvec), (iter))->bv_page)
+	(bvec_page(__bvec_iter_bvec((bvec), (iter))))
 
 #define mp_bvec_iter_len(bvec, iter)				\
 	min((iter).bi_size,					\
@@ -192,6 +202,6 @@ static inline void mp_bvec_last_segment(const struct bio_vec *bvec,
 #define mp_bvec_for_each_page(pg, bv, i)				\
 	for (i = (bv)->bv_offset / PAGE_SIZE;				\
 		(i <= (((bv)->bv_offset + (bv)->bv_len - 1) / PAGE_SIZE)) && \
-		(pg = bvec_nth_page((bv)->bv_page, i)); i += 1)
+		(pg = bvec_nth_page(bvec_page(bv), i)); i += 1)
 
 #endif /* __LINUX_BVEC_ITER_H */
diff --git a/lib/iov_iter.c b/lib/iov_iter.c
index ea36dc355da1..e20a3b1d8b0e 100644
--- a/lib/iov_iter.c
+++ b/lib/iov_iter.c
@@ -608,7 +608,7 @@ size_t _copy_to_iter(const void *addr, size_t bytes, struct iov_iter *i)
 		might_fault();
 	iterate_and_advance(i, bytes, v,
 		copyout(v.iov_base, (from += v.iov_len) - v.iov_len, v.iov_len),
-		memcpy_to_page(v.bv_page, v.bv_offset,
+		memcpy_to_page(bvec_page(&v), v.bv_offset,
 			       (from += v.bv_len) - v.bv_len, v.bv_len),
 		memcpy(v.iov_base, (from += v.iov_len) - v.iov_len, v.iov_len)
 	)
@@ -709,7 +709,7 @@ size_t _copy_to_iter_mcsafe(const void *addr, size_t bytes, struct iov_iter *i)
 	iterate_and_advance(i, bytes, v,
 		copyout_mcsafe(v.iov_base, (from += v.iov_len) - v.iov_len, v.iov_len),
 		({
-		rem = memcpy_mcsafe_to_page(v.bv_page, v.bv_offset,
+		rem = memcpy_mcsafe_to_page(bvec_page(&v), v.bv_offset,
                                (from += v.bv_len) - v.bv_len, v.bv_len);
 		if (rem) {
 			curr_addr = (unsigned long) from;
@@ -744,7 +744,7 @@ size_t _copy_from_iter(void *addr, size_t bytes, struct iov_iter *i)
 		might_fault();
 	iterate_and_advance(i, bytes, v,
 		copyin((to += v.iov_len) - v.iov_len, v.iov_base, v.iov_len),
-		memcpy_from_page((to += v.bv_len) - v.bv_len, v.bv_page,
+		memcpy_from_page((to += v.bv_len) - v.bv_len, bvec_page(&v),
 				 v.bv_offset, v.bv_len),
 		memcpy((to += v.iov_len) - v.iov_len, v.iov_base, v.iov_len)
 	)
@@ -770,7 +770,7 @@ bool _copy_from_iter_full(void *addr, size_t bytes, struct iov_iter *i)
 				      v.iov_base, v.iov_len))
 			return false;
 		0;}),
-		memcpy_from_page((to += v.bv_len) - v.bv_len, v.bv_page,
+		memcpy_from_page((to += v.bv_len) - v.bv_len, bvec_page(&v),
 				 v.bv_offset, v.bv_len),
 		memcpy((to += v.iov_len) - v.iov_len, v.iov_base, v.iov_len)
 	)
@@ -790,7 +790,7 @@ size_t _copy_from_iter_nocache(void *addr, size_t bytes, struct iov_iter *i)
 	iterate_and_advance(i, bytes, v,
 		__copy_from_user_inatomic_nocache((to += v.iov_len) - v.iov_len,
 					 v.iov_base, v.iov_len),
-		memcpy_from_page((to += v.bv_len) - v.bv_len, v.bv_page,
+		memcpy_from_page((to += v.bv_len) - v.bv_len, bvec_page(&v),
 				 v.bv_offset, v.bv_len),
 		memcpy((to += v.iov_len) - v.iov_len, v.iov_base, v.iov_len)
 	)
@@ -824,7 +824,7 @@ size_t _copy_from_iter_flushcache(void *addr, size_t bytes, struct iov_iter *i)
 	iterate_and_advance(i, bytes, v,
 		__copy_from_user_flushcache((to += v.iov_len) - v.iov_len,
 					 v.iov_base, v.iov_len),
-		memcpy_page_flushcache((to += v.bv_len) - v.bv_len, v.bv_page,
+		memcpy_page_flushcache((to += v.bv_len) - v.bv_len, bvec_page(&v),
 				 v.bv_offset, v.bv_len),
 		memcpy_flushcache((to += v.iov_len) - v.iov_len, v.iov_base,
 			v.iov_len)
@@ -849,7 +849,7 @@ bool _copy_from_iter_full_nocache(void *addr, size_t bytes, struct iov_iter *i)
 					     v.iov_base, v.iov_len))
 			return false;
 		0;}),
-		memcpy_from_page((to += v.bv_len) - v.bv_len, v.bv_page,
+		memcpy_from_page((to += v.bv_len) - v.bv_len, bvec_page(&v),
 				 v.bv_offset, v.bv_len),
 		memcpy((to += v.iov_len) - v.iov_len, v.iov_base, v.iov_len)
 	)
@@ -951,7 +951,7 @@ size_t iov_iter_zero(size_t bytes, struct iov_iter *i)
 		return pipe_zero(bytes, i);
 	iterate_and_advance(i, bytes, v,
 		clear_user(v.iov_base, v.iov_len),
-		memzero_page(v.bv_page, v.bv_offset, v.bv_len),
+		memzero_page(bvec_page(&v), v.bv_offset, v.bv_len),
 		memset(v.iov_base, 0, v.iov_len)
 	)
 
@@ -974,7 +974,7 @@ size_t iov_iter_copy_from_user_atomic(struct page *page,
 	}
 	iterate_all_kinds(i, bytes, v,
 		copyin((p += v.iov_len) - v.iov_len, v.iov_base, v.iov_len),
-		memcpy_from_page((p += v.bv_len) - v.bv_len, v.bv_page,
+		memcpy_from_page((p += v.bv_len) - v.bv_len, bvec_page(&v),
 				 v.bv_offset, v.bv_len),
 		memcpy((p += v.iov_len) - v.iov_len, v.iov_base, v.iov_len)
 	)
@@ -1300,7 +1300,7 @@ ssize_t iov_iter_get_pages(struct iov_iter *i,
 	0;}),({
 		/* can't be more than PAGE_SIZE */
 		*start = v.bv_offset;
-		get_page(*pages = v.bv_page);
+		get_page(*pages = bvec_page(&v));
 		return v.bv_len;
 	}),({
 		return -EFAULT;
@@ -1387,7 +1387,7 @@ ssize_t iov_iter_get_pages_alloc(struct iov_iter *i,
 		*pages = p = get_pages_array(1);
 		if (!p)
 			return -ENOMEM;
-		get_page(*p = v.bv_page);
+		get_page(*p = bvec_page(&v));
 		return v.bv_len;
 	}),({
 		return -EFAULT;
@@ -1419,7 +1419,7 @@ size_t csum_and_copy_from_iter(void *addr, size_t bytes, __wsum *csum,
 		}
 		err ? v.iov_len : 0;
 	}), ({
-		char *p = kmap_atomic(v.bv_page);
+		char *p = kmap_atomic(bvec_page(&v));
 		sum = csum_and_memcpy((to += v.bv_len) - v.bv_len,
 				      p + v.bv_offset, v.bv_len,
 				      sum, off);
@@ -1461,7 +1461,7 @@ bool csum_and_copy_from_iter_full(void *addr, size_t bytes, __wsum *csum,
 		off += v.iov_len;
 		0;
 	}), ({
-		char *p = kmap_atomic(v.bv_page);
+		char *p = kmap_atomic(bvec_page(&v));
 		sum = csum_and_memcpy((to += v.bv_len) - v.bv_len,
 				      p + v.bv_offset, v.bv_len,
 				      sum, off);
@@ -1507,7 +1507,7 @@ size_t csum_and_copy_to_iter(const void *addr, size_t bytes, void *csump,
 		}
 		err ? v.iov_len : 0;
 	}), ({
-		char *p = kmap_atomic(v.bv_page);
+		char *p = kmap_atomic(bvec_page(&v));
 		sum = csum_and_memcpy(p + v.bv_offset,
 				      (from += v.bv_len) - v.bv_len,
 				      v.bv_len, sum, off);
@@ -1696,10 +1696,10 @@ int iov_iter_for_each_range(struct iov_iter *i, size_t bytes,
 		return 0;
 
 	iterate_all_kinds(i, bytes, v, -EINVAL, ({
-		w.iov_base = kmap(v.bv_page) + v.bv_offset;
+		w.iov_base = kmap(bvec_page(&v)) + v.bv_offset;
 		w.iov_len = v.bv_len;
 		err = f(&w, context);
-		kunmap(v.bv_page);
+		kunmap(bvec_page(&v));
 		err;}), ({
 		w = v;
 		err = f(&w, context);})
-- 
2.20.1
