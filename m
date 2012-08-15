From: James Harper <james.harper-NMzNsA1hOHcW+bLBXbPJGg@public.gmane.org>
Subject: RE: [Xen-devel] blkback and bcache
Date: Wed, 15 Aug 2012 23:48:33 +0000
Message-ID: <6035A0D088A63A46850C3988ED045A4B299FCC7F@BITCOM1.int.sbss.com.au>
References: <6035A0D088A63A46850C3988ED045A4B299F67FA@BITCOM1.int.sbss.com.au>
 <CAOzFzEhna3CaBE28aHVX_ZoNLDEa6AhArHPcB9240Ni4jh9PYA@mail.gmail.com>
 <6035A0D088A63A46850C3988ED045A4B299F6A9B@BITCOM1.int.sbss.com.au>
 <CAOzFzEhF+Pb89PNoibBc-9_Db6OUiyG5R8mKkAPi5pns4+CsAg@mail.gmail.com>
 <20120813213455.GC6887@google.com>
 <6035A0D088A63A46850C3988ED045A4B299F80E1@BITCOM1.int.sbss.com.au>
 <CAOzFzEitP95cy4LKJD+H1ffBLP_OjxWPTYCEd=XNkb-i5Mz39w@mail.gmail.com>
 <20120815200418.GA2758@google.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-bcache-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20120815200418.GA2758-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Content-Language: en-US
Sender: linux-bcache-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Kent Overstreet <koverstreet-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Joseph Glanville <joseph.glanville-2MxvZkOi9dvvnOemgxGiVw@public.gmane.org>
Cc: "xen-devel-GuqFBffKawuEi8DpZVb4nw@public.gmane.org" <xen-devel-GuqFBffKawuEi8DpZVb4nw@public.gmane.org>, "linux-bcache-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-bcache-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-bcache@vger.kernel.org

> > Is there anything xen-devel should be doing about this? I wouldn't
> > expect blkback to care about block size...
> 
> Well, I wouldn't be surprised if Windows doesn't work on a device with block
> size > 512 bytes. But Linux (ext4 at least) certaintly does work with 4k blocks -
> unless maybe it was breaking on something in the boot process?
> 
> So it sounds like this might be indicative of a bug in blkback.
> 

As far as I can tell, blkback works internally in 512 byte sectors, but does a bounds check of the 512 byte sector offset against the native sector count, so if you have 4K sectors you get an error trying to access anything past 1/8th of the disk. This is a problem, but qemu can't boot off anything but 512 byte sectors so that is the more limiting factor. I suspect a more thorough audit of blkback's behaviour wrt 4K sectors would be in order before simply fixing the bounds check bug, although it seems to work fine.

Curiously, despite literature to the contrary, Windows itself doesn't seem to care if the sector size is 4K. I added a second disk to an already running Windows DomU, partitioned it, and formatted it, and tested it (copying files on, off, rebooting, etc). As long as the size of my partition was <1/8th the size of the disk it worked fine.

James
