From: Alex Pyrgiotis <apyrgio-Sqt7GMbKoOQ@public.gmane.org>
Subject: Re: bcache-tools: minor change for bcache-register
Date: Tue, 27 Aug 2013 13:00:24 +0300
Message-ID: <521C78B8.7060402@grnet.gr>
References: <521B1C5E.2090007@rolffokkens.nl> <20130826214155.GA2798@kmo-pixel> <521C4E2B.8090008@rolffokkens.nl>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-bcache-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <521C4E2B.8090008-6w2rdlBuEQTpMFipWq+H6g@public.gmane.org>
Sender: linux-bcache-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Rolf Fokkens <rolf-6w2rdlBuEQTpMFipWq+H6g@public.gmane.org>
Cc: Kent Overstreet <kmo-PEzghdH756F8UrSeD/g0lQ@public.gmane.org>, linux-bcache-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-bcache@vger.kernel.org

On 08/27/2013 09:58 AM, Rolf Fokkens wrote:
> Would you consider another change as well:
> 
> --- bcache-tools-20130827.orig/bcache-register    2013-08-26 
> 23:46:19.000000000 +0200
> +++ bcache-tools-20130827/bcache-register    2013-08-27 
> 08:55:48.060477014 +0200
> @@ -1,4 +1,4 @@
>   #!/bin/sh
> -modprobe -qba bcache
> +/sbin/modprobe -qba bcache
>   test -f /sys/fs/bcache/register_quiet && echo "$1" > 
> /sys/fs/bcache/register_quiet
> 
> /sbin is not in the $PATH for utilities started from udev. For Fedora it 
> isn't anyway, but it won't harm other distro's neither.
> 

Hi all,

Pardon the interrupt, but this is not the case for Arch Linux:
https://www.archlinux.org/news/binaries-move-to-usrbin-requiring-update-intervention/

In my opinion, if modprobe *has* to be called with the exact path name,
it would probably be clearer to use `which modprobe` and then call the
result.

Just my two cents...

-- 
Alex | apyrgio-Sqt7GMbKoOQ@public.gmane.org
