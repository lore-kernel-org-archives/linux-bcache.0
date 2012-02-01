From: Adam Berkan <aberkan-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Subject: Re: Formatting of backing device
Date: Wed, 1 Feb 2012 11:12:52 -0800
Message-ID: <CAHYUNGZMgErz=WSB8SoMmq=mw5E+t4eBD1g4P2+SuwX_nnpSZw@mail.gmail.com>
References: <20120201101041.GA2779@lazy.lzy>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-bcache-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20120201101041.GA2779-W+Wf6LxwHt0@public.gmane.org>
Sender: linux-bcache-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Piergiorgio Sartor <piergiorgio.sartor-KvP5wT2u2U0@public.gmane.org>
Cc: linux-bcache-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-bcache@vger.kernel.org

You can attach bcache to a drive with an existing file system, and it
will continue as normal. =A0If you connect to a drive without a file
system, then it will continue to not have a file system, but you can
format it while attached.

Attach/detach should work while the device is in use. =A0This isn't the
most tested code path, especially with writeback on, but it's supposed
to work. =A0Detaching while the cache is dirty requires flushing all
that data so performance will be bad until the detach completes.

Let us know if you find any bugs.

On Wed, Feb 1, 2012 at 2:10 AM, Piergiorgio Sartor
<piergiorgio.sartor-KvP5wT2u2U0@public.gmane.org> wrote:
>
> Hi all,
>
> first of all I would like to congratulate for this
> project, I think it is one of the most promising
> feature the Linux kernel can have.
>
> Wrote that, I've a question about the concept of
> formatting the backing device.
>
> As far as I understood, the first concept of bcache
> was to simply "register" or "attach" a cache to a
> backing device, that is, the backing device had not
> to be formatted.
>
> Lately, still if I understood it correctly, this
> behaviour was changed and, now, the backing device
> needs to be formatted.
>
> So, the question is:
>
> How about an already running device? Is it still
> possible to attach a cache under such situation?
>
> In general, would it be possible to attach/detach
> a cache to any already available device (in the
> future)? Or the caching/backing setup must be planned
> before the HW is available, so to speak?
>
> It would be useful (and cool too), to have the
> possibility to attach/detach the SSD cache, on
> the fly (at run-time) to any device it needs it.
>
> I hope the question(s) are clear, if not please
> let me know.
>
> Thanks a lot in advance,
>
> bye,
>
> --
>
> piergiorgio
> --
> To unsubscribe from this list: send the line "unsubscribe linux-bcach=
e" in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at =A0http://vger.kernel.org/majordomo-info.html
