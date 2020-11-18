Return-Path: <linux-bcache-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.7 required=3.0 tests=BAYES_00,DATE_IN_PAST_06_12,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 23103C63798
	for <linux-bcache@archiver.kernel.org>; Wed, 18 Nov 2020 21:34:29 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C9B24246C1
	for <linux-bcache@archiver.kernel.org>; Wed, 18 Nov 2020 21:34:28 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726304AbgKRVe1 (ORCPT
        <rfc822;linux-bcache@archiver.kernel.org>);
        Wed, 18 Nov 2020 16:34:27 -0500
Received: from mx2.suse.de ([195.135.220.15]:52034 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726163AbgKRVe0 (ORCPT <rfc822;linux-bcache@vger.kernel.org>);
        Wed, 18 Nov 2020 16:34:26 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id 01321B000;
        Wed, 18 Nov 2020 21:34:23 +0000 (UTC)
Received: by quack2.suse.cz (Postfix, from userid 1000)
        id BCB4E1E1330; Wed, 18 Nov 2020 15:46:40 +0100 (CET)
Date:   Wed, 18 Nov 2020 15:46:40 +0100
From:   Jan Kara <jack@suse.cz>
To:     Christoph Hellwig <hch@lst.de>
Cc:     Jens Axboe <axboe@kernel.dk>, Tejun Heo <tj@kernel.org>,
        Josef Bacik <josef@toxicpanda.com>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Coly Li <colyli@suse.de>, Mike Snitzer <snitzer@redhat.com>,
        dm-devel@redhat.com, Richard Weinberger <richard@nod.at>,
        Jan Kara <jack@suse.com>, linux-block@vger.kernel.org,
        xen-devel@lists.xenproject.org, linux-bcache@vger.kernel.org,
        linux-mtd@lists.infradead.org, linux-fsdevel@vger.kernel.org,
        linux-mm@kvack.org
Subject: Re: [PATCH 10/20] block: refactor __blkdev_put
Message-ID: <20201118144640.GO1981@quack2.suse.cz>
References: <20201118084800.2339180-1-hch@lst.de>
 <20201118084800.2339180-11-hch@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201118084800.2339180-11-hch@lst.de>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <linux-bcache.vger.kernel.org>
X-Mailing-List: linux-bcache@vger.kernel.org

On Wed 18-11-20 09:47:50, Christoph Hellwig wrote:
> Reorder the code to have one big section for the last close, and to use
> bdev_is_partition.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>

Looks good. You can add:

Reviewed-by: Jan Kara <jack@suse.cz>

								Honza

> ---
>  fs/block_dev.c | 14 +++++++-------
>  1 file changed, 7 insertions(+), 7 deletions(-)
> 
> diff --git a/fs/block_dev.c b/fs/block_dev.c
> index 29db12c3bb501c..4c4d6c30382c06 100644
> --- a/fs/block_dev.c
> +++ b/fs/block_dev.c
> @@ -1745,22 +1745,22 @@ static void __blkdev_put(struct block_device *bdev, fmode_t mode, int for_part)
>  		WARN_ON_ONCE(bdev->bd_holders);
>  		sync_blockdev(bdev);
>  		kill_bdev(bdev);
> -
>  		bdev_write_inode(bdev);
> -	}
> -	if (bdev->bd_contains == bdev) {
> -		if (disk->fops->release)
> +
> +		if (!bdev_is_partition(bdev) && disk->fops->release)
>  			disk->fops->release(disk, mode);
> -	}
> -	if (!bdev->bd_openers) {
> +
>  		disk_put_part(bdev->bd_part);
>  		bdev->bd_part = NULL;
>  		bdev->bd_disk = NULL;
> -		if (bdev != bdev->bd_contains)
> +		if (bdev_is_partition(bdev))
>  			victim = bdev->bd_contains;
>  		bdev->bd_contains = NULL;
>  
>  		put_disk_and_module(disk);
> +	} else {
> +		if (!bdev_is_partition(bdev) && disk->fops->release)
> +			disk->fops->release(disk, mode);
>  	}
>  	mutex_unlock(&bdev->bd_mutex);
>  	bdput(bdev);
> -- 
> 2.29.2
> 
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR
