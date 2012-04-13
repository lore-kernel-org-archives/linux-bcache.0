From: Leen Besselink <leen-RaxvPIb8m1QxPGQnf4u0eF6hYfS7NtTn@public.gmane.org>
Subject: Re: Preliminary performance benchmarks.
Date: Fri, 13 Apr 2012 02:05:46 +0200
Message-ID: <20120413000546.GB2941@apia.perrit.net>
Reply-To: leen-RaxvPIb8m1QxPGQnf4u0eF6hYfS7NtTn@public.gmane.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-bcache-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
Sender: linux-bcache-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-bcache-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-bcache@vger.kernel.org

(I've been lurking the mailinglist archive for a few months already, I think
bcache sounds really interresting)

Hello Joseph,

> Carrying out some scalability tests on high I/O systems. More tests to
> come using the Phoronix Test Suite.
> 
> Fio summary:
> 24 jobs
> Direct IO
> Randwrite test
> Total of about 80k IOPs at 3.5k IOPS per thread.
> 
> Test rig specs:
> 2x Intel(R) Xeon(R) CPU X5650  @ 2.67GHz (12 physical cores, 24 logical)
> 12x 2TB Seagate nearline-SAS in RAID6 on LSI Logic / Symbios Logic LSI
> MegaSAS 9260
> 2x Intel 520 SSDs 120GB in RAID0
> 
> The 2 520s are striped with md raid as /dev/md0 whch is formatted as a
> bcache cache device using 1M buckets and 8k hard block size
> Backing device is the big old raid6.
> 
> Random IO performance of the native raid0 is about 96K IOPs, backing
> device in the realm of 1600ish.
> However the backing device has a sequential IO performance of about 1.5GB/s.
> 

So why do you put your SSDs in RAID0 ?

If you are using RAID6 for your HDD you obviously care about your data, shouldn't
you be using RAID1 or let bcache do some RAID1-like behaviour* ?

Because when you use RAID0 your data will only be written to one SSD.

* I think bcache had some ability to handle that sort of automatically.

> Below are some quick findings using fio - showing very good
> scalability of bcache even with very very fast SSDs.
> *Note: The SSDs are connected via a SATA2 interface being somewhat of
> a bottleneck.

Have a nice day,
	Leen.
