From: Joseph Glanville <joseph.glanville-2MxvZkOi9dvvnOemgxGiVw@public.gmane.org>
Subject: Re: add to Debian
Date: Tue, 7 Aug 2012 22:21:59 +1000
Message-ID: <CAOzFzEhzt7tSBi7ZXnyZcC6UaaoHYoDfqgD6CeH5ian++=uGMg@mail.gmail.com>
References: <6035A0D088A63A46850C3988ED045A4B299EA53B@BITCOM1.int.sbss.com.au>
	<CAOzFzEicSMKQ4eerE2_J30vJhsYnm1Y7KPvCkVA5T3Dg0KEN9A@mail.gmail.com>
	<6035A0D088A63A46850C3988ED045A4B299EAE1D@BITCOM1.int.sbss.com.au>
	<CAOzFzEi97TuJrR7jnEq9SvNyQPTq8Fat1FmMfFHxvYN0P0XioQ@mail.gmail.com>
	<6035A0D088A63A46850C3988ED045A4B299EAF7D@BITCOM1.int.sbss.com.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-bcache-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <6035A0D088A63A46850C3988ED045A4B299EAF7D-mzsoxcrO4/2UD0RQwgcqbDSf8X3wrgjD@public.gmane.org>
Sender: linux-bcache-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: James Harper <james.harper-NMzNsA1hOHcW+bLBXbPJGg@public.gmane.org>
Cc: "linux-bcache-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-bcache-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-bcache@vger.kernel.org

On 7 August 2012 22:15, James Harper <james.harper-NMzNsA1hOHcW+bLBXbPJGg@public.gmane.org> wrote:
>>
>> The bcache tree is rebased on Linus's tree every now and then.
>> Generally there is a bunch of branches that refer to the relevant
>> releases/backports of the bcache code.
>> Linus's tags are still intact though so you can do a git diff <tagname> or any
>> other <refspec>
>>
>> For 3.2 it would be something along the lines of this:
>>
>> git clone http://evilpiepirate.org/git/linux-bcache.git
>> git checkout bcache-3.2
>> git diff v3.2
>>
>
> Is the bcache-3.2 branch as up to date (wrt bcache code) as the bcache branch?

Atm they are not in sync, The 3.2 code is usually pretty stable
though, at some point in time Kent will rebase his changes onto 3.2.

>
> Thanks
>
> James
> --
> To unsubscribe from this list: send the line "unsubscribe linux-bcache" in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html



-- 
CTO | Orion Virtualisation Solutions | www.orionvm.com.au
Phone: 1300 56 99 52 | Mobile: 0428 754 846
