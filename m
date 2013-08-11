From: Josep Lladonosa <jlladono-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: Replacing the caching device (SSD) of a bcache set
Date: Sun, 11 Aug 2013 13:19:17 +0200
Message-ID: <CAPBO7TZn9R3aYbkca214eEQqpujie-XWZeHXmzx-EeMSB9JJcA@mail.gmail.com>
References: <CAPBO7TbPW5thQt04kUm6gzHqAJna+2pvKU5rnwLVGc7DdBdMvA@mail.gmail.com>
	<20130809002550.GE15409@kmo-pixel>
	<CAPBO7TYh36a1ON=4zT6qvwQYAwsOy5KAu0qQLNMtLP9+ySdoMA@mail.gmail.com>
	<520763C3.9080605@w20e.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-bcache-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <520763C3.9080605-CuspTiYYhYk@public.gmane.org>
Sender: linux-bcache-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Huub Bouma <bouma-CuspTiYYhYk@public.gmane.org>
Cc: linux-bcache-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-bcache@vger.kernel.org

On 11 August 2013 12:13, Huub Bouma <bouma-CuspTiYYhYk@public.gmane.org> wrote:
> On 08/11/2013 11:28 AM, Josep Lladonosa wrote:
>> Hello, Thanks to eveybody. All working now. Just a comment. I find
>> that with kernel 3.11.0-rc4 hard disk writes are teeeeeerribly slow
>> (for example when installing a deb package, for example, a new kernel.
>> It runs, but very slow comparing to a system running without bcache.
>> Josep
>
> Hi Josep,
>
> I had the exact same issue, when running dpkg it took half an hour or
> so.. after chatting on IRC to Kent Overstreet I was told this was fixed,
> so you might need to patch the kernel with the latest changes. I haven't
> seen this issue since, but haven't done a lot of testing since either..
>
> Cheers, Huub

Thanks. I wanted to git clone http://evilpiepirate.org/git/linux-bcache.git
but it gives me timeout. I am very new to git and so. Is there an easy
way to the patch from git to patch 3.11.0-rc4 with the latest? (Or how
getting just the drivers/md/bcache folder and replace it would do,
yes?)



-- 
--
Salutacions...Josep
--
