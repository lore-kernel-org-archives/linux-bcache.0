From: Michael Lyle <mlyle@lyle.org>
Subject: [PATCH] bcache: fix bch_hprint crash and improve output
Date: Fri,  1 Sep 2017 13:37:22 -0700
Message-ID: <20170901203722.29974-1-mlyle@lyle.org>
Return-path: <linux-bcache-owner@vger.kernel.org>
Received: from mail-pg0-f68.google.com ([74.125.83.68]:35668 "EHLO
        mail-pg0-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752347AbdIAUin (ORCPT
        <rfc822;linux-bcache@vger.kernel.org>);
        Fri, 1 Sep 2017 16:38:43 -0400
Received: by mail-pg0-f68.google.com with SMTP id r133so754858pgr.2
        for <linux-bcache@vger.kernel.org>; Fri, 01 Sep 2017 13:38:42 -0700 (PDT)
Sender: linux-bcache-owner@vger.kernel.org
List-Id: linux-bcache@vger.kernel.org
To: linux-bcache@vger.kernel.org
Cc: kent.overstreet@gmail.com, mlyle@lyle.org

Solve a crash where the stack is overrun when reading sysfs and
small negative values are present.  Also correct output, as before
it would output "1.10" for numbers bigger than "1.9", and negative
fractional output was incorrect.

Signed-off-by: Michael Lyle <mlyle@lyle.org>
Reported-by: Dmitry Yu Okunev <dyokunev@ut.mephi.ru>
---
 drivers/md/bcache/util.c | 10 +++++++---
 1 file changed, 7 insertions(+), 3 deletions(-)

diff --git a/drivers/md/bcache/util.c b/drivers/md/bcache/util.c
index 8c3a938f4bf0..11957038c630 100644
--- a/drivers/md/bcache/util.c
+++ b/drivers/md/bcache/util.c
@@ -86,10 +86,14 @@ ssize_t bch_hprint(char *buf, int64_t v)
 	}
 
 	if (!u)
-		return sprintf(buf, "%llu", v);
+		return sprintf(buf, "%lli", v);
 
-	if (v < 100 && v > -100)
-		snprintf(dec, sizeof(dec), ".%i", t / 100);
+	if (t > 103) {
+		if (v > 0)
+			snprintf(dec, sizeof(dec), ".%i", t * 10 / 1024);
+		else
+			snprintf(dec, sizeof(dec), ".%i", 10 - (t * 10 / 1024));
+	}
 
 	return sprintf(buf, "%lli%s%c", v, dec, units[u]);
 }
-- 
2.11.0
