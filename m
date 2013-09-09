From: Karel Zak <kzak-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: bcache-tools package for Fedora / status probe-bcache
Date: Mon, 9 Sep 2013 15:26:53 +0200
Message-ID: <20130909132653.GA8061@x2.net.home>
References: <521A55D4.20908@rolffokkens.nl>
 <52282A87.4000801@rolffokkens.nl>
 <52285A03.7080802@gmail.com>
 <FEBD3400-93F1-4286-8BE8-45D5413C2EA2@rolffokkens.nl>
 <52286299.7000708@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <util-linux-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <52286299.7000708-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Sender: util-linux-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Gabriel de Perthuis <g2p.code-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: Rolf Fokkens <rolf-6w2rdlBuEQTpMFipWq+H6g@public.gmane.org>, "linux-bcache-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-bcache-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, util-linux <util-linux-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-bcache@vger.kernel.org

On Thu, Sep 05, 2013 at 12:53:13PM +0200, Gabriel de Perthuis wrote:
> >> I'm not a fan of a blkid csum check (I pointed it out on the 
> >> bug[1]). If a superblock gets scribbled or corrupted, you want 
> >> bcache to complain, and you don't want blkid to look for the next 
> >> possible signature.
> > 
> > Having blkid also verify the csum was requested by Karel Zak, the 
> > maintainer of util-linux. As a packager of bcache-tools I'm in favour
> > of having blkid identify bcache, but I don't have a preference on
> > using csum to identify bcache. I can pass the message to Karel, but
> > it would be better if we both discuss it on the appropriate 
> > (util-linux?) mail list.
> 
> Karel, are you okay if blkid doesn't do the csum verification discussed above?

 I don't insist on csum, but I'd like to have something more robust
 than check for a magic string only. It's usually better if there
 is some additional thing (for example within superblock offset,
 csum, etc.) -- checksums are ideal because it usually verifies 
 whole superblock (header). 
 
> Checksum failures will be reported by the kernel instead.

 I don't care about kernel :-) The important is what userspace (udev)
 thinks about the device -- is it correct to trigger any action on
 broken bcache device or the device should be ignored by userspace
 rules?

> Alternatively, do you see a way libblkid can return good magic / bad checksum
> results?

 If I good understand your patches then it makes wipefs(8) more
 "hungry" to zap incomplete superblock. I have no problem to support
 this scenario. 
 
 Something else (like report bad checksums to udev) is probably
 unnecessary. Right?

> > I agree, f20 is a specific case, but in general probe-bcache will be 
> > needed for a while.
> 
> For the record, the libblkid patch is a good thing in the long run:
> common interface, less forks in udev.

 Yes, definitely. 
 
 Maybe we can backport the patch to F20 if you need it -- it's not too
 invasive change. 

    Karel

-- 
 Karel Zak  <kzak-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
 http://karelzak.blogspot.com
--
To unsubscribe from this list: send the line "unsubscribe util-linux" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
