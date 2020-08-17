Return-Path: <SRS0=Zhg3=B3=vger.kernel.org=linux-bcache-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4853DC433E1
	for <linux-bcache@archiver.kernel.org>; Mon, 17 Aug 2020 06:36:55 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 3010F20716
	for <linux-bcache@archiver.kernel.org>; Mon, 17 Aug 2020 06:36:55 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726646AbgHQGgy (ORCPT
        <rfc822;linux-bcache@archiver.kernel.org>);
        Mon, 17 Aug 2020 02:36:54 -0400
Received: from mx2.suse.de ([195.135.220.15]:50190 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726308AbgHQGgy (ORCPT <rfc822;linux-bcache@vger.kernel.org>);
        Mon, 17 Aug 2020 02:36:54 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id 9DEE4ACB0;
        Mon, 17 Aug 2020 06:37:17 +0000 (UTC)
Subject: Re: [PATCH 14/14] bcache: move struct cache_sb out of uapi bcache.h
To:     Coly Li <colyli@suse.de>, linux-bcache@vger.kernel.org
Cc:     linux-block@vger.kernel.org
References: <20200815041043.45116-1-colyli@suse.de>
 <20200815041043.45116-15-colyli@suse.de>
From:   Hannes Reinecke <hare@suse.de>
Message-ID: <809bef2f-af92-1071-685d-6454fa93b50c@suse.de>
Date:   Mon, 17 Aug 2020 08:36:50 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.11.0
MIME-Version: 1.0
In-Reply-To: <20200815041043.45116-15-colyli@suse.de>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: linux-bcache-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-bcache.vger.kernel.org>
X-Mailing-List: linux-bcache@vger.kernel.org

On 8/15/20 6:10 AM, Coly Li wrote:
> struct cache_sb does not exactly map to cache_sb_disk, it is only for
> in-memory super block and dosn't belong to uapi bcache.h.
> 
> This patch moves the struct cache_sb definition and other depending
> macros and inline routines from include/uapi/linux/bcache.h to
> drivers/md/bcache/bcache.h, this is the proper location to have them.
> 
And that I'm not sure of.
The 'uapi' directory is there to hold the user-visible kernel API.
So the real question is whether the bcache superblock is or should be 
part of the user API or not.
Hence an alternative way would be to detail out the entire superblock in
include/uapi/linux/bcache.h, and remove the definitions from
drivers/md/bcache/bcache.h.

There doesn't seem to be a consistent policy here; some things like MD 
have their superblock in the uapi directory, others like btrfs only have 
the ioctl definitions there.

I'm somewhat in favour of having the superblock definition as part of 
the uapi, as this would make writing external tools like blkid easier.
But then the ultimate decision is yours.

Cheers,

Hannes
-- 
Dr. Hannes Reinecke            Teamlead Storage & Networking
hare@suse.de                               +49 911 74053 688
SUSE Software Solutions GmbH, Maxfeldstr. 5, 90409 Nürnberg
HRB 36809 (AG Nürnberg), Geschäftsführer: Felix Imendörffer
