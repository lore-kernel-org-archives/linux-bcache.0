From: Kent Overstreet <kmo-PEzghdH756F8UrSeD/g0lQ@public.gmane.org>
Subject: Re: bcache disabled due to inconsistent ptrs
Date: Mon, 29 Jul 2013 12:13:05 -0700
Message-ID: <20130729191305.GB13280@kmo-pixel>
References: <CAB7xdimUODWgMC8fuxC_6bRWYja6g5Z+LYSr85obRUUvWsoArQ@mail.gmail.com>
 <20130728233757.GB6653@moria.home.lan>
 <CAB7xdik9ZEsj8+s+DB9GDqEZAcLTStyk+mf7Yiw7uazAXjz1MA@mail.gmail.com>
 <20130728235259.GC6653@moria.home.lan>
 <CAB7xdimynY=k1e9+jMM1Fwm1LmY=n_xZQS+zKW5VZpPDa_2jGw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-bcache-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <CAB7xdimynY=k1e9+jMM1Fwm1LmY=n_xZQS+zKW5VZpPDa_2jGw-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-bcache-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: sheng qiu <herbert1984106-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: linux-bcache-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-bcache@vger.kernel.org

On Sun, Jul 28, 2013 at 06:57:42PM -0500, sheng qiu wrote:
> generally the flash size is 40GB, RAM is 8GB. The workload first
> writes about 65GB of data and then do read/writes (10 threads) on
> those data.
> it runs less than 1 hour during the read/write step and nearly
> happened each time. now i was testing with less threads and see if
> this is the case.

Some kind of garbage collection bug... :/

Could you try the bcache-testing branch? It's got significantly improved
garbage collection code - if it's not fixed there, at least that code
should be easier to debug...
