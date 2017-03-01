From: Eric Wheeler <bcache@lists.ewheeler.net>
Subject: Re: Drop in Iops with fsync when using NVMe as cache
Date: Tue, 28 Feb 2017 16:55:28 -0800 (PST)
Message-ID: <alpine.LRH.2.11.1702281634490.21435@mail.ewheeler.net>
References: <CAPntomBf8c6TFBLM5iBuX=OWmfQ-uGCUiDdJnXEn1+-gS7KJaw@mail.gmail.com> <20170222094057.GD31967@suse.cz> <CAPntomDbChdaEeJ+6E4-La-fEYgsbrKd1wUcxgM1mVKtTtinAA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-bcache-owner@vger.kernel.org>
Received: from mx.ewheeler.net ([66.155.3.69]:33756 "EHLO mail.ewheeler.net"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1751583AbdCAA46 (ORCPT <rfc822;linux-bcache@vger.kernel.org>);
        Tue, 28 Feb 2017 19:56:58 -0500
In-Reply-To: <CAPntomDbChdaEeJ+6E4-La-fEYgsbrKd1wUcxgM1mVKtTtinAA@mail.gmail.com>
Sender: linux-bcache-owner@vger.kernel.org
List-Id: linux-bcache@vger.kernel.org
To: shiva rkreddy <shiva.rkreddy@gmail.com>
Cc: Vojtech Pavlik <vojtech@suse.com>, linux-bcache@vger.kernel.org

On Wed, 22 Feb 2017, shiva rkreddy wrote:
> >> fio command without fsync:
> >>
> >> # fio -filename=/dev/bcache0 -direct=1 -ioengine=libaio -rw=randwrite
> >> -bs=4k -name=mytest -iodepth=1 -runtime=30 -time_based
> >>
> >> iops : 35k
> >>
> >> fio command with fsync:
> >>
> >> fio -filename=/dev/bcache0 -direct=1 -ioengine=libaio -rw=randwrite
> >> -bs=4k -name=mytest -iodepth=1 -runtime=30 -time_based -fsync=1

Try -runtime=25 since 30s is the default writeback delay.  More below.

> >>
> >> iops: 8.1k
> >
> >> I'm quite surprised by the drop in iops with fsync turned on. Is this
> >> expected or am I missing some basic setting?
> >
> > It's not uncommon that fsync would have a huge performance impact.
> > Without fsync, most of the data never hits the storage and is only
> > staying in the system memory.
> >
> > May I suggest that you try to measure the performance of the same tests
> > when the filesystem is created on the NVMe device directly, without
> > using bcache? You're likely to observe a similar pattern.
>
> I've tried fio directly on nvme device and without filesystem. The
> drop with fsync is not that significant; 44313 vs 42713 on a 30s
> randwrite run with iodepth=1

Try using `make-bcache --data-offset X ...` to align your backing device. 
It defaults to an 8k offset which may not be optimal. By the way, what is 
your backing device /dev/sdb?

Try these, too:

echo 0 > /sys/block/bcache0/bcache/sequential_cutoff
echo 10000000 > /sys/block/bcache0/bcache/cache/congested_read_threshold_us 
echo 10000000 > /sys/block/bcache0/bcache/cache/congested_write_threshold_us





--
Eric Wheeler


> 
> 
> # fio -filename=/dev/nvme0n1 -direct=1 -ioengine=libaio -rw=randwrite
> -bs=4k -name=mytest -iodepth=1 -runtime=30 -time_based
> mytest: (g=0): rw=randwrite, bs=4K-4K/4K-4K/4K-4K, ioengine=libaio, iodepth=1
> fio-2.1.3
> Starting 1 process
> Jobs: 1 (f=1): [w] [100.0% done] [0KB/177.6MB/0KB /s] [0/45.5K/0 iops]
> [eta 00m:00s]
> mytest: (groupid=0, jobs=1): err= 0: pid=2131: Thu Feb  9 18:56:01 2017
>   write: io=5193.2MB, bw=177253KB/s, iops=44313, runt= 30001msec
> 
> # fio -filename=/dev/nvme0n1 -direct=1 -ioengine=libaio -rw=randwrite
> -bs=4k -name=mytest -iodepth=1 -runtime=30 -time_based -fsync=1
> mytest: (g=0): rw=randwrite, bs=4K-4K/4K-4K/4K-4K, ioengine=libaio, iodepth=1
> fio-2.1.3
> Starting 1 process
> Jobs: 1 (f=1): [w] [100.0% done] [0KB/167.4MB/0KB /s] [0/42.9K/0 iops]
> [eta 00m:00s]
> mytest: (groupid=0, jobs=1): err= 0: pid=2136: Thu Feb  9 19:04:54 2017
>   write: io=5005.5MB, bw=170853KB/s, iops=42713, runt= 30000msec
> 
> 
> On Wed, Feb 22, 2017 at 3:40 AM, Vojtech Pavlik <vojtech@suse.com> wrote:
> > On Tue, Feb 21, 2017 at 10:48:06AM -0600, shiva rkreddy wrote:
> >
> >
> > --
> > Vojtech Pavlik
> > Director SUSE Labs
> --
> To unsubscribe from this list: send the line "unsubscribe linux-bcache" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
