From: Liang C <liangchen.linux@gmail.com>
Subject: Re: [PATCH 2/2] [PATCH] bcache: __write_super to handle page sizes
 other than 4k
Date: Mon, 9 Dec 2019 18:21:07 +0800
Message-ID: <CAKhg4tL+A0aPMFxQt43EvzW4vH1p4T8XGMH5eKuT5_-ZvK5H5A@mail.gmail.com>
References: <1575622543-22470-1-git-send-email-liangchen.linux@gmail.com>
 <1575622543-22470-2-git-send-email-liangchen.linux@gmail.com>
 <e44b8bd9-470d-08af-be7f-a0808504772e@suse.de> <20191209073744.GB3852@infradead.org>
 <dc01bf2c-4457-9658-c0a3-cbd4b7eff82b@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <dc01bf2c-4457-9658-c0a3-cbd4b7eff82b@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
To: Coly Li <colyli@suse.de>
Cc: Christoph Hellwig <hch@infradead.org>, Kent Overstreet <kent.overstreet@gmail.com>, linux-kernel@vger.kernel.org, linux-bcache@vger.kernel.org
List-Id: linux-bcache@vger.kernel.org

No problem. I will change the patch to remove this extra read. Thanks.

On Mon, Dec 9, 2019 at 5:52 PM Coly Li <colyli@suse.de> wrote:
>
> On 2019/12/9 3:37 =E4=B8=8B=E5=8D=88, Christoph Hellwig wrote:
> > On Fri, Dec 06, 2019 at 05:44:38PM +0800, Coly Li wrote:
> >>>  {
> >>> -   struct cache_sb *out =3D page_address(bio_first_page_all(bio));
> >>> +   struct cache_sb *out;
> >>>     unsigned int i;
> >>> +   struct buffer_head *bh;
> >>> +
> >>> +   /*
> >>> +    * The page is held since read_super, this __bread * should not
> >>> +    * cause an extra io read.
> >>> +    */
> >>> +   bh =3D __bread(bdev, 1, SB_SIZE);
> >>> +   if (!bh)
> >>> +           goto out_bh;
> >>> +
> >>> +   out =3D (struct cache_sb *) bh->b_data;
> >>
> >> This is quite tricky here. Could you please to move this code piece in=
to
> >> an inline function and add code comments to explain why a read is
> >> necessary for a write.
> >
> > A read is not nessecary.  He only added it because he was too fearful
> > of calculating the data offset directly.  But calculating it directly
> > is almost trivial and should just be done here.  Alternatively if that
> > is still to hard just keep a pointer to the cache_sb around, which is
> > how most file systems do it.
> >
> Copied, if Liang does not have time to handle this as your suggestion, I
> will handle it.
>
> Thanks for the hint.
>
> --
>
> Coly Li
