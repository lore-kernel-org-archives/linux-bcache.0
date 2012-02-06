From: Kent Overstreet <koverstreet-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Subject: Re: bcache on layered devices
Date: Mon, 6 Feb 2012 12:34:57 -0800
Message-ID: <CAH+dOxKir2mKZfq6r=aHngQeRxmPreS9=ch4dGaFtGscfkxBpA@mail.gmail.com>
References: <20120206185612.GA2381@lazy.lzy>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-bcache-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20120206185612.GA2381-W+Wf6LxwHt0@public.gmane.org>
Sender: linux-bcache-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Piergiorgio Sartor <piergiorgio.sartor-KvP5wT2u2U0@public.gmane.org>
Cc: linux-bcache-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-bcache@vger.kernel.org

I'd personally use the raid as the backing device but any would work -
you would have duplicates ending up in the cache if you cached the
hard drives directly.

On Mon, Feb 6, 2012 at 10:56 AM, Piergiorgio Sartor
<piergiorgio.sartor-KvP5wT2u2U0@public.gmane.org> wrote:
> Hi all again,
>
> I'm not sure if the topic was already discussed here,
> anyway I'll go ahead, sorry if it is a duplication.
>
> I was wondering, in case of layered devices, what would
> be the best layer to use as backing device.
>
> Specifically, I've two HDDs in RAID10 (Linux md driver,
> software RAID), on top of the RAID there are LV partitions.
>
> Obviously, it would be possible to use the RAID components,
> i.e. the HDDs as backing devices, or the RAID itself, or
> the LV partitions (/dev/mapper/VolXXX).
>
> My guess would be to use the LV partitions, since these
> are closer to the filesystem, but, maybe, using the RAID
> or even the single HDDs could be better.
>
> Any idea on the topic? Suggestions & motivations?
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
