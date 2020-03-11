From: Takashi Iwai <tiwai@suse.de>
Subject: [PATCH] bcache: Use scnprintf() for avoiding potential buffer overflow
Date: Wed, 11 Mar 2020 08:45:58 +0100
Message-ID: <20200311074558.8517-1-tiwai@suse.de>
Return-path: <linux-bcache-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:49980 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726160AbgCKHqA (ORCPT <rfc822;linux-bcache@vger.kernel.org>);
        Wed, 11 Mar 2020 03:46:00 -0400
Sender: linux-bcache-owner@vger.kernel.org
List-Id: linux-bcache@vger.kernel.org
To: Coly Li <colyli@suse.de>, Kent Overstreet <kent.overstreet@gmail.com>
Cc: linux-bcache@vger.kernel.org

Since snprintf() returns the would-be-output size instead of the
actual output size, the succeeding calls may go beyond the given
buffer limit.  Fix it by replacing with scnprintf().

Signed-off-by: Takashi Iwai <tiwai@suse.de>
---
 drivers/md/bcache/sysfs.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/md/bcache/sysfs.c b/drivers/md/bcache/sysfs.c
index 3470fae4eabc..323276994aab 100644
--- a/drivers/md/bcache/sysfs.c
+++ b/drivers/md/bcache/sysfs.c
@@ -154,7 +154,7 @@ static ssize_t bch_snprint_string_list(char *buf,
 	size_t i;
 
 	for (i = 0; list[i]; i++)
-		out += snprintf(out, buf + size - out,
+		out += scnprintf(out, buf + size - out,
 				i == selected ? "[%s] " : "%s ", list[i]);
 
 	out[-1] = '\n';
-- 
2.16.4
