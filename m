From: Joseph Glanville <joseph.glanville-2MxvZkOi9dvvnOemgxGiVw@public.gmane.org>
Subject: Re: [Xen-devel] blkback and bcache
Date: Mon, 13 Aug 2012 17:35:16 +1000
Message-ID: <CAOzFzEhna3CaBE28aHVX_ZoNLDEa6AhArHPcB9240Ni4jh9PYA@mail.gmail.com>
References: <6035A0D088A63A46850C3988ED045A4B299F67FA@BITCOM1.int.sbss.com.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-bcache-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <6035A0D088A63A46850C3988ED045A4B299F67FA-mzsoxcrO4/2UD0RQwgcqbDSf8X3wrgjD@public.gmane.org>
Sender: linux-bcache-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: James Harper <james.harper-NMzNsA1hOHcW+bLBXbPJGg@public.gmane.org>
Cc: "xen-devel-GuqFBffKawuEi8DpZVb4nw@public.gmane.org" <xen-devel-GuqFBffKawuEi8DpZVb4nw@public.gmane.org>, linux-bcache-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Kent Overstreet <koverstreet-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
List-Id: linux-bcache@vger.kernel.org

On 13 August 2012 17:16, James Harper <james.harper-NMzNsA1hOHcW+bLBXbPJGg@public.gmane.org> wrote:
> I'm having trouble using blkback under gplpv when the disk is on top of a bcache device. My devices are layered as follows:
>
> /dev/sd[ab]
> md0 (RAID1)
> bcache
> lvm
>
> It seems that bcache presents a 4K sector size to Linux, which is then reflected by lvm and in turn blkback.
>
> Obviously GPLPV isn't handling 4K sectors correctly... any suggestions as to what I might need to do to make this work properly? As a last resort I should be able to fake 512 byte sectors to Windows but would prefer that Windows knew it was dealing with a device with 4K sectors underneath.
>
> Thanks
>
> James
>
> _______________________________________________
> Xen-devel mailing list
> Xen-devel-GuqFBffKawuEi8DpZVb4nw@public.gmane.org
> http://lists.xen.org/xen-devel

This could very well be the issue I was having, I haven't been able to
pull the latest bcache code for a few days (repo down?) but if I can
help debug let me know.

-- 
CTO | Orion Virtualisation Solutions | www.orionvm.com.au
Phone: 1300 56 99 52 | Mobile: 0428 754 846
