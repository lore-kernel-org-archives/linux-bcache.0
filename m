From: tang.junhui@zte.com.cn
Subject: Re: Re: [PATCH] update bucket_in_use in real time
Date: Wed, 25 Oct 2017 09:21:28 +0800
Message-ID: <1508894488-3624-1-git-send-email-tang.junhui@zte.com.cn>
Return-path: <linux-block-owner@vger.kernel.org>
Sender: linux-block-owner@vger.kernel.org
To: colyli@suse.de, mlyle@lyle.org
Cc: linux-bcache@vger.kernel.org, linux-block@vger.kernel.org, tang.junhui@zte.com.cn
List-Id: linux-bcache@vger.kernel.org

From: Tang Junhui <tang.junhui@zte.com.cn>

Thanks to Mike and Coly's comments.

>> +		 if(ca->set->avail_nbuckets > 0) {
>> +		 		 ca->set->avail_nbuckets--;
>> +		 		 bch_update_bucket_in_use(ca->set);
>> +		 }
>> +
> 
> I am not sure this needs an atomic.  All accesses to this variable are
>> done with the bucket_lock held, so that seems correct.  Is this right?
Yes, you are right.

>> static void bch_btree_gc_finish(struct cache_set *c)
> available should be removed and this function should return 0.
I have changed this function to a void type, so nothing need return.

>> +		 stats.in_use		 = (c->nbuckets - c->avail_nbuckets) * 100 / c->nbuckets;
> 
> This should instead call bch_update_bucket_in_use to avoid code duplication.
OK, I will modify it and resend a v2 patch later. 
                  
> Overall I think this is a good piece of progress.
Thanks for your review and comments again.

Tang Junhui
