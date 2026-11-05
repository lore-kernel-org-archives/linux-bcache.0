Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=156.224.82.216
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793884810;
	b=a5578KmScOYPFyw1VuTGEjWgCOdvsFbjqqMBpaLoQNl3UlNlnitrZLepjPkj0IGEubra
	 6MTnlucBk6ECzP2Fm7Zj4o7juaGFigiFJrTD1sd4aowLKl8+fdvkxuIveWPWc9hZT7z9Q
	 NVzpgVIweROjKehYwpINBvF5F2YcF+LeD5KFxPPf1RLsNjpE6fUgewT91h3YXBMvs5WFf
	 DWOh3s+7SvZzTDadtTr7QD2MjPUKvJ3I8MvzYDOXuK7ES7rJtLKC8sHS93jY7s9DFqAlT
	 xQFFR7CDr1h/DW73zPf8PZqLdP1XqEJ6rxDOr13un9EkjCP6tRhC1LtZTztTcFvzDWw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793884810;
	h=DMARC-Filter:Received:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 MIME-Version:Content-Transfer-Encoding:X-HM-Tid:X-HM-MType:
	 X-HM-Spam-Status:DKIM-Signature;
	bh=2TzSoLWtRKuFMw7/tnNqI1rSDm2j/2Qgs5STebGi0hs=;
	b=vRoNF/6QtJ8KJt7jj/uBE7UDVaZkZwBJk6bNR1tuTpCZqhhqbd4k6i1Ey8iudGxZiUAG
	 GKFLMQNypHMDoR4q9e9oY4dnsgkHwI3eCPHJmrBcLn35lU2ffTx1Gjs9aWAAQPKdvnUHV
	 dig279UA1JhH3FFtSdJ7vlYx2qlE17KuaIn8M/LWDkpMo0mJ9I2pS8lB+fFdCdL2zfa26
	 VbzzWQt0uVly31GNYU6ahwuuEbooNBkEMmOSAcm9j0DtsQzR/EhDW2trnvLnxygykHcQM
	 CjPk0D0R5pjvEmh4w/2MmJjcY0UNpmr4eTc/JGhDrPWVa7rkKGIMq9uXJ7zmnso1Acg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=easystack.cn;
	spf=pass smtp.mailfrom=easystack.cn;
	dkim=pass header.d=easystack.cn header.i=@easystack.cn header.a=rsa-sha256 header.s=default header.b=LBbs1IBy;
	arc=none smtp.remote-ip=156.224.82.216
Received: from mail-m82216.xmail.ntesmail.com (mail-m82216.xmail.ntesmail.com [156.224.82.216])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4507C606A333;
	Thu,  5 Nov 2026 13:20:05 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 4507C606A333
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=easystack.cn
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=easystack.cn
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=easystack.cn header.i=@easystack.cn header.a=rsa-sha256 header.s=default header.b=LBbs1IBy
Received: from chenfan-ThinkPad-P1-Gen-4i.. (unknown [218.94.118.90])
	by smtp.qiye.163.com (Hmail) with ESMTP id 25658c7e3;
	Thu, 5 Nov 2026 21:19:56 +0800 (GMT+08:00)
From: Chen Fan <fan.chen@easystack.cn>
To: colyli@fygo.io,
	kent.overstreet@linux.dev
Cc: linux-bcache@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	fan.chen@easystack.cn
Subject: [PATCH 1/1] bcache: fix use-after-free when waiting for dirty-init threads
Date: Thu,  5 Nov 2026 21:19:54 +0800
Message-ID: <20261105131954.1195428-1-fan.chen@easystack.cn>
X-Mailer: git-send-email 2.43.0
X-Mailing-List: linux-bcache@vger.kernel.org
List-Id: <linux-bcache.vger.kernel.org>
List-Post: <mailto:linux-bcache@vger.kernel.org>
List-Help: <mailto:linux-bcache+help@vger.kernel.org>
List-Subscribe: <mailto:linux-bcache+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcache+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-bcache+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-HM-Tid: 0aa1abddb6240229kunmd82a544d4466
X-HM-MType: 1
X-HM-Spam-Status: e1kfGhgUHx5ZQUpXWQgPGg8OCBgUHx5ZQUlOS1dZFg8aDwILHllBWSg2Ly
	tZV1koWUFJQjdXWRgWCB1ZQUpXWS1ZQUlXWQ8JGhUIEh9ZQVkaT0IfVkpMQ05PHk9ITUkYS1YVFA
	kWGhdVGRETFhoSFyQUDg9ZV1kYEgtZQVlJSkNVQk9VSkpDVUJLWVdZFhoPEhUdFFlBWU9LSFVKS0
	lPT09IVUpLS1VKQktLWQY+
DKIM-Signature: a=rsa-sha256;
	b=LBbs1IBygPK0IHriXErHsuWfvAQ3RdDboS55b4f0cQ0LYwZaX8SJ67WT7lEqWGDw6b26EvYpzHjLrMNSkLF5WTL9sWetnUP2hszXG0HLwe6cBoJxRSVjMcTUy4MnSL5izmsecaNrfjx9auz3GPuPcjt4ahZl5ZaN/UXoBTKvgOw=; s=default; c=relaxed/relaxed; d=easystack.cn; v=1;
	bh=2TzSoLWtRKuFMw7/tnNqI1rSDm2j/2Qgs5STebGi0hs=;
	h=date:mime-version:subject:message-id:from;

We use multiple threads to count dirty sectors in parallel (read-only).
bch_sectors_dirty_init() waits for the last dirty-init thread to set
state.started to 0.

