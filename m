From: sheng qiu <herbert1984106-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: bcache disabled due to inconsistent ptrs
Date: Wed, 31 Jul 2013 23:14:32 -0400
Message-ID: <CAB7xdiks7vebk-tC-rvR-RpBy4C=zpE9vksRjGZPLEL=WQfcVg@mail.gmail.com>
References: <CAB7xdimUODWgMC8fuxC_6bRWYja6g5Z+LYSr85obRUUvWsoArQ@mail.gmail.com>
	<20130728233757.GB6653@moria.home.lan>
	<CAB7xdik9ZEsj8+s+DB9GDqEZAcLTStyk+mf7Yiw7uazAXjz1MA@mail.gmail.com>
	<20130728235259.GC6653@moria.home.lan>
	<CAB7xdimynY=k1e9+jMM1Fwm1LmY=n_xZQS+zKW5VZpPDa_2jGw@mail.gmail.com>
	<20130729191305.GB13280@kmo-pixel>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-bcache-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20130729191305.GB13280@kmo-pixel>
Sender: linux-bcache-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Kent Overstreet <kmo-PEzghdH756F8UrSeD/g0lQ@public.gmane.org>
Cc: linux-bcache-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-bcache@vger.kernel.org

Hi Kent,

i find something happened when i set a large bucket size. i.e.
bucket_size >= 2mb.
when cache become full, 1% cache_available_percent. the new data keeps
skipping the cache, and the cache will remain in that state. by
default, the movinggc is disabled (copy_enabled = 0), so we might not
get free buckets by cleaning up invalid data. since data skips cache
under such high utilization, no insertion no new allocation, won't
cause the replacement (invalidate buckets) on existing buckets. is
this the correct logic that suppose to happen? or did i miss anything?

Thanks,
Sheng

On Mon, Jul 29, 2013 at 3:13 PM, Kent Overstreet <kmo-PEzghdH756F8UrSeD/g0lQ@public.gmane.org> wrote:
> On Sun, Jul 28, 2013 at 06:57:42PM -0500, sheng qiu wrote:
>> generally the flash size is 40GB, RAM is 8GB. The workload first
>> writes about 65GB of data and then do read/writes (10 threads) on
>> those data.
>> it runs less than 1 hour during the read/write step and nearly
>> happened each time. now i was testing with less threads and see if
>> this is the case.
>
> Some kind of garbage collection bug... :/
>
> Could you try the bcache-testing branch? It's got significantly improved
> garbage collection code - if it's not fixed there, at least that code
> should be easier to debug...



-- 
Sheng Qiu
Texas A & M University
Room 332B Wisenbaker
email: herbert1984106-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org
College Station, TX 77843-3259
