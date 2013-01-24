From: Kent Overstreet <koverstreet-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Subject: Re: your mail
Date: Thu, 24 Jan 2013 15:12:40 -0800
Message-ID: <20130124231240.GN26407@google.com>
References: <C4B5704C6FEB5244B2A1BCC8CF83B86B0A6257C7D0@MYMBX.MY.STEC-INC.AD>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-bcache-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <C4B5704C6FEB5244B2A1BCC8CF83B86B0A6257C7D0-AQg6BlXVjylhNUoibfp7lHKnxlUjViKd@public.gmane.org>
Sender: linux-bcache-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Nitin Kshirsagar <nshirsagar-FZ1t8LVTR2ZWk0Htik3J/w@public.gmane.org>
Cc: "linux-bcache-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-bcache-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "kent.overstreet-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org" <kent.overstreet-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Amit Kale <akale-FZ1t8LVTR2ZWk0Htik3J/w@public.gmane.org>, Sanoj Unnikrishnan <sunnikrishnan-FZ1t8LVTR2ZWk0Htik3J/w@public.gmane.org>
List-Id: linux-bcache@vger.kernel.org

On Wed, Jan 23, 2013 at 08:37:10PM +0800, Nitin Kshirsagar wrote:
> Hello Kent,
> 
> I have setup bcache and run fio data verification test on write back and write through caches.
> The fio tests are passed, however I have found following issues while using bcache.
> 
> Issue1: Cache is not created as per user specified options  
> --------------------------------------------------------------------------------------------------------
> Steps:
> 1.Create cache by specifying mode writeback and cache replacement policy as fifo
> [root@annu bcache]# make-bcache --cache  /dev/sdc --bdev /dev/sdd  --writeback --cache_replacement_policy=fifo 
> UUID:                   e25f2840-f02b-46af-81e7-28948b2737cc
> Set UUID:               68da5b89-1e87-457a-80c7-2c822737f969
> nbuckets:               2048
> block_size:             1
> bucket_size:            1024
> nr_in_set:              1
> nr_this_dev:            0
> first_bucket:           1
> UUID:                   a3ce52e6-631b-4c74-afa2-9f8b0088c7f4
> Set UUID:               68da5b89-1e87-457a-80c7-2c822737f969
> nbuckets:               20480
> block_size:             1
> bucket_size:            1024
> nr_in_set:              1
> nr_this_dev:            0
> first_bucket:           1
> 
> [root@annu bcache]# echo /dev/sdc > /sys/fs/bcache/register
> [root@annu bcache]# echo /dev/sdd > /sys/fs/bcache/register
> 
> 
> 2. Cache mode should  be "writeback" instead of "writethrough"
> [root@annu bcache]# cat /sys/block/bcache2/bcache/cache_mode
> [writethrough] writeback writearound none
> [root@annu bcache]# cat /sys/block/bcache2/bcache/writeback_running
> 1
> 
> 3. Cache policy should be "fifo" instead of "lru" 
> [root@annu ~]# cat /sys/block/bcache2/bcache/cache/cache0/cache_replacement_policy
> [lru] fifo random

These two are... oddities/documentation bugs with make-bcache. Options
apply to devices you specify _after_ the option, not before - it was
implemented this way so you could format cache devices and backing
devices at the same time - and really, the other options should be
parsed differently but I haven't spent much time on make-bcache.

Patches welcome :)

> Issue2: Cache dirty data value should not be negative.
> -------------------------------------------------------------------------------------------------------
> Steps:
> 
> 1.Create cache by specifying mode writeback and cache replacement policy as fifo
> 2.To make bcache devices known to the kernel
>     [root@annu bcache]# echo /dev/sdc > /sys/fs/bcache/register
>     [root@annu bcache]# echo /dev/sdd > /sys/fs/bcache/register
> 3.Create FS on cache  /dev/bcacheN and mount in directory
> 4.Create Data set by using fio or dd on mount point.
> 5. Change cache node from "writethrough" to "writeback"    
>     [root@annu ~]# echo writeback >  /sys/block/bcache2/bcache/cache_mode
>     [root@annu ~]# cat /sys/block/bcache2/bcache/cache_mode
>     writethrough [writeback] writearound none
> 6.Check cache dirty data should not be negative value 
>    [root@annu ~]# cat /sys/block/bcache2/bcache/dirty_data
>    -9.4M

Known bug, but fairly harmless one. That value is only used for the pd
controller that adjusts the background writeback rate - and in practice
when there's dirty data in the cache it shouldn't be _too_ far off.

It's on the todo list, but it'll be a bit before I get to it.
