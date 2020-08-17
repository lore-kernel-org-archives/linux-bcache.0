Return-Path: <SRS0=Zhg3=B3=vger.kernel.org=linux-bcache-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,NICE_REPLY_A,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7A046C433DF
	for <linux-bcache@archiver.kernel.org>; Mon, 17 Aug 2020 06:15:06 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 5F75B20758
	for <linux-bcache@archiver.kernel.org>; Mon, 17 Aug 2020 06:15:06 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726381AbgHQGPG (ORCPT
        <rfc822;linux-bcache@archiver.kernel.org>);
        Mon, 17 Aug 2020 02:15:06 -0400
Received: from mx2.suse.de ([195.135.220.15]:43924 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726235AbgHQGPF (ORCPT <rfc822;linux-bcache@vger.kernel.org>);
        Mon, 17 Aug 2020 02:15:05 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id F2DB5AD7D;
        Mon, 17 Aug 2020 06:15:28 +0000 (UTC)
Subject: Re: [PATCH 04/14] bcache: add set_uuid in struct cache_set
To:     Coly Li <colyli@suse.de>, linux-bcache@vger.kernel.org
Cc:     linux-block@vger.kernel.org
References: <20200815041043.45116-1-colyli@suse.de>
 <20200815041043.45116-5-colyli@suse.de>
From:   Hannes Reinecke <hare@suse.de>
Message-ID: <0a1d6c62-b3a6-b869-2968-02f9097699d3@suse.de>
Date:   Mon, 17 Aug 2020 08:15:00 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.11.0
MIME-Version: 1.0
In-Reply-To: <20200815041043.45116-5-colyli@suse.de>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: linux-bcache-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-bcache.vger.kernel.org>
X-Mailing-List: linux-bcache@vger.kernel.org

On 8/15/20 6:10 AM, Coly Li wrote:
> This patch adds a separated set_uuid[16] in struct cache_set, to store
> the uuid of the cache set. This is the preparation to remove the
> embedded struct cache_sb from struct cache_set.
> 
> Signed-off-by: Coly Li <colyli@suse.de>
> ---
>   drivers/md/bcache/bcache.h    |  1 +
>   drivers/md/bcache/debug.c     |  2 +-
>   drivers/md/bcache/super.c     | 24 ++++++++++++------------
>   include/trace/events/bcache.h |  4 ++--
>   4 files changed, 16 insertions(+), 15 deletions(-)
> 
Reviewed-by: Hannes Reinecke <hare@suse.de>

Cheers,

Hannes
-- 
Dr. Hannes Reinecke            Teamlead Storage & Networking
hare@suse.de                               +49 911 74053 688
SUSE Software Solutions GmbH, Maxfeldstr. 5, 90409 Nürnberg
HRB 36809 (AG Nürnberg), Geschäftsführer: Felix Imendörffer
