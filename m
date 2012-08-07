From: Kent Overstreet <koverstreet-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Subject: Re: Unable to mount btrfs rootfs over after merging bcache
Date: Tue, 7 Aug 2012 02:02:04 -0700
Message-ID: <CAH+dOx+U4uHQGw2yS7Pr7ObKQ7YVVJoV789+caEOKwpMbh9ZHw@mail.gmail.com>
References: <jvqffl$6ci$1@dough.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-bcache-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <jvqffl$6ci$1@dough.gmane.org>
Sender: linux-bcache-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Alex Elsayed <eternaleye+usenet-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: linux-bcache-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-bcache@vger.kernel.org

I'll give it a try and see what happens - we'll see if I can reproduce it.

On Tue, Aug 7, 2012 at 12:18 AM, Alex Elsayed
<eternaleye+usenet-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrote:
> Hi, I've found that if I merge bcache into my kernel it causes booting with
> a btrfs rootfs on top of dm-thin (with dm-crypt under it) to fail. In 3.4 it
> looped indefinitely IIRC, whereas with 3.5 it OOPSed until panic.
>
> I don't have logs, sadly, as this occurs before I have a writable FS.
>
> I will note that I don't have a bcache device, and this occurs even if
> bcache is compiled out.
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-bcache" in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
