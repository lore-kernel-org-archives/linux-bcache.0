From: "Gustavo A. R. Silva" <gustavoars@kernel.org>
Subject: [PATCH][next] bcache: Use struct_size() in kzalloc()
Date: Wed, 17 Jun 2020 17:27:33 -0500
Message-ID: <20200617222733.GA24156@embeddedor>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
To: Coly Li <colyli@suse.de>, Kent Overstreet <kent.overstreet@gmail.com>
Cc: linux-bcache@vger.kernel.org, linux-kernel@vger.kernel.org, "Gustavo A. R. Silva" <gustavo@embeddedor.com>
List-Id: linux-bcache@vger.kernel.org

Make use of the struct_size() helper instead of an open-coded version
in order to avoid any potential type mistakes.

This code was detected with the help of Coccinelle and, audited and
fixed manually.

Signed-off-by: Gustavo A. R. Silva <gustavoars@kernel.org>
---
 drivers/md/bcache/writeback.c | 6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

diff --git a/drivers/md/bcache/writeback.c b/drivers/md/bcache/writeback.c
index 1cf1e5016cb9..c0db3c860179 100644
--- a/drivers/md/bcache/writeback.c
+++ b/drivers/md/bcache/writeback.c
@@ -459,10 +459,8 @@ static void read_dirty(struct cached_dev *dc)
 		for (i = 0; i < nk; i++) {
 			w = keys[i];
 
-			io = kzalloc(sizeof(struct dirty_io) +
-				     sizeof(struct bio_vec) *
-				     DIV_ROUND_UP(KEY_SIZE(&w->key),
-						  PAGE_SECTORS),
+			io = kzalloc(struct_size(io, bio.bi_inline_vecs,
+						DIV_ROUND_UP(KEY_SIZE(&w->key), PAGE_SECTORS)),
 				     GFP_KERNEL);
 			if (!io)
 				goto err;
-- 
2.27.0
