From: Liang C <liangchen.linux@gmail.com>
Subject: Re: [PATCH 1/2] [PATCH] bcache: cached_dev_free needs to put the sb page
Date: Fri, 6 Dec 2019 19:27:42 +0800
Message-ID: <CAKhg4tKw9XbtMmUokYCus0H6ESkhrcxudT6wSgLwFa+kfwatzg@mail.gmail.com>
References: <1575622543-22470-1-git-send-email-liangchen.linux@gmail.com> <20191206092713.GB7650@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20191206092713.GB7650@infradead.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Christoph Hellwig <hch@infradead.org>
Cc: Coly Li <colyli@suse.de>, Kent Overstreet <kent.overstreet@gmail.com>, linux-kernel@vger.kernel.org, linux-bcache@vger.kernel.org
List-Id: linux-bcache@vger.kernel.org

Sure. I will make a patch to clean up all the occurrences of this
usages later. Thanks.

On Fri, Dec 6, 2019 at 5:27 PM Christoph Hellwig <hch@infradead.org> wrote:
>
> On Fri, Dec 06, 2019 at 04:55:42PM +0800, Liang Chen wrote:
> > Same as cache device, the buffer page needs to be put while
> > freeing cached_dev.  Otherwise a page would be leaked every
> > time a cached_dev is stopped.
> >
> > Signed-off-by: Liang Chen <liangchen.linux@gmail.com>
> > ---
> >  drivers/md/bcache/super.c | 3 +++
> >  1 file changed, 3 insertions(+)
> >
> > diff --git a/drivers/md/bcache/super.c b/drivers/md/bcache/super.c
> > index 77e9869345e7..a573ce1d85aa 100644
> > --- a/drivers/md/bcache/super.c
> > +++ b/drivers/md/bcache/super.c
> > @@ -1275,6 +1275,9 @@ static void cached_dev_free(struct closure *cl)
> >
> >       mutex_unlock(&bch_register_lock);
> >
> > +     if (dc->sb_bio.bi_inline_vecs[0].bv_page)
> > +             put_page(bio_first_page_all(&dc->sb_bio));
>
> Using bio_first_page_all in the put_page call, but open coding it
> for the check looks rather strange.
>
> The cleanest thing here would be to just add a page pointer to the
> cached device structure and use that instead of all the indirections.
