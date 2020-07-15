Return-Path: <SRS0=SjEI=A2=vger.kernel.org=linux-bcache-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-11.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,NICE_REPLY_A,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DDEA1C433E1
	for <linux-bcache@archiver.kernel.org>; Wed, 15 Jul 2020 06:04:58 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B2EF220663
	for <linux-bcache@archiver.kernel.org>; Wed, 15 Jul 2020 06:04:58 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727908AbgGOGE6 (ORCPT
        <rfc822;linux-bcache@archiver.kernel.org>);
        Wed, 15 Jul 2020 02:04:58 -0400
Received: from [195.135.220.15] ([195.135.220.15]:43314 "EHLO mx2.suse.de"
        rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org with ESMTP
        id S1727899AbgGOGE6 (ORCPT <rfc822;linux-bcache@vger.kernel.org>);
        Wed, 15 Jul 2020 02:04:58 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id 966ECAC37;
        Wed, 15 Jul 2020 06:04:59 +0000 (UTC)
Subject: Re: [PATCH v2 03/17] bcache: add more accurate error information in
 read_super_basic()
To:     Coly Li <colyli@suse.de>, linux-bcache@vger.kernel.org
Cc:     linux-block@vger.kernel.org
References: <20200715054612.6349-1-colyli@suse.de>
 <20200715054612.6349-4-colyli@suse.de>
From:   Hannes Reinecke <hare@suse.de>
Message-ID: <f960d3b1-0b4d-6e4f-377a-7fec3730f949@suse.de>
Date:   Wed, 15 Jul 2020 08:04:53 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.9.0
MIME-Version: 1.0
In-Reply-To: <20200715054612.6349-4-colyli@suse.de>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: linux-bcache-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-bcache.vger.kernel.org>
X-Mailing-List: linux-bcache@vger.kernel.org

On 7/15/20 7:45 AM, Coly Li wrote:
> The improperly set bucket or block size will trigger error in
> read_super_basic(). For large bucket size, a more accurate error message
> for invalid bucket or block size is necessary.
> 
> This patch disassembles the combined if() checks into multile single

multiple

> if() check, and provide more accurate error message for each check
> failure condition.
> 
> Signed-off-by: Coly Li <colyli@suse.de>
> ---
>   drivers/md/bcache/super.c | 19 ++++++++++++++-----
>   1 file changed, 14 insertions(+), 5 deletions(-)
> 
> diff --git a/drivers/md/bcache/super.c b/drivers/md/bcache/super.c
> index 74681fb92158..2abeb3ba88be 100644
> --- a/drivers/md/bcache/super.c
> +++ b/drivers/md/bcache/super.c
> @@ -79,11 +79,20 @@ static const char *read_super_basic(struct cache_sb *sb,  struct block_device *b
>   	if (sb->nbuckets < 1 << 7)
>   		goto err;
>   
> -	err = "Bad block/bucket size";
> -	if (!is_power_of_2(sb->block_size) ||
> -	    sb->block_size > PAGE_SECTORS ||
> -	    !is_power_of_2(sb->bucket_size) ||
> -	    sb->bucket_size < PAGE_SECTORS)
> +	err = "Bad block size (not power of 2)";
> +	if (!is_power_of_2(sb->block_size))
> +		goto err;
> +
> +	err = "Bad block size (larger than page size)";
> +	if (sb->block_size > PAGE_SECTORS)
> +		goto err;
> +
> +	err = "Bad bucket size (not power of 2)";
> +	if (!is_power_of_2(sb->bucket_size))
> +		goto err;
> +
> +	err = "Bad bucket size (smaller than page size)";
> +	if (sb->bucket_size < PAGE_SECTORS)
>   		goto err;
>   
>   	err = "Invalid superblock: device too small";
> 
Otherwise:

Reviewed-by: Hannes Reinecke <hare@suse.de>

Cheers,

Hannes
-- 
Dr. Hannes Reinecke            Teamlead Storage & Networking
hare@suse.de                               +49 911 74053 688
SUSE Software Solutions GmbH, Maxfeldstr. 5, 90409 Nürnberg
HRB 36809 (AG Nürnberg), Geschäftsführer: Felix Imendörffer
