From: Coly Li <colyli@suse.de>
Subject: Re: bcache on XFS: metadata I/O (dirent I/O?) not getting cached at
 all?
Date: Thu, 7 Feb 2019 10:38:58 +0800
Message-ID: <438851ef-ef77-b5f2-d46d-05762b6330b2@suse.de>
References: <87h8dgefee.fsf@esperi.org.uk> <20190206234328.GH14116@dastard>
 <20190207002425.GX24140@tuebingen.mpg.de> <20190207022657.GI14116@dastard>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20190207022657.GI14116@dastard>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
To: Dave Chinner <david@fromorbit.com>, Andre Noll <maan@tuebingen.mpg.de>
Cc: Nix <nix@esperi.org.uk>, linux-bcache@vger.kernel.org, linux-xfs@vger.kernel.org, linux-kernel@vger.kernel.org, Christoph Hellwig <hch@lst.de>, axboe@kernel.dk
List-Id: linux-bcache@vger.kernel.org

On 2019/2/7 10:26 上午, Dave Chinner wrote:
> On Thu, Feb 07, 2019 at 01:24:25AM +0100, Andre Noll wrote:
>> On Thu, Feb 07, 10:43, Dave Chinner wrote
>>> File data readahead: REQ_RAHEAD
>>> Metadata readahead: REQ_META | REQ_RAHEAD
>>>
>>> drivers/md/bcache/request.c::check_should_bypass():
>>>
>>>         /*
>>>          * Flag for bypass if the IO is for read-ahead or background,
>>>          * unless the read-ahead request is for metadata (eg, for gfs2).
>>>          */
>>>         if (bio->bi_opf & (REQ_RAHEAD|REQ_BACKGROUND) &&
>>>             !(bio->bi_opf & REQ_PRIO))
>>>                 goto skip;
>>>
>>> bcache needs fixing - it thinks REQ_PRIO means metadata IO. That's
>>> wrong - REQ_META means it's metadata IO, and so this is a bcache
>>> bug.
>>
>> Do you think 752f66a75abad is bad (ha!) and should be reverted?
> 
> Yes, that change is just broken. From include/linux/blk_types.h:
> 
> 	__REQ_META,             /* metadata io request */
> 	__REQ_PRIO,             /* boost priority in cfq */
> 
> 

Hi Dave,

> i.e. REQ_META means that it is a metadata request, REQ_PRIO means it
> is a "high priority" request. Two completely different things, often
> combined, but not interchangeable.

I found in file system metadata IO, most of time REQ_META and REQ_PRIO
are tagged together for bio, but XFS seems not use REQ_PRIO.

Is there any basic principle for when should these tags to be used or
not ? e.g. If REQ_META is enough for meta data I/O, why REQ_PRIO is used
too. And if REQ_PRIO is necessary, why it is not used in fs/xfs/ code ?

> 
> So, yeah, that needs to be reverted if you want bcache to function
> properly for metadata caching.

Sure, I will fix this, once I make it clear to me.

Thanks for the hint.

-- 

Coly Li
