From: Kent Overstreet <kmo-PEzghdH756F8UrSeD/g0lQ@public.gmane.org>
Subject: Re: Inconsistent Performance
Date: Mon, 29 Jul 2013 12:04:47 -0700
Message-ID: <20130729190447.GA13280@kmo-pixel>
References: <51F5E261.6050600@networklabs.co.nz>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-bcache-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <51F5E261.6050600-3e6jenk95VYpDvLZ8AWkcaVXKuFTiq87@public.gmane.org>
Sender: linux-bcache-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Andrew Thrift <andrew-3e6jenk95VYpDvLZ8AWkcaVXKuFTiq87@public.gmane.org>
Cc: linux-bcache-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-bcache@vger.kernel.org

On Mon, Jul 29, 2013 at 03:32:49PM +1200, Andrew Thrift wrote:
> Hi,
> 
> We are noticing some odd performance characteristics with bcache on
> 3.10 Mainline kernel.
> 
> We are using Intel DC S3700 SSD and Seagate Constellation ES.2 HDD
> 
> Using FIO to perform a 4K random write test with QD=32 and 4
> instances we get:
> 
> RAW SSD:    55.5K iops
> 
> RAW HDD:   540 iops
> 
> Fresh bcache on top of SSD/HDD [writeback]:    36.8K iops
> 
> Which is not great, but OK.
> 
> However if I run the FIO test a number of times, letting it write
> out the data to the backing device after each run, after a few runs
> I will notice the IOPS drop.  When the benchmark starts it will sit
> around 14K IOPS, then as soon as it starts writing to the backing
> device this will drop to around 5K IOPS. On the subsequent runs it
> will never go above 5K IOPS.

Hmm... that sounds like something an SSD would do, but it sounds like
you've checked that performance to the bare SSD isn't degrading, and
that is a rather large regression.

> Has there been a performance regression on 3.10 ?

Certainly not impossible.

Could you try doing some profiling with perf and seeing if anything
shows up? Also, try flipping off discards if you have them on.

It's just write performance that's degrading, not read?
