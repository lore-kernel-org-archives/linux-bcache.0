From: Kent Overstreet <kmo@daterainc.com>
Subject: [PATCH 01/11] block: Fix bio_copy_data()
Date: Mon, 23 Sep 2013 23:17:26 -0700
Message-ID: <1380003456-19938-2-git-send-email-kmo@daterainc.com>
References: <1380003456-19938-1-git-send-email-kmo@daterainc.com>
Return-path: <stable-owner@vger.kernel.org>
In-Reply-To: <1380003456-19938-1-git-send-email-kmo@daterainc.com>
Sender: stable-owner@vger.kernel.org
To: torvalds@linux-foundation.org, linux-kernel@vger.kernel.org, linux-bcache@vger.kernel.org
Cc: axboe@kernel.dk, Kent Overstreet <kmo@daterainc.com>, stable@vger.kernel.org
List-Id: linux-bcache@vger.kernel.org

The memcpy() in bio_copy_data() was using the wrong offset vars, leading
to data corruption in weird unusual setups.

Signed-off-by: Kent Overstreet <kmo@daterainc.com>
Cc: Jens Axboe <axboe@kernel.dk>
Cc: linux-stable <stable@vger.kernel.org> # >= v3.9
---
 fs/bio.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/fs/bio.c b/fs/bio.c
index b3b20ed..ea5035d 100644
--- a/fs/bio.c
+++ b/fs/bio.c
@@ -917,8 +917,8 @@ void bio_copy_data(struct bio *dst, struct bio *src)
 		src_p = kmap_atomic(src_bv->bv_page);
 		dst_p = kmap_atomic(dst_bv->bv_page);
 
-		memcpy(dst_p + dst_bv->bv_offset,
-		       src_p + src_bv->bv_offset,
+		memcpy(dst_p + dst_offset,
+		       src_p + src_offset,
 		       bytes);
 
 		kunmap_atomic(dst_p);
-- 
1.8.4.rc3
