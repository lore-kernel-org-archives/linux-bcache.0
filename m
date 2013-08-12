From: Josep Lladonosa <jlladono-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: Replacing the caching device (SSD) of a bcache set
Date: Mon, 12 Aug 2013 10:21:24 +0200
Message-ID: <CAPBO7TaGt2sPaLn1AoYv1yNbE6px1dXeFAf6S6jCFSOjHGBSMQ@mail.gmail.com>
References: <CAPBO7TbPW5thQt04kUm6gzHqAJna+2pvKU5rnwLVGc7DdBdMvA@mail.gmail.com>
	<20130809002550.GE15409@kmo-pixel>
	<CAPBO7TYh36a1ON=4zT6qvwQYAwsOy5KAu0qQLNMtLP9+ySdoMA@mail.gmail.com>
	<520763C3.9080605@w20e.com>
	<CAPBO7TZn9R3aYbkca214eEQqpujie-XWZeHXmzx-EeMSB9JJcA@mail.gmail.com>
	<CA+res+TDPvuqj1A=6OznPRyA+OZnfHSo7=d=82gTrELaby7vPg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-bcache-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CA+res+TDPvuqj1A=6OznPRyA+OZnfHSo7=d=82gTrELaby7vPg-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-bcache-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jack Wang <jack.wang.usish-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: Huub Bouma <bouma-CuspTiYYhYk@public.gmane.org>, "linux-bcache-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-bcache-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-bcache@vger.kernel.org

On 11 August 2013 16:17, Jack Wang <jack.wang.usish-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrote:
> Hi Josep,
>
> I think what you need is patch below
>
> http://evilpiepirate.org/git/linux-bcache.git/patch/?id=2c19adf62316ff0bb9db85b11845d18b7009ab4b
>
> http://evilpiepirate.org/git/linux-bcache.git/commit/?h=bcache-for-3.11
>
> Apply that patch and re complile your bcache should work

Thanks Jack. Unfortunately long writes to drive are still slow.
Checked the patch against 3.11.0-rc4 and 3.11.0-rc5...

Josep

>
> KR
>
> Jack
>
>
> 2013/8/11 Josep Lladonosa <jlladono-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
>>
>> On 11 August 2013 12:13, Huub Bouma <bouma-CuspTiYYhYk@public.gmane.org> wrote:
>> > On 08/11/2013 11:28 AM, Josep Lladonosa wrote:
>> >> Hello, Thanks to eveybody. All working now. Just a comment. I find
>> >> that with kernel 3.11.0-rc4 hard disk writes are teeeeeerribly slow
>> >> (for example when installing a deb package, for example, a new kernel.
>> >> It runs, but very slow comparing to a system running without bcache.
>> >> Josep
>> >
>> > Hi Josep,
>> >
>> > I had the exact same issue, when running dpkg it took half an hour or
>> > so.. after chatting on IRC to Kent Overstreet I was told this was fixed,
>> > so you might need to patch the kernel with the latest changes. I haven't
>> > seen this issue since, but haven't done a lot of testing since either..
>> >
>> > Cheers, Huub
>>
>> Thanks. I wanted to git clone
>> http://evilpiepirate.org/git/linux-bcache.git
>> but it gives me timeout. I am very new to git and so. Is there an easy
>> way to the patch from git to patch 3.11.0-rc4 with the latest? (Or how
>> getting just the drivers/md/bcache folder and replace it would do,
>> yes?)
>>
>>
>>
>> --
>> --
>> Salutacions...Josep
>> --
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-bcache" in
>> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>
>



-- 
--
Salutacions...Josep
--
