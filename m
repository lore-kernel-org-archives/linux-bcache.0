From: Coly Li <colyli@suse.de>
Subject: [PATCH 5/7] bcache: Use scnprintf() for avoiding potential buffer overflow
Date: Sun, 22 Mar 2020 14:03:03 +0800
Message-ID: <20200322060305.70637-6-colyli@suse.de>
References: <20200322060305.70637-1-colyli@suse.de>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <linux-block-owner@vger.kernel.org>
In-Reply-To: <20200322060305.70637-1-colyli@suse.de>
Sender: linux-block-owner@vger.kernel.org
To: axboe@kernel.dk
Cc: linux-bcache@vger.kernel.org, linux-block@vger.kernel.org, Takashi Iwai <tiwai@suse.de>, Coly Li <colyli@suse.de>
List-Id: linux-bcache@vger.kernel.org

From: Takashi Iwai <tiwai@suse.de>

Since snprintf() returns the would-be-output size instead of the
actual output size, the succeeding calls may go beyond the given
buffer limit.  Fix it by replacing with scnprintf().

Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Coly Li <colyli@suse.de>
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
2.25.0
