From: Michael Lyle <mlyle@lyle.org>
Subject: [PATCH] bcache: fix bch_hprint crash and improve output
Date: Mon,  4 Sep 2017 14:55:24 -0700
Message-ID: <20170904215524.26672-1-mlyle@lyle.org>
Return-path: <linux-bcache-owner@vger.kernel.org>
Received: from mail-pf0-f194.google.com ([209.85.192.194]:38813 "EHLO
        mail-pf0-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753978AbdIDVzj (ORCPT
        <rfc822;linux-bcache@vger.kernel.org>);
        Mon, 4 Sep 2017 17:55:39 -0400
Received: by mail-pf0-f194.google.com with SMTP id q76so710079pfq.5
        for <linux-bcache@vger.kernel.org>; Mon, 04 Sep 2017 14:55:39 -0700 (PDT)
Sender: linux-bcache-owner@vger.kernel.org
List-Id: linux-bcache@vger.kernel.org
To: colyli@suse.de
Cc: linux-bcache@vger.kernel.org, Michael Lyle <mlyle@lyle.org>

Most importantly, solve a crash where %llu was used to format signed
numbers.  This would cause a buffer overflow when reading sysfs
writeback_rate_debug, as only 20 bytes were allocated for this and
%llu writes 20 characters plus a null.

Always use the units mechanism rather than having different output
paths for simplicity.

Also, correct problems with display output where 1.10 was a larger
number than 1.09, by multiplying by 10 and then dividing by 1024 instead
of dividing by 100.  (Remainders of >= 1000 would print as .10).

Minor changes: Always display the decimal point instead of trying to
omit it based on number of digits shown.  Decide what units to use
based on 1000 as a threshold, not 1024 (in other words, always print
at most 3 digits before the decimal point).

Signed-off-by: Michael Lyle <mlyle@lyle.org>
Reported-by: Dmitry Yu Okunev <dyokunev@ut.mephi.ru>
---
 drivers/md/bcache/util.c | 50 +++++++++++++++++++++++++++++++++---------------
 1 file changed, 35 insertions(+), 15 deletions(-)

diff --git a/drivers/md/bcache/util.c b/drivers/md/bcache/util.c
index 8c3a938f4bf0..176d3c2ef5f5 100644
--- a/drivers/md/bcache/util.c
+++ b/drivers/md/bcache/util.c
@@ -74,24 +74,44 @@ STRTO_H(strtouint, unsigned int)
 STRTO_H(strtoll, long long)
 STRTO_H(strtoull, unsigned long long)
 
+/**
+ * bch_hprint() - formats @v to human readable string for sysfs.
+ *
+ * @v - signed 64 bit integer
+ * @buf - the (at least 8 byte) buffer to format the result into.
+ *
+ * Returns the number of bytes used by format.
+ */
 ssize_t bch_hprint(char *buf, int64_t v)
 {
 	static const char units[] = "?kMGTPEZY";
-	char dec[4] = "";
-	int u, t = 0;
-
-	for (u = 0; v >= 1024 || v <= -1024; u++) {
-		t = v & ~(~0 << 10);
-		v >>= 10;
-	}
-
-	if (!u)
-		return sprintf(buf, "%llu", v);
-
-	if (v < 100 && v > -100)
-		snprintf(dec, sizeof(dec), ".%i", t / 100);
-
-	return sprintf(buf, "%lli%s%c", v, dec, units[u]);
+	int u = 0, t;
+
+	uint64_t q;
+
+	if (v < 0)
+		q = -v;
+	else
+		q = v;
+
+	/* For as long as the number is more than 3 digits, but at least
+	 * once, shift right / divide by 1024.  Keep the remainder for
+	 * a digit after the decimal point.
+	 */
+	do {
+		u++;
+
+		t = q & ~(~0 << 10);
+		q >>= 10;
+	} while (q >= 1000);
+
+	if (v < 0)
+		/* '-', up to 3 digits, '.', 1 digit, 1 character, null;
+		 * yields 8 bytes.
+		 */
+		return sprintf(buf, "-%llu.%i%c", q, t * 10 / 1024, units[u]);
+	else
+		return sprintf(buf, "%llu.%i%c", q, t * 10 / 1024, units[u]);
 }
 
 ssize_t bch_snprint_string_list(char *buf, size_t size, const char * const list[],
-- 
2.11.0
