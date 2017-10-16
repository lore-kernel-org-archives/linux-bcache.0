From: Jens Axboe <axboe@kernel.dk>
Subject: Re: [PATCH] bcache: writeback rate clamping: make 32 bit safe
Date: Mon, 16 Oct 2017 13:08:45 -0600
Message-ID: <f0762144-33a7-abd5-8bf0-b5347c0aa799@kernel.dk>
References: <20171016173447.27253-1-mlyle@lyle.org>
 <20f5b753-1d5f-eb7d-cbb9-6ecaf43294f8@kernel.dk>
 <CAJ+L6qcdCDP=G4FUQphESad6zcSTExYp_6KP8jQSmb9Y9CB-3g@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-block-owner@vger.kernel.org>
In-Reply-To: <CAJ+L6qcdCDP=G4FUQphESad6zcSTExYp_6KP8jQSmb9Y9CB-3g@mail.gmail.com>
Content-Language: en-US
Sender: linux-block-owner@vger.kernel.org
To: Michael Lyle <mlyle@lyle.org>
Cc: linux-bcache@vger.kernel.org, linux-block@vger.kernel.org
List-Id: linux-bcache@vger.kernel.org

On 10/16/2017 01:07 PM, Michael Lyle wrote:
> Jens--
> 
> Thanks for your patience.
> 
> On Mon, Oct 16, 2017 at 12:01 PM, Jens Axboe <axboe@kernel.dk> wrote:
>> On 10/16/2017 11:34 AM, Michael Lyle wrote:
>>> Sorry this got through to linux-block, was detected by the kbuilds test
>>> robot.  NSEC_PER_SEC is a long constant; 2.5 * 10^9 doesn't fit in a
>>> signed long constant.
>>
>> Applied, but you should remember to add Fixes lines when a patch
>> explicitly fixes a problem introduced by a previous patch. Ala:
>>
>> Fixes: e41166c5c44e ("bcache: writeback rate shouldn't artifically clamp")
>>
>> so that backports have an easier time finding dependent fixes.
> 
> Sorry about that too. I considered the Fixes: tag but didn't know if
> the hashes would "hold true" into mainline.  Now I see Linus merges
> your tree so the hash should be durable.

They are durable once applied, so yeah.

-- 
Jens Axboe
