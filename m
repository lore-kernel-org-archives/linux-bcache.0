From: Scott Wood <scottwood@freescale.com>
Subject: [PATCH 04/22] md/bcache: %pF is only for function pointers
Date: Wed, 11 Mar 2015 22:13:39 -0500
Message-ID: <1426130037-17956-4-git-send-email-scottwood@freescale.com>
References: <1426130037-17956-1-git-send-email-scottwood@freescale.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1426130037-17956-1-git-send-email-scottwood@freescale.com>
Sender: linux-kernel-owner@vger.kernel.org
To: trivial@kernel.org, linux-kernel@vger.kernel.org
Cc: Scott Wood <scottwood@freescale.com>, linux-bcache@vger.kernel.org, Kent Overstreet <kmo@daterainc.com>
List-Id: linux-bcache@vger.kernel.org

Use %pS for actual addresses, otherwise you'll get bad output
on arches like ppc64 where %pF expects a function descriptor.

Signed-off-by: Scott Wood <scottwood@freescale.com>
Cc: linux-bcache@vger.kernel.org
Cc: Kent Overstreet <kmo@daterainc.com>
---
 drivers/md/bcache/closure.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/md/bcache/closure.c b/drivers/md/bcache/closure.c
index 7a228de..87abf53 100644
--- a/drivers/md/bcache/closure.c
+++ b/drivers/md/bcache/closure.c
@@ -177,7 +177,7 @@ static int debug_seq_show(struct seq_file *f, void *data)
 	list_for_each_entry(cl, &closure_list, all) {
 		int r = atomic_read(&cl->remaining);
 
-		seq_printf(f, "%p: %pF -> %pf p %p r %i ",
+		seq_printf(f, "%p: %pS -> %pf p %p r %i ",
 			   cl, (void *) cl->ip, cl->fn, cl->parent,
 			   r & CLOSURE_REMAINING_MASK);
 
@@ -189,7 +189,7 @@ static int debug_seq_show(struct seq_file *f, void *data)
 			   r & CLOSURE_SLEEPING	? "Sl" : "");
 
 		if (r & CLOSURE_WAITING)
-			seq_printf(f, " W %pF\n",
+			seq_printf(f, " W %pS\n",
 				   (void *) cl->waiting_on);
 
 		seq_printf(f, "\n");
-- 
2.1.0
