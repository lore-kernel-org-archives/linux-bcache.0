From: Kent Overstreet <koverstreet-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Subject: Re: bcache: A block layer cache
Date: Fri, 5 Apr 2013 14:14:20 -0700
Message-ID: <20130405211420.GC15749@google.com>
References: <20130401193740.GA32549@longonot.mountain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-bcache-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20130401193740.GA32549-dZEljifmRObu9KfB+GxooP8+0UxHXcjY@public.gmane.org>
Sender: linux-bcache-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Dan Carpenter <dan.carpenter-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Cc: linux-bcache-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-bcache@vger.kernel.org

On Mon, Apr 01, 2013 at 10:37:41PM +0300, Dan Carpenter wrote:
> Hello Kent Overstreet,
> 
> The patch cafe56359144: "bcache: A block layer cache" from Mar 23, 
> 2013, leads to the following warning:
> "drivers/md/bcache/util.c:92 hprint()
> 	 error: format string overflow. buf_size: 3 length: 4"

Thanks - fixed

commit c20bbfc0e049ca785bb19419121091e4fd419886
Author: Kent Overstreet <koverstreet-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Date:   Fri Apr 5 14:12:28 2013 -0700

    bcache: Fix a format string overflow
    
    Reported-by: Dan Carpenter <dan.carpenter-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
    Signed-off-by: Kent Overstreet <koverstreet-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>

diff --git a/drivers/md/bcache/util.c b/drivers/md/bcache/util.c
index a9619d8..da3a99e 100644
--- a/drivers/md/bcache/util.c
+++ b/drivers/md/bcache/util.c
@@ -76,7 +76,7 @@ STRTO_H(strtoull, unsigned long long)
 ssize_t bch_hprint(char *buf, int64_t v)
 {
 	static const char units[] = "?kMGTPEZY";
-	char dec[3] = "";
+	char dec[4] = "";
 	int u, t = 0;
 
 	for (u = 0; v >= 1024 || v <= -1024; u++) {
@@ -88,7 +88,7 @@ ssize_t bch_hprint(char *buf, int64_t v)
 		return sprintf(buf, "%llu", v);
 
 	if (v < 100 && v > -100)
-		sprintf(dec, ".%i", t / 100);
+		snprintf(dec, sizeof(dec), ".%i", t / 100);
 
 	return sprintf(buf, "%lli%s%c", v, dec, units[u]);
 }
