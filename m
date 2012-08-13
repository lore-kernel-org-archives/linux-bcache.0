From: Kent Overstreet <koverstreet-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Subject: Re: 4K sectors
Date: Mon, 13 Aug 2012 14:12:27 -0700
Message-ID: <20120813211227.GA6887@google.com>
References: <6035A0D088A63A46850C3988ED045A4B299F682F@BITCOM1.int.sbss.com.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-bcache-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <6035A0D088A63A46850C3988ED045A4B299F682F-mzsoxcrO4/2UD0RQwgcqbDSf8X3wrgjD@public.gmane.org>
Sender: linux-bcache-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: James Harper <james.harper-NMzNsA1hOHcW+bLBXbPJGg@public.gmane.org>
Cc: "linux-bcache-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-bcache-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-bcache@vger.kernel.org

On Mon, Aug 13, 2012 at 07:19:50AM +0000, James Harper wrote:
> I notice on my system that bcache presents 4K sectors to Linux. This is causing me problems with Windows on Xen using my PV drivers (problem = doesn't work). I haven't figured out if it's my PV drivers that don't tell Windows the right thing, or if Windows just doesn't like 4K sectors.
> 
> Is the 4K sector thing intentional? I assume there is a performance improvement in doing so.

It is intentional, but it's configurable. It's mainly for devices that
don't support < 4k writes; there might also be a performance impact with
some SSDs but I'm sure it's slight.

You'll need to reformat - pass --block 512 to make-bcache.  The backing
devices need to be reformatted too, but just rerunning make-bcache won't
touch any of the existing data.

> 
> And what would be the performance impact if I just told Windows that it was dealing with 512 byte sectors (eg fake it)?
> 
> Thanks
> 
> James
> --
> To unsubscribe from this list: send the line "unsubscribe linux-bcache" in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
