From: "Juerd Waalboer" <juerd@tnx.nl>
Subject: [PATCH 1/1] bcache: fix rounding in human readable output
Date: Mon, 24 Nov 2014 14:05:43 +0100
Message-ID: <20141124130543.GD2814@k>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-bcache-owner@vger.kernel.org>
Received: from c26.tnx.nl ([193.200.132.216]:53389 "EHLO c26.tnx.nl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753154AbaKXNKw (ORCPT <rfc822;linux-bcache@vger.kernel.org>);
	Mon, 24 Nov 2014 08:10:52 -0500
Received: from k.tnx.nl (k [193.200.132.132])
	by c26.tnx.nl (Postfix) with SMTP id BD55A82398
	for <linux-bcache@vger.kernel.org>; Mon, 24 Nov 2014 14:05:43 +0100 (CET)
Content-Disposition: inline
Sender: linux-bcache-owner@vger.kernel.org
List-Id: linux-bcache@vger.kernel.org
To: linux-bcache@vger.kernel.org, Kent Overstreet <kmo@daterainc.com>

Division by 100 caused results like 3.9k < 3.10k < 4.0k; fixed by
increasing the denominator to 103, which is a better approximation
of 1024 / 10 == 102.4

Signed-off-by: Juerd Waalboer <juerd@tnx.nl>
---
 drivers/md/bcache/util.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/md/bcache/util.c b/drivers/md/bcache/util.c
index db3ae4c..56e8a62 100644
--- a/drivers/md/bcache/util.c
+++ b/drivers/md/bcache/util.c
@@ -88,7 +88,7 @@ ssize_t bch_hprint(char *buf, int64_t v)
 		return sprintf(buf, "%llu", v);
 
 	if (v < 100 && v > -100)
-		snprintf(dec, sizeof(dec), ".%i", t / 100);
+		snprintf(dec, sizeof(dec), ".%i", t / 103);
 
 	return sprintf(buf, "%lli%s%c", v, dec, units[u]);
 }
-- 
2.1.3
