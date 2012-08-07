From: Joseph Glanville <joseph.glanville-2MxvZkOi9dvvnOemgxGiVw@public.gmane.org>
Subject: Re: add to Debian
Date: Tue, 7 Aug 2012 16:12:57 +1000
Message-ID: <CAOzFzEicSMKQ4eerE2_J30vJhsYnm1Y7KPvCkVA5T3Dg0KEN9A@mail.gmail.com>
References: <6035A0D088A63A46850C3988ED045A4B299EA53B@BITCOM1.int.sbss.com.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-bcache-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <6035A0D088A63A46850C3988ED045A4B299EA53B-mzsoxcrO4/2UD0RQwgcqbDSf8X3wrgjD@public.gmane.org>
Sender: linux-bcache-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: James Harper <james.harper-NMzNsA1hOHcW+bLBXbPJGg@public.gmane.org>
Cc: "linux-bcache-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-bcache-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-bcache@vger.kernel.org

On 7 August 2012 15:39, James Harper <james.harper-NMzNsA1hOHcW+bLBXbPJGg@public.gmane.org> wrote:
> Any suggestions on the best way to get bcache onto a Debian Wheezy system?
>
> Would the current patches apply cleanly against 3.2?
>
> James
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-bcache" in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

Hi James,

Yes the current patches apply cleanly afaik. :)

There is still an outstanding bug with relation to Xen's blkback that
I haven't had time to debug further yet that you might run into.

Joseph.

-- 
CTO | Orion Virtualisation Solutions | www.orionvm.com.au
Phone: 1300 56 99 52 | Mobile: 0428 754 846
