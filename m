From: sheng qiu <herbert1984106-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: reverse link from bucket to keys
Date: Tue, 16 Jul 2013 11:14:29 -0400
Message-ID: <CAB7xdimAMQSovzRkBz47KwrVqDt1C4-d3iL6cBcrTGoqJ0dJNg@mail.gmail.com>
References: <CAB7xdi=wn1O4+g8cynMpSrD114RVsXf4O6Jzz+cytcb=RZhHAg@mail.gmail.com>
	<CAB7xdinPKr6orbY4Oc-CH-e5aeGwghLsiTFmFC4Qs80PwniBcg@mail.gmail.com>
	<20130710230257.GD13527@kmo-pixel>
	<CAB7xdik_nDtJbz-YBaKkQ6XDVQT65ZiSB9E7WWZHon8jXH57SQ@mail.gmail.com>
	<CAB7xdikjXhAyM5dqVXuEUgL4RHM4L0uf0ksXZ_6uU3-ZgAKR4g@mail.gmail.com>
	<CAB7xdinRH6ysM6O1x4jB00acqOvtRwPN00xjm2jkmvML37f3JQ@mail.gmail.com>
	<20130712021057.GA30223@kmo-pixel>
	<CAB7xdimtWj728xp9amk=K3-dnCWugFYLSUDuueHQwRYOP13dmw@mail.gmail.com>
	<20130712022551.GB30223@kmo-pixel>
	<CAB7xdinz82AstkNTptXa2z3VFsAB4AT3NXf-Y0X7PZ+27k6iAw@mail.gmail.com>
	<20130712024125.GC30223@kmo-pixel>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-bcache-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20130712024125.GC30223@kmo-pixel>
Sender: linux-bcache-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Kent Overstreet <kmo-PEzghdH756F8UrSeD/g0lQ@public.gmane.org>
Cc: linux-bcache-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-bcache@vger.kernel.org

Hi Kent,

sorry to bother you again. i got another question. it's about the
bucket->pin. Can you explain what's the usage for this data member?
i see only bucket with pin value "0" can be invalidated. And only "0"
valued pin bucket's prio will be decreased within the
bch_rescale_priorities(). But every time when you write data to
bucket, you increase that bucket's pin, and i did not see when it will
be decreased. This makes me a little confused. Or do i miss anything
where you might reset it?

i am appreciated for your help.

Thanks,
Sheng

On Thu, Jul 11, 2013 at 10:41 PM, Kent Overstreet <kmo-PEzghdH756F8UrSeD/g0lQ@public.gmane.org> wrote:
> On Thu, Jul 11, 2013 at 10:29:23PM -0400, sheng qiu wrote:
>> sure, in your btree.c code, when you do btree gc, you update the
>> bucket's used sectors by min(unsigned, GC_SECTORS_USED(b)+key_size(),
>> 1<<14-1). this might get you larger than the bucket size. since the
>> newly allocated bucket is set to bucket size already. so each round
>> you will accumulate the key_size(). i print the information at that
>> point, and see GC_SECTORS_USED > bucket size.
>
> Hey, I think you're right - btree_gc_start() is supposed to be zeroing
> out GC_SECTORS_USED() (the same place it does SET_GC_MARK(b,
> GC_MARK_RECLAIMABLE)) - but that's missing. Thanks!



-- 
Sheng Qiu
Texas A & M University
Room 332B Wisenbaker
email: herbert1984106-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org
College Station, TX 77843-3259
