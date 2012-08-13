From: Kent Overstreet <koverstreet-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Subject: Re: [Xen-devel] blkback and bcache
Date: Mon, 13 Aug 2012 14:34:55 -0700
Message-ID: <20120813213455.GC6887@google.com>
References: <6035A0D088A63A46850C3988ED045A4B299F67FA@BITCOM1.int.sbss.com.au>
 <CAOzFzEhna3CaBE28aHVX_ZoNLDEa6AhArHPcB9240Ni4jh9PYA@mail.gmail.com>
 <6035A0D088A63A46850C3988ED045A4B299F6A9B@BITCOM1.int.sbss.com.au>
 <CAOzFzEhF+Pb89PNoibBc-9_Db6OUiyG5R8mKkAPi5pns4+CsAg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-bcache-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <CAOzFzEhF+Pb89PNoibBc-9_Db6OUiyG5R8mKkAPi5pns4+CsAg-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-bcache-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Joseph Glanville <joseph.glanville-2MxvZkOi9dvvnOemgxGiVw@public.gmane.org>
Cc: James Harper <james.harper-NMzNsA1hOHcW+bLBXbPJGg@public.gmane.org>, "xen-devel-GuqFBffKawuEi8DpZVb4nw@public.gmane.org" <xen-devel-GuqFBffKawuEi8DpZVb4nw@public.gmane.org>, "linux-bcache-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-bcache-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-bcache@vger.kernel.org

On Mon, Aug 13, 2012 at 08:53:44PM +1000, Joseph Glanville wrote:
> On 13 August 2012 18:17, James Harper <james.harper-NMzNsA1hOHcW+bLBXbPJGg@public.gmane.org> wrote:
> >>
> >> This could very well be the issue I was having, I haven't been able to pull the
> >> latest bcache code for a few days (repo down?) but if I can help debug let me
> >> know.
> >>
> >
> > Is it Windows or Linux giving you problems? I've only tested Windows so far.
> >
> > James
> > --
> > To unsubscribe from this list: send the line "unsubscribe linux-bcache" in
> > the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> > More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
> Both, I wasn't able to get either to work correctly with blkback.

Just mentioned this in the other thread, but if this is due to the 4k
blocksize - that's easy to fix: just format with 512 byte blocksize

make-bcache --block 512

Maybe I should change the default.
