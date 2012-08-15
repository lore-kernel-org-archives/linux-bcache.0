From: Kent Overstreet <koverstreet-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Subject: Re: [Xen-devel] blkback and bcache
Date: Wed, 15 Aug 2012 13:04:18 -0700
Message-ID: <20120815200418.GA2758@google.com>
References: <6035A0D088A63A46850C3988ED045A4B299F67FA@BITCOM1.int.sbss.com.au>
 <CAOzFzEhna3CaBE28aHVX_ZoNLDEa6AhArHPcB9240Ni4jh9PYA@mail.gmail.com>
 <6035A0D088A63A46850C3988ED045A4B299F6A9B@BITCOM1.int.sbss.com.au>
 <CAOzFzEhF+Pb89PNoibBc-9_Db6OUiyG5R8mKkAPi5pns4+CsAg@mail.gmail.com>
 <20120813213455.GC6887@google.com>
 <6035A0D088A63A46850C3988ED045A4B299F80E1@BITCOM1.int.sbss.com.au>
 <CAOzFzEitP95cy4LKJD+H1ffBLP_OjxWPTYCEd=XNkb-i5Mz39w@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-bcache-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <CAOzFzEitP95cy4LKJD+H1ffBLP_OjxWPTYCEd=XNkb-i5Mz39w-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-bcache-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Joseph Glanville <joseph.glanville-2MxvZkOi9dvvnOemgxGiVw@public.gmane.org>
Cc: James Harper <james.harper-NMzNsA1hOHcW+bLBXbPJGg@public.gmane.org>, "xen-devel-GuqFBffKawuEi8DpZVb4nw@public.gmane.org" <xen-devel-GuqFBffKawuEi8DpZVb4nw@public.gmane.org>, "linux-bcache-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-bcache-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-bcache@vger.kernel.org

On Wed, Aug 15, 2012 at 10:40:08PM +1000, Joseph Glanville wrote:
> Hi James, Kent.
> 
> I can confirm this is the issue I was seeing, thanks for locating the
> blkback issue!

Cool!

> Is there anything xen-devel should be doing about this? I wouldn't
> expect blkback to care about block size...

Well, I wouldn't be surprised if Windows doesn't work on a device with
block size > 512 bytes. But Linux (ext4 at least) certaintly does work
with 4k blocks - unless maybe it was breaking on something in the boot
process?

So it sounds like this might be indicative of a bug in blkback.

> Joseph.
> 
> On 14 August 2012 09:30, James Harper <james.harper-NMzNsA1hOHcW+bLBXbPJGg@public.gmane.org> wrote:
> >>
> >> Just mentioned this in the other thread, but if this is due to the 4k blocksize -
> >> that's easy to fix: just format with 512 byte blocksize
> >>
> >> make-bcache --block 512
> >>
> >> Maybe I should change the default.
> >
> > I suggest making the default 512, but also print a warning if the user didn't explicitly set it,eg "Block size not set - defaulting to 512 bytes"
> >
> > James
> > --
> > To unsubscribe from this list: send the line "unsubscribe linux-bcache" in
> > the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> > More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
> 
> 
> -- 
> CTO | Orion Virtualisation Solutions | www.orionvm.com.au
> Phone: 1300 56 99 52 | Mobile: 0428 754 846
