From: Alex Elsayed <eternaleye+usenet-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: Bcache in Xen Environment
Date: Fri, 03 Aug 2012 00:03:11 -0700
Message-ID: <jvft3g$tc5$1@dough.gmane.org>
References: <f6d8cb27fa455b02f6da326945b06173@abpni.co.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7Bit
Return-path: <linux-bcache-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-bcache-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-bcache-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-bcache@vger.kernel.org

I'm not a bcache developer, but here's how I understand this would work out:

Jonathan Tripathy wrote:

> Hi Everyone,
> 
> I wish to investigate using bcache in a Xen virtualisation environment.
> We wish to use bcache to add a SSD (single drive) cache to a RAID10
> device (using metal spindles), and I have a few questions.
> 
> 1) On the bcache website, it says this:
> 
> "It won't return a write as completed until everything necessary to
> locate it is on stable storage, nor will writes ever be seen as
> partially completed (or worse, missing) in the event of power failure."
> 
> Is this just true for write-through? Or write-back mode as well? If it
> is true for write-back mode, how does this work? I thought the point of
> write-back mode was to return write quickly due to the fast buffer
> storage.

In this case, 'stable storage' almost certainly means 'persistent and will 
survive unexpected power loss' rather than 'the backing device'. It returns 
quickly because it writes to the SSD and then gets it to the backing device 
later, but since the SSD will survive uncontrolled power loss it counts as 
stable storage.

> 2) When we delete a virtual machine, it is common for us to run dd to
> "zero" the LVM LV so that data is deleted. If we introduce bcache, can
> we still be sure that all data is gone? We need to make sure that no
> data leakage can occur between LVs.

The user-level semantics should be unchanged - if you zero the old data, a 
new LV that is allocated the same extents won't see old data. Also, writes 
to a block would invalidate old cached data for that block, so it won't be 
returned on reads; however it may not be physically deleted from the cache 
device immediately due to how bcache tries to be careful about erase blocks. 
The short of it is, LVs should contain the data you expect, but anything 
that could read blocks off of the cache device (the SSD) directly might be 
able to see that data.

> 3) SSD storage has a much more limited write span that metal spindles.
> If an SSD drive were to fail, will the RAID10 spindle array still
> continue to function? Will any data be lost? How does write-through and
> write-back handle these cases?

In the case of write-though caching with a single cache device, bcache.txt 
in the kernel source tree says:

> If you're booting up and your cache device is gone and never coming back,
> you can force run the backing device:
>
>   echo 1 > /sys/block/sdb/bcache/running
>
> (You need to use /sys/block/sdb (or whatever your backing device is
> called), not /sys/block/bcache0, because bcache0 doesn't exist yet. If
> you're using a partition, the bcache directory would be at
> /sys/block/sdb/sdb2/bcache)
>
> The backing device will still use that cache set if it shows up in the
> future, but all the cached data will be invalidated.

If you use write-back caching, the following line is also relevant:

> If there was dirty data in the cache, don't expect the filesystem to be
> recoverable - you will have massive filesystem corruption, though ext4's
> fsck does work miracles.

Multiple cache devices are not fully implemented yet (about 95% according to 
bcache.h), but when they are ready they should mitigate the risks by 
mirroring dirty data between cache devices, while maximizing space and 
performance by striping the clean read cache which can be discarded without 
losing data.

> Thanks for your time.

You're welcome!
