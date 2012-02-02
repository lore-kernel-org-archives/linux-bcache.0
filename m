From: Piergiorgio Sartor <piergiorgio.sartor-KvP5wT2u2U0@public.gmane.org>
Subject: Re: Formatting of backing device
Date: Thu, 2 Feb 2012 20:01:22 +0100
Message-ID: <20120202190122.GA2353@lazy.lzy>
References: <20120201101041.GA2779@lazy.lzy>
 <CAHYUNGYcs3CeRA8Pk-R_3hA6mFHshKzysxRaCcsfm3WLT__B0A@mail.gmail.com>
 <20120201205456.GA7669@lazy.lzy>
 <CAHYUNGaB4LCESDWU1tWB1ZJp_kBH_=19e07vCndxXS5T98_xBA@mail.gmail.com>
 <20120201214443.GA8544@lazy.lzy>
 <CAHYUNGYyPafQzmwMdS-tRAPsYYM+9uRpN-38Av4uDJwtwY_d=A@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-bcache-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <CAHYUNGYyPafQzmwMdS-tRAPsYYM+9uRpN-38Av4uDJwtwY_d=A@mail.gmail.com>
Sender: linux-bcache-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Adam Berkan <aberkan-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Cc: Piergiorgio Sartor <piergiorgio.sartor-KvP5wT2u2U0@public.gmane.org>, linux-bcache-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-bcache@vger.kernel.org

Hi Adam,

On Wed, Feb 01, 2012 at 03:11:54PM -0800, Adam Berkan wrote:
> When we make-bcache on a drive we need to replace the filesytem
> superblock with a bcache superblock so the kernel knows to load the
> drive through bcache, but this destroys the filesystem.  We've talked

well, I guess it will destroy the md superblock 1.1 too,
how about LVM metadata?

I think the mismatch is with /dev/bcacheX device.

The first implementation, as far as I remember, was simply
telling the caching device (using UUID) which was the
backing device, i.e. it was registering the backing to
the caching.
Then, still if I got it right, the bcache was caching the
backing device directly, without any need of a third
device (/dev/bcacheX).

I understand that the actual implementation is easier and,
maybe, simpler, since a completely new device is added,
which will have the new caching "features", while the
old one (backing device) is just a further layer.
This is similar to LVM over md over /dev/sdX.

Nevertheless, my opinioni is, while still considering bcache
a great project, that it should work on already existing
devices, without touching them.

Anyway, thanks a lot for the chat,

bye,

pg

> about hacky ways to hide the bcache superblock somewhere else, but
> it's very dangerous stuff that's likely to fail and we don't want to
> support it.
>=20
> Adam
>=20
>=20
>=20
> On Wed, Feb 1, 2012 at 1:44 PM, Piergiorgio Sartor
> <piergiorgio.sartor-KvP5wT2u2U0@public.gmane.org> wrote:
> > Hi Adam,
> >
> > On Wed, Feb 01, 2012 at 01:38:12PM -0800, Adam Berkan wrote:
> >> Oh, sorry I misunderstood.
> >>
> >> You have to run make-bcache once to add a bcache superblock to the=
 drive.
> >> =A0After that the drive contents are destroyed and it needs to be =
formatted
> >> with a filesystem.
> >
> > ah! That's not good...
> >
> > Is there any plan to have the caching device attachable
> > and detachable from *any* backing device without prior
> > "formatting" of this second one?
> >
> > I think bcache is a very interesting and promising
> > project, but formatting the backing device is
> > something, I think, that should be avoided.
> >
> > bye,
> >
> > pg
> >
> >> At that point you can attach or detach the drive while it is in us=
e.
> >>
> >> Adam
> >>
> >> On Wed, Feb 1, 2012 at 12:54 PM, Piergiorgio Sartor <
> >> piergiorgio.sartor-KvP5wT2u2U0@public.gmane.org> wrote:
> >>
> >> > Hi Adam,
> >> >
> >> > thanks for the answer, see below.
> >> >
> >> > On Wed, Feb 01, 2012 at 11:04:59AM -0800, Adam Berkan wrote:
> >> > > You can attach bcache to a drive with an existing file system,=
 and it
