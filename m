Return-Path: <linux-bcache-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1E362C433E0
	for <linux-bcache@archiver.kernel.org>; Mon, 11 Jan 2021 03:55:30 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E22EB22582
	for <linux-bcache@archiver.kernel.org>; Mon, 11 Jan 2021 03:55:29 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726494AbhAKDzN (ORCPT
        <rfc822;linux-bcache@archiver.kernel.org>);
        Sun, 10 Jan 2021 22:55:13 -0500
Received: from mx2.suse.de ([195.135.220.15]:60164 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725991AbhAKDzN (ORCPT <rfc822;linux-bcache@vger.kernel.org>);
        Sun, 10 Jan 2021 22:55:13 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id 522AEAB3E;
        Mon, 11 Jan 2021 03:54:31 +0000 (UTC)
Subject: Re: [PATCH V3 6/6] bcache: don't pass BIOSET_NEED_BVECS for the
 'bio_set' embedded in 'cache_set'
To:     Ming Lei <ming.lei@redhat.com>, Jens Axboe <axboe@kernel.dk>
Cc:     linux-block@vger.kernel.org, Christoph Hellwig <hch@lst.de>,
        linux-bcache@vger.kernel.org
References: <20210111030557.4154161-1-ming.lei@redhat.com>
 <20210111030557.4154161-7-ming.lei@redhat.com>
From:   Coly Li <colyli@suse.de>
Message-ID: <127486de-a058-1cfd-a53a-a33a1a63a750@suse.de>
Date:   Mon, 11 Jan 2021 11:54:28 +0800
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.16; rv:78.0)
 Gecko/20100101 Thunderbird/78.6.0
MIME-Version: 1.0
In-Reply-To: <20210111030557.4154161-7-ming.lei@redhat.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-bcache.vger.kernel.org>
X-Mailing-List: linux-bcache@vger.kernel.org

On 1/11/21 11:05 AM, Ming Lei wrote:
> This bioset is just for allocating bio only from bio_next_split, and it
> needn't bvecs, so remove the flag.
> 
> Cc: linux-bcache@vger.kernel.org
> Cc: Coly Li <colyli@suse.de>
> Reviewed-by: Christoph Hellwig <hch@lst.de>
> Signed-off-by: Ming Lei <ming.lei@redhat.com>

Acked-by: Coly Li <colyli@suse.de>

Thanks.

Coly Li

> ---
>  drivers/md/bcache/super.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/md/bcache/super.c b/drivers/md/bcache/super.c
> index a4752ac410dc..4102e47f43e1 100644
> --- a/drivers/md/bcache/super.c
> +++ b/drivers/md/bcache/super.c
> @@ -1897,7 +1897,7 @@ struct cache_set *bch_cache_set_alloc(struct cache_sb *sb)
>  		goto err;
>  
>  	if (bioset_init(&c->bio_split, 4, offsetof(struct bbio, bio),
> -			BIOSET_NEED_BVECS|BIOSET_NEED_RESCUER))
> +			BIOSET_NEED_RESCUER))
>  		goto err;
>  
>  	c->uuids = alloc_meta_bucket_pages(GFP_KERNEL, sb);
> 

