From: Kent Overstreet <kmo-PEzghdH756F8UrSeD/g0lQ@public.gmane.org>
Subject: Re: bcache disabled due to inconsistent ptrs
Date: Sun, 28 Jul 2013 16:37:57 -0700
Message-ID: <20130728233757.GB6653@moria.home.lan>
References: <CAB7xdimUODWgMC8fuxC_6bRWYja6g5Z+LYSr85obRUUvWsoArQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-bcache-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <CAB7xdimUODWgMC8fuxC_6bRWYja6g5Z+LYSr85obRUUvWsoArQ-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-bcache-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: sheng qiu <herbert1984106-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: linux-bcache-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-bcache@vger.kernel.org

On Sun, Jul 28, 2013 at 06:59:10PM -0400, sheng qiu wrote:
> Hi,
> 
> i run filebench's fileserver workload on bcache. It disabled the flash
> cache layer in the middle due to the inconsistent ptrs. here is the
> error message.
> 
> bcache: error on b3f3f4cb-3df2-4564-a45f-18a05f497d78: inconsistent
> ptrs: mark = 2, level = 0, disabling caching
> [ 2444.047018] Pid: 2930, comm: kworker/u:1 Not tainted 3.9.0+ #196
> [ 2444.047019] Call Trace:
> [ 2444.047025]  [<ffffffff81614bd8>] __bch_btree_mark_key+0x268/0x290
> [ 2444.047027]  [<ffffffff81614ff5>] btree_gc_mark_node+0x75/0x230
> [ 2444.047029]  [<ffffffff8161530e>] btree_gc_recurse+0x15e/0x530
> [ 2444.047031]  [<ffffffff8161b20d>] ? bch_btree_sort_into+0x8d/0xf0
> [ 2444.047033]  [<ffffffff81617794>] bch_btree_gc+0x594/0x640
> [ 2444.047035]  [<ffffffff8161e4be>] ? dirty_io_destructor+0xe/0x10
> [ 2444.047038]  [<ffffffff81077cfb>] process_one_work+0x16b/0x400
> [ 2444.047040]  [<ffffffff81078988>] worker_thread+0x118/0x360
> [ 2444.047042]  [<ffffffff81078870>] ? manage_workers+0x350/0x350
> [ 2444.047044]  [<ffffffff8107df10>] kthread+0xc0/0xd0
> [ 2444.047046]  [<ffffffff8107de50>] ? flush_kthread_worker+0xb0/0xb0
> [ 2444.047048]  [<ffffffff817adb2c>] ret_from_fork+0x7c/0xb0
> [ 2444.047050]  [<ffffffff8107de50>] ? flush_kthread_worker+0xb0/0xb0
> 
> is there any suggestion?

Erg.. What branch are you running?
