From: sheng qiu <herbert1984106-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: reverse link from bucket to keys
Date: Thu, 11 Jul 2013 22:29:23 -0400
Message-ID: <CAB7xdinz82AstkNTptXa2z3VFsAB4AT3NXf-Y0X7PZ+27k6iAw@mail.gmail.com>
References: <20130708214859.GB1959@kmo-pixel>
	<CAB7xdinkyiE1Wp+K3=WyA7J1==G3t_coXoDn3wf_6ZvyUV+Vkg@mail.gmail.com>
	<CAB7xdi=wn1O4+g8cynMpSrD114RVsXf4O6Jzz+cytcb=RZhHAg@mail.gmail.com>
	<CAB7xdinPKr6orbY4Oc-CH-e5aeGwghLsiTFmFC4Qs80PwniBcg@mail.gmail.com>
	<20130710230257.GD13527@kmo-pixel>
	<CAB7xdik_nDtJbz-YBaKkQ6XDVQT65ZiSB9E7WWZHon8jXH57SQ@mail.gmail.com>
	<CAB7xdikjXhAyM5dqVXuEUgL4RHM4L0uf0ksXZ_6uU3-ZgAKR4g@mail.gmail.com>
	<CAB7xdinRH6ysM6O1x4jB00acqOvtRwPN00xjm2jkmvML37f3JQ@mail.gmail.com>
	<20130712021057.GA30223@kmo-pixel>
	<CAB7xdimtWj728xp9amk=K3-dnCWugFYLSUDuueHQwRYOP13dmw@mail.gmail.com>
	<20130712022551.GB30223@kmo-pixel>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-bcache-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20130712022551.GB30223@kmo-pixel>
Sender: linux-bcache-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Kent Overstreet <kmo-PEzghdH756F8UrSeD/g0lQ@public.gmane.org>
Cc: linux-bcache-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-bcache@vger.kernel.org

sure, in your btree.c code, when you do btree gc, you update the
bucket's used sectors by min(unsigned, GC_SECTORS_USED(b)+key_size(),
1<<14-1). this might get you larger than the bucket size. since the
newly allocated bucket is set to bucket size already. so each round
you will accumulate the key_size(). i print the information at that
point, and see GC_SECTORS_USED > bucket size.

Thanks,
Sheng

On Thu, Jul 11, 2013 at 10:25 PM, Kent Overstreet <kmo-PEzghdH756F8UrSeD/g0lQ@public.gmane.org> wrote:
> On Thu, Jul 11, 2013 at 10:22:02PM -0400, sheng qiu wrote:
>> Hi Kent,
>>
>> thanks for the explain above. my concern is that the GC_SECTORS_USED
>> does not get you the correct valid data size within each bucket. for
>> example, the GC_SECTORS_USED might return you larger than the bucket
>> size, while when you go to match the reserved_sectors, you might get
>> wrong.  i do not know if you get my meaning. A simple way is run some
>> test while enable the GC code, you will see how it work actually. If
>> it's my misunderstanding, i am glad to hear from you later.
>
> I'm not sure I follow - if GC_SECTORS_USED was > bucket size that'd
> probably be a bug, but I don't see how that could happen - could you
> explain?



-- 
Sheng Qiu
Texas A & M University
Room 332B Wisenbaker
email: herbert1984106-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org
College Station, TX 77843-3259
