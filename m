From: luvar-2S8i3W4CjuIzjkFyG6Beag@public.gmane.org
Subject: Re: comparison with rival projects
Date: Thu, 16 Dec 2010 01:46:46 +0100 (GMT+01:00)
Message-ID: <1474160620.28501292460406484.JavaMail.root@shiva>
References: <824216649.28481292460292573.JavaMail.root@shiva>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-bcache-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <824216649.28481292460292573.JavaMail.root@shiva>
Sender: linux-bcache-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Nauman Rafique <nauman-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Cc: linux-bcache-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, info-2S8i3W4CjuIzjkFyG6Beag@public.gmane.org, Kent Overstreet <kent.overstreet-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
List-Id: linux-bcache@vger.kernel.org

=46irst of all, I would like to thanks for answers.

One more question and some reply in text.

After making ssd disc a cache for some partition, there is possibility =
to detach cache. What should I do to "erase" (trim) whole disk for anot=
her benchmarking? I think that "dd if=3D/dev/zero of=3D/dev/sdx" wouldn=
t be right command.

----- "Nauman Rafique" <nauman-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org> wrote:

> On Wed, Dec 15, 2010 at 4:05 PM, Kent Overstreet
> <kent.overstreet-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrote:
> > On 12/15/2010 03:26 PM, luvar-2S8i3W4CjuIzjkFyG6Beag@public.gmane.org wrote:
> >>
> >> Hi,
> >> Iam new in problematic of caching persistent data. I want to use
> caching
> >> (on ssd disk) on my desktop with a lot of ram. I hope, it will
> provide me
> >> better latency for starting programs (developer/scientific
> desktop). My
> >> questions are:
> >>
> >> Is it possible to use single ssd disk for making two caches? One
> for
> >> /dev/md2 (root partition, raid10) and second for /dev/md3
> (raid5,home
> >> partition, etc) (I hope this is possible by partitioning that ssd
> disk and
> >> using partitions for caching)
> >
> > Yep. One cache device can be used with (currently) up to 256
> backing
> > devices.
> >
> >>
> >> Is it dangerous (in terms of data loss) to use writethrough cachin=
g
> to
> >> single ssd disk of raid5 block device? (I have 5 disks, using lvm
> on top of
> >> raid).
> >
> > Shouldn't be, recovery from unclean shutdown is quite well tested,
> both
> > writethrough and writeback should be perfectly safe.
> >
> >>
> >> For caching device is most critical number for random reads or
> operations
> >> per second. Is it right?
> >
> > For writethrough caching random reads, for writeback both reads and
> writes.
> >
> >>
> >> Trim is not need feature for cache ssd device. It will have same
> cache
> >> performance without it. Is it right?
> >
> > Really just depends on the ssd; some (cheaper, earlier) drives are
> known for
> > performance significantly degrading over time, with trim helps with
> (but
> > doesn't necessarily eliminate). Bcache uses trim if it's available.
> >
> >>
> >> What benefits/disadvantages have bcache [1] project over dm-cache
> [2] and
> >> flashcache [3]? My current knowledge is that writethrough is
> possible only
> >> in bcache, but dm-cache is implemented in more "standard" way
> (thdough
> >> devicemaper). Also bcache has some more information on web.
> >>
> >> [1] - http://bcache.evilpiepirate.org/
> >> [2] - http://users.cis.fiu.edu/~zhaom/dmcache/index.html
> >> [3] - https://github.com/facebook/flashcache
> >
> > Flashcache is based off of dm-cache.
> >
> > Flashcache has been used in production awhile, bcache is still a
> little
> > rough around the edges - but bcache has better performance, more
> features,
> > and it always orders writes correctly so as to be crash safe
> (flashcache has
> > a "torn write" problem).
>=20
> Kent, now that we are on the topic, I wonder if there has been some
> benchmarking comparing bcache to flashcache performance?
>=20
> Also I wonder if you plan to target for getting bcache included in
> mainline kernel. I wonder if such attempts were made for flashcache
> but that's probably off-topic.

I hope, next two links will help in making comparison.
http://www.mysqlperformanceblog.com/2010/05/10/flashcache-first-experim=
ents/
http://www.mysqlperformanceblog.com/2010/05/18/flashcache-more-benchmar=
ks/
There is simple methodology of cache testing by using it with mysql dat=
abase. I hope, someone will catch this discussion and try some comparab=
le test on bcache.

=46or me will be next test sufficient:
Activate caching and make for example 20 reboots. Measure time from com=
puter bios beep till starting gimp, which will be in gnome/kde/fluxbox =
autostart script. Of course before starting gimp, there will be need fo=
r starting some other programs like firefox, eclipse, mplayer with some=
 film...

I would like to see these times of booting in graph. I promise that aft=
er installation of bcache I will do this test with bcache and post it h=
ere.

>=20
> Thanks.
> --
> Nauman
>=20
> >
> >>
> >> PS: Is there any tutorial for gentoo users?
> >
> > Nah, I'm an ubuntu/debian user. For caching / the important thing i=
s
> to hook
> > into your initramfs and get everything loaded before you mount your
> root
> > filesystem.
> >
> >>
> >> Thanks for any explanations / answers,
> >> --
> >> LuVar
> >> --
> >> To unsubscribe from this list: send the line "unsubscribe
> linux-bcache" in
> >> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> >> More majordomo info at =C2=A0http://vger.kernel.org/majordomo-info=
=2Ehtml
> >
> > --
> > To unsubscribe from this list: send the line "unsubscribe
> linux-bcache" in
> > the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> > More majordomo info at =C2=A0http://vger.kernel.org/majordomo-info.=
html
> >

PS: I am now decided to use bcache (after buying some ssd).
--
To unsubscribe from this list: send the line "unsubscribe linux-bcache"=
 in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
