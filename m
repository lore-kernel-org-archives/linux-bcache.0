From: SF Markus Elfring <elfring@users.sourceforge.net>
Subject: [PATCH] bcache: Use seq_putc() in debug_seq_show()
Date: Sat, 13 Jan 2018 09:11:43 +0100
Message-ID: <9de4911b-23ff-ef53-5187-73eca1d521ea@users.sourceforge.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Language: en-GB
Sender: linux-kernel-owner@vger.kernel.org
To: linux-bcache@vger.kernel.org, Kent Overstreet <kent.overstreet@gmail.com>, Michael Lyle <mlyle@lyle.org>
Cc: LKML <linux-kernel@vger.kernel.org>, kernel-janitors@vger.kernel.org
List-Id: linux-bcache@vger.kernel.org

From: Markus Elfring <elfring@users.sourceforge.net>
Date: Sat, 13 Jan 2018 09:05:03 +0100

A single character (line break) should be put into a sequence.
Thus use the corresponding function "seq_putc".

This issue was detected by using the Coccinelle software.

Signed-off-by: Markus Elfring <elfring@users.sourceforge.net>
---
 drivers/md/bcache/closure.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/md/bcache/closure.c b/drivers/md/bcache/closure.c
index 1841d0359bac..9cdbddbe0ed0 100644
--- a/drivers/md/bcache/closure.c
+++ b/drivers/md/bcache/closure.c
@@ -179,7 +179,7 @@ static int debug_seq_show(struct seq_file *f, void *data)
 			seq_printf(f, " W %pF\n",
 				   (void *) cl->waiting_on);
 
-		seq_printf(f, "\n");
+		seq_putc(f, '\n');
 	}
 
 	spin_unlock_irq(&closure_list_lock);
-- 
2.15.1
