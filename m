From: Kent Overstreet <koverstreet-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Subject: Re: Expected Behavior
Date: Mon, 3 Sep 2012 20:46:30 -0700
Message-ID: <20120904034630.GB21602@moria.home.lan>
References: <503F147A.10101@abpni.co.uk>
 <239802233aa1dabc37f60b293d2941c9@abpni.co.uk>
 <20120830212841.GB14247@google.com>
 <503FF05B.1040506@abpni.co.uk>
 <6035A0D088A63A46850C3988ED045A4B29A7D49D@BITCOM1.int.sbss.com.au>
 <a7955ba43dfd9792245545eeb8c54e55@abpni.co.uk>
 <151f74230aeb6825d9b8b633881d5e6c@abpni.co.uk>
 <504203F8.4000302@abpni.co.uk>
 <20120903003750.GA20060@moria.home.lan>
 <fd31f46503030cb2f09c50453971f618@abpni.co.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-bcache-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <fd31f46503030cb2f09c50453971f618-Nf8S+5hNwl710XsdtD+oqA@public.gmane.org>
Sender: linux-bcache-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jonathan Tripathy <jonnyt-Nf8S+5hNwl710XsdtD+oqA@public.gmane.org>
Cc: James Harper <james.harper-NMzNsA1hOHcW+bLBXbPJGg@public.gmane.org>, linux-bcache-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-bcache@vger.kernel.org

On Mon, Sep 03, 2012 at 09:30:26AM +0100, Jonathan Tripathy wrote:
> On 03.09.2012 01:37, Kent Overstreet wrote:
> >Shell access would probably be fastest, I suppose...
> >
> >One thing that comes to mind is perhaps the load from background
> >writeback is slowing things down. Two things you can do:
> >
> >set writeback_percent to 10, that'll enable a pd controller so
> >it's not
> >going full blast
> >
> 
> Hi Kent,
> 
> I will try the above configuration change and repeat the test.
> However, it's worth noting that I left an overnight gap between from
> when my iomater run finished and from when I started the fio test.
> This was to ensure that all data had been written out to backing
> storage. While I didn't check if the cache was clean or dirty in the
> morning, I can confirm that there was no disk activity according to
> the HDD lights on the server case.

Shoot. That probably rules that out.

Yeah, I'll probably just have to poke around at random stuff. Hopefully
it's just something burning cpu and profiling will make it obvious.
