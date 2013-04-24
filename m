From: Kent Overstreet <koverstreet-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Subject: Re: backporting bcache-testing to kernel 3.4
Date: Wed, 24 Apr 2013 13:41:03 -0700
Message-ID: <CAH+dOx+QJTebijkPSe6LvD_S-rCSJKdEv6izfsGGYpQ2io1rRA@mail.gmail.com>
References: <20130422192100.GA16221@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-bcache-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20130422192100.GA16221-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Sender: linux-bcache-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Dongsu Park <dongsu.park-EIkl63zCoXaH+58JC4qpiA@public.gmane.org>
Cc: "linux-bcache-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-bcache-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-bcache@vger.kernel.org

This sounds like the bug I _think_ I just fixed - Do you suppose you
could try again with the current bcache branch?

On Mon, Apr 22, 2013 at 12:21 PM, Dongsu Park
<dongsu.park-EIkl63zCoXaH+58JC4qpiA@public.gmane.org> wrote:
> Hi,
>
> has anyone succeeded backporting bcache(-testing) branch to kernel 3.4?
>
> I tried to get it working, patching commits from bcache-testing branch
> as well as block patches by Kent, on top of Kernel 3.4.23.
>
> * writeback mode
> * backing device: MD-RAID0, or a HDD
> * cache device: loopback device on tmpfs (for test)
> * testing command:
>    dd if=/dev/zero of=/dev/bcache0 bs=4K count=1M oflag=sync
>
> Everything works fine, except for a problem of sync operation.
> Every write request is being immediately flushed into backing device.
> That's actually what I want to avoid in writeback caches.
> Observing block I/Os with iostat, it's weird that no data is actually
> written to backing device, despite of high IOPs. e.g.:
>
> Device:  rrqm/s   wrqm/s  r/s     w/s    rMB/s    wMB/s
> avgrq-sz avgqu-sz   await r_await w_await svctm  %util
> vdb      0.00     0.00    0.00 2550.00    0.00     0.00
> 0.00     2.05       0.81  0.00    0.81    0.26   67.00
>
> If I test bcache-testing branch based on kernel 3.9-rc3, which means
> without backporting, then it works well without such massive bogus syncs.
> bcache-3.2 is also fine. So I suppose there might be any change on the
> block layer between 3.4 and 3.9, making bcache work in such a strange way.
>
> Any idea?
>
> Dongsu
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-bcache" in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
