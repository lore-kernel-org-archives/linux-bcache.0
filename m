From: James Harper <james.harper-NMzNsA1hOHcW+bLBXbPJGg@public.gmane.org>
Subject: RE: [Xen-devel] blkback and bcache
Date: Mon, 13 Aug 2012 23:30:09 +0000
Message-ID: <6035A0D088A63A46850C3988ED045A4B299F80E1@BITCOM1.int.sbss.com.au>
References: <6035A0D088A63A46850C3988ED045A4B299F67FA@BITCOM1.int.sbss.com.au>
 <CAOzFzEhna3CaBE28aHVX_ZoNLDEa6AhArHPcB9240Ni4jh9PYA@mail.gmail.com>
 <6035A0D088A63A46850C3988ED045A4B299F6A9B@BITCOM1.int.sbss.com.au>
 <CAOzFzEhF+Pb89PNoibBc-9_Db6OUiyG5R8mKkAPi5pns4+CsAg@mail.gmail.com>
 <20120813213455.GC6887@google.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-bcache-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20120813213455.GC6887-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Content-Language: en-US
Sender: linux-bcache-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Kent Overstreet <koverstreet-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Joseph Glanville <joseph.glanville-2MxvZkOi9dvvnOemgxGiVw@public.gmane.org>
Cc: "xen-devel-GuqFBffKawuEi8DpZVb4nw@public.gmane.org" <xen-devel-GuqFBffKawuEi8DpZVb4nw@public.gmane.org>, "linux-bcache-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-bcache-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-bcache@vger.kernel.org

> 
> Just mentioned this in the other thread, but if this is due to the 4k blocksize -
> that's easy to fix: just format with 512 byte blocksize
> 
> make-bcache --block 512
> 
> Maybe I should change the default.

I suggest making the default 512, but also print a warning if the user didn't explicitly set it,eg "Block size not set - defaulting to 512 bytes"

James
