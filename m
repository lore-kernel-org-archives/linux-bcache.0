From: Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH 7/7] bcache: optimize barrier usage for atomic operations
Date: Mon, 23 Mar 2020 08:09:23 +0100
Message-ID: <8536b839-252d-8b88-d2fc-d41cfc0a9af3@suse.de>
References: <20200322060305.70637-1-colyli@suse.de>
 <20200322060305.70637-8-colyli@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Return-path: <linux-block-owner@vger.kernel.org>
In-Reply-To: <20200322060305.70637-8-colyli@suse.de>
Content-Language: en-US
Sender: linux-block-owner@vger.kernel.org
To: Coly Li <colyli@suse.de>, axboe@kernel.dk
Cc: linux-bcache@vger.kernel.org, linux-block@vger.kernel.org, Davidlohr Bueso <dave@stgolabs.net>
List-Id: linux-bcache@vger.kernel.org

On 3/22/20 7:03 AM, Coly Li wrote:
> The idea of this patch is from Davidlohr Bueso, he posts a patch
> for bcache to optimize barrier usage for read-modify-write atomic
> bitops. Indeed such optimization can also apply on other locations
> where smp_mb() is used before or after an atomic operation.
> 
> This patch replaces smp_mb() with smp_mb__before_atomic() or
> smp_mb__after_atomic() in btree.c and writeback.c,  where it is used
> to synchronize memory cache just earlier on other cores. Although
> the locations are not on hot code path, it is always not bad to mkae
> things a little better.
> 
> Signed-off-by: Coly Li <colyli@suse.de>
> Cc: Davidlohr Bueso <dave@stgolabs.net>
> ---
>   drivers/md/bcache/btree.c     | 6 +++---
>   drivers/md/bcache/writeback.c | 6 +++---
>   2 files changed, 6 insertions(+), 6 deletions(-)
> 
Reviewed-by: Hannes Reinecke <hare@suse.de>

Cheers,

Hannes
-- 
Dr. Hannes Reinecke            Teamlead Storage & Networking
hare@suse.de                               +49 911 74053 688
SUSE Software Solutions GmbH, Maxfeldstr. 5, 90409 Nürnberg
HRB 36809 (AG Nürnberg), Geschäftsführer: Felix Imendörffer
