From: Coly Li <colyli@suse.de>
Subject: Re: [PATCH] bcache: only recovery I/O error for writethrough mode
Date: Wed, 12 Jul 2017 09:32:13 +0800
Message-ID: <431c92e9-0019-f4d5-9db6-1cd6784e2b4e@suse.de>
References: <20170710111828.97918-1-colyli@suse.de>
 <20170710234619.7388fde2@jupiter.sol.kaishome.de>
 <c343434e-3dc0-ef05-23eb-270266e23c1b@suse.de>
 <alpine.LRH.2.11.1707111740290.17052@mail.ewheeler.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Return-path: <linux-bcache-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:52136 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1756405AbdGLBc3 (ORCPT <rfc822;linux-bcache@vger.kernel.org>);
        Tue, 11 Jul 2017 21:32:29 -0400
In-Reply-To: <alpine.LRH.2.11.1707111740290.17052@mail.ewheeler.net>
Content-Language: en-US
Sender: linux-bcache-owner@vger.kernel.org
List-Id: linux-bcache@vger.kernel.org
To: Eric Wheeler <bcache@lists.ewheeler.net>
Cc: Kai Krakow <hurikhan77@gmail.com>, linux-bcache@vger.kernel.org, linux-block@vger.kernel.org

On 2017/7/12 上午1:42, Eric Wheeler wrote:
> On Tue, 11 Jul 2017, Coly Li wrote:
>> On 2017/7/11 上午5:46, Kai Krakow wrote:
>>> Am Mon, 10 Jul 2017 19:18:28 +0800
>>> schrieb Coly Li <colyli@suse.de>:
>>>
>>>> If a read bio to cache device gets failed, bcache will try to
>>>> recovery it by forward the read bio to backing device. If backing
>>>> device responses read request successfully then the bio contains data
>>>> from backing device will be returned to uppper layer.
>>>>
>>>> The recovery effort in cached_dev_read_error() is not correct, and
>>>> there is report that corrupted data may returned when a dirty cache
>>>> device goes offline during reading I/O.
>>>>
>>>> For writeback cache mode, before dirty data are wrote back to backing
>>>> device, data blocks on backing device are not updated and consistent.
>>>> If a dirty cache device dropped and a read bio gets failed, bcache
>>>> will return its stale version from backing device. This is mistaken
>>>> behavior that applications don't expected, especially for data base
>>>> workload.
>>>>
>>>> This patch fixes the issue by only permit recoverable I/O when cached
>>>> device is in writethough mode, and s->recoverable is set. For other
>>>> cache mode, recovery I/O failure by reading backing device does not
>>>> make sense, bache just simply returns -EIO immediately.
> 
> Since bcache keeps the dirty map in memory, can you allow the passthrough 
> to the backing device if the block is clean, but -EIO otherwise?

Hi Eric,

This is a nice idea, I also discussed with other people around me. A
reason not to choose it is, for data base applications in clustering
environment, it is not very important for dirty data lost on
disconnected from one server, because the work load can be switched to
other server and replay inside the cluster. But it is important to
detect the disconnected cache device failure as early as possible, so
the work load can be switched with less dirty data lost.

Finally I choose simply returning an -EIO to I/O requester, to make
application to know the cache not available earlier and not to introduce
more inconsistent data on backing device.

Coly

> 
>>>
>>> Shouldn't write-around mode be okay for the same reason, i.e. there's
>>> no stale version on disk?
>>>
>>> So the patch should read "mode != CACHE_MODE_WRITEBACK" (not sure about
>>> the constant), that would also match your textual description.
>>>
>>
>> For write-around mode, there is only backing device as bdev target, it
>> does not have such inconsistent data issue.
>>
>> And indeed, this is a try-best effort. I mean, if a cached device is
>> changed from writeback mode to writethrough mode, then the cache device
>> is offline with dirty data, data corruption will still be probably to
>> happen. Anyway, this patch fixes most of cases when people do not change
>> cache mode in runtime.
>>
>> Thanks.
>>
>> Coly
>>
>>>
>>>> Reported-by: Arne Wolf <awolf@lenovo.com>
>>>> Signed-off-by: Coly Li <colyli@suse.de>
>>>> ---
>>>>  drivers/md/bcache/request.c | 5 ++++-
>>>>  1 file changed, 4 insertions(+), 1 deletion(-)
>>>>
>>>> diff --git a/drivers/md/bcache/request.c b/drivers/md/bcache/request.c
>>>> index 019b3df9f1c6..6edacac9b00d 100644
>>>> --- a/drivers/md/bcache/request.c
>>>> +++ b/drivers/md/bcache/request.c
>>>> @@ -702,8 +702,11 @@ static void cached_dev_read_error(struct closure
>>>> *cl) {
>>>>  	struct search *s = container_of(cl, struct search, cl);
>>>>  	struct bio *bio = &s->bio.bio;
>>>> +	struct cached_dev *dc = container_of(s->d, struct
>>>> cached_dev, disk);
>>>> +	unsigned mode = cache_mode(dc, NULL);
>>>>  
>>>> -	if (s->recoverable) {
>>>> +	if (s->recoverable &&
>>>> +	    (mode == CACHE_MODE_WRITETHROUGH)) {
>>>>  		/* Retry from the backing device: */
>>>>  		trace_bcache_read_retry(s->orig_bio);
>>>>  
>>>
>>>
>>>
>>
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-bcache" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
