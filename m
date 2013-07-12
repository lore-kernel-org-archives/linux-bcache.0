From: sheng qiu <herbert1984106-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: reverse link from bucket to keys
Date: Thu, 11 Jul 2013 22:22:02 -0400
Message-ID: <CAB7xdimtWj728xp9amk=K3-dnCWugFYLSUDuueHQwRYOP13dmw@mail.gmail.com>
References: <CALJ65zk1kkUgOa4iqAFkA+64eU+6cEa=HRNQxZQ5SOwn4e5jAA@mail.gmail.com>
	<CAB7xdikiVCeG=fJENSGY2K256CGOZrp=MYE8q6quSGX0h=ph9g@mail.gmail.com>
	<20130708214859.GB1959@kmo-pixel>
	<CAB7xdinkyiE1Wp+K3=WyA7J1==G3t_coXoDn3wf_6ZvyUV+Vkg@mail.gmail.com>
	<CAB7xdi=wn1O4+g8cynMpSrD114RVsXf4O6Jzz+cytcb=RZhHAg@mail.gmail.com>
	<CAB7xdinPKr6orbY4Oc-CH-e5aeGwghLsiTFmFC4Qs80PwniBcg@mail.gmail.com>
	<20130710230257.GD13527@kmo-pixel>
	<CAB7xdik_nDtJbz-YBaKkQ6XDVQT65ZiSB9E7WWZHon8jXH57SQ@mail.gmail.com>
	<CAB7xdikjXhAyM5dqVXuEUgL4RHM4L0uf0ksXZ_6uU3-ZgAKR4g@mail.gmail.com>
	<CAB7xdinRH6ysM6O1x4jB00acqOvtRwPN00xjm2jkmvML37f3JQ@mail.gmail.com>
	<20130712021057.GA30223@kmo-pixel>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-bcache-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20130712021057.GA30223@kmo-pixel>
Sender: linux-bcache-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Kent Overstreet <kmo-PEzghdH756F8UrSeD/g0lQ@public.gmane.org>
Cc: linux-bcache-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-bcache@vger.kernel.org

Hi Kent,

thanks for the explain above. my concern is that the GC_SECTORS_USED
does not get you the correct valid data size within each bucket. for
example, the GC_SECTORS_USED might return you larger than the bucket
size, while when you go to match the reserved_sectors, you might get
wrong.  i do not know if you get my meaning. A simple way is run some
test while enable the GC code, you will see how it work actually. If
it's my misunderstanding, i am glad to hear from you later.

Thanks,
Sheng

On Thu, Jul 11, 2013 at 10:10 PM, Kent Overstreet <kmo-PEzghdH756F8UrSeD/g0lQ@public.gmane.org> wrote:
> On Thu, Jul 11, 2013 at 11:02:01AM -0400, sheng qiu wrote:
>> Hi Kent,
>>
>> i think i get a little clear about your codes. so initially each newly
>> allocated buckets are SET_GC_SECTORS_USED(bucket.size), then during
>> the btree gc, you update the bucket by accumulate the still valid key
>> data. So if the bucket has more valid data left, it should be
>> accumulated more for each round at the btree gc. I think this is fine.
>> But at the movinggc code, when you calculate how many sectors to move
>> for each bucket, you directly add the current GC_SECTORS_USED(bucket),
>> which is actually the accumulated value (relative value), not the
>> actual valid size of data within the bucket. Is this correct? I guess
>> that's why i ended up with the threshold equal to newly allocated
>> bucket size.
>
> That "sectors_to_move" we're calculating isn't for any one bucket, it's
> how many _total_ sectors we're going to move this iteration.
>
> The reason is we've got a fixed size reserve of buckets that can be
> allocated for moving gc - we may not be able to allocate more than that.
>
> But when we start copying data out of buckets, we always want to copy
> out of the buckets that had the least amount of live data in them. So we
> take our heap of buckets with the smallest GC_SECTORS_USED(), and pop
> buckets off the top until sectors_to_move is under our reserve - that
> is, until we've got few enough buckets that we know we'll be able to
> move all the data in them.



-- 
Sheng Qiu
Texas A & M University
Room 332B Wisenbaker
email: herbert1984106-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org
College Station, TX 77843-3259
