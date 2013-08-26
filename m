From: "Darrick J. Wong" <darrick.wong-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Subject: Re: [RFC] bcache-status
Date: Mon, 26 Aug 2013 09:30:55 -0700
Message-ID: <20130826163055.GB4780@blackbox.djwong.org>
References: <521A55D4.20908@rolffokkens.nl>
 <521A6B92.60001@rolffokkens.nl>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-bcache-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <521A6B92.60001-6w2rdlBuEQTpMFipWq+H6g@public.gmane.org>
Sender: linux-bcache-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Rolf Fokkens <rolf-6w2rdlBuEQTpMFipWq+H6g@public.gmane.org>
Cc: linux-bcache-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-bcache@vger.kernel.org

On Sun, Aug 25, 2013 at 10:39:46PM +0200, Rolf Fokkens wrote:
> Hi,
> 
> I took the liberty of adding bcache-status to the bcache-tools
> package I'm building:

Yay! :)

> https://bugzilla.redhat.com/show_bug.cgi?id=999690#c12
> 
> I have a few questions/remarks:
> - Is the python3 dependency really needed? I changed it to ordinary
> python(2) and it runs fine I think.

Not required; I'm merely writing new scripts in python3.  (At least when I can
find py3 libraries...)  I didn't write anything py3-specific, as far as I know.

> - Is https://gist.github.com/damoxc/6267899 the proper source?

I was hoping someone will (eventually) commit the status tool to
bcache-tools.git.

For now, there's: https://gist.github.com/djwong/6343451 in which I've merged
all the changes made by the two people who (thank you both!) provided
modifications.

> - When the bcache kernel module is not loaded, the feedback looks buggy:
> [root@home07 ~]# bcache-status
> Traceback (most recent call last):
>   File "/sbin/bcache-status", line 348, in <module>
>     main()
>   File "/sbin/bcache-status", line 333, in main
>     for cache in os.listdir(SYSFS_BCACHE_PATH):
> OSError: [Errno 2] No such file or directory: '/sys/fs/bcache/'
> [root@home07 ~]#

Yeah, I fixed that before posting the gist. :)

--D
> 
> Rolf
> 
> On 08/25/2013 09:07 PM, Rolf Fokkens wrote:
> >To allow Fedora users to benefit from bcache I'm currently
> >packaging bcache-tools for Fedora.
> >
> >See also: https://bugzilla.redhat.com/show_bug.cgi?id=999690
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-bcache" in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
