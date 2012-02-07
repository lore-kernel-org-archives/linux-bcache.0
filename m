From: Piergiorgio Sartor <piergiorgio.sartor-KvP5wT2u2U0@public.gmane.org>
Subject: Re: bcache on layered devices
Date: Tue, 7 Feb 2012 20:12:13 +0100
Message-ID: <20120207191213.GA2581@lazy.lzy>
References: <20120206185612.GA2381@lazy.lzy>
 <CAH+dOxKir2mKZfq6r=aHngQeRxmPreS9=ch4dGaFtGscfkxBpA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-bcache-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <CAH+dOxKir2mKZfq6r=aHngQeRxmPreS9=ch4dGaFtGscfkxBpA-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-bcache-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Kent Overstreet <koverstreet-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Cc: Piergiorgio Sartor <piergiorgio.sartor-KvP5wT2u2U0@public.gmane.org>, linux-bcache-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-bcache@vger.kernel.org

Hi Kent,

thanks for the answer.

Reading bcache docs, I found that there should be
distinction, in bcache, between "small" writes
and "large" writes.

I was wondering if the choice of the layer could
influence this distinction.
Namely, LV uses PE of 4MB, which, I'm not sure,
results in writes of 4MB as smallest size.

Thanks,

bye,

pg

On Mon, Feb 06, 2012 at 12:34:57PM -0800, Kent Overstreet wrote:
> I'd personally use the raid as the backing device but any would work =
-
> you would have duplicates ending up in the cache if you cached the
> hard drives directly.
>=20
> On Mon, Feb 6, 2012 at 10:56 AM, Piergiorgio Sartor
> <piergiorgio.sartor-KvP5wT2u2U0@public.gmane.org> wrote:
> > Hi all again,
> >
> > I'm not sure if the topic was already discussed here,
> > anyway I'll go ahead, sorry if it is a duplication.
> >
> > I was wondering, in case of layered devices, what would
> > be the best layer to use as backing device.
> >
> > Specifically, I've two HDDs in RAID10 (Linux md driver,
> > software RAID), on top of the RAID there are LV partitions.
> >
> > Obviously, it would be possible to use the RAID components,
> > i.e. the HDDs as backing devices, or the RAID itself, or
> > the LV partitions (/dev/mapper/VolXXX).
> >
> > My guess would be to use the LV partitions, since these
> > are closer to the filesystem, but, maybe, using the RAID
> > or even the single HDDs could be better.
> >
> > Any idea on the topic? Suggestions & motivations?
> >
> > Thanks a lot in advance,
> >
> > bye,
> >
> > --
> >
> > piergiorgio
> > --
> > To unsubscribe from this list: send the line "unsubscribe linux-bca=
che" in
> > the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> > More majordomo info at =A0http://vger.kernel.org/majordomo-info.htm=
l
> --
> To unsubscribe from this list: send the line "unsubscribe linux-bcach=
e" in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

--=20

piergiorgio
