From: Coly Li <colyli@suse.de>
Subject: Re: [RFC PATCH v2 03/16] bcache: reload jouranl key information
 during journal replay
Date: Tue, 23 Apr 2019 14:56:11 +0800
Message-ID: <6c124c55-3275-8983-dd32-10885ec0b5c2@suse.de>
References: <20190419160509.66298-1-colyli@suse.de>
 <20190419160509.66298-4-colyli@suse.de>
 <74048171-b86f-f913-6df0-97114fe7d0fd@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Return-path: <stable-owner@vger.kernel.org>
In-Reply-To: <74048171-b86f-f913-6df0-97114fe7d0fd@suse.de>
Content-Language: en-US
Sender: stable-owner@vger.kernel.org
To: Hannes Reinecke <hare@suse.de>, linux-bcache@vger.kernel.org
Cc: linux-block@vger.kernel.org, stable@vger.kernel.org
List-Id: linux-bcache@vger.kernel.org

On 2019/4/23 2:54 下午, Hannes Reinecke wrote:
> On 4/19/19 6:04 PM, Coly Li wrote:
>> When bcache journal initiates during running cache set, cache set
>> journal.blocks_free is initiated as 0. Then during journal replay if
>> journal_meta() is called and an empty jset is written to cache device,
>> journal_reclaim() is called. If there is available journal bucket to
>> reclaim, c->journal.blocks_free is set to numbers of blocks of a journal
>> bucket, which is c->sb.bucket_size >> c->block_bits.
>>
>> Most of time the above process works correctly, expect the condtion
>> when journal space is almost full. "Almost full" means there is no free
>> journal bucket, but there are still free blocks in last available
>> bucket indexed by ja->cur_idx.
>>
>> If system crashes or reboots when journal space is almost full, problem
>> comes. During cache set reload after the reboot, c->journal.blocks_free
>> is initialized as 0, when jouranl replay process writes bcache jouranl,
>> journal_reclaim() will be called to reclaim available journal bucket and
>> set c->journal.blocks_free to c->sb.bucket_size >> c->block_bits. But
>> there is no fully free bucket to reclaim in journal_reclaim(), so value
>> of c->journal.blocks_free will keep 0. If the first journal entry
>> processed by journal_replay() causes btree split and requires writing
>> journal space by journal_meta(), journal_meta() has to go into an
>> infinite loop to reclaim jouranl bucket, and blocks the whole cache set
>> to run.
>>
>> Such buggy situation can be solved if we do following things before
>> journal replay starts,
>> - Recover previous value of c->journal.blocks_free in last run time,
>>    and set it to current c->journal.blocks_free as initial value.
>> - Recover previous value of ja->cur_idx in last run time, and set it to
>>    KEY_PTR of current c->journal.key as initial value.
>>
>> After c->journal.blocks_free and c->journal.key are recovered, in
>> condition when jouranl space is almost full and cache set is reloaded,
>> meta journal entry from journal reply can be written into free blocks of
>> the last available journal bucket, then old jouranl entries can be
>> replayed and reclaimed for further journaling request.
>>
>> This patch adds bch_journal_key_reload() to recover journal blocks_free
>> and key ptr value for above purpose. bch_journal_key_reload() is called
>> in bch_journal_read() before replying journal by bch_journal_replay().
>>
>> Cc: stable@vger.kernel.org
>> Signed-off-by: Coly Li <colyli@suse.de>
>> ---
>>   drivers/md/bcache/journal.c | 87
>> +++++++++++++++++++++++++++++++++++++++++++++
>>   1 file changed, 87 insertions(+)
>>
>> diff --git a/drivers/md/bcache/journal.c b/drivers/md/bcache/journal.c
>> index 5180bed911ef..a6deb16c15c8 100644
>> --- a/drivers/md/bcache/journal.c
>> +++ b/drivers/md/bcache/journal.c
>> @@ -143,6 +143,89 @@ reread:        left = ca->sb.bucket_size - offset;
>>       return ret;
>>   }
>>   +static int bch_journal_key_reload(struct cache_set *c)
>> +{
>> +    struct cache *ca;
>> +    unsigned int iter, n = 0;
>> +    struct bkey *k = &c->journal.key;
>> +    int ret = 0;
>> +
>> +    for_each_cache(ca, c, iter) {
>> +        struct journal_device *ja = &ca->journal;
>> +        struct bio *bio = &ja->bio;
>> +        struct jset *j, *data = c->journal.w[0].data;
>> +        struct closure cl;
>> +        unsigned int len, left;
>> +        unsigned int offset = 0, used_blocks = 0;
>> +        sector_t bucket = bucket_to_sector(c, ca->sb.d[ja->cur_idx]);
>> +
>> +        closure_init_stack(&cl);
>> +
>> +        while (offset < ca->sb.bucket_size) {
>> +reread:            left = ca->sb.bucket_size - offset;
> 
> Please place the label on a line of its own.
> 
>> +            len = min_t(unsigned int,
>> +                    left, PAGE_SECTORS << JSET_BITS);
>> +
>> +            bio_reset(bio);
>> +            bio->bi_iter.bi_sector = bucket + offset;
>> +            bio_set_dev(bio, ca->bdev);
>> +            bio->bi_iter.bi_size = len << 9;
>> +
>> +            bio->bi_end_io = journal_read_endio;
>> +            bio->bi_private = &cl;
>> +            bio_set_op_attrs(bio, REQ_OP_READ, 0);
>> +            bch_bio_map(bio, data);
>> +
>> +            closure_bio_submit(c, bio, &cl);
>> +            closure_sync(&cl);
>> +
>> +            j = data;
>> +            while (len) {
>> +                size_t blocks, bytes = set_bytes(j);
>> +
>> +                if (j->magic != jset_magic(&ca->sb))
>> +                    goto out;
>> +
>> +                if (bytes > left << 9 ||
>> +                    bytes > PAGE_SIZE << JSET_BITS) {
>> +                    pr_err("jset may be correpted: too big");
>> +                    ret = -EIO;
>> +                    goto err;
>> +                }
>> +
>> +                if (bytes > len << 9)
>> +                    goto reread;
>> +
>> +                if (j->csum != csum_set(j)) {
>> +                    pr_err("jset may be corrupted: bad csum");
>> +                    ret = -EIO;
>> +                    goto err;
>> +                }
>> +
>> +                blocks = set_blocks(j, block_bytes(c));
>> +                used_blocks += blocks;
>> +
>> +                offset    += blocks * ca->sb.block_size;
>> +                len    -= blocks * ca->sb.block_size;
>> +                j = ((void *) j) + blocks * block_bytes(ca);
>> +            }
>> +        }
>> +out:
>> +        c->journal.blocks_free =
>> +            (c->sb.bucket_size >> c->block_bits) -
>> +            used_blocks;
>> +
>> +        k->ptr[n++] = MAKE_PTR(0, bucket, ca->sb.nr_this_dev);
>> +    }
>> +
>> +    BUG_ON(n == 0);
>> +    bkey_init(k);
>> +    SET_KEY_PTRS(k, n);
>> +
>> +err:
>> +    return ret;
>> +}
>> +
>>   int bch_journal_read(struct cache_set *c, struct list_head *list)
>>   {
>>   #define read_bucket(b)                            \
> This is a _quite_ convoluted nested loop.
> It would be far better if it could be split into functions, so as to
> avoid the loop-within-loop constructs.
> Oh, and some documentation (especially the 'reread' bit) would be nice.

Hi Hannes,

Sure I will fix them in next version. Thanks.


-- 

Coly Li
