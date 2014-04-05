From: Sitsofe Wheeler <sitsofe@yahoo.com>
Subject: Re: Performance testing with bcache
Date: Sat, 5 Apr 2014 08:57:53 +0100
Message-ID: <20140405075750.GA27592@sucs.org>
References: <155722734.53464.1394740311695.JavaMail.zimbra@xes-inc.com>
 <2000529324.55683.1394741536677.JavaMail.zimbra@xes-inc.com>
 <20140313205259.GA28293@sucs.org>
 <216592761.38181.1394822496274.JavaMail.zimbra@xes-inc.com>
 <1899882151.50322.1394831787760.JavaMail.zimbra@xes-inc.com>
 <20140315175212.GA20197@sucs.org>
 <459660524.313506.1396631210130.JavaMail.zimbra@xes-inc.com>
 <CALJ65zm2C5xX0am76ZNK4N2Uai+3U8bQENHcfjU_KOOb4+1iAw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-bcache-owner@vger.kernel.org>
Received: from silver.sucs.swan.ac.uk ([137.44.10.1]:58309 "EHLO
	silver.sucs.swan.ac.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753920AbaDEH56 (ORCPT
	<rfc822;linux-bcache@vger.kernel.org>);
	Sat, 5 Apr 2014 03:57:58 -0400
Content-Disposition: inline
In-Reply-To: <CALJ65zm2C5xX0am76ZNK4N2Uai+3U8bQENHcfjU_KOOb4+1iAw@mail.gmail.com>
Sender: linux-bcache-owner@vger.kernel.org
List-Id: linux-bcache@vger.kernel.org
To: Andrew Martin <amartin@xes-inc.com>
Cc: Kent Overstreet <kmo@daterainc.com>, "linux-bcache@vger.kernel.org" <linux-bcache@vger.kernel.org>

On Fri, Apr 04, 2014 at 12:10:53PM -0700, Kent Overstreet wrote:
> How much data is being bypassed?
> 
> On Fri, Apr 4, 2014 at 10:06 AM, Andrew Martin <amartin@xes-inc.com> wrote:
> >
> > Am I doing something wrong when running fio?

Andrew, 

There's not enough information to be able to say if something is going
wrong at this stage as I don't know:
a) The speed of the backing device (also the block device name (e.g.
sda/md0 helps later)) with a given IO pattern
b) The speed of the front device (block name also helps later) with a
given IO pattern
c) What bcache settings you have set
d) What type of IO was done to the bcache device and at which points
(e.g. was writeback happening at that point?)
e) What statistics bcache is reporting

Initially while you're getting used to this I'd stick to just running
one block size (4k). So something like:
export RT=30; export SEED=21; export SIZE="5G"; export DEV="bcache0"; BS="4k"

Ensure you have read and implemented the appropriate pieces mentioned in
the TROUBLESHOOTING PERFORMANCE section of
https://git.kernel.org/cgit/linux/kernel/git/torvalds/linux.git/tree/Documentation/bcache.txt#n130
otherwise results can be unexpected when benchmarking...

Something like the following would be easier to follow:
Set the cache_mode to none. Run (and record)
grep -r . /sys/block/bcache0/bcache/
Clear the bcache total stats (see clear_stats)
View and record the bcache backing device total stats then run
fio benchmark-rand.fio
View and record the bcache backing device total stats
Set the cache_mode to writeback. Run (and record)
grep -r . /sys/block/bcache0/bcache/
Clear the bcache total stats then run
View and record the bcache backing device total stats then run
fio benchmark-rand.fio
View and record the bcache backing device total stats

If everything is working (and the front device is faster for random
writes) I'd expect the with writeback fio job to be noticibly faster
than none fio job (how much faster is setup dependent). Only if my
expectation was correct would I repeat the above with the
benchmark-seq.fio job...

-- 
Sitsofe | http://sucs.org/~sits/
