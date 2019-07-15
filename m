From: Sasha Levin <sashal@kernel.org>
Subject: [PATCH AUTOSEL 5.2 192/249] bcache: fix return value error in bch_journal_read()
Date: Mon, 15 Jul 2019 09:45:57 -0400
Message-ID: <20190715134655.4076-192-sashal@kernel.org>
References: <20190715134655.4076-1-sashal@kernel.org>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20190715134655.4076-1-sashal@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Coly Li <colyli@suse.de>, Jens Axboe <axboe@kernel.dk>, Sasha Levin <sashal@kernel.org>, linux-bcache@vger.kernel.org
List-Id: linux-bcache@vger.kernel.org

From: Coly Li <colyli@suse.de>

[ Upstream commit 0ae49cb7aa005ed18fe8f4d6ccf73019b78ac7b2 ]

When everything is OK in bch_journal_read(), finally the return value
is returned by,
	return ret;
which assumes ret will be 0 here. This assumption is wrong when all
journal buckets as are full and filled with valid journal entries. In
such cache the last location referencess read_bucket() sets 'ret' to
1, which means new jset added into jset list. The jset list is list
'journal' in caller run_cache_set().

Return 1 to run_cache_set() means something wrong and the cache set
won't start, but indeed everything is OK.

This patch changes the line at end of bch_journal_read() to directly
return 0 since everything if verything is good. Then a bogus error
is fixed.

Signed-off-by: Coly Li <colyli@suse.de>
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/md/bcache/journal.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/md/bcache/journal.c b/drivers/md/bcache/journal.c
index 12dae9348147..4e5fc05720fc 100644
--- a/drivers/md/bcache/journal.c
+++ b/drivers/md/bcache/journal.c
@@ -268,7 +268,7 @@ int bch_journal_read(struct cache_set *c, struct list_head *list)
 					    struct journal_replay,
 					    list)->j.seq;
 
-	return ret;
+	return 0;
 #undef read_bucket
 }
 
-- 
2.20.1
