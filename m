From: Joseph Glanville <joseph.glanville-2MxvZkOi9dvvnOemgxGiVw@public.gmane.org>
Subject: Re: bcache hangs..
Date: Wed, 26 Sep 2012 08:21:44 +1000
Message-ID: <CAOzFzEiWDfot2KkWXGowvp4thY5o+rvWHNvW=ORZTHNeyucefQ@mail.gmail.com>
References: <CAPKZHbX86Jw6JYEkO8zSJqxXezXtEg_+mRGOSjzhz4NZHn-ueQ@mail.gmail.com>
	<loom.20120925T221213-151@post.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-bcache-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <loom.20120925T221213-151-eS7Uydv5nfjZ+VzJOa5vwg@public.gmane.org>
Sender: linux-bcache-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Brad Walker <bwalker-WlSugiYO8JFBDgjK7y7TUQ@public.gmane.org>
Cc: linux-bcache-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-bcache@vger.kernel.org

On 26 September 2012 06:12, Brad Walker <bwalker-WlSugiYO8JFBDgjK7y7TUQ@public.gmane.org> wrote:
> Brad Walker <bwalker@...> writes:
>
>>
>> I have a problem where BCache is hanging.
>>
>>
>
> Forgot to mention this is the latest BCache.
>
> I cloned it from the tree using
>     git clone http://evilpiepirate.org/git/linux-bcache.git
>
> bwalker@nellis:~> uname -a
> Linux nellis 3.6.0-rc3-0.5-default+ #1 SMP Tue Sep 25 11:12:26 MDT 2012 x86_64
> x86_64 x86_64 GNU/Linux
> bwalker@nellis:~>
>
> -brad w.
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-bcache" in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

Hi,

You might have better luck with the stable bcache branch, usually bcache-3.2

Joseph.

-- 
CTO | Orion Virtualisation Solutions | www.orionvm.com.au
Phone: 1300 56 99 52 | Mobile: 0428 754 846
