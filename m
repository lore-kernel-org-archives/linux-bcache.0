From: Liang C <liangchen.linux@gmail.com>
Subject: Re: [PATCH 2/2] [PATCH] bcache: __write_super to handle page sizes
 other than 4k
Date: Fri, 6 Dec 2019 19:22:52 +0800
Message-ID: <CAKhg4tLfZ8Gud7zFxkkVzn6uDwLYNZerxjGsdB=N9qDj4mwKFg@mail.gmail.com>
References: <1575622543-22470-1-git-send-email-liangchen.linux@gmail.com>
 <1575622543-22470-2-git-send-email-liangchen.linux@gmail.com> <e44b8bd9-470d-08af-be7f-a0808504772e@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <e44b8bd9-470d-08af-be7f-a0808504772e@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
To: Coly Li <colyli@suse.de>
Cc: Kent Overstreet <kent.overstreet@gmail.com>, linux-kernel@vger.kernel.org, linux-bcache@vger.kernel.org
List-Id: linux-bcache@vger.kernel.org

Sure. will do in a follow up patch.

On Fri, Dec 6, 2019 at 5:44 PM Coly Li <colyli@suse.de> wrote:
>
> On 2019/12/6 4:55 =E4=B8=8B=E5=8D=88, Liang Chen wrote:
> > __write_super assumes super block data starts at offset 0 of the page
> > read in with __bread from read_super, which is not true when page size
> > is not 4k. We encountered the issue on system with 64K page size - comm=
only
> >  seen on aarch64 architecture.
> >
> > Instead of making any assumption on the offset of the data within the p=
age,
> > this patch calls __bread again to locate the data. That should not intr=
oduce
> > an extra io since the page has been held when it's read in from read_su=
per,
> > and __write_super is not on performance critical code path.
> >
> > Signed-off-by: Liang Chen <liangchen.linux@gmail.com>
>
> In general the patch is good for me. Just two minor requests I add them
> in line the email.
>
> Thanks.
>
> > ---
> >  drivers/md/bcache/super.c | 32 +++++++++++++++++++++++++++-----
> >  1 file changed, 27 insertions(+), 5 deletions(-)
> >
> > diff --git a/drivers/md/bcache/super.c b/drivers/md/bcache/super.c
> > index a573ce1d85aa..a39450c9bc34 100644
> > --- a/drivers/md/bcache/super.c
> > +++ b/drivers/md/bcache/super.c
> > @@ -207,15 +207,27 @@ static void write_bdev_super_endio(struct bio *bi=
o)
> >       closure_put(&dc->sb_write);
> >  }
> >
> > -static void __write_super(struct cache_sb *sb, struct bio *bio)
> > +static int __write_super(struct cache_sb *sb, struct bio *bio,
> > +                      struct block_device *bdev)
> >  {
> > -     struct cache_sb *out =3D page_address(bio_first_page_all(bio));
> > +     struct cache_sb *out;
> >       unsigned int i;
> > +     struct buffer_head *bh;
> > +
> > +     /*
> > +      * The page is held since read_super, this __bread * should not
> > +      * cause an extra io read.
> > +      */
> > +     bh =3D __bread(bdev, 1, SB_SIZE);
> > +     if (!bh)
> > +             goto out_bh;
> > +
> > +     out =3D (struct cache_sb *) bh->b_data;
>
> This is quite tricky here. Could you please to move this code piece into
> an inline function and add code comments to explain why a read is
> necessary for a write.
>
>
> >
> >       bio->bi_iter.bi_sector  =3D SB_SECTOR;
> >       bio->bi_iter.bi_size    =3D SB_SIZE;
> >       bio_set_op_attrs(bio, REQ_OP_WRITE, REQ_SYNC|REQ_META);
> > -     bch_bio_map(bio, NULL);
> > +     bch_bio_map(bio, bh->b_data);
> >
> >       out->offset             =3D cpu_to_le64(sb->offset);
> >       out->version            =3D cpu_to_le64(sb->version);
> > @@ -239,7 +251,14 @@ static void __write_super(struct cache_sb *sb, str=
uct bio *bio)
> >       pr_debug("ver %llu, flags %llu, seq %llu",
> >                sb->version, sb->flags, sb->seq);
> >
> > +     /* The page will still be held without this bh.*/
> > +     put_bh(bh);
> >       submit_bio(bio);
> > +     return 0;
> > +
> > +out_bh:
> > +     pr_err("Couldn't read super block, __write_super failed");
> > +     return -1;
> >  }
> >
> >  static void bch_write_bdev_super_unlock(struct closure *cl)
> > @@ -264,7 +283,8 @@ void bch_write_bdev_super(struct cached_dev *dc, st=
ruct closure *parent)
> >
> >       closure_get(cl);
> >       /* I/O request sent to backing device */
> > -     __write_super(&dc->sb, bio);
> > +     if(__write_super(&dc->sb, bio, dc->bdev))
> > +             closure_put(cl);
> >
> >       closure_return_with_destructor(cl, bch_write_bdev_super_unlock);
> >  }
> > @@ -312,7 +332,9 @@ void bcache_write_super(struct cache_set *c)
> >               bio->bi_private =3D ca;
> >
> >               closure_get(cl);
> > -             __write_super(&ca->sb, bio);
> > +             if(__write_super(&ca->sb, bio, ca->bdev))
>
> And here, please add code comments for why closure_put() is necessary her=
e.
>
> > +                     closure_put(cl);
> > +
> >       }
> >
> >       closure_return_with_destructor(cl, bcache_write_super_unlock);
> >
>
>
> --
>
> Coly Li
