From: Hannes Reinecke <hare@suse.de>
Subject: Re: [RFC PATCH v2 13/16] bcache: fix fifo index swapping condition in
 btree_flush_write()
Date: Tue, 23 Apr 2019 09:09:44 +0200
Message-ID: <0f302a9e-3718-e042-abb0-0ed518ee1583@suse.de>
References: <20190419160509.66298-1-colyli@suse.de>
 <20190419160509.66298-14-colyli@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Return-path: <stable-owner@vger.kernel.org>
In-Reply-To: <20190419160509.66298-14-colyli@suse.de>
Content-Language: en-US
Sender: stable-owner@vger.kernel.org
To: Coly Li <colyli@suse.de>, linux-bcache@vger.kernel.org
Cc: linux-block@vger.kernel.org, stable@vger.kernel.org
List-Id: linux-bcache@vger.kernel.org

On 4/19/19 6:05 PM, Coly Li wrote:
> Current journal_max_cmp() and journal_min_cmp() assume that smaller fifo
> index indicating elder journal entries, but this is only true when fifo
> index is not swapped.
> 
> Fifo structure journal.pin is implemented by a cycle buffer, if the head
> index reaches highest location of the cycle buffer, it will be swapped
> to 0. Once the swapping happens, it means a smaller fifo index might be
> associated to a newer journal entry. So the btree node with oldest
> journal entry won't be selected by btree_flush_write() to flush out to
> cache device. The result is, the oldest journal entries may always has
> no chance to be written into cache device, and after a reboot
> bch_journal_replay() may complain some journal entries are missing.
> 
> This patch handles the fifo index swapping conditions properly, then in
> btree_flush_write() the btree node with oldest journal entry can be
> slected from c->flush_btree correctly.
> 
> Cc: stable@vger.kernel.org
> Signed-off-by: Coly Li <colyli@suse.de>
> ---
>   drivers/md/bcache/journal.c | 47 +++++++++++++++++++++++++++++++++++++++------
>   1 file changed, 41 insertions(+), 6 deletions(-)
> 
> diff --git a/drivers/md/bcache/journal.c b/drivers/md/bcache/journal.c
> index bdb6f9cefe48..bc0e01151155 100644
> --- a/drivers/md/bcache/journal.c
> +++ b/drivers/md/bcache/journal.c
> @@ -464,12 +464,47 @@ int bch_journal_replay(struct cache_set *s, struct list_head *list)
>   }
>   
>   /* Journalling */
> -#define journal_max_cmp(l, r) \
> -	(fifo_idx(&c->journal.pin, btree_current_write(l)->journal) < \
> -	 fifo_idx(&(c)->journal.pin, btree_current_write(r)->journal))
> -#define journal_min_cmp(l, r) \
> -	(fifo_idx(&c->journal.pin, btree_current_write(l)->journal) > \
> -	 fifo_idx(&(c)->journal.pin, btree_current_write(r)->journal))
> +#define journal_max_cmp(l, r)						\
> +({									\
> +	int l_idx, r_idx, f_idx, b_idx;					\
> +	bool _ret = true;						\
> +									\
> +	l_idx = fifo_idx(&c->journal.pin, btree_current_write(l)->journal); \
> +	r_idx = fifo_idx(&c->journal.pin, btree_current_write(r)->journal); \
> +	f_idx = c->journal.pin.front;					\
> +	b_idx = c->journal.pin.back;					\
> +									\
> +	_ret = (l_idx < r_idx);						\
> +	/* in case fifo back pointer is swapped */			\
> +	if (b_idx < f_idx) { 						\
> +		if (l_idx <= b_idx && r_idx >= f_idx)			\
> +			_ret = false;					\
> +		else if (l_idx >= f_idx && r_idx <= b_idx)		\
> +			_ret = true;					\
> +	}								\
> +	_ret;								\
> +})
> +
> +#define journal_min_cmp(l, r)						\
> +({									\
> +	int l_idx, r_idx, f_idx, b_idx;					\
> +	bool _ret = true;						\
> +									\
> +	l_idx = fifo_idx(&c->journal.pin, btree_current_write(l)->journal); \
> +	r_idx = fifo_idx(&c->journal.pin, btree_current_write(r)->journal); \
> +	f_idx = c->journal.pin.front;					\
> +	b_idx = c->journal.pin.back;					\
> +									\
> +	_ret = (l_idx > r_idx);						\
> +	/* in case fifo back pointer is swapped */			\
> +	if (b_idx < f_idx) {						\
> +		if (l_idx <= b_idx && r_idx >= f_idx)			\
> +			_ret = true;					\
> +		else if (l_idx >= f_idx && r_idx <= b_idx)		\
> +			_ret = false;					\
> +	}								\
> +	_ret;								\
> +})
>   
>   static void btree_flush_write(struct cache_set *c)
>   {
> 
Please make it a proper function.
This is far too convoluted for being handled via #define, and it would
avoid cluttering the function namespace with hidden variables.

Cheers,

Hannes
-- 
Dr. Hannes Reinecke		   Teamlead Storage & Networking
hare@suse.de			               +49 911 74053 688
SUSE LINUX GmbH, Maxfeldstr. 5, 90409 Nürnberg
GF: Felix Imendörffer, Mary Higgins, Sri Rasiah
HRB 21284 (AG Nürnberg)
