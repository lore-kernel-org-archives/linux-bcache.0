From: Huub Bouma <bouma-CuspTiYYhYk@public.gmane.org>
Subject: Re: Replacing the caching device (SSD) of a bcache set
Date: Sun, 11 Aug 2013 12:13:23 +0200
Message-ID: <520763C3.9080605@w20e.com>
References: <CAPBO7TbPW5thQt04kUm6gzHqAJna+2pvKU5rnwLVGc7DdBdMvA@mail.gmail.com> <20130809002550.GE15409@kmo-pixel> <CAPBO7TYh36a1ON=4zT6qvwQYAwsOy5KAu0qQLNMtLP9+ySdoMA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-bcache-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CAPBO7TYh36a1ON=4zT6qvwQYAwsOy5KAu0qQLNMtLP9+ySdoMA-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-bcache-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Josep Lladonosa <jlladono-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: linux-bcache-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-bcache@vger.kernel.org

On 08/11/2013 11:28 AM, Josep Lladonosa wrote:
> Hello, Thanks to eveybody. All working now. Just a comment. I find
> that with kernel 3.11.0-rc4 hard disk writes are teeeeeerribly slow
> (for example when installing a deb package, for example, a new kernel.
> It runs, but very slow comparing to a system running without bcache.
> Josep 

Hi Josep,

I had the exact same issue, when running dpkg it took half an hour or
so.. after chatting on IRC to Kent Overstreet I was told this was fixed,
so you might need to patch the kernel with the latest changes. I haven't
seen this issue since, but haven't done a lot of testing since either..

Cheers, Huub
