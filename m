From: James Harper <james.harper-NMzNsA1hOHcW+bLBXbPJGg@public.gmane.org>
Subject: RE: add to Debian
Date: Tue, 7 Aug 2012 12:15:31 +0000
Message-ID: <6035A0D088A63A46850C3988ED045A4B299EAF7D@BITCOM1.int.sbss.com.au>
References: <6035A0D088A63A46850C3988ED045A4B299EA53B@BITCOM1.int.sbss.com.au>
	<CAOzFzEicSMKQ4eerE2_J30vJhsYnm1Y7KPvCkVA5T3Dg0KEN9A@mail.gmail.com>
	<6035A0D088A63A46850C3988ED045A4B299EAE1D@BITCOM1.int.sbss.com.au>
 <CAOzFzEi97TuJrR7jnEq9SvNyQPTq8Fat1FmMfFHxvYN0P0XioQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-bcache-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CAOzFzEi97TuJrR7jnEq9SvNyQPTq8Fat1FmMfFHxvYN0P0XioQ-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Content-Language: en-US
Sender: linux-bcache-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Joseph Glanville <joseph.glanville-2MxvZkOi9dvvnOemgxGiVw@public.gmane.org>
Cc: "linux-bcache-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-bcache-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-bcache@vger.kernel.org

> 
> The bcache tree is rebased on Linus's tree every now and then.
> Generally there is a bunch of branches that refer to the relevant
> releases/backports of the bcache code.
> Linus's tags are still intact though so you can do a git diff <tagname> or any
> other <refspec>
> 
> For 3.2 it would be something along the lines of this:
> 
> git clone http://evilpiepirate.org/git/linux-bcache.git
> git checkout bcache-3.2
> git diff v3.2
> 

Is the bcache-3.2 branch as up to date (wrt bcache code) as the bcache branch?

Thanks

James
