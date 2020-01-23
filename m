From: Michael Lyle <mlyle@lyle.org>
Subject: Re: [PATCH 14/17] bcache: back to cache all readahead I/Os
Date: Thu, 23 Jan 2020 09:19:50 -0800
Message-ID: <CAJ+L6qckUd+Kw8_jKov0dNnSiGxxvXSgc=2dPai+1ANaEdfWPQ@mail.gmail.com>
References: <20200123170142.98974-1-colyli@suse.de> <20200123170142.98974-15-colyli@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-bcache-owner@vger.kernel.org>
Received: from mail-ed1-f68.google.com ([209.85.208.68]:41042 "EHLO
        mail-ed1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728057AbgAWRUc (ORCPT
        <rfc822;linux-bcache@vger.kernel.org>);
        Thu, 23 Jan 2020 12:20:32 -0500
Received: by mail-ed1-f68.google.com with SMTP id c26so4080505eds.8
        for <linux-bcache@vger.kernel.org>; Thu, 23 Jan 2020 09:20:30 -0800 (PST)
In-Reply-To: <20200123170142.98974-15-colyli@suse.de>
Sender: linux-bcache-owner@vger.kernel.org
List-Id: linux-bcache@vger.kernel.org
To: Coly Li <colyli@suse.de>
Cc: Jens Axboe <axboe@kernel.dk>, linux-bcache <linux-bcache@vger.kernel.org>, linux-block@vger.kernel.org, stable <stable@vger.kernel.org>

Hi Coly and Jens--

One concern I have with this is that it's going to wear out
limited-lifetime SSDs a -lot- faster.  Was any thought given to making
this a tunable instead of just changing the behavior?  Even if we have
an anecdote or two that it seems to have increased performance for
some workloads, I don't expect it will have increased performance in
general and it may even be costly for some workloads (it all comes
down to what is more useful in the cache-- somewhat-recently readahead
data, or the data that it is displacing).

Regards,

Mike


On Thu, Jan 23, 2020 at 9:03 AM <colyli@suse.de> wrote:
>
> From: Coly Li <colyli@suse.de>
>
> In year 2007 high performance SSD was still expensive, in order to
> save more space for real workload or meta data, the readahead I/Os
> for non-meta data was bypassed and not cached on SSD.
>
> In now days, SSD price drops a lot and people can find larger size
> SSD with more comfortable price. It is unncessary to bypass normal
> readahead I/Os to save SSD space for now.
>
> This patch removes the code which checks REQ_RAHEAD tag of bio in
> check_should_bypass(), then all readahead I/Os will be cached on SSD.
>
> NOTE: this patch still keeps the checking of "REQ_META|REQ_PRIO" in
> should_writeback(), because we still want to cache meta data I/Os
> even they are asynchronized.
>
> Cc: stable@vger.kernel.org
> Signed-off-by: Coly Li <colyli@suse.de>
> Acked-by: Eric Wheeler <bcache@linux.ewheeler.net>
> ---
>  drivers/md/bcache/request.c | 9 ---------
>  1 file changed, 9 deletions(-)
>
> diff --git a/drivers/md/bcache/request.c b/drivers/md/bcache/request.c
> index 73478a91a342..acc07c4f27ae 100644
> --- a/drivers/md/bcache/request.c
> +++ b/drivers/md/bcache/request.c
> @@ -378,15 +378,6 @@ static bool check_should_bypass(struct cached_dev *dc, struct bio *bio)
>              op_is_write(bio_op(bio))))
>                 goto skip;
>
> -       /*
> -        * Flag for bypass if the IO is for read-ahead or background,
> -        * unless the read-ahead request is for metadata
> -        * (eg, for gfs2 or xfs).
> -        */
> -       if (bio->bi_opf & (REQ_RAHEAD|REQ_BACKGROUND) &&
> -           !(bio->bi_opf & (REQ_META|REQ_PRIO)))
> -               goto skip;
> -
>         if (bio->bi_iter.bi_sector & (c->sb.block_size - 1) ||
>             bio_sectors(bio) & (c->sb.block_size - 1)) {
>                 pr_debug("skipping unaligned io");
> --
> 2.16.4
>
