From: Coly Li <colyli@suse.de>
Subject: Re: [PATCH] bcache: only recovery I/O error for writethrough mode
Date: Tue, 11 Jul 2017 11:55:49 +0800
Message-ID: <c343434e-3dc0-ef05-23eb-270266e23c1b@suse.de>
References: <20170710111828.97918-1-colyli@suse.de>
 <20170710234619.7388fde2@jupiter.sol.kaishome.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Return-path: <linux-bcache-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:51258 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1754832AbdGKDz4 (ORCPT <rfc822;linux-bcache@vger.kernel.org>);
        Mon, 10 Jul 2017 23:55:56 -0400
In-Reply-To: <20170710234619.7388fde2@jupiter.sol.kaishome.de>
Content-Language: en-US
Sender: linux-bcache-owner@vger.kernel.org
List-Id: linux-bcache@vger.kernel.org
To: Kai Krakow <hurikhan77@gmail.com>, linux-bcache@vger.kernel.org
Cc: linux-block@vger.kernel.org

On 2017/7/11 上午5:46, Kai Krakow wrote:
> Am Mon, 10 Jul 2017 19:18:28 +0800
> schrieb Coly Li <colyli@suse.de>:
> 
>> If a read bio to cache device gets failed, bcache will try to
>> recovery it by forward the read bio to backing device. If backing
>> device responses read request successfully then the bio contains data
>> from backing device will be returned to uppper layer.
>>
>> The recovery effort in cached_dev_read_error() is not correct, and
>> there is report that corrupted data may returned when a dirty cache
>> device goes offline during reading I/O.
>>
>> For writeback cache mode, before dirty data are wrote back to backing
>> device, data blocks on backing device are not updated and consistent.
>> If a dirty cache device dropped and a read bio gets failed, bcache
>> will return its stale version from backing device. This is mistaken
>> behavior that applications don't expected, especially for data base
>> workload.
>>
>> This patch fixes the issue by only permit recoverable I/O when cached
>> device is in writethough mode, and s->recoverable is set. For other
>> cache mode, recovery I/O failure by reading backing device does not
>> make sense, bache just simply returns -EIO immediately.
> 
> Shouldn't write-around mode be okay for the same reason, i.e. there's
> no stale version on disk?
> 
> So the patch should read "mode != CACHE_MODE_WRITEBACK" (not sure about
> the constant), that would also match your textual description.
> 

For write-around mode, there is only backing device as bdev target, it
does not have such inconsistent data issue.

And indeed, this is a try-best effort. I mean, if a cached device is
changed from writeback mode to writethrough mode, then the cache device
is offline with dirty data, data corruption will still be probably to
happen. Anyway, this patch fixes most of cases when people do not change
cache mode in runtime.

Thanks.

Coly

> 
>> Reported-by: Arne Wolf <awolf@lenovo.com>
>> Signed-off-by: Coly Li <colyli@suse.de>
>> ---
>>  drivers/md/bcache/request.c | 5 ++++-
>>  1 file changed, 4 insertions(+), 1 deletion(-)
>>
>> diff --git a/drivers/md/bcache/request.c b/drivers/md/bcache/request.c
>> index 019b3df9f1c6..6edacac9b00d 100644
>> --- a/drivers/md/bcache/request.c
>> +++ b/drivers/md/bcache/request.c
>> @@ -702,8 +702,11 @@ static void cached_dev_read_error(struct closure
>> *cl) {
>>  	struct search *s = container_of(cl, struct search, cl);
>>  	struct bio *bio = &s->bio.bio;
>> +	struct cached_dev *dc = container_of(s->d, struct
>> cached_dev, disk);
>> +	unsigned mode = cache_mode(dc, NULL);
>>  
>> -	if (s->recoverable) {
>> +	if (s->recoverable &&
>> +	    (mode == CACHE_MODE_WRITETHROUGH)) {
>>  		/* Retry from the backing device: */
>>  		trace_bcache_read_retry(s->orig_bio);
>>  
> 
> 
> 
