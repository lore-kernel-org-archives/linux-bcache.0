From: Rolf Fokkens <rolf-6w2rdlBuEQTpMFipWq+H6g@public.gmane.org>
Subject: Re: bcache-tools package for Fedora / status probe-bcache
Date: Thu, 5 Sep 2013 12:36:17 +0200
Message-ID: <FEBD3400-93F1-4286-8BE8-45D5413C2EA2@rolffokkens.nl>
References: <521A55D4.20908@rolffokkens.nl> <52282A87.4000801@rolffokkens.nl> <52285A03.7080802@gmail.com>
Mime-Version: 1.0 (1.0)
Content-Type: text/plain;
	charset=us-ascii
Content-Transfer-Encoding: 8BIT
Return-path: <linux-bcache-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <52285A03.7080802-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Sender: linux-bcache-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Gabriel de Perthuis <g2p.code-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: "linux-bcache-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-bcache-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-bcache@vger.kernel.org


> 
> I'm not a fan of a blkid csum check (I pointed it out on the bug[1]).
> If a superblock gets scribbled or corrupted, you want bcache to
> complain, and you don't want blkid to look for the next possible
> signature.
Having blkid also verify the csum was requested by Karel Zak, the maintainer of util-linux. As a packager of bcache-tools I'm in favour of having blkid identify bcache, but I don't have a preference on using csum to identify bcache. I can pass the message to Karel, but it would be better if we both discuss it on the appropriate (util-linux?) mail list.
> 
>> So now I'm wondering: are there any particular reasons to keep
>> probe-bcache part of the package, or will it really be obsolete?
> 
> If you address the above and tweak the udev rules, why not.
> 
> The upstream repo will need to keep probe-bcache for a while
> longer, because we don't have a way to require a sufficiently
> recent libblkid.

I agree, f20 is a specific case, but in general probe-bcache will be needed for a while.
> [1] https://bugzilla.redhat.com/show_bug.cgi?id=1001120#c9
