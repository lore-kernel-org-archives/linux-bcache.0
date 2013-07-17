From: sheng qiu <herbert1984106-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: reverse link from bucket to keys
Date: Wed, 17 Jul 2013 18:28:40 -0400
Message-ID: <CAB7xdim3d3Q7jM7+q8mwUVh6yCW1JQaM_xzWOnGHrkMxbS8EMA@mail.gmail.com>
References: <20130710230257.GD13527@kmo-pixel>
	<CAB7xdik_nDtJbz-YBaKkQ6XDVQT65ZiSB9E7WWZHon8jXH57SQ@mail.gmail.com>
	<CAB7xdikjXhAyM5dqVXuEUgL4RHM4L0uf0ksXZ_6uU3-ZgAKR4g@mail.gmail.com>
	<CAB7xdinRH6ysM6O1x4jB00acqOvtRwPN00xjm2jkmvML37f3JQ@mail.gmail.com>
	<20130712021057.GA30223@kmo-pixel>
	<CAB7xdimtWj728xp9amk=K3-dnCWugFYLSUDuueHQwRYOP13dmw@mail.gmail.com>
	<20130712022551.GB30223@kmo-pixel>
	<CAB7xdinz82AstkNTptXa2z3VFsAB4AT3NXf-Y0X7PZ+27k6iAw@mail.gmail.com>
	<20130712024125.GC30223@kmo-pixel>
	<CAB7xdimAMQSovzRkBz47KwrVqDt1C4-d3iL6cBcrTGoqJ0dJNg@mail.gmail.com>
	<20130716205934.GB27000@kmo-pixel>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-bcache-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20130716205934.GB27000@kmo-pixel>
Sender: linux-bcache-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Kent Overstreet <kmo-PEzghdH756F8UrSeD/g0lQ@public.gmane.org>
Cc: linux-bcache-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-bcache@vger.kernel.org

Hi Kent,

Thanks for you previous reply. I know bcache does not care write hit,
but is there a easy way to check write hit for write request?
If i reuse the search_recurse() as what you do for read request, will
it has any impact?

Thanks,
Sheng

On Tue, Jul 16, 2013 at 4:59 PM, Kent Overstreet <kmo-PEzghdH756F8UrSeD/g0lQ@public.gmane.org> wrote:
> On Tue, Jul 16, 2013 at 11:14:29AM -0400, sheng qiu wrote:
>> Hi Kent,
>>
>> sorry to bother you again. i got another question. it's about the
>> bucket->pin. Can you explain what's the usage for this data member?
>> i see only bucket with pin value "0" can be invalidated. And only "0"
>> valued pin bucket's prio will be decreased within the
>> bch_rescale_priorities(). But every time when you write data to
>> bucket, you increase that bucket's pin, and i did not see when it will
>> be decreased. This makes me a little confused. Or do i miss anything
>> where you might reset it?
>
> It's to keep buckets from being garbage collected after they're
> allocated but before we've added a pointer to them to the btree.
>
> I've actually been meaning to get rid of it, and just keep a refcount on
> the open buckets (the ones pick_data_bucket() uses) and have garbage
> collection mark those buckets too.
>
> Originally I also used it for preventing buckets from being invalidated
> while we were reading from them (on cache hit), but I got rid of that
> ages ago for performance reasons - now it just checks after the read
> finishes if it was invalidated, and if so rereads from the backing
> device.



-- 
Sheng Qiu
Texas A & M University
Room 332B Wisenbaker
email: herbert1984106-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org
College Station, TX 77843-3259
