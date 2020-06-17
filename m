From: "Gustavo A. R. Silva" <gustavoars@kernel.org>
Subject: [PATCH][next] bcache: movinggc: Use struct_size() helper in kzalloc()
Date: Wed, 17 Jun 2020 17:33:31 -0500
Message-ID: <20200617223331.GA25794@embeddedor>
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
 drivers/md/bcache/movinggc.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/md/bcache/movinggc.c b/drivers/md/bcache/movinggc.c
index 7891fb512736..b7dd2d75f58c 100644
--- a/drivers/md/bcache/movinggc.c
+++ b/drivers/md/bcache/movinggc.c
@@ -145,8 +145,8 @@ static void read_moving(struct cache_set *c)
 			continue;
 		}
 
-		io = kzalloc(sizeof(struct moving_io) + sizeof(struct bio_vec)
-			     * DIV_ROUND_UP(KEY_SIZE(&w->key), PAGE_SECTORS),
+		io = kzalloc(struct_size(io, bio.bio.bi_inline_vecs,
+					 DIV_ROUND_UP(KEY_SIZE(&w->key), PAGE_SECTORS)),
 			     GFP_KERNEL);
 		if (!io)
 			goto err;
-- 
2.27.0
