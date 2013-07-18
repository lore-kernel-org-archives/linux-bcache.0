From: Juha Aatrokoski <jha-6fQLAAUwtFMxHbG02/KK1g@public.gmane.org>
Subject: Re: bcache hangs on writes, recovers after disabling discard on
 cache device
Date: Fri, 19 Jul 2013 00:02:14 +0300 (EEST)
Message-ID: <alpine.DEB.2.02.1307182314160.7323@orbit.lan>
References: <51C891C9.4060809@modelnine.org> <alpine.DEB.2.02.1307111748130.26927@orbit.lan> <20130712011554.GA17799@kmo-pixel> <alpine.DEB.2.02.1307121902540.10602@orbit.lan> <alpine.DEB.2.02.1307162111590.3617@orbit.lan> <20130716210527.GC27000@kmo-pixel>
 <alpine.DEB.2.02.1307181458180.18577@orbit.lan> <20130718175309.GB4848@kmo-pixel>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Return-path: <linux-bcache-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20130718175309.GB4848@kmo-pixel>
Sender: linux-bcache-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Kent Overstreet <kmo-PEzghdH756F8UrSeD/g0lQ@public.gmane.org>
Cc: linux-bcache-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-bcache@vger.kernel.org

On Thu, 18 Jul 2013, Kent Overstreet wrote:

> On Thu, Jul 18, 2013 at 03:05:49PM +0300, Juha Aatrokoski wrote:
>> On Tue, 16 Jul 2013, Kent Overstreet wrote:
>>
>>> On Tue, Jul 16, 2013 at 09:14:09PM +0300, Juha Aatrokoski wrote:
>>>> On Fri, 12 Jul 2013, Juha Aatrokoski wrote:
>>>>>> Can you give this patch a try? It's on top of the current
>>>>>> bcache-for-3.11 branch
>>>>>
>>>>> OK, now running the same kernel with this patch applied and
>>>>> discard enabled. However, it has previously taken my system 2-4
>>>>> days to trigger this bug, so I'd say at least two weeks before I
>>>>> can say the patch (may have) fixed the issue.
>>>>
>>>> No such luck, hit the bug after four days of uptime. Disabling
>>>> discard fixed the problem so at least it's not any worse than
>>>> before.
>>>
>>> Argh, damn peculiar bug... and the fact that it takes so long to trigger
>>> is frustrating. I'm honestly at a loss at this point as to what that IO
>>> actually is.
>>
>> One thing I noticed is that your patch only affects the allocator,
>> the journal still does discards the old way. Perhaps it's worth a
>> try to apply a similar change to the journal discards?
>
> Oh man, thanks for pointing me at that code. This looks like a brown
> paper bag bug...
>
> Try this patch and tell me what happens:

Yeah, looks like a very probable culprit for this bug. If I read this 
correctly, the bug is triggered the first time do_journal_discard() is 
called, which results in an infinite discard loop (the switch statement 
alternates between the DISCARD_IN_FLIGHT and DISCARD_READY branches with 
DISCARD_DONE never reached, and do_journal_discard() is called repeatedly 
as it does not seem to accomplish the requested discards), which explains 
the observed 50MB/s write activity.

Now, assuming (with very good reason) that this is the cause of the bug, 
is there something I can do (on a file system on top of the bcache dev) to 
trigger it faster than in 2-4 days? My guess is that this happens when the 
journal gets full/wraps around the first time, but I don't know if the 
journal size is fixed or dynamic, I saw nothing regarding journal size in 
/sys/fs/bcache. My cache dev is 80G with 512k bucket size and 4k block 
size. Will a simple loop like this work: "while true; do cp 200MB_file 
tmpfile; sync; rm tmpfile; sync; done"

BTW, are there performance or other gains to be had by doing the discards 
"manually" by submitting bios? As evidenced by the other patch, the code 
would be much simpler if blkdev_issue_discard() was used instead.


> From 72c531ee46e73a63739aa3fd10130f167d6bd30d Mon Sep 17 00:00:00 2001
> From: Kent Overstreet <kmo-PEzghdH756F8UrSeD/g0lQ@public.gmane.org>
> Date: Thu, 18 Jul 2013 10:50:55 -0700
> Subject: [PATCH] Fix a dumb journal discard bug
>
>
> diff --git a/drivers/md/bcache/journal.c b/drivers/md/bcache/journal.c
> index ba95ab8..c0017ca 100644
> --- a/drivers/md/bcache/journal.c
> +++ b/drivers/md/bcache/journal.c
> @@ -428,7 +428,7 @@ static void do_journal_discard(struct cache *ca)
> 		return;
> 	}
>
> -	switch (atomic_read(&ja->discard_in_flight) == DISCARD_IN_FLIGHT) {
> +	switch (atomic_read(&ja->discard_in_flight)) {
> 	case DISCARD_IN_FLIGHT:
> 		return;
