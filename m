From: Kent Overstreet <kmo-PEzghdH756F8UrSeD/g0lQ@public.gmane.org>
Subject: Re: reverse link from bucket to keys
Date: Tue, 23 Jul 2013 12:46:24 -0700
Message-ID: <20130723194624.GA22312@kmo-pixel>
References: <CAB7xdikjXhAyM5dqVXuEUgL4RHM4L0uf0ksXZ_6uU3-ZgAKR4g@mail.gmail.com>
 <CAB7xdinRH6ysM6O1x4jB00acqOvtRwPN00xjm2jkmvML37f3JQ@mail.gmail.com>
 <20130712021057.GA30223@kmo-pixel>
 <CAB7xdimtWj728xp9amk=K3-dnCWugFYLSUDuueHQwRYOP13dmw@mail.gmail.com>
 <20130712022551.GB30223@kmo-pixel>
 <CAB7xdinz82AstkNTptXa2z3VFsAB4AT3NXf-Y0X7PZ+27k6iAw@mail.gmail.com>
 <20130712024125.GC30223@kmo-pixel>
 <CAB7xdimAMQSovzRkBz47KwrVqDt1C4-d3iL6cBcrTGoqJ0dJNg@mail.gmail.com>
 <20130716205934.GB27000@kmo-pixel>
 <CAB7xdim3d3Q7jM7+q8mwUVh6yCW1JQaM_xzWOnGHrkMxbS8EMA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-bcache-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <CAB7xdim3d3Q7jM7+q8mwUVh6yCW1JQaM_xzWOnGHrkMxbS8EMA-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-bcache-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: sheng qiu <herbert1984106-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: linux-bcache-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-bcache@vger.kernel.org

On Wed, Jul 17, 2013 at 06:28:40PM -0400, sheng qiu wrote:
> Hi Kent,
> 
> Thanks for you previous reply. I know bcache does not care write hit,
> but is there a easy way to check write hit for write request?
> If i reuse the search_recurse() as what you do for read request, will
> it has any impact?

Well, the question would be where you would track it - for read hits,
we're tracking by bucket on the cache device, not by lba on the backing
device.

But since writes are always COW - they're always going to a new bucket -
tracking write hits by bucket wouldn't really make sense.

What are you trying to do?
