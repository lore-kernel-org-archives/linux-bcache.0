From: wangyijing <wangyijing@huawei.com>
Subject: Re: [PATCH 2/2] bcache: remove unused parameter
Date: Mon, 28 Nov 2016 08:51:59 +0800
Message-ID: <583B7FAF.30601@huawei.com>
References: <1480038004-45129-1-git-send-email-wangyijing@huawei.com>
 <b5051477-73bd-0c74-a371-2c2f547e5c6e@coly.li>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <b5051477-73bd-0c74-a371-2c2f547e5c6e@coly.li>
Sender: linux-kernel-owner@vger.kernel.org
To: Coly Li <i@coly.li>, axboe@fb.com, kent.overstreet@gmail.com
Cc: git@linux.ewheeler.net, colyli@suse.de, linux-bcache@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-bcache@vger.kernel.org



在 2016/11/27 16:00, Coly Li 写道:
> On 2016/11/25 上午9:40, Yijing Wang wrote:
>> Parameter bio is no longer used, clean it.
>>
>> Signed-off-by: Yijing Wang <wangyijing@huawei.com>
>> ---
>>  drivers/md/bcache/request.c | 12 ++++++------
>>  1 file changed, 6 insertions(+), 6 deletions(-)
>>
>> diff --git a/drivers/md/bcache/request.c b/drivers/md/bcache/request.c
>> index 40ffe5e..bf6e432 100644
>> --- a/drivers/md/bcache/request.c
>> +++ b/drivers/md/bcache/request.c
>> @@ -26,12 +26,12 @@ struct kmem_cache *bch_search_cache;
>>  
>>  static void bch_data_insert_start(struct closure *);
>>  
>> -static unsigned cache_mode(struct cached_dev *dc, struct bio *bio)
>> +static unsigned cache_mode(struct cached_dev *dc)
>>  {
>>  	return BDEV_CACHE_MODE(&dc->sb);
>>  }
>>  
>> -static bool verify(struct cached_dev *dc, struct bio *bio)
>> +static bool verify(struct cached_dev *dc)
>>  {
>>  	return dc->verify;
>>  }
>> @@ -371,7 +371,7 @@ static struct hlist_head *iohash(struct cached_dev *dc, uint64_t k)
>>  static bool check_should_bypass(struct cached_dev *dc, struct bio *bio)
>>  {
>>  	struct cache_set *c = dc->disk.c;
>> -	unsigned mode = cache_mode(dc, bio);
>> +	unsigned mode = cache_mode(dc);
>>  	unsigned sectors, congested = bch_get_congested(c);
>>  	struct task_struct *task = current;
>>  	struct io *i;
>> @@ -746,7 +746,7 @@ static void cached_dev_read_done(struct closure *cl)
>>  		s->cache_miss = NULL;
>>  	}
>>  
>> -	if (verify(dc, &s->bio.bio) && s->recoverable && !s->read_dirty_data)
>> +	if (verify(dc) && s->recoverable && !s->read_dirty_data)
>>  		bch_data_verify(dc, s->orig_bio);
>>  
>>  	bio_complete(s);
>> @@ -771,7 +771,7 @@ static void cached_dev_read_done_bh(struct closure *cl)
>>  
>>  	if (s->iop.error)
>>  		continue_at_nobarrier(cl, cached_dev_read_error, bcache_wq);
>> -	else if (s->iop.bio || verify(dc, &s->bio.bio))
>> +	else if (s->iop.bio || verify(dc))
>>  		continue_at_nobarrier(cl, cached_dev_read_done, bcache_wq);
>>  	else
>>  		continue_at_nobarrier(cl, cached_dev_bio_complete, NULL);
>> @@ -898,7 +898,7 @@ static void cached_dev_write(struct cached_dev *dc, struct search *s)
>>  		s->iop.bypass = true;
>>  
>>  	if (should_writeback(dc, s->orig_bio,
>> -			     cache_mode(dc, bio),
>> +			     cache_mode(dc),
>>  			     s->iop.bypass)) {
>>  		s->iop.bypass = false;
>>  		s->iop.writeback = true;
>>
> 
> Acked-by: Coly Li <colyli@suse.de>

Thanks!

> 
