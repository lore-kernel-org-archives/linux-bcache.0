From: Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH 2/7] bcache: add bcache_ prefix to btree_root() and
 btree() macros
Date: Mon, 23 Mar 2020 08:06:02 +0100
Message-ID: <4242c8b7-0168-c554-c3ce-32bb0be0de84@suse.de>
References: <20200322060305.70637-1-colyli@suse.de>
 <20200322060305.70637-3-colyli@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Return-path: <linux-block-owner@vger.kernel.org>
In-Reply-To: <20200322060305.70637-3-colyli@suse.de>
Content-Language: en-US
Sender: linux-block-owner@vger.kernel.org
To: Coly Li <colyli@suse.de>, axboe@kernel.dk
Cc: linux-bcache@vger.kernel.org, linux-block@vger.kernel.org, Christoph Hellwig <hch@infradead.org>
List-Id: linux-bcache@vger.kernel.org

On 3/22/20 7:03 AM, Coly Li wrote:
> This patch changes macro btree_root() and btree() to bcache_btree_root()
> and bcache_btree(), to avoid potential generic name clash in future.
> 
> NOTE: for porduct kernel maintainers, this patch can be skipped if
> you feel the rename stuffs introduce inconvenince to patch backport.
> 
> Suggested-by: Christoph Hellwig <hch@infradead.org>
> Signed-off-by: Coly Li <colyli@suse.de>
> ---
>   drivers/md/bcache/btree.c | 15 ++++++++-------
>   drivers/md/bcache/btree.h |  4 ++--
>   2 files changed, 10 insertions(+), 9 deletions(-)
> Reviewed-by: Hannes Reinecke <hare@suse.de>

Cheers,

Hannes
-- 
Dr. Hannes Reinecke            Teamlead Storage & Networking
hare@suse.de                               +49 911 74053 688
SUSE Software Solutions GmbH, Maxfeldstr. 5, 90409 Nürnberg
HRB 36809 (AG Nürnberg), Geschäftsführer: Felix Imendörffer
