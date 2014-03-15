From: Sitsofe Wheeler <sitsofe@yahoo.com>
Subject: Re: Performance testing with bcache
Date: Sat, 15 Mar 2014 17:52:15 +0000
Message-ID: <20140315175212.GA20197@sucs.org>
References: <155722734.53464.1394740311695.JavaMail.zimbra@xes-inc.com>
 <2000529324.55683.1394741536677.JavaMail.zimbra@xes-inc.com>
 <20140313205259.GA28293@sucs.org>
 <216592761.38181.1394822496274.JavaMail.zimbra@xes-inc.com>
 <1899882151.50322.1394831787760.JavaMail.zimbra@xes-inc.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-bcache-owner@vger.kernel.org>
Received: from silver.sucs.swan.ac.uk ([137.44.10.1]:47794 "EHLO
	silver.sucs.swan.ac.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756327AbaCORwS (ORCPT
	<rfc822;linux-bcache@vger.kernel.org>);
	Sat, 15 Mar 2014 13:52:18 -0400
Content-Disposition: inline
In-Reply-To: <1899882151.50322.1394831787760.JavaMail.zimbra@xes-inc.com>
Sender: linux-bcache-owner@vger.kernel.org
List-Id: linux-bcache@vger.kernel.org
To: Andrew Martin <amartin@xes-inc.com>
Cc: linux-bcache@vger.kernel.org

On Fri, Mar 14, 2014 at 04:16:27PM -0500, Andrew Martin wrote:
> 
> Do you have an example fio job file that has worked well for testing
> bcache?

Try these as a starting point:
benchmark-seq.fio:
; Script to gather general sequential write performance statistics
; Basic usage:
; BS="4k" DEV="sdf" RT=90 SEED=21 TYPE="ssd" fio benchmark-seq.fio

[global]
filename=/dev/${DEV}
runtime=${RT}
bs=${BS}
iodepth=4
ioengine=libaio
direct=1
stonewall
size=${SIZE}
randseed=${SEED}
[write]
rw=write

benchmark-rand.fio:
; Script to gather general random write performance statistics
; Basic usage:
; BS="4k" DEV="sdf" RT=90 SEED=21 TYPE="ssd" fio benchmark-rand.fio

[global]
filename=/dev/${DEV}
runtime=${RT}
bs=${BS}
iodepth=4
ioengine=libaio
direct=1
stonewall
size=${SIZE}
randseed=${SEED}
[randwrite]
rw=randwrite

After making the above files do
export RT=30; export SEED=21; export SIZE="10G"; export DEV="bcache0"
for b in "4" "16" "64"; do export BS="${b}k"; for job in "benchmark-seq" "benchmark-rand"; do fio $job.fio; done; done

The first time round get the stats where the cache is not being used.
Next time round set the appropriate cache options (easier said than done
:-), run a single benchmark-seq.fio job (I'd recommend 64k blocksize) to
warm the cache then rerun the above.

Let us know what you did and how it went!

-- 
Sitsofe | http://sucs.org/~sits/
