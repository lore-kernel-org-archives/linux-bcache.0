From: Coly Li <i@coly.li>
Subject: Re: [PATCH 09/19] bcache: update bio->bi_opf bypass/writeback REQ_
 flag hints
Date: Sun, 2 Jul 2017 14:51:20 +0800
Message-ID: <a4f5a7e5-97aa-4245-5f96-2df2045fb2a4@coly.li>
References: <20170629134510.GA32385@infradead.org>
 <1498855388-16990-1-git-send-email-bcache@lists.ewheeler.net>
 <1498855388-16990-9-git-send-email-bcache@lists.ewheeler.net>
 <f9976cdb-dcff-ac98-9a18-2d06b2d4c475@coly.li>
 <alpine.LRH.2.11.1707011930010.17052@mail.ewheeler.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Return-path: <linux-block-owner@vger.kernel.org>
In-Reply-To: <alpine.LRH.2.11.1707011930010.17052@mail.ewheeler.net>
Content-Language: en-US
Sender: linux-block-owner@vger.kernel.org
To: Eric Wheeler <bcache@lists.ewheeler.net>
Cc: linux-block@vger.kernel.org, linux-bcache@vger.kernel.org, hch@infradead.org, axboe@kernel.dk
List-Id: linux-bcache@vger.kernel.org

On 2017/7/2 上午3:39, Eric Wheeler wrote:
> On Sun, 2 Jul 2017, Coly Li wrote:
> 
>> On 2017/7/1 上午4:42, bcache@lists.ewheeler.net wrote:
>>> From: Eric Wheeler <git@linux.ewheeler.net>
>>>
>>> Bypass if:     bio->bi_opf & (REQ_RAHEAD|REQ_BACKGROUND)
>>>
>>> Writeback if:  op_is_sync(bio->bi_opf) || bio->bi_opf & (REQ_META|REQ_PRIO)
>>>
>>
>> Hi Eric,
>>
>> Could you please explain a bit how the above policy is designed ? I'd
>> like to understand it more.
> 
> Hi Coly,
> 
> It is pretty trivial, all of the processing code exists already.  This 
> patch only adds to the existing functions for the constraints noted in the 
> patch.
> 
> What happens is this: cached_dev_make_request() in request.c takes the IO 
> decides where the IO should go by using these two functions to decide 
> whether a bio should writeback or bypass:
> 	check_should_bypass()
> and
> 	should_writeback()
> 
> In check_should_bypass(), `if (bio->bi_opf & (REQ_RAHEAD|REQ_BACKGROUND))`
> means bypass the cache because the bio has been flagged as a readahead or 
> background IO (no sense in polluting cache in either case).
> 
> Later, if the bio is a write, then cached_dev_write() checks 
> should_writeback()
> 
> In bio->bi_opf & (REQ_META|REQ_PRIO), it means writeback to cache.  Some 
> filesystems use REQ_META for metadata operations which are best to keep 
> low-latency for high transactional performance.  REQ_PRIO is a CFQ hint 
> that the priority of the IO has been raised, so writeback is faster here.  
> 
> 

Thanks for the detailed information. I come to understand :-)

For writing case, I agree that metadata should be kept in cache device.
For reading case, there is a special case for gfs2. gfs2 sets
(REQ_RAHEAD | REQ_META) both for meta data read ahead code path, all
other file systems use (REQ_META | REQ_PRIO) when doing metadata read
ahead. I don't know whether this is something should be fixed in gfs2,
but currently maybe we should also check REQ_META,

+ /* if the read ahead request is for metadata, don't skip it */
+ if ((bio->bi_opf & (REQ_RAHEAD|REQ_BACKGROUND)) &&
+     !(bio->bi_opf & REQ_META))
+ 	goto skip;

At least we can avoid a potential performance regression here.

And could you please add the above information in patch comments.

Thank you in advance.

Coly

>>
>>> Signed-off-by: Eric Wheeler <bcache@linux.ewheeler.net>
>>> ---
>>>  drivers/md/bcache/request.c   | 3 +++
>>>  drivers/md/bcache/writeback.h | 3 ++-
>>>  2 files changed, 5 insertions(+), 1 deletion(-)
>>>
>>> diff --git a/drivers/md/bcache/request.c b/drivers/md/bcache/request.c
>>> index a95609f..4629b0c 100644
>>> --- a/drivers/md/bcache/request.c
>>> +++ b/drivers/md/bcache/request.c
>>> @@ -386,6 +386,9 @@ static bool check_should_bypass(struct cached_dev *dc, struct bio *bio)
>>>  	     op_is_write(bio_op(bio))))
>>>  		goto skip;
>>>  
>>> +	if (bio->bi_opf & (REQ_RAHEAD|REQ_BACKGROUND))
>>> +		goto skip;
>>> +
>>>  	/* If the ioprio already exists on the bio, use that.  We assume that
>>>  	 * the upper layer properly assigned the calling process's ioprio to
>>>  	 * the bio being passed to bcache. Otherwise, use current's ioc. */
>>> diff --git a/drivers/md/bcache/writeback.h b/drivers/md/bcache/writeback.h
>>> index cd82fe8..ea2f92e 100644
>>> --- a/drivers/md/bcache/writeback.h
>>> +++ b/drivers/md/bcache/writeback.h
>>> @@ -81,7 +81,8 @@ static inline bool should_writeback(struct cached_dev *dc, struct bio *bio,
>>>  		return true;
>>>  	}
>>>  
>>> -	return op_is_sync(bio->bi_opf) || in_use <= CUTOFF_WRITEBACK;
>>> +	return op_is_sync(bio->bi_opf) || bio->bi_opf & (REQ_META|REQ_PRIO)
>>> +		|| in_use <= CUTOFF_WRITEBACK;
>>>  }
>>>  
>>>  static inline void bch_writeback_queue(struct cached_dev *dc)
>>>
