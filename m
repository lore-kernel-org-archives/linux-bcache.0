From: Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH 3/4] bcache: use delayed kworker fo asynchronous devices
 registration
Date: Mon, 15 Jun 2020 08:12:46 +0200
Message-ID: <9bd21fc5-2666-e239-3da1-dc51c3ca2e49@suse.de>
References: <20200614165333.124999-1-colyli@suse.de>
 <20200614165333.124999-4-colyli@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Return-path: <linux-block-owner@vger.kernel.org>
In-Reply-To: <20200614165333.124999-4-colyli@suse.de>
Content-Language: en-US
Sender: linux-block-owner@vger.kernel.org
To: colyli@suse.de, axboe@kernel.dk
Cc: linux-bcache@vger.kernel.org, linux-block@vger.kernel.org
List-Id: linux-bcache@vger.kernel.org

On 6/14/20 6:53 PM, colyli@suse.de wrote:
> From: Coly Li <colyli@suse.de>
> 
> This patch changes the asynchronous registration kworker to a delayed
> kworker. There is probability queue_work() queues the async registration
> kworker to the same CPU (even though very little), then the process
> which writing sysfs interface to reigster bcache device may won't return
> immeidately. queue_delayed_work() in this patch will delay 10 jiffies
> before insert the kworker to run queue, which makes sure the registering
> process may always returns to user space in time.
> 
> Fixes: 9e23ccf8f0a22 ("bcache: asynchronous devices registration")
> Signed-off-by: Coly Li <colyli@suse.de>
> Cc: Hannes Reinecke <hare@suse.de>
> ---
>   drivers/md/bcache/super.c | 14 ++++++++------
>   1 file changed, 8 insertions(+), 6 deletions(-)
> 
Reviewed-by: Hannes Reinecke <hare@suse.de>

Cheers,

Hannes
-- 
Dr. Hannes Reinecke            Teamlead Storage & Networking
hare@suse.de                               +49 911 74053 688
SUSE Software Solutions GmbH, Maxfeldstr. 5, 90409 Nürnberg
HRB 36809 (AG Nürnberg), Geschäftsführer: Felix Imendörffer
