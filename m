From: Sasha Levin <sashal@kernel.org>
Subject: [PATCH AUTOSEL 5.0 083/317] bcache: avoid potential memleak of list of journal_replay(s) in the CACHE_SYNC branch of run_cache_set
Date: Wed, 22 May 2019 15:19:44 -0400
Message-ID: <20190522192338.23715-83-sashal@kernel.org>
References: <20190522192338.23715-1-sashal@kernel.org>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20190522192338.23715-1-sashal@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Shenghui Wang <shhuiw@foxmail.com>, Coly Li <colyli@suse.de>, Jens Axboe <axboe@kernel.dk>, Sasha Levin <sashal@kernel.org>, linux-bcache@vger.kernel.org
List-Id: linux-bcache@vger.kernel.org

From: Shenghui Wang <shhuiw@foxmail.com>

[ Upstream commit 95f18c9d1310730d075499a75aaf13bcd60405a7 ]

In the CACHE_SYNC branch of run_cache_set(), LIST_HEAD(journal) is used
to collect journal_replay(s) and filled by bch_journal_read().

If all goes well, bch_journal_replay() will release the list of
jounal_replay(s) at the end of the branch.

If something goes wrong, code flow will jump to the label "err:" and leave
the list unreleased.

This patch will release the list of journal_replay(s) in the case of
error detected.

v1 -> v2:
* Move the release code to the location after label 'err:' to
  simply the change.

Signed-off-by: Shenghui Wang <shhuiw@foxmail.com>
Signed-off-by: Coly Li <colyli@suse.de>
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/md/bcache/super.c | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/drivers/md/bcache/super.c b/drivers/md/bcache/super.c
index 4dee119c36646..7adafe8488273 100644
--- a/drivers/md/bcache/super.c
+++ b/drivers/md/bcache/super.c
@@ -1782,6 +1782,8 @@ static void run_cache_set(struct cache_set *c)
 	struct cache *ca;
 	struct closure cl;
 	unsigned int i;
+	LIST_HEAD(journal);
+	struct journal_replay *l;
 
 	closure_init_stack(&cl);
 
@@ -1939,6 +1941,12 @@ static void run_cache_set(struct cache_set *c)
 	set_bit(CACHE_SET_RUNNING, &c->flags);
 	return;
 err:
+	while (!list_empty(&journal)) {
+		l = list_first_entry(&journal, struct journal_replay, list);
+		list_del(&l->list);
+		kfree(l);
+	}
+
 	closure_sync(&cl);
 	/* XXX: test this, it's broken */
 	bch_cache_set_error(c, "%s", err);
-- 
2.20.1
