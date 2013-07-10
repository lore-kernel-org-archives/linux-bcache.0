From: sheng qiu <herbert1984106-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: reverse link from bucket to keys
Date: Wed, 10 Jul 2013 17:14:49 -0400
Message-ID: <CAB7xdinPKr6orbY4Oc-CH-e5aeGwghLsiTFmFC4Qs80PwniBcg@mail.gmail.com>
References: <CAB7xdi=zBrOfPH9PwCeu=wrguku5utMXJM1pQFiRa1GZU6xGEw@mail.gmail.com>
	<CALJ65zk1kkUgOa4iqAFkA+64eU+6cEa=HRNQxZQ5SOwn4e5jAA@mail.gmail.com>
	<CAB7xdikiVCeG=fJENSGY2K256CGOZrp=MYE8q6quSGX0h=ph9g@mail.gmail.com>
	<20130708214859.GB1959@kmo-pixel>
	<CAB7xdinkyiE1Wp+K3=WyA7J1==G3t_coXoDn3wf_6ZvyUV+Vkg@mail.gmail.com>
	<CAB7xdi=wn1O4+g8cynMpSrD114RVsXf4O6Jzz+cytcb=RZhHAg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-bcache-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CAB7xdi=wn1O4+g8cynMpSrD114RVsXf4O6Jzz+cytcb=RZhHAg-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-bcache-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Kent Overstreet <kmo-PEzghdH756F8UrSeD/g0lQ@public.gmane.org>
Cc: linux-bcache-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-bcache@vger.kernel.org

Hi Kent,

i am sorry to bother you again. i am reading the movinggc.c, i am
really interested in this piece of codes. So if i enable the copy_gc,
this piece of codes will be active. My question is after the gc_moving
confirmed the gc_moving_threshold, it began to scan the bkeys. i do
not quite understand how you fill the moving_gc_keys, do you go
through all the current btree nodes to find proper keys for migration
(the bucket.used_sectors < threshold)? or you do incremental scans?

i will be appreciated if you can explain some more about it.

Thanks,
Sheng

On Wed, Jul 10, 2013 at 11:22 AM, sheng qiu <herbert1984106-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrote:
> Hi Kent,
>
> just a quick question about the bkey fields. The "high" member seems
> to have some bits not used right now. from bits 37 to bits 54 seems to
> be unused, right?
> The reason i was asking is that i want to keep some additional
> information in the bkeys,  if these bits are not used i might reuse
> them without incur more storage.
>
> Thanks,
> Sheng
>
> On Tue, Jul 9, 2013 at 11:24 AM, sheng qiu <herbert1984106-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrote:
>> Hi Kent,
>>
>> thanks for reply. i read the document in the code. just to make sure i
>> understand correctly, the stale key nodes are produced by invalidation
>> (replacement) of the buckets they reside on, right?
>> in another word, the stale key nodes might be the recently evict out data?
>>
>> Thanks,
>> Sheng
>>
>> On Mon, Jul 8, 2013 at 5:48 PM, Kent Overstreet <kmo-PEzghdH756F8UrSeD/g0lQ@public.gmane.org> wrote:
>>> On Mon, Jul 08, 2013 at 09:44:41AM -0400, sheng qiu wrote:
>>>> Hi Kent,
>>>>
>>>> Thanks a lot for your reply.
>>>>
>>>> Then i have a question about the bucket invalidation. when bcache
>>>> choose to replace a bucket, will the keys that reside on that bucket
>>>> still be in the btree? since you do not have information about which
>>>> keys reside on the bucket, how do you update the btree?
>>>>
>>>> i can think out two ways, one is you periodically scan the btree nodes
>>>> and delete the stale nodes, the other way is when you get a cache hit
>>>> on stale nodes, then you delete it at that moment. How bcache does
>>>> this? Can you tell me the functions involve for these operations? i am
>>>> interested in this part of codes.
>>>
>>> This is documented in the code - start here:
>>> http://evilpiepirate.org/git/linux-bcache.git/tree/drivers/md/bcache/bcache.h?h=bcache-dev
>>
>>
>>
>> --
>> Sheng Qiu
>> Texas A & M University
>> Room 332B Wisenbaker
>> email: herbert1984106-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org
>> College Station, TX 77843-3259
>
>
>
> --
> Sheng Qiu
> Texas A & M University
> Room 332B Wisenbaker
> email: herbert1984106-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org
> College Station, TX 77843-3259



-- 
Sheng Qiu
Texas A & M University
Room 332B Wisenbaker
email: herbert1984106-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org
College Station, TX 77843-3259
