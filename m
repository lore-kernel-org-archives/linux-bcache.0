From: Leen Besselink <leen-RaxvPIb8m1QxPGQnf4u0eF6hYfS7NtTn@public.gmane.org>
Subject: Re: Preliminary performance benchmarks.
Date: Fri, 13 Apr 2012 13:40:50 +0200
Message-ID: <20120413114049.GA416@apia.perrit.net>
References: <20120413000546.GB2941@apia.perrit.net> <CAOzFzEgYeru29S8BnPr+y=C1=ess1d8F4v3wRFqGwiTHiWdGRQ@mail.gmail.com>
Reply-To: leen-RaxvPIb8m1QxPGQnf4u0eF6hYfS7NtTn@public.gmane.org
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-bcache-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <CAOzFzEgYeru29S8BnPr+y=C1=ess1d8F4v3wRFqGwiTHiWdGRQ-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-bcache-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-bcache-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-bcache@vger.kernel.org

On Fri, Apr 13, 2012 at 11:43:14AM +1000, Joseph Glanville wrote:
> On 13 April 2012 10:05, Leen Besselink <leen-RaxvPIb8m1QxPGQnf4u0eF6hYfS7NtTn@public.gmane.org> wrote=
:
> > (I've been lurking the mailinglist archive for a few months already=
, I think
> > bcache sounds really interresting)
> >
> > Hello Joseph,
> >
> >> Carrying out some scalability tests on high I/O systems. More test=
s to
> >> come using the Phoronix Test Suite.
> >>
> >> Fio summary:
> >> 24 jobs
> >> Direct IO
> >> Randwrite test
> >> Total of about 80k IOPs at 3.5k IOPS per thread.
> >>
> >> Test rig specs:
> >> 2x Intel(R) Xeon(R) CPU X5650 =A0@ 2.67GHz (12 physical cores, 24 =
logical)
> >> 12x 2TB Seagate nearline-SAS in RAID6 on LSI Logic / Symbios Logic=
 LSI
> >> MegaSAS 9260
> >> 2x Intel 520 SSDs 120GB in RAID0
> >>
> >> The 2 520s are striped with md raid as /dev/md0 whch is formatted =
as a
> >> bcache cache device using 1M buckets and 8k hard block size
> >> Backing device is the big old raid6.
> >>
> >> Random IO performance of the native raid0 is about 96K IOPs, backi=
ng
> >> device in the realm of 1600ish.
> >> However the backing device has a sequential IO performance of abou=
t 1.5GB/s.
> >>
> >
> > So why do you put your SSDs in RAID0 ?
> >
> > If you are using RAID6 for your HDD you obviously care about your d=
ata, shouldn't
> > you be using RAID1 or let bcache do some RAID1-like behaviour* ?
> >
> > Because when you use RAID0 your data will only be written to one SS=
D.
> >
> > * I think bcache had some ability to handle that sort of automatica=
lly.
>=20
> I used RAID0 to demonstrate bcache scaling to 80k IOPs, this was not =
a
> production machine nor a production configuration.
>=20

OK, that explains it.

> Yes, atleast somewhat. Bcache cache devices are structured into
> cache-sets, which are groups of SSDs that form one logical cache whic=
h
> you can attach multiple backing devices to.
> This is different from RAID1 because only dirty data is mirrored. You
> don't need redundant copies of your read cache but you care very much
> that you don't lose writeback cache data.
> This isn't fully fleshed out in bcache yet but all the infrastructure
> is there, I am looking to doing some work on it soonish I have just
> been busy with other things.

Yes, only mirror the dirty data. That is what it was, now I remember.

Good to know what the state of development is also.

Thanks.

> >
> >> Below are some quick findings using fio - showing very good
> >> scalability of bcache even with very very fast SSDs.
> >> *Note: The SSDs are connected via a SATA2 interface being somewhat=
 of
> >> a bottleneck.
> >
> > Have a nice day,
> > =A0 =A0 =A0 =A0Leen.
> > --
> > To unsubscribe from this list: send the line "unsubscribe linux-bca=
che" in
> > the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> > More majordomo info at =A0http://vger.kernel.org/majordomo-info.htm=
l
>=20
> Joseph.
>=20
> --=20
> Founder | Director | VP Research
> Orion Virtualisation Solutions=A0|=A0www.orionvm.com.au=A0| Phone: 13=
00 56
> 99 52 | Mobile: 0428 754 846
> --
> To unsubscribe from this list: send the line "unsubscribe linux-bcach=
e" in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
