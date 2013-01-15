From: Kent Overstreet <koverstreet@google.com>
Subject: [PATCH 3/4] Export blk_fill_rwbs()
Date: Tue, 15 Jan 2013 13:25:41 -0800
Message-ID: <1358285142-10576-3-git-send-email-koverstreet@google.com>
References: <1358285142-10576-1-git-send-email-koverstreet@google.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1358285142-10576-1-git-send-email-koverstreet@google.com>
In-Reply-To: <20130114223202.GV26407@google.com>
References: <20130114223202.GV26407@google.com>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-kernel@vger.kernel.org, linux-bcache@vger.kernel.org
Cc: Kent Overstreet <koverstreet@google.com>, Steven Rostedt <rostedt@goodmis.org>, Frederic Weisbecker <fweisbec@gmail.com>, Ingo Molnar <mingo@redhat.com>
List-Id: linux-bcache@vger.kernel.org

Exported so it can be used by bcache's tracepoints

Signed-off-by: Kent Overstreet <koverstreet@google.com>
CC: Steven Rostedt <rostedt@goodmis.org>
CC: Frederic Weisbecker <fweisbec@gmail.com>
CC: Ingo Molnar <mingo@redhat.com>
---
 kernel/trace/blktrace.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/kernel/trace/blktrace.c b/kernel/trace/blktrace.c
index c0bd030..dbe1667 100644
--- a/kernel/trace/blktrace.c
+++ b/kernel/trace/blktrace.c
@@ -1806,6 +1806,7 @@ void blk_fill_rwbs(char *rwbs, u32 rw, int bytes)
 
 	rwbs[i] = '\0';
 }
+EXPORT_SYMBOL_GPL(blk_fill_rwbs);
 
 #endif /* CONFIG_EVENT_TRACING */
 
-- 
1.7.12
