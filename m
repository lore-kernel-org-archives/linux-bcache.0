From: "gnehzuil.lzheng-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org" <gnehzuil.lzheng-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: add to Debian
Date: Wed, 08 Aug 2012 13:04:09 +0800
Message-ID: <5021F349.9030605@gmail.com>
References: <6035A0D088A63A46850C3988ED045A4B299EA53B@BITCOM1.int.sbss.com.au> <CAOzFzEicSMKQ4eerE2_J30vJhsYnm1Y7KPvCkVA5T3Dg0KEN9A@mail.gmail.com> <6035A0D088A63A46850C3988ED045A4B299EAE1D@BITCOM1.int.sbss.com.au> <CAOzFzEi97TuJrR7jnEq9SvNyQPTq8Fat1FmMfFHxvYN0P0XioQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-bcache-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CAOzFzEi97TuJrR7jnEq9SvNyQPTq8Fat1FmMfFHxvYN0P0XioQ-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-bcache-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Joseph Glanville <joseph.glanville-2MxvZkOi9dvvnOemgxGiVw@public.gmane.org>
Cc: James Harper <james.harper-NMzNsA1hOHcW+bLBXbPJGg@public.gmane.org>, "linux-bcache-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-bcache-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-bcache@vger.kernel.org

On 08/07/2012 08:12 PM, Joseph Glanville wrote:
> On 7 August 2012 21:30, James Harper <james.harper-NMzNsA1hOHcW+bLBXbPJGg@public.gmane.org> wrote:
>>>
>>> Hi James,
>>>
>>> Yes the current patches apply cleanly afaik. :)
>>>
>>> There is still an outstanding bug with relation to Xen's blkback that I haven't
>>> had time to debug further yet that you might run into.
>>>
>>
>> What is the best way to get a diff against the current linux head?
>>
>> Thanks
>>
>> James
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-bcache" in
>> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
> The bcache tree is rebased on Linus's tree every now and then.
> Generally there is a bunch of branches that refer to the relevant
> releases/backports of the bcache code.
> Linus's tags are still intact though so you can do a git diff
> <tagname> or any other <refspec>
> 
> For 3.2 it would be something along the lines of this:
> 
> git clone http://evilpiepirate.org/git/linux-bcache.git

Hi Joseph,

I cannot get bcache repo from this url.  Could you please tell me where
can I get it in another url?  Thanks.

Regards,
Zheng
