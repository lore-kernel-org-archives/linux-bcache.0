From: sheng qiu <herbert1984106-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: bcache disabled due to inconsistent ptrs
Date: Sun, 28 Jul 2013 18:57:42 -0500
Message-ID: <CAB7xdimynY=k1e9+jMM1Fwm1LmY=n_xZQS+zKW5VZpPDa_2jGw@mail.gmail.com>
References: <CAB7xdimUODWgMC8fuxC_6bRWYja6g5Z+LYSr85obRUUvWsoArQ@mail.gmail.com>
	<20130728233757.GB6653@moria.home.lan>
	<CAB7xdik9ZEsj8+s+DB9GDqEZAcLTStyk+mf7Yiw7uazAXjz1MA@mail.gmail.com>
	<20130728235259.GC6653@moria.home.lan>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-bcache-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20130728235259.GC6653-jC9Py7bek1znysI04z7BkA@public.gmane.org>
Sender: linux-bcache-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Kent Overstreet <kmo-PEzghdH756F8UrSeD/g0lQ@public.gmane.org>
Cc: linux-bcache-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-bcache@vger.kernel.org

generally the flash size is 40GB, RAM is 8GB. The workload first
writes about 65GB of data and then do read/writes (10 threads) on
those data.
it runs less than 1 hour during the read/write step and nearly
happened each time. now i was testing with less threads and see if
this is the case.

Thanks,
Sheng

On Sun, Jul 28, 2013 at 6:52 PM, Kent Overstreet <kmo-PEzghdH756F8UrSeD/g0lQ@public.gmane.org> wrote:
> On Sun, Jul 28, 2013 at 06:47:43PM -0500, sheng qiu wrote:
>> Hi Kent,
>>
>> i get the bcache codes from git clone
>> http://evilpiepirate.org/git/linux-bcache.git.
>
> Can you reproduce it? How long did it take to trigger?



-- 
Sheng Qiu
Texas A & M University
Room 332B Wisenbaker
email: herbert1984106-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org
College Station, TX 77843-3259
