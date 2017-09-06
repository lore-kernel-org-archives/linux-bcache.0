From: Coly Li <i@coly.li>
Subject: Re: [PATCH 00/13] bcache: fixes and update for 4.14
Date: Thu, 7 Sep 2017 01:38:07 +0800
Message-ID: <c60bdc9a-cd8b-66c2-33c1-d9587499745d@coly.li>
References: <20170906062602.50497-1-colyli@suse.de>
 <20170906142002.GA19380@kernel.dk>
 <d2a5b042-a81d-71c4-1f8c-8fc6416ed363@coly.li>
 <ffeb8364-a0ac-009c-5430-f047457d1272@kernel.dk>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Return-path: <linux-block-owner@vger.kernel.org>
In-Reply-To: <ffeb8364-a0ac-009c-5430-f047457d1272@kernel.dk>
Content-Language: en-US
Sender: linux-block-owner@vger.kernel.org
To: Jens Axboe <axboe@kernel.dk>
Cc: linux-bcache@vger.kernel.org, linux-block@vger.kernel.org, bcache@lists.ewheeler.net
List-Id: linux-bcache@vger.kernel.org

On 2017/9/6 下午11:46, Jens Axboe wrote:
> On 09/06/2017 09:41 AM, Coly Li wrote:
>> On 2017/9/6 下午10:20, Jens Axboe wrote:
>>> On Wed, Sep 06 2017, Coly Li wrote:
>>>> Hi Jens,
>>>>
>>>> Here are 12 patchs for bcache fixes and updates, most of them were posted
>>>> by Eric Wheeler in 4.13 merge window, but delayed due to lack of code
>>>> review.
>>>
>>> Next time, please send this _before_ the merge window opens. Not a huge
>>> problem for this series, since it has been posted numerous times in the
>>> past and already has good review coverage, but it really should have
>>> been in linux-next for a week or two before heading upstream.
>>>
>> Hi Jens,
>>
>> Copied, send patches _before_ merge window opens.
>>
>> But could you please to give me a hint, how can I find when a specific
>> merge window will open ? I search LKML, and see people send pull
>> requests for 4.14 merge window, but I don't see any announcement for
>> 4.14 merge window time slot.
> 
> The merge window opens when Linus releases the previous kernel. So you
> have to try and keep track of when he expects to do that. That really
> isn't that difficult - Linus always cuts a release on Sundays. We always
> have 7 or 8 rc releases, so a good time to check is his mail on -rc6 or
> -rc7 release, that usually gives a good indication of when he expects to
> release the final.
> 
> To keep things simple, if you always have things ready when -rc7 is
> released, then you are at least one week out from the merge window,
> possibly two if we end up doing an -rc8. That means you don't have to
> track anything, you know the exact date of when -rc7 is released since
> Linus's schedule is usually reliable.
> 

Hi Jens,

Copied, I will follow the above rule in next cycle.

And I just post the last patch
(0013-bcache-initialize-stripe_sectors_dirty-correctly-for.patch) to you
for 4.14 cycle.

This patch is an important fix for bcache writeback rate calculation, it
is depended by another patch I sent to you
(0006-bcache-correct-cache_dirty_target-in-__update_writeb.patch),
please have it in 4.14.

Thanks in advance.

-- 
Coly Li
