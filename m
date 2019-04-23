From: Hannes Reinecke <hare@suse.de>
Subject: Re: [RFC PATCH v2 02/16] bcache: never set 0 to KEY_PTRS of jouranl
 key in journal_reclaim()
Date: Tue, 23 Apr 2019 08:50:51 +0200
Message-ID: <1df5217e-1e88-217f-e3ce-4b97b2180673@suse.de>
References: <20190419160509.66298-1-colyli@suse.de>
 <20190419160509.66298-3-colyli@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Return-path: <stable-owner@vger.kernel.org>
In-Reply-To: <20190419160509.66298-3-colyli@suse.de>
Content-Language: en-US
Sender: stable-owner@vger.kernel.org
To: Coly Li <colyli@suse.de>, linux-bcache@vger.kernel.org
Cc: linux-block@vger.kernel.org, stable@vger.kernel.org
List-Id: linux-bcache@vger.kernel.org

On 4/19/19 6:04 PM, Coly Li wrote:
> In journal_reclaim() ja->cur_idx of each cache will be update to
> reclaim available journal buckets. Variable 'int n' is used to count how
> many cache is successfully reclaimed, then n is set to c->journal.key
> by SET_KEY_PTRS(). Later in journal_write_unlocked(), a for_each_cache()
> loop will write the jset data onto each cache.
> 
> The problem is, if all jouranl buckets on each cache is full, the
> following code in journal_reclaim(),
> 
> 529 for_each_cache(ca, c, iter) {
> 530         struct journal_device *ja = &ca->journal;
> 531         unsigned int next = (ja->cur_idx + 1) % ca->sb.njournal_buckets;
> 532
> 533         /* No space available on this device */
> 534         if (next == ja->discard_idx)
> 535                 continue;
> 536
> 537         ja->cur_idx = next;
> 538         k->ptr[n++] = MAKE_PTR(0,
> 539                           bucket_to_sector(c, ca->sb.d[ja->cur_idx]),
> 540                           ca->sb.nr_this_dev);
> 541 }
> 542
> 543 bkey_init(k);
> 544 SET_KEY_PTRS(k, n);
> 
> If there is no available bucket to reclaim, the if() condition at line
> 534 will always true, and n remains 0. Then at line 544, SET_KEY_PTRS()
> will set KEY_PTRS field of c->journal.key to 0.
> 
> Setting KEY_PTRS field of c->journal.key to 0 is wrong. Because in
> journal_write_unlocked() the journal data is written in following loop,
> 
> 649	for (i = 0; i < KEY_PTRS(k); i++) {
> 650-671		submit journal data to cache device
> 672	}
> 
> If KEY_PTRS field is set to 0 in jouranl_reclaim(), the journal data
> won't be written to cache device here. If system crahed or rebooted
> before bkeys of the lost journal entries written into btree nodes, data
> corruption will be reported during bcache reload after rebooting the
> system.
> 
> Indeed there is only one cache in a cache set, there is no need to set
> KEY_PTRS field in journal_reclaim() at all. But in order to keep the
> for_each_cache() logic consistent for now, this patch fixes the above
> problem by not setting 0 KEY_PTRS of journal key, if there is no bucket
> available to reclaim.
> 
> Cc: stable@vger.kernel.org
> Signed-off-by: Coly Li <colyli@suse.de>
> ---
>   drivers/md/bcache/journal.c | 11 +++++++----
>   1 file changed, 7 insertions(+), 4 deletions(-)
> 
> diff --git a/drivers/md/bcache/journal.c b/drivers/md/bcache/journal.c
> index 6e18057d1d82..5180bed911ef 100644
> --- a/drivers/md/bcache/journal.c
> +++ b/drivers/md/bcache/journal.c
> @@ -541,11 +541,11 @@ static void journal_reclaim(struct cache_set *c)
>   				  ca->sb.nr_this_dev);
>   	}
>   
> -	bkey_init(k);
> -	SET_KEY_PTRS(k, n);
> -
> -	if (n)
> +	if (n) {
> +		bkey_init(k);
> +		SET_KEY_PTRS(k, n);
>   		c->journal.blocks_free = c->sb.bucket_size >> c->block_bits;
> +	}
>   out:
>   	if (!journal_full(&c->journal))
>   		__closure_wake_up(&c->journal.wait);
> @@ -672,6 +672,9 @@ static void journal_write_unlocked(struct closure *cl)
>   		ca->journal.seq[ca->journal.cur_idx] = w->data->seq;
>   	}
>   
> +	/* If KEY_PTRS(k) == 0, this jset gets lost in air */
> +	BUG_ON(i == 0);
> +
>   	atomic_dec_bug(&fifo_back(&c->journal.pin));
>   	bch_journal_next(&c->journal);
>   	journal_reclaim(c);
> 
Reviewed-by: Hannes Reinecke <hare@suse.com>

Cheers,

Hannes
-- 
Dr. Hannes Reinecke		   Teamlead Storage & Networking
hare@suse.de			               +49 911 74053 688
SUSE LINUX GmbH, Maxfeldstr. 5, 90409 Nürnberg
GF: Felix Imendörffer, Mary Higgins, Sri Rasiah
HRB 21284 (AG Nürnberg)
