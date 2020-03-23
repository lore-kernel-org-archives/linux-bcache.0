From: Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH 1/7] bcache: move macro btree() and btree_root() into
 btree.h
Date: Mon, 23 Mar 2020 08:05:26 +0100
Message-ID: <32b1c348-e9fd-1c0d-d0fc-7a6711410106@suse.de>
References: <20200322060305.70637-1-colyli@suse.de>
 <20200322060305.70637-2-colyli@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Return-path: <linux-bcache-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:53950 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727164AbgCWHFa (ORCPT <rfc822;linux-bcache@vger.kernel.org>);
        Mon, 23 Mar 2020 03:05:30 -0400
In-Reply-To: <20200322060305.70637-2-colyli@suse.de>
Content-Language: en-US
Sender: linux-bcache-owner@vger.kernel.org
List-Id: linux-bcache@vger.kernel.org
To: Coly Li <colyli@suse.de>, axboe@kernel.dk
Cc: linux-bcache@vger.kernel.org, linux-block@vger.kernel.org

On 3/22/20 7:02 AM, Coly Li wrote:
> In order to accelerate bcache registration speed, the macro btree()
> and btree_root() will be referenced out of btree.c. This patch moves
> them from btree.c into btree.h with other relative function declaration
> in btree.h, for the following changes.
> 
> Signed-off-by: Coly Li <colyli@suse.de>
> ---
>   drivers/md/bcache/btree.c | 60 +----------------------------------
>   drivers/md/bcache/btree.h | 66 +++++++++++++++++++++++++++++++++++++++
>   2 files changed, 67 insertions(+), 59 deletions(-)
> 
Reviewed-by: Hannes Reinecke <hare@suse.de>

Cheers,

Hannes
-- 
Dr. Hannes Reinecke            Teamlead Storage & Networking
hare@suse.de                               +49 911 74053 688
SUSE Software Solutions GmbH, Maxfeldstr. 5, 90409 Nürnberg
HRB 36809 (AG Nürnberg), Geschäftsführer: Felix Imendörffer
