From: Boaz Harrosh <openosd@gmail.com>
Subject: Re: [PATCH] mm: Support madvise_willneed override by Filesystems
Date: Wed, 3 Jul 2019 21:03:42 +0300
Message-ID: <7206059e-5a57-aa46-0a6c-e62b085f6c75@gmail.com>
References: <20190610191420.27007-1-kent.overstreet@gmail.com>
 <CAHk-=wi0iMHcO5nsYug06fV3-8s8fz7GDQWCuanefEGq6mHH1Q@mail.gmail.com>
 <20190611011737.GA28701@kmo-pixel>
 <20190611043336.GB14363@dread.disaster.area>
 <20190612162144.GA7619@kmo-pixel>
 <20190612230224.GJ14308@dread.disaster.area>
 <20190619082141.GA32409@quack2.suse.cz>
 <27171de5-430e-b3a8-16f1-7ce25b76c874@gmail.com>
 <20190703172141.GD26423@quack2.suse.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20190703172141.GD26423@quack2.suse.cz>
Content-Language: en-MW
Sender: linux-kernel-owner@vger.kernel.org
To: Jan Kara <jack@suse.cz>
Cc: Dave Chinner <david@fromorbit.com>, Kent Overstreet <kent.overstreet@gmail.com>, Linus Torvalds <torvalds@linux-foundation.org>, Dave Chinner <dchinner@redhat.com>, Waiman Long <longman@redhat.com>, Peter Zijlstra <peterz@infradead.org>, Linux List Kernel Mailing <linux-kernel@vger.kernel.org>, linux-fsdevel <linux-fsdevel@vger.kernel.org>, linux-bcache@vger.kernel.org, "Darrick J . Wong" <darrick.wong@oracle.com>, Zach Brown <zach.brown@ni.com>, Jens Axboe <axboe@kernel.dk>, Josef Bacik <josef@toxicpanda.com>, Alexander Viro <viro@zeniv.linux.org.uk>, Andrew Morton <akpm@linux-foundation.org>, Tejun Heo <tj@kernel.org>, Amir Goldstein <amir73il@gmail.com>
List-Id: linux-bcache@vger.kernel.org

On 03/07/2019 20:21, Jan Kara wrote:
> On Wed 03-07-19 04:04:57, Boaz Harrosh wrote:
>> On 19/06/2019 11:21, Jan Kara wrote:
>> <>
<>
>> Hi Jan
>>
>> Funny I'm sitting on the same patch since LSF last. I need it too for other
>> reasons. I have not seen, have you pushed your patch yet?
>> (Is based on old v4.20)
> 
> Your patch is wrong due to lock ordering. You should not call vfs_fadvise()
> under mmap_sem. So we need to do a similar dance like madvise_remove(). I
> have to get to writing at least XFS fix so that the madvise change gets
> used and post the madvise patch with it... Sorry it takes me so long.
> 
> 								Honza

Ha Sorry I was not aware of this. Lockdep did not catch it on my setup
because my setup does not have any locking conflicts with mmap_sem on the
WILL_NEED path.

But surly you are right because the all effort is to fix the locking problems.

I will also try in a day or two to do as you suggest, and look at madvise_remove()
once I have a bit of time. Who ever gets to be less busy ...

Thank you for your help
Boaz
