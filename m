From: Mike Snitzer <snitzer-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: bcache and dm targets (specifically lvm)
Date: Sun, 4 Mar 2012 09:21:40 -0500
Message-ID: <20120304142139.GA10510@redhat.com>
References: <CAOzFzEjKapphA5NKCWbEyx4nvjWw+e_dxr+fOLr8f5j586jiyA@mail.gmail.com>
 <CAOzFzEjffLGjYhOznTo1F3moHLq+nvKYZFoy7mkU-q8RPDd9oQ@mail.gmail.com>
 <CAC7rs0vpQAaF9uNhhy2ziLa+3EB6udJVRjGwf=RVoSk0TxuDcw@mail.gmail.com>
 <CAC7rs0us5Xqag_AWq=wsFYqn3Fub3qt59a9=vDeS5cLh2oOg0Q@mail.gmail.com>
 <CAOzFzEifqyFz2G=0OEPA9BN8-kU3MabUhGmU7-jSQCxwPcHrpw@mail.gmail.com>
 <CAH+dOx+eWJKvKz=HEGHaPu8tqqz2CqVjUC1+0GJqta0GE4aYNw@mail.gmail.com>
 <CAOzFzEj=gBXL9UaVytrebU3gr2p1rJaMVPkz1X0oZOALQKbcNA@mail.gmail.com>
 <CAH+dOxKznm_mhe_TkN5eOY8tz6snyAC0TF6bsZpi4P1KtDd9kA@mail.gmail.com>
 <CAOzFzEiSR1izXGuS+djSpCJOTnaPU6KetR=wB8tXmPopUk4Jrg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-bcache-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <CAOzFzEiSR1izXGuS+djSpCJOTnaPU6KetR=wB8tXmPopUk4Jrg-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-bcache-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Joseph Glanville <joseph.glanville-2MxvZkOi9dvvnOemgxGiVw@public.gmane.org>
Cc: Kent Overstreet <koverstreet-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, linux-bcache-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Kent Overstreet <kent.overstreet-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, linux-lvm-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
List-Id: linux-bcache@vger.kernel.org

On Fri, Mar 02 2012 at  9:28pm -0500,
Joseph Glanville <joseph.glanville-2MxvZkOi9dvvnOemgxGiVw@public.gmane.org> wrote:

> Ahh!
> 
> I didn't know LVM had a device type lookup table. You can see if you
> look further that it also reads new types from the lvm.conf file.
> Adding this line to lvm.conf fixes the problem:
> 
> types = [ "bcache", 16 ]
>
> I would imagine if merged it would be added to the internal compiled in table.

Assuming bcache devices are partitionable 16 would be used (like patch
below), if they aren't then 1 would be used.

Kent,

I know you were frustrated with DM in the past and that is why you
created your own device type.

I'll be looking much closer at bcache in the next week or so.  I'm
starting to work on a DM-based caching target... it will re-use the
drivers/md/persistent-data/ infrastructure we've established as part of
the DM Thin Provisioning target.

Anyway, even if bcache remains to be a standalone (non-DM) block device
in the future I'll have a look at it with an eye toward code sharing
that might allow other caching layers to build on a common layer.  Even
if the common code is a policy engine I think it'd be cool to allow
sharing of policy across caching targets.

That said I'm also open to porting bcache to DM... but time will tell.
I'll grab the latest bcache code and jump on the linux-bcache list and
we can take it one step at a time.

---
 lib/filters/filter.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/lib/filters/filter.c b/lib/filters/filter.c
index 4c3d3b7..f4a9615 100644
--- a/lib/filters/filter.c
+++ b/lib/filters/filter.c
@@ -129,6 +129,7 @@ static const device_info_t device_info[] = {
 	{"mmc", 16},		/* MMC block device */
 	{"blkext", 1},		/* Extended device partitions */
 	{"fio", 16},		/* Fusion */
+	{"bcache", 16},		/* bcache */
 	{NULL, 0}
 };
 
