From: Kent Overstreet <kent.overstreet@gmail.com>
Subject: [PATCH 12/12] closures: fix a race on wakeup from closure_sync
Date: Mon, 10 Jun 2019 15:14:20 -0400
Message-ID: <20190610191420.27007-13-kent.overstreet@gmail.com>
References: <20190610191420.27007-1-kent.overstreet@gmail.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20190610191420.27007-1-kent.overstreet@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org, linux-bcache@vger.kernel.org
Cc: Kent Overstreet <kent.overstreet@gmail.com>
List-Id: linux-bcache@vger.kernel.org

Signed-off-by: Kent Overstreet <kent.overstreet@gmail.com>
---
 lib/closure.c | 10 ++++++++--
 1 file changed, 8 insertions(+), 2 deletions(-)

diff --git a/lib/closure.c b/lib/closure.c
index 46cfe4c382..3e6366c262 100644
--- a/lib/closure.c
+++ b/lib/closure.c
@@ -104,8 +104,14 @@ struct closure_syncer {
 
 static void closure_sync_fn(struct closure *cl)
 {
-	cl->s->done = 1;
-	wake_up_process(cl->s->task);
+	struct closure_syncer *s = cl->s;
+	struct task_struct *p;
+
+	rcu_read_lock();
+	p = READ_ONCE(s->task);
+	s->done = 1;
+	wake_up_process(p);
+	rcu_read_unlock();
 }
 
 void __sched __closure_sync(struct closure *cl)
-- 
2.20.1
