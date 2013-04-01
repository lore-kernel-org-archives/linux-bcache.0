From: Dan Carpenter <dan.carpenter-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Subject: re: bcache: A block layer cache
Date: Mon, 1 Apr 2013 22:37:41 +0300
Message-ID: <20130401193740.GA32549@longonot.mountain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-bcache-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
Sender: linux-bcache-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: koverstreet-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org
Cc: linux-bcache-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-bcache@vger.kernel.org

Hello Kent Overstreet,

The patch cafe56359144: "bcache: A block layer cache" from Mar 23, 
2013, leads to the following warning:
"drivers/md/bcache/util.c:92 hprint()
	 error: format string overflow. buf_size: 3 length: 4"

drivers/md/bcache/util.c
    77  ssize_t hprint(char *buf, int64_t v)
    78  {
    79          static const char units[] = "?kMGTPEZY";
    80          char dec[3] = "";
    81          int u, t = 0;
    82  
    83          for (u = 0; v >= 1024 || v <= -1024; u++) {
    84                  t = v & ~(~0 << 10);
    85                  v >>= 10;
    86          }
    87  
    88          if (!u)
    89                  return sprintf(buf, "%llu", v);
    90  
    91          if (v < 100 && v > -100)
    92                  sprintf(dec, ".%i", t / 100);

For example, hprint(buf, 2024) will cause a one char buffer overflow.

    93  
    94          return sprintf(buf, "%lli%s%c", v, dec, units[u]);

regards,
dan carpenter
