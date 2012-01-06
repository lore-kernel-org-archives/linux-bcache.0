From: Kent Overstreet <koverstreet-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Subject: Re: Write-only Caching Without Backing
Date: Fri, 6 Jan 2012 02:56:43 -0800
Message-ID: <CAH+dOxKZs7HRqXtvgfO4M3GQTUS078OOwf0jtTM1Gefp05XCRQ@mail.gmail.com>
References: <4F06C3E8.3040001@bobich.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-bcache-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <4F06C3E8.3040001-UpbECiGlrmGsTnJN9+BGXg@public.gmane.org>
Sender: linux-bcache-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Gordan Bobic <gordan-UpbECiGlrmGsTnJN9+BGXg@public.gmane.org>
Cc: linux-bcache-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-bcache@vger.kernel.org

What you're describing would be best served not by using bcache as a
cache, but by using it only store data in the "cache device" - using
it as a better ftl, really.

That feature's on the roadmap, mostly just need to implement a moving
garbage collector - shouldn't be that much work.

On Fri, Jan 6, 2012 at 1:50 AM, Gordan Bobic <gordan-UpbECiGlrmGsTnJN9+BGXg@public.gmane.org> wrote:
> Hi,
>
> I'm looking at whether Bcache can be used (or easily modified to be u=
sed)
> for rectifying the poor random write performance of cheap flash media=
=2E
>
> I am aware of the following projects that provide similar functionali=
ty to
> what I require:
>
> Managed Flash (MFT) (not OSS, purely commercial, requires a substanti=
al
> amount of RAM for mapping)
> ReSSD (research paper, requires less RAM than MFT, no code available)
>
> Unfortunately, I am specifically interested in this for ARM machines =
that
> frequently don't have SATA ports but only SD card ports. Most SD card=
s have
> exceptionally poor random-write performance, and since the only
> semi-solution (MFT requires a substantial amount of RAM which is also=
 an
> issue on a 256MB ARM machine) doesn't support ARM, I'm looking for
> alternatives.
>
> So what I envisage (hope for?) is using Bcache in a way that does
> random-write caching by linearizing writes into sequential writes. My
> performance tests indicate that even with small blocks (4KB) and even=
 on
> some of the best SD cards, sequential writes are still at least 3-4x =
faster
> than random writes. On the worst SD cards, the difference can be as m=
uch as
> 100x.
>
> Note that this would involve having a "cache" partition on the same S=
D card.
>
> However, the random read performance on these is very good (as good a=
s any
> flash), and typical measurements are 500-1500 IOPS on random reads.
> Therefore, there is no point in caching data for reading, since the r=
ead
> performance from the cache partition would be the same as the read
> performance off the real data source.
>
> The other use case I envisage is for things like swap that don't need=
 to be
> persisted across reboots, and thus don't need to be committed back to
> backing storage from cache (i.e. it is OK for them to disappear on re=
boot).
> In this use-case, I would like to use Bcache without the backing stor=
age -
> simply use it in write-back caching mode without committing anything =
back,
> and re-using blocks as and when they get over-written (or perhaps use=
 a
> discard feature for early pruning?).
>
> So to summarize:
> 1) Can Bcache be configured or relatively easily modified to only do
> random-write caching with no read caching (except in cases where ther=
e is a
> request for written data that hasn't yet been committed to the backin=
g
> storage)?
> 2) Can Bcache be used in full write-back-only mode without backing da=
ta
> store for non-persistent data?
>
> Thanks.
>
> Gordan
> --
> To unsubscribe from this list: send the line "unsubscribe linux-bcach=
e" in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at =A0http://vger.kernel.org/majordomo-info.html
