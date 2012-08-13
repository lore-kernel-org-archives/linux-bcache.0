From: Kent Overstreet <koverstreet-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Subject: Re: grub and bcache
Date: Mon, 13 Aug 2012 14:26:27 -0700
Message-ID: <20120813212627.GB6887@google.com>
References: <6035A0D088A63A46850C3988ED045A4B299F5324@BITCOM1.int.sbss.com.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-bcache-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <6035A0D088A63A46850C3988ED045A4B299F5324-mzsoxcrO4/2UD0RQwgcqbDSf8X3wrgjD@public.gmane.org>
Sender: linux-bcache-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: James Harper <james.harper-NMzNsA1hOHcW+bLBXbPJGg@public.gmane.org>
Cc: "linux-bcache-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-bcache-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-bcache@vger.kernel.org

On Sun, Aug 12, 2012 at 11:17:39AM +0000, James Harper wrote:
> Is the underlying bdev bcache format such that bios/grub won't be able to boot off it?

Bios isn't an issue, because the mbr just takes up the first 512 bytes
of the hard drive and bcache leaves the first 4k of the device unused.
But grub needs to be able to read everything, and it doesn't know
anything about bcache devices.

> 
> Or to put it another way, I am wondering whether I can get away with:
> 
> /dev/sd[ab]
>  md0
>   bcache
>    lvm
>     lv-root
>     lv-boot
> 
> like I do now without bcache and have grub find the lv-boot, or if I need a separate md device to hold /boot like:

Yeah, this is the one you'll need.

> 
> /dev/sd[ab]
>   md0
>     boot
>   md1
>     bcache
>       lvm
>         lv-root
>         lv-boot
> 
> thanks
> 
> James
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-bcache" in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
