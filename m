From: Sasha Levin <sashal@kernel.org>
Subject: [PATCH AUTOSEL 4.19 125/158] bcache: check CACHE_SET_IO_DISABLE bit in bch_journal()
Date: Mon, 15 Jul 2019 10:17:36 -0400
Message-ID: <20190715141809.8445-125-sashal@kernel.org>
References: <20190715141809.8445-1-sashal@kernel.org>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20190715141809.8445-1-sashal@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Coly Li <colyli@suse.de>, Jens Axboe <axboe@kernel.dk>, Sasha Levin <sashal@kernel.org>, linux-bcache@vger.kernel.org
List-Id: linux-bcache@vger.kernel.org

From: Coly Li <colyli@suse.de>

[ Upstream commit 383ff2183ad16a8842d1fbd9dd3e1cbd66813e64 ]

When too many I/O errors happen on cache set and CACHE_SET_IO_DISABLE
bit is set, bch_journal() may continue to work because the journaling
bkey might be still in write set yet. The caller of bch_journal() may
believe the journal still work but the truth is in-memory journal write
set won't be written into cache device any more. This behavior may
introduce potential inconsistent metadata status.

This patch checks CACHE_SET_IO_DISABLE bit at the head of bch_journal(),
if the bit is set, bch_journal() returns NULL immediately to notice
caller to know journal does not work.

Signed-off-by: Coly Li <colyli@suse.de>
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/md/bcache/journal.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/md/bcache/journal.c b/drivers/md/bcache/journal.c
index f880e5eba8dd..8d4d63b51553 100644
--- a/drivers/md/bcache/journal.c
+++ b/drivers/md/bcache/journal.c
@@ -810,6 +810,10 @@ atomic_t *bch_journal(struct cache_set *c,
 	struct journal_write *w;
 	atomic_t *ret;
 
+	/* No journaling if CACHE_SET_IO_DISABLE set already */
+	if (unlikely(test_bit(CACHE_SET_IO_DISABLE, &c->flags)))
+		return NULL;
+
 	if (!CACHE_SYNC(&c->sb))
 		return NULL;
 
-- 
2.20.1
