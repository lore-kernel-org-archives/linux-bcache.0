From: Gabriel de Perthuis <g2p.code-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: bcache-tools: changes to make the udev rules work
Date: Mon, 26 Aug 2013 15:27:45 +0000 (UTC)
Message-ID: <kvfs5h$j12$1@ger.gmane.org>
References: <521B1E94.8090802@rolffokkens.nl>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Return-path: <linux-bcache-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-bcache-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-bcache-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-bcache@vger.kernel.org

On Mon, 26 Aug 2013 11:23:32 +0200, Rolf Fokkens wrote:
> Hi!

Hello!

> When making bcache tools run on Fedora I had to make some small tweaks 
> on the udev rules file:
> 
> - first trying with blkid doesn't work, because it doesn't know about bcache
> - full pathnames are needed, also for bcache-register because udev 
> doesn't include /sbin and /usr/sbin in PATH.

The blkid check is to make sure that there isn't a non-bcache superblock.
blkid doesn't need to understand bcache for this.

Make path changes if you really need, but udev is supposed to find unqualified
paths like bcache-register in $udevlibdir ( /lib/udev on debian, possibly
/usr/lib/udev in fedora).

> This is the diff:
> 
> --- bcache-tools-20130820/61-bcache.rules.rules    2013-08-20 
> 22:03:46.000000000 +0200
> +++ bcache-tools-20130820/61-bcache.rules    2013-08-25 
> 15:53:32.690312711 +0200
> @@ -5,14 +5,14 @@
>   ACTION=="remove", GOTO="bcache_end"
> 
>   # Backing devices: scan, symlink, register
> -IMPORT{program}="/sbin/blkid -o udev $tempnode"
> +#IMPORT{program}="/usr/sbin/blkid -o udev $tempnode"
>   # blkid and probe-bcache can disagree, in which case don't register
> -ENV{ID_FS_TYPE}=="?*", ENV{ID_FS_TYPE}!="bcache", GOTO="bcache_backing_end"
> +#ENV{ID_FS_TYPE}=="?*", ENV{ID_FS_TYPE}!="bcache", 
> GOTO="bcache_backing_end"

Those first two changes should be reverted.

> -IMPORT{program}="/sbin/probe-bcache -o udev $tempnode"
> +IMPORT{program}="/usr/sbin/probe-bcache -o udev $tempnode"

This change isn't broken, though you could make use of any /sbin
compat symlinks and not carry an upstream delta.

>   ENV{ID_FS_UUID_ENC}=="?*", SYMLINK+="disk/by-uuid/$env{ID_FS_UUID_ENC}"
>   SUBSYSTEM=="block", ACTION=="add|change", ENV{ID_FS_TYPE}=="bcache", \
> -        RUN+="bcache-register $tempnode"
> +        RUN+="/usr/lib/udev/bcache-register $tempnode"
>   LABEL="bcache_backing_end"

Unless there's been a change in udev, this change is unnecessary and
introduces a distro-specific path.
