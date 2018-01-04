From: Coly Li <colyli@suse.de>
Subject: Re: [PATCH v1 00/10] cache device failure handling improvement
Date: Thu, 4 Jan 2018 10:20:47 +0800
Message-ID: <d0c930bf-ea36-9fe5-3cce-b8f56e1b163e@suse.de>
References: <20180103140325.63175-1-colyli@suse.de>
 <e53e363e-740d-5974-d989-6bf2c3a37dac@lyle.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Return-path: <linux-block-owner@vger.kernel.org>
In-Reply-To: <e53e363e-740d-5974-d989-6bf2c3a37dac@lyle.org>
Content-Language: en-US
Sender: linux-block-owner@vger.kernel.org
To: Michael Lyle <mlyle@lyle.org>, linux-bcache@vger.kernel.org
Cc: linux-block@vger.kernel.org, tang.junhui@zte.com.cn
List-Id: linux-bcache@vger.kernel.org

On 04/01/2018 1:07 AM, Michael Lyle wrote:
> Hey Coly,
> 
> On 01/03/2018 06:03 AM, Coly Li wrote:
> [snip]
>> The first 8 patches of this patch set is to fix existing bugs in bcache,
>> the last 2 patches do the real improvement. Order of applying these patches
>> is important, if the last 2 patches are applied firstly, kernel panic or
>> process hang will be observed. Therefore I suggest to apply the first 8
>> fixes, then apply the last 2 patches.
> 

Hi Mike,

> Wow, this is a lot of changes.  :D  Thanks for the fixes.  I've skimmed
> through these (no real review yet) and overall what you're doing looks
> good.  I think I'm going to concentrate on the first several patches in
> the set for now as a strategy to get at least some of this in for the
> first pass of 4.16 and we can figure out what to do from there.
> 

Yes, I am also testing it from my side, and after v2 patches (I will
rebase the rested patches agains bcache-for-next) our partners will join
the verification too.


> We're up to RC6, so it's getting to be time to get things into next, and
> pretty soon I need to focus on testing for awhile.
> 

Thanks for doing this. When you test the patch set, please apply them
together, because the bugs that the first 8 patches try to fix won't be
triggered without applying the last 2 patches, especially the io_disable
patch.

The io_disable patch fixes dc->count reference issue, then
cache_set_flush() can be executed, and the bugs are triggered.

> [off-topic, I wasn't able to find the time to go through the lock model
> for 4.16 as I had hoped-- hopefully these changes make it to 4.17].

No rush, I am glad to review the patches once they are done.

Thanks for your effort, again :-)

Coly Li
