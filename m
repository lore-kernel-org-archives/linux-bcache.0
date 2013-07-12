From: Kent Overstreet <kmo-PEzghdH756F8UrSeD/g0lQ@public.gmane.org>
Subject: Re: reverse link from bucket to keys
Date: Thu, 11 Jul 2013 19:01:11 -0700
Message-ID: <20130712020111.GG17799@kmo-pixel>
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
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-bcache-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <CAB7xdikjXhAyM5dqVXuEUgL4RHM4L0uf0ksXZ_6uU3-ZgAKR4g-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-bcache-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: sheng qiu <herbert1984106-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: linux-bcache-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-bcache@vger.kernel.org

On Thu, Jul 11, 2013 at 09:45:25AM -0400, sheng qiu wrote:
> Hi Kent,
> 
> i do not know if this is a problem or i did not understand correctly.
> when i enable the copy_gc, at first the gc_moving_threshold is larger
> than the bucket size (512KB),

I haven't looked at the copy gc code in ages, but if I remember the
algorithm I used - the threshold is set based on how many buckets we
want to free up, so if most of the buckets are reclaimable threshold >
bucket size is what I'd expect.

> i guess maybe initially they are set to
> 1<<14 -1, after some time, seems all the bucket are set to use all the
> sectors it own, which is 1024 in my case. I guess this is because
> SET_GC_SECTORS_USED(bucket.size) is called while returning a free
> bucket for new allocation.  then the gc_moving_threshold became 1024
> (512KB), and no bucket's GC_SECTORS_USED is smaller than this value.
> So no gc_moving event at all.
> at first, i thought the bcache code would set 0 sectors used for each
> new allocated bucket, and then update GC_SECTORS_USED whenever fill
> data into the bucket. In that way, we can track how many data are
> valid within a bucket.

When we allocate a bucket we generally fill it up right away - we don't
make it available for GC (the ->pin refcount) until after we're finished
writing to it, at which point GC_SECTORS_USED is going to = bucket_size.

So that's why the alloc code just sets GC_SECTORS_USED(b,
ca->sb.bucket_size) when you allocate it.

But then over time, as new writes come in - when those writes are
overwriting data that's already in the cache, now GC will notice those
buckets aren't full of (live) data anymore.
