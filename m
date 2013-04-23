From: Jack Wang <jinpu.wang-EIkl63zCoXaH+58JC4qpiA@public.gmane.org>
Subject: Re: [PATCH]bcache : limit the bio max sectors to make request bug
 in raid0
Date: Tue, 23 Apr 2013 10:30:02 +0200
Message-ID: <5176468A.7080906@profitbricks.com>
References: <516E50EB.6020902@profitbricks.com> <20130422214601.GC4704@localhost> <5176184A.4040206@profitbricks.com> <CAMGffE=s6mT69VCQYmzgdz_a-HRTqkH-PpWTU_6-mN6mBvBtJA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-bcache-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CAMGffE=s6mT69VCQYmzgdz_a-HRTqkH-PpWTU_6-mN6mBvBtJA-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-bcache-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Kent Overstreet <koverstreet-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Cc: linux-bcache-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Michael Balser <michael.balser-EIkl63zCoXaH+58JC4qpiA@public.gmane.org>, Dongsu Park <dongsu.park-EIkl63zCoXaH+58JC4qpiA@public.gmane.org>
List-Id: linux-bcache@vger.kernel.org

On 04/23/2013 10:28 AM, Jinpu Wang wrote:
> Hi Kent,
>=20
> I tested your patch today, it works well, and you're right, my patch
> limits every BIO in a single page:(
>=20
> Thanks for your patch and share.
>=20
> Regards,
> Jack
>=20
>=20
> On Tue, Apr 23, 2013 at 7:12 AM, Jack Wang <jinpu.wang@profitbricks.c=
om
> <mailto:jinpu.wang-EIkl63zCoXaH+58JC4qpiA@public.gmane.org>> wrote:
>=20
>     On 2013=E5=B9=B404=E6=9C=8822=E6=97=A5 23:46, Kent Overstreet wro=
te:
>     > On Wed, Apr 17, 2013 at 09:36:11AM +0200, Jack Wang wrote:
>     >> We are using your bcache-testing branch.
>     >>
>     >> From 20ad8cfb8047df2d09a5a960610f02c555a31a4f Mon Sep 17 00:00=
:00
>     2001
>     >> From: Jack Wang <jinpu.wang-EIkl63zCoXaH+58JC4qpiA@public.gmane.org
>     <mailto:jinpu.wang-EIkl63zCoXaH+58JC4qpiA@public.gmane.org>>
>     >> Date: Tue, 16 Apr 2013 14:59:04 +0200
>     >> Subject: [PATCH] limit the max sectors in bcache to fix the ma=
ke
>     request bug
>     >>  in raid10
>     >> During test bcache with raid1+0, we saw a lot of complain as b=
elow:
>     >> [ 2766.555172] md/raid0:md400: make_request bug: can't convert=
 block
>     >> across chunks or bigger than 512k 953328 144
>     >>
>     >> when the using dd or fio with bigger blocksize like 512k, limi=
ted the
>     >> bio_max_sectors resolve this issue.
>     >
>     > The fix is wrong - it'll have the effect of limiting _every_ bi=
o
>     bcache
>     > emits to a single page, which will be bad for performance.
>     >
>     > I think I just found the problem though - looking at the raid0
>     > merge_bvec_fn, when it's stacked on top of devices with their o=
wn
>     > merge_bvec_fns, it reuses the bvm was passed to it and modifies=
 the
>     > bi_bdev and bi_sector. Ew.
>     >
>     > Can you try this patch and see if it fixes it?
>     Sure, thanks for looking into it, will test it today.
>     >
>     > commit a09ded8edf9ed4009930713e101249084cbcea5c
>     > Author: Kent Overstreet <koverstreet-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org
>     <mailto:koverstreet-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>>
>     > Date:   Mon Apr 22 14:44:24 2013 -0700
>     >
>     >     bcache: Fix merge_bvec_fn usage for when it modifies the bv=
m
>     >
>     >     Stacked md devices reuse the bvm for the subordinate device=
,
>     causing
>     >     problems...
>     >
>     >     Reported-by: Michael Balser <michael.balser-EIkl63zCoXbZz8UjPX3odA@public.gmane.org=
m
>     <mailto:michael.balser-EIkl63zCoXaH+58JC4qpiA@public.gmane.org>>
>     >     Signed-off-by: Kent Overstreet <koverstreet-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org
>     <mailto:koverstreet-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>>
>     >
>     > diff --git a/drivers/md/bcache/io.c b/drivers/md/bcache/io.c
>     > index 5304eaa..48efd4d 100644
>     > --- a/drivers/md/bcache/io.c
>     > +++ b/drivers/md/bcache/io.c
>     > @@ -163,13 +163,6 @@ static unsigned bch_bio_max_sectors(struct
>     bio *bio)
>     >       struct bio_vec *bv, *end =3D bio_iovec(bio) +
>     >               min_t(int, bio_segments(bio), max_segments);
>     >
>     > -     struct bvec_merge_data bvm =3D {
>     > -             .bi_bdev        =3D bio->bi_bdev,
>     > -             .bi_sector      =3D bio->bi_sector,
>     > -             .bi_size        =3D 0,
>     > -             .bi_rw          =3D bio->bi_rw,
>     > -     };
>     > -
>     >       if (bio->bi_rw & REQ_DISCARD)
>     >               return min(ret, q->limits.max_discard_sectors);
>     >
>     > @@ -178,12 +171,18 @@ static unsigned bch_bio_max_sectors(struc=
t
>     bio *bio)
>     >               ret =3D 0;
>     >
>     >               for (bv =3D bio_iovec(bio); bv < end; bv++) {
>     > +                     struct bvec_merge_data bvm =3D {
>     > +                             .bi_bdev        =3D bio->bi_bdev,
>     > +                             .bi_sector      =3D bio->bi_secto=
r,
>     > +                             .bi_size        =3D ret << 9,
>     > +                             .bi_rw          =3D bio->bi_rw,
>     > +                     };
>     > +
>     >                       if (q->merge_bvec_fn &&
>     >                           q->merge_bvec_fn(q, &bvm, bv) < (int)
>     bv->bv_len)
>     >                               break;
>     >
>     > -                     ret             +=3D bv->bv_len >> 9;
>     > -                     bvm.bi_size     +=3D bv->bv_len;
>     > +                     ret +=3D bv->bv_len >> 9;
>     >               }
>     >       }
>     >
>     >
>=20
>=20
>=20
>=20
> --=20
>=20
> Mit freundlichen Gr=C3=BC=C3=9Fen,
> Best Regards,
>=20
> Jack Wang
>=20
> Linux Kernel Developer Storage
> ProfitBricks GmbH  The IaaS-Company.
>=20
> Beschreibung: Beschreibung: Beschreibung:
> cid:part1.00030702.00050402-EIkl63zCoXaH+58JC4qpiA@public.gmane.org
>=20
> *ProfitBricks GmbH*
> Greifswalder Str. 207
> D - 10405 Berlin
> Tel: +49 30 6098 56991-308
> Fax: +49 30 6098 56992-203
> Email: jinpu.wang-EIkl63zCoXaH+58JC4qpiA@public.gmane.org <http://profitbricks.com>
> URL: http://www.profitbricks.com <http://www.profitbricks.com/>
>=20
> Sitz der Gesellschaft: Berlin.
> Registergericht: Amtsgericht Charlottenburg, HRB 125506 B.
> Gesch=C3=A4ftsf=C3=BChrer: Andreas Gauger, Achim Weiss.
