From: sheng qiu <herbert1984106-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: reverse link from bucket to keys
Date: Thu, 11 Jul 2013 11:02:01 -0400
Message-ID: <CAB7xdinRH6ysM6O1x4jB00acqOvtRwPN00xjm2jkmvML37f3JQ@mail.gmail.com>
References: <CAB7xdi=zBrOfPH9PwCeu=wrguku5utMXJM1pQFiRa1GZU6xGEw@mail.gmail.com>
	<CALJ65zk1kkUgOa4iqAFkA+64eU+6cEa=HRNQxZQ5SOwn4e5jAA@mail.gmail.com>
	<CAB7xdikiVCeG=fJENSGY2K256CGOZrp=MYE8q6quSGX0h=ph9g@mail.gmail.com>
	<20130708214859.GB1959@kmo-pixel>
	<CAB7xdinkyiE1Wp+K3=WyA7J1==G3t_coXoDn3wf_6ZvyUV+Vkg@mail.gmail.com>
	<CAB7xdi=wn1O4+g8cynMpSrD114RVsXf4O6Jzz+cytcb=RZhHAg@mail.gmail.com>
	<CAB7xdinPKr6orbY4Oc-CH-e5aeGwghLsiTFmFC4Qs80PwniBcg@mail.gmail.com>
	<20130710230257.GD13527@kmo-pixel>
	<CAB7xdik_nDtJbz-YBaKkQ6XDVQT65ZiSB9E7WWZHon8jXH57SQ@mail.gmail.com>
	<CAB7xdikjXhAyM5dqVXuEUgL4RHM4L0uf0ksXZ_6uU3-ZgAKR4g@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-bcache-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CAB7xdikjXhAyM5dqVXuEUgL4RHM4L0uf0ksXZ_6uU3-ZgAKR4g-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-bcache-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Kent Overstreet <kmo-PEzghdH756F8UrSeD/g0lQ@public.gmane.org>
Cc: linux-bcache-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-bcache@vger.kernel.org

Hi Kent,

i think i get a little clear about your codes. so initially each newly
allocated buckets are SET_GC_SECTORS_USED(bucket.size), then during
the btree gc, you update the bucket by accumulate the still valid key
data. So if the bucket has more valid data left, it should be
accumulated more for each round at the btree gc. I think this is fine.
But at the movinggc code, when you calculate how many sectors to move
for each bucket, you directly add the current GC_SECTORS_USED(bucket),
which is actually the accumulated value (relative value), not the
actual valid size of data within the bucket. Is this correct? I guess
that's why i ended up with the threshold equal to newly allocated
bucket size.

If i misunderstanding anything, please correct me.

Thanks,
Sheng

On Thu, Jul 11, 2013 at 9:45 AM, sheng qiu <herbert1984106-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrote:
> Hi Kent,
>
> i do not know if this is a problem or i did not understand correctly.
> when i enable the copy_gc, at first the gc_moving_threshold is larger
> than the bucket size (512KB), i guess maybe initially they are set to
> 1<<14 -1, after some time, seems all the bucket are set to use all the
> sectors it own, which is 1024 in my case. I guess this is because
> SET_GC_SECTORS_USED(bucket.size) is called while returning a free
> bucket for new allocation.  then the gc_moving_threshold became 1024
> (512KB), and no bucket's GC_SECTORS_USED is smaller than this value.
> So no gc_moving event at all.
>
> at first, i thought the bcache code would set 0 sectors used for each
> new allocated bucket, and then update GC_SECTORS_USED whenever fill
> data into the bucket. In that way, we can track how many data are
> valid within a bucket.
>
> Do i misunderstanding anything? i am a little confused.
>
> Thanks,
> Sheng
>
> On Wed, Jul 10, 2013 at 10:16 PM, sheng qiu <herbert1984106-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrote:
>> i see. Thanks a lot for your explain. i have some further questions
>> below, i will be appreciated if you have time to answer.
>>
>> by "arbitrary number", can i understand it as the user can decide how
>> many keys in the keybuf or something else?
>> when the keybuf code try to refill itself, it continues scan following
>> "last_scan" or it start over from the beginning? if try to scan all
>> the existing keys per round, will it be very costly?
>>
>> Thanks,
>> Sheng
>>
>>
>>
>>
>> On Wed, Jul 10, 2013 at 7:02 PM, Kent Overstreet <kmo-PEzghdH756F8UrSeD/g0lQ@public.gmane.org> wrote:
>>> On Wed, Jul 10, 2013 at 05:14:49PM -0400, sheng qiu wrote:
>>>> Hi Kent,
>>>>
>>>> i am sorry to bother you again. i am reading the movinggc.c, i am
>>>> really interested in this piece of codes. So if i enable the copy_gc,
>>>> this piece of codes will be active. My question is after the gc_moving
>>>> confirmed the gc_moving_threshold, it began to scan the bkeys. i do
>>>> not quite understand how you fill the moving_gc_keys, do you go
>>>> through all the current btree nodes to find proper keys for migration
>>>> (the bucket.used_sectors < threshold)? or you do incremental scans?
>>>
>>> Incremental scans - the keybuf code scans the btree until it has some
>>> arbitrary number of keys in a red black tree; the copy gc code pulls
>>> keys out of that one at a time to move them and the keybuf code refills
>>> itself by scanning incrementally as needed.
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
