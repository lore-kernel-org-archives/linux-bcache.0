Return-Path: <SRS0=SjEI=A2=vger.kernel.org=linux-bcache-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,NICE_REPLY_A,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D9B58C433E5
	for <linux-bcache@archiver.kernel.org>; Wed, 15 Jul 2020 15:37:38 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id BF68320663
	for <linux-bcache@archiver.kernel.org>; Wed, 15 Jul 2020 15:37:38 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726782AbgGOPhi (ORCPT
        <rfc822;linux-bcache@archiver.kernel.org>);
        Wed, 15 Jul 2020 11:37:38 -0400
Received: from mx2.suse.de ([195.135.220.15]:41326 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725770AbgGOPhi (ORCPT <rfc822;linux-bcache@vger.kernel.org>);
        Wed, 15 Jul 2020 11:37:38 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id E7C20AD18;
        Wed, 15 Jul 2020 15:37:39 +0000 (UTC)
Subject: Re: [PATCH v3 09/16] bcache: handle c->uuids properly for bucket size
 > 8MB
To:     colyli@suse.de, linux-bcache@vger.kernel.org
Cc:     linux-block@vger.kernel.org
References: <20200715143015.14957-1-colyli@suse.de>
 <20200715143015.14957-10-colyli@suse.de>
From:   Hannes Reinecke <hare@suse.de>
Message-ID: <95cc26c1-1da5-1e07-aca3-0585b6d01147@suse.de>
Date:   Wed, 15 Jul 2020 17:37:34 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.9.0
MIME-Version: 1.0
In-Reply-To: <20200715143015.14957-10-colyli@suse.de>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: linux-bcache-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-bcache.vger.kernel.org>
X-Mailing-List: linux-bcache@vger.kernel.org

On 7/15/20 4:30 PM, colyli@suse.de wrote:
> From: Coly Li <colyli@suse.de>
> 
> Bcache allocates a whole bucket to store c->uuids on cache device, and
> allocates continuous pages to store it in-memory. When the bucket size
> exceeds maximum allocable continuous pages, bch_cache_set_alloc() will
> fail and cache device registration will fail.
> 
> This patch allocates c->uuids by alloc_meta_bucket_pages(), and uses
> ilog2(meta_bucket_pages(c)) to indicate order of c->uuids pages when
> free it. When writing c->uuids to cache device, its size is decided
> by meta_bucket_pages(c) * PAGE_SECTORS. Now c->uuids is properly handled
> for bucket size > 8MB.
> 
> Signed-off-by: Coly Li <colyli@suse.de>
> ---
>   drivers/md/bcache/super.c | 10 ++++++----
>   1 file changed, 6 insertions(+), 4 deletions(-)
> 
Reviewed-by: Hannes Reinecke <hare@suse.de>

Cheers,

Hannes
-- 
Dr. Hannes Reinecke            Teamlead Storage & Networking
hare@suse.de                               +49 911 74053 688
SUSE Software Solutions GmbH, Maxfeldstr. 5, 90409 Nürnberg
HRB 36809 (AG Nürnberg), Geschäftsführer: Felix Imendörffer
