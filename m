Return-Path: <linux-bcache-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.2 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_SANE_1 autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6EEBCC43381
	for <linux-bcache@archiver.kernel.org>; Wed, 27 Jan 2021 13:15:13 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 20F3A207A3
	for <linux-bcache@archiver.kernel.org>; Wed, 27 Jan 2021 13:15:13 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343749AbhA0NO6 (ORCPT
        <rfc822;linux-bcache@archiver.kernel.org>);
        Wed, 27 Jan 2021 08:14:58 -0500
Received: from mx2.suse.de ([195.135.220.15]:35026 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1343800AbhA0NMw (ORCPT <rfc822;linux-bcache@vger.kernel.org>);
        Wed, 27 Jan 2021 08:12:52 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id CEA72AC4F;
        Wed, 27 Jan 2021 13:12:10 +0000 (UTC)
Subject: Re: [PATCH 2/3] bcache: use bio_set_dev to assign ->bi_bdev
To:     Christoph Hellwig <hch@lst.de>, axboe@kernel.dk
Cc:     linux-block@vger.kernel.org, linux-nvme@lists.infradead.org,
        linux-bcache@vger.kernel.org
References: <20210126143308.1960860-1-hch@lst.de>
 <20210126143308.1960860-3-hch@lst.de>
From:   Coly Li <colyli@suse.de>
Message-ID: <19965f34-ed71-c5c4-cd6b-b4c7ac4d5e38@suse.de>
Date:   Wed, 27 Jan 2021 21:12:07 +0800
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.16; rv:78.0)
 Gecko/20100101 Thunderbird/78.6.1
MIME-Version: 1.0
In-Reply-To: <20210126143308.1960860-3-hch@lst.de>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-bcache.vger.kernel.org>
X-Mailing-List: linux-bcache@vger.kernel.org

On 1/26/21 10:33 PM, Christoph Hellwig wrote:
> Always use the bio_set_dev helper to assign ->bi_bdev to make sure
> other state related to the device is uptodate.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>

Acked-by: Coly Li <colyli@suse.de>


Coly Li

> ---
>  drivers/md/bcache/debug.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/md/bcache/debug.c b/drivers/md/bcache/debug.c
> index 058dd80144281e..63e809f38e3f51 100644
> --- a/drivers/md/bcache/debug.c
> +++ b/drivers/md/bcache/debug.c
> @@ -114,7 +114,7 @@ void bch_data_verify(struct cached_dev *dc, struct bio *bio)
>  	check = bio_kmalloc(GFP_NOIO, bio_segments(bio));
>  	if (!check)
>  		return;
> -	check->bi_bdev = bio->bi_bdev;
> +	bio_set_dev(check, bio->bi_bdev);
>  	check->bi_opf = REQ_OP_READ;
>  	check->bi_iter.bi_sector = bio->bi_iter.bi_sector;
>  	check->bi_iter.bi_size = bio->bi_iter.bi_size;
> 

