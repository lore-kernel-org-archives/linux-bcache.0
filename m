Return-Path: <linux-bcache-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.2 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2C172C63697
	for <linux-bcache@archiver.kernel.org>; Thu, 26 Nov 2020 15:07:59 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id CC66220B80
	for <linux-bcache@archiver.kernel.org>; Thu, 26 Nov 2020 15:07:58 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391156AbgKZPH5 (ORCPT
        <rfc822;linux-bcache@archiver.kernel.org>);
        Thu, 26 Nov 2020 10:07:57 -0500
Received: from mx2.suse.de ([195.135.220.15]:37260 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2391068AbgKZPH5 (ORCPT <rfc822;linux-bcache@vger.kernel.org>);
        Thu, 26 Nov 2020 10:07:57 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id 5E206ACE0;
        Thu, 26 Nov 2020 15:07:55 +0000 (UTC)
Received: by quack2.suse.cz (Postfix, from userid 1000)
        id 2EBF11E10D0; Thu, 26 Nov 2020 16:07:55 +0100 (CET)
Date:   Thu, 26 Nov 2020 16:07:55 +0100
From:   Jan Kara <jack@suse.cz>
To:     Christoph Hellwig <hch@lst.de>
Cc:     Jens Axboe <axboe@kernel.dk>, Tejun Heo <tj@kernel.org>,
        Josef Bacik <josef@toxicpanda.com>, Coly Li <colyli@suse.de>,
        Mike Snitzer <snitzer@redhat.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Jan Kara <jack@suse.cz>,
        Johannes Thumshirn <johannes.thumshirn@wdc.com>,
        dm-devel@redhat.com, Jan Kara <jack@suse.com>,
        linux-block@vger.kernel.org, linux-bcache@vger.kernel.org,
        linux-mtd@lists.infradead.org, linux-fsdevel@vger.kernel.org,
        linux-mm@kvack.org
Subject: Re: [PATCH 22/44] block: opencode devcgroup_inode_permission
Message-ID: <20201126150755.GI422@quack2.suse.cz>
References: <20201126130422.92945-1-hch@lst.de>
 <20201126130422.92945-23-hch@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201126130422.92945-23-hch@lst.de>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <linux-bcache.vger.kernel.org>
X-Mailing-List: linux-bcache@vger.kernel.org

On Thu 26-11-20 14:04:00, Christoph Hellwig wrote:
> Just call devcgroup_check_permission to avoid various superflous checks
> and a double conversion of the access flags.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> Acked-by: Tejun Heo <tj@kernel.org>

Looks good. You can add:

Reviewed-by: Jan Kara <jack@suse.cz>

								Honza

> ---
>  fs/block_dev.c | 10 ++++------
>  1 file changed, 4 insertions(+), 6 deletions(-)
> 
> diff --git a/fs/block_dev.c b/fs/block_dev.c
> index d0783c55a0ce65..b12ab68297baf3 100644
> --- a/fs/block_dev.c
> +++ b/fs/block_dev.c
> @@ -1516,15 +1516,13 @@ static int blkdev_get(struct block_device *bdev, fmode_t mode, void *holder)
>  	struct block_device *claiming;
>  	bool unblock_events = true;
>  	struct gendisk *disk;
> -	int perm = 0;
>  	int partno;
>  	int ret;
>  
> -	if (mode & FMODE_READ)
> -		perm |= MAY_READ;
> -	if (mode & FMODE_WRITE)
> -		perm |= MAY_WRITE;
> -	ret = devcgroup_inode_permission(bdev->bd_inode, perm);
> +	ret = devcgroup_check_permission(DEVCG_DEV_BLOCK,
> +			imajor(bdev->bd_inode), iminor(bdev->bd_inode),
> +			((mode & FMODE_READ) ? DEVCG_ACC_READ : 0) |
> +			((mode & FMODE_WRITE) ? DEVCG_ACC_WRITE : 0));
>  	if (ret)
>  		goto bdput;
>  
> -- 
> 2.29.2
> 
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR
