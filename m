From: matthew patton <pattonme-/E1597aS9LQAvxtiuMwx3w@public.gmane.org>
Subject: block activity stats
Date: Mon, 29 Apr 2013 20:46:50 -0700 (PDT)
Message-ID: <1367293610.13617.YahooMailClassic@web181503.mail.ne1.yahoo.com>
References: <CAC7rs0t4uKx37i7pxMoMQgVeUT6spDeridfdC+R6mqLbf1dwug@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-bcache-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CAC7rs0t4uKx37i7pxMoMQgVeUT6spDeridfdC+R6mqLbf1dwug-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-bcache-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-bcache-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-bcache@vger.kernel.org

Is block activity tracked exclusively by Bcache code or is Bcache piggy-backing on already existing statistics tracking that is implemented in LVM or the VM or (scsi?) block layers? If the first, I was wondering how hard it would be to move it into the lower levels and turned on/off with sysfs.

Is there a whitepaper that goes into the mechanics of the tracking, the granularity (eg. block region size), (de)promotion trigger logic, etc? Or is this a question best answered by "go read the code"?
