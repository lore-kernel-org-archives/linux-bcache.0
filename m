From: Coly Li <colyli@suse.de>
Subject: Re: [PATCH] bcache: only recovery I/O error for writethrough mode
Date: Wed, 12 Jul 2017 09:45:34 +0800
Message-ID: <45926957-5990-6520-7bd7-6de8c2bae7b8@suse.de>
References: <20170710111828.97918-1-colyli@suse.de>
 <OFCB2AA6A0.E15FCC3D-ON4825815B.0001EEF5-4825815B.00033093@zte.com.cn>
 <eb85fc2b-91d9-0344-829c-972803572ac1@suse.de>
 <OFAAA836F5.65C1F846-ON4825815B.00093270-4825815B.0009741B@zte.com.cn>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Return-path: <linux-block-owner@vger.kernel.org>
In-Reply-To: <OFAAA836F5.65C1F846-ON4825815B.00093270-4825815B.0009741B@zte.com.cn>
Content-Language: en-US
Sender: linux-block-owner@vger.kernel.org
To: tang.junhui@zte.com.cn
Cc: linux-bcache@vger.kernel.org, linux-bcache-owner@vger.kernel.org, linux-block@vger.kernel.org
List-Id: linux-bcache@vger.kernel.org

On 2017/7/12 上午9:43, tang.junhui@zte.com.cn wrote:
>>>> If a read bio to cache device gets failed, bcache will try to
> recovery it
>>>> by forward the read bio to backing device. If backing device responses
>>>> read request successfully then the bio contains data from backing
> device
>>>> will be returned to uppper layer.
>>>>
>>>> The recovery effort in cached_dev_read_error() is not correct, and
> there
>>>> is report that corrupted data may returned when a dirty cache device
> goes
>>>> offline during reading I/O.
>>>>
>>>> For writeback cache mode, before dirty data are wrote back to backing
>>>> device, data blocks on backing device are not updated and
> consistent. If
>>>> a dirty cache device dropped and a read bio gets failed, bcache will
>>>> return its stale version from backing device. This is mistaken behavior
>>>> that applications don't expected, especially for data base workload.
>>>>
>>>> This patch fixes the issue by only permit recoverable I/O when cached
>>>> device is in writethough mode, and s->recoverable is set. For other
> cache
>>>> mode, recovery I/O failure by reading backing device does not make
> sense,
>>>> bache just simply returns -EIO immediately.
>>>>
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
>>> *cl)
>>>>  {
>>>>                   struct search *s = container_of(cl, struct search,
> cl);
>>>>                   struct bio *bio = &s->bio.bio;
>>>> +                 struct cached_dev *dc = container_of(s->d, struct
>>> cached_dev, disk);
>>>> +                 unsigned mode = cache_mode(dc, NULL);
>>>>  
>>>> -                 if (s->recoverable) {
>>>> +                 if (s->recoverable &&
>>>> +                     (mode == CACHE_MODE_WRITETHROUGH)) {
>>>>                                    /* Retry from the backing device: */
>>>>                                  
>  trace_bcache_read_retry(s->orig_bio);
>>>>  
>>>> --
>>>
>>> No, Poly,
>>> Cache mode can change dynamically,
>>> So maybe the bcache device is still dirty
>>> when the cache mode is changed to CACHE_MODE_WRITETHROUGH,
>>> so I think this patch can not solve this question fundamentally.
>>
>>Hi Junnhui,
>>
>>Yes I agree with you, if cache mode is switched from writeback to
>>writethrough or writearound mode, and then the cache device is
>>disconnected, this patch does not help us.
>>
>>When I replied question from Kai Krakow, I expressed similar opinion as
>>yours. This patch is a best-effort fix, it is very necessary for data
>>base applications which always use writeback mode and not switch to
>>other mode during all their online time.
>  
> Since this issue is important, we should find out a solution
> to solve it completely, not just do best-effort.
> 

I meant "it is very necessary for data base applications which always
use *writeback* mode and not switch to other mode during all their
online time."  ^_^

Thanks.

Coly
