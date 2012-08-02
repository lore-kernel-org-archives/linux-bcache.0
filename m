From: John McCabe-Dansted <gmatht-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: Backing/caching ration
Date: Thu, 2 Aug 2012 11:09:51 +0800
Message-ID: <CAA-P7fUQZ4H679vZP+51JXu6BEDwWhS_xM0ov61JDUvMYQQqnA@mail.gmail.com>
References: <20120801170143.GA2549@lazy.lzy>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-bcache-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20120801170143.GA2549-W+Wf6LxwHt0@public.gmane.org>
Sender: linux-bcache-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Piergiorgio Sartor <piergiorgio.sartor-i47jiTeKxPI@public.gmane.org>
Cc: linux-bcache-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-bcache@vger.kernel.org

On Thu, Aug 2, 2012 at 1:01 AM, Piergiorgio Sartor
<piergiorgio.sartor-i47jiTeKxPI@public.gmane.org> wrote:
..
> At the moment, I've 1TB RAID-10, of which /usr is
> 24GiB (10GiB used), /home is 64GiB, and then there

So this is a desktop then?

> are two "work area" volumes of 250GiB.
>
> Some other space is spread around /var and similar,
> and there is some backup space, for future use.
>
> Any idea on what could be "minimum" SSD size (due to
> cost, of course).

What is your objective? To speed up normal Desktop tasks such as
booting and loading applications? I haven't kept to date with bcache,
so my advice may be outdated, but...

Given that you only use 10GB of usr my hunch would be that 16GB would
be plenty; However, at 16GB speed is a concern, particularly as 16GB
SSDs are usually sitting on the other side of a USB2 port. The maximum
write speed of your raid array is going to be capped to the write
speed of the SSD unless you use write-around.

If price is really a concern you could try using an old 4gb usb stick
to writearound cache /usr, and see it that helps somewhat.

In summary, if you want the benefit of writeback caching, get a decent
2.5" internal SSD. Internal SSD are pretty much always at least 32GB,
which should be plenty for normal Linux desktop use.


Hope this helps,


-- 
John C. McCabe-Dansted