However, after the last thread sets state.started to 0 but before it calls
wake_up(&state->wait), bch_sectors_dirty_init() may observe started == 0,
return from wait_event() directly, and free local variable state.
The subsequent wake_up(&state->wait) then accesses freed memory, because
bch_sectors_dirty_init() has already exited.

Fix this by using a completion to wait for all dirty-init threads, so that
no dirty-init thread can still access state after the wait completes.

This issue was triggered in our environment with the following stack:
------------[ cut here ]------------
[30433.391386] Internal error: Oops: 0000000096000047 [#1] SMP
[30433.585804] CPU: 54 PID: 48242 Comm: bch_dirtcnt[1] Kdump: loaded Tainted: G  6.6.0-98.0.0.90.aarch64 #1
[30433.718972] Call trace:
[30433.722722]  native_queued_spin_lock_slowpath+0x33c/0x420
[30433.729401]  __wake_up_common_lock+0xbc/0x118
[30433.735050]  __wake_up+0x20/0x38
[30433.739575]  bch_dirty_init_thread+0x1c0/0x1f8 [bcache]
[30433.746169]  kthread+0xf0/0x108
[30433.750583]  ret_from_fork+0x10/0x20
[30433.755425] Code: 91002020 8b040284 f862d8a5 aa0403e2 (f8256841)
      ---[ end trace ]---

Signed-off-by: Chen Fan <fan.chen@easystack.cn>
---
 drivers/md/bcache/writeback.c | 31 ++++++++++++-------------------
 drivers/md/bcache/writeback.h |  4 +---
 2 files changed, 13 insertions(+), 22 deletions(-)

diff --git a/drivers/md/bcache/writeback.c b/drivers/md/bcache/writeback.c
index 4b237074f453..e74457a8c952 100644
--- a/drivers/md/bcache/writeback.c
+++ b/drivers/md/bcache/writeback.c
@@ -16,6 +16,7 @@
 #include <linux/kthread.h>
 #include <linux/sched/clock.h>
 #include <trace/events/bcache.h>
+#include <linux/completion.h>
 
 static void update_gc_after_writeback(struct cache_set *c)
 {
@@ -953,12 +954,7 @@ static int bch_dirty_init_thread(void *arg)
 	}
 
 out:
-	/* In order to wake up state->wait in time */
-	smp_mb__before_atomic();
-	if (atomic_dec_and_test(&state->started))
-		wake_up(&state->wait);
-
-	return 0;
+	kthread_complete_and_exit(&state->done, 0);
 }
 
 static int bch_btre_dirty_init_thread_nr(void)
@@ -975,8 +971,9 @@ static int bch_btre_dirty_init_thread_nr(void)
 
 void bch_sectors_dirty_init(struct bcache_device *d)
 {
-	int i;
+	int i, launched = 0;
 	struct btree *b = NULL;
+	struct task_struct *thread;
 	struct bkey *k = NULL;
 	struct btree_iter_stack iter;
 	struct sectors_dirty_init op;
@@ -1014,9 +1011,8 @@ void bch_sectors_dirty_init(struct bcache_device *d)
 	state.total_threads = bch_btre_dirty_init_thread_nr();
 	state.key_idx = 0;
 	spin_lock_init(&state.idx_lock);
-	atomic_set(&state.started, 0);
 	atomic_set(&state.enough, 0);
-	init_waitqueue_head(&state.wait);
+	init_completion(&state.done);
 
 	for (i = 0; i < state.total_threads; i++) {
 		/* Fetch latest state.enough earlier */
@@ -1024,23 +1020,20 @@ void bch_sectors_dirty_init(struct bcache_device *d)
 		if (atomic_read(&state.enough))
 			break;
 
-		atomic_inc(&state.started);
 		state.infos[i].state = &state;
-		state.infos[i].thread =
+		thread =
 			kthread_run(bch_dirty_init_thread, &state.infos[i],
 				    "bch_dirtcnt[%d]", i);
-		if (IS_ERR(state.infos[i].thread)) {
+		if (IS_ERR(thread)) {
 			pr_err("fails to run thread bch_dirty_init[%d]\n", i);
-			atomic_dec(&state.started);
-			for (--i; i >= 0; i--)
-				kthread_stop(state.infos[i].thread);
-			goto out;
+			break;
 		}
+		launched++;
 	}
 
-out:
-	/* Must wait for all threads to stop. */
-	wait_event(state.wait, atomic_read(&state.started) == 0);
+	/* Wait for all threads to finish accessing state. */
+	for (i = 0; i < launched; i++)
+		wait_for_completion(&state.done);
 	rw_unlock(0, b);
 }
 
diff --git a/drivers/md/bcache/writeback.h b/drivers/md/bcache/writeback.h
index 31df716951f6..e6c74be20fc6 100644
--- a/drivers/md/bcache/writeback.h
+++ b/drivers/md/bcache/writeback.h
@@ -31,7 +31,6 @@
 struct bch_dirty_init_state;
 struct dirty_init_thrd_info {
 	struct bch_dirty_init_state	*state;
-	struct task_struct		*thread;
 };
 
 struct bch_dirty_init_state {
@@ -40,9 +39,8 @@ struct bch_dirty_init_state {
 	int				total_threads;
 	int				key_idx;
 	spinlock_t			idx_lock;
-	atomic_t			started;
 	atomic_t			enough;
-	wait_queue_head_t		wait;
+	struct completion		done;
 	struct dirty_init_thrd_info	infos[BCH_DIRTY_INIT_THRD_MAX];
 };
 
-- 
2.43.0