> >> > will
> >> > > continue as normal. =A0If you connect to a drive without a fil=
e system,
> >> > then
> >> > > it will continue to not have a file system, but you can format=
 it while
> >> > > attached.
> >> >
> >> > Maybe I misused the term "format".
> >> >
> >> > I did not mean filesystem format, but bcache format.
> >> >
> >> > What I understood, maybe I'm wrong, is that the backing
> >> > device, before being used, must be "initialized" with
> >> > the bcache tool.
> >> >
> >> > From the docs:
> >> >
> >> > Getting started:
> >> > You'll need make-bcache from the bcache-tools repository. Both t=
he cache
> >> > device
> >> > and backing device must be formatted before use.
> >> > =A0make-bcache -B /dev/sdb
> >> > =A0make-bcache -C -w2k -b1M -j64 /dev/sdc
> >> >
> >> > I understand this as the backing device gets something
> >> > on written on it (note the term "formatted").
> >> >
> >> > Am I wrong? I hope so...
> >> >
> >> > Thanks again,
> >> >
> >> > bye,
> >> >
> >> > pg
> >> >
> >> > > Attach/detach should work while the device is in use. =A0This =
isn't the
> >> > most
> >> > > tested code path, especially with writeback on, but it's suppo=
sed to
> >> > work.
> >> > > =A0Detaching while the cache is dirty requires flushing all th=
at data so
> >> > > performance will be bad until the detach completes.
> >> > >
> >> > > Let us know if you find any bugs.
> >> > > Adam
> >> > >
> >> > > On Wed, Feb 1, 2012 at 2:10 AM, Piergiorgio Sartor <
> >> > > piergiorgio.sartor-KvP5wT2u2U0@public.gmane.org> wrote:
> >> > >
> >> > > > Hi all,
> >> > > >
> >> > > > first of all I would like to congratulate for this
> >> > > > project, I think it is one of the most promising
> >> > > > feature the Linux kernel can have.
> >> > > >
> >> > > > Wrote that, I've a question about the concept of
> >> > > > formatting the backing device.
> >> > > >
> >> > > > As far as I understood, the first concept of bcache
> >> > > > was to simply "register" or "attach" a cache to a
> >> > > > backing device, that is, the backing device had not
> >> > > > to be formatted.
> >> > > >
> >> > > > Lately, still if I understood it correctly, this
> >> > > > behaviour was changed and, now, the backing device
> >> > > > needs to be formatted.
> >> > > >
> >> > > > So, the question is:
> >> > > >
> >> > > > How about an already running device? Is it still
> >> > > > possible to attach a cache under such situation?
> >> > > >
> >> > > > In general, would it be possible to attach/detach
> >> > > > a cache to any already available device (in the
> >> > > > future)? Or the caching/backing setup must be planned
> >> > > > before the HW is available, so to speak?
> >> > > >
> >> > > > It would be useful (and cool too), to have the
> >> > > > possibility to attach/detach the SSD cache, on
> >> > > > the fly (at run-time) to any device it needs it.
> >> > > >
> >> > > > I hope the question(s) are clear, if not please
> >> > > > let me know.
> >> > > >
> >> > > > Thanks a lot in advance,
> >> > > >
> >> > > > bye,
> >> > > >
> >> > > > --
> >> > > >
> >> > > > piergiorgio
> >> > > > --
> >> > > > To unsubscribe from this list: send the line "unsubscribe
> >> > linux-bcache" in
> >> > > > the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> >> > > > More majordomo info at =A0http://vger.kernel.org/majordomo-i=
nfo.html
> >> > > >
> >> >
> >> > --
> >> >
> >> > piergiorgio
> >> >
> >
> > --
> >
> > piergiorgio

--=20

piergiorgio
