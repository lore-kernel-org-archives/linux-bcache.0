From: Gabriel de Perthuis <g2p.code-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: bcache-tools package for Fedora / status probe-bcache
Date: Thu, 05 Sep 2013 12:16:35 +0200
Message-ID: <52285A03.7080802@gmail.com>
References: <521A55D4.20908@rolffokkens.nl> <52282A87.4000801@rolffokkens.nl>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-bcache-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <52282A87.4000801-6w2rdlBuEQTpMFipWq+H6g@public.gmane.org>
Sender: linux-bcache-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Rolf Fokkens <rolf-6w2rdlBuEQTpMFipWq+H6g@public.gmane.org>
Cc: linux-bcache-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-bcache@vger.kernel.org

> Hi,
> 
> Packaging is progressing well, an initial package is available:
> https://admin.fedoraproject.org/updates/bcache-tools-0-0.9.20130827git.fc20
>
>  probe-bcache is part of this package, but util-linux will obsolete
> this shortly: https://bugzilla.redhat.com/show_bug.cgi?id=1001120#c13
> Actually the blkid utility in util-linux will do a more thorough job
> on identifying bcache, e.g. by also checking the csum. Having blkid
> identify bcache also simplifies the bcache udev rules.

I'm not a fan of a blkid csum check (I pointed it out on the bug[1]).
If a superblock gets scribbled or corrupted, you want bcache to
complain, and you don't want blkid to look for the next possible
signature.

> So now I'm wondering: are there any particular reasons to keep
> probe-bcache part of the package, or will it really be obsolete?

If you address the above and tweak the udev rules, why not.

The upstream repo will need to keep probe-bcache for a while
longer, because we don't have a way to require a sufficiently
recent libblkid.

[1] https://bugzilla.redhat.com/show_bug.cgi?id=1001120#c9
