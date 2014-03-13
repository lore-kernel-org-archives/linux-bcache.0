From: Sitsofe Wheeler <sitsofe@yahoo.com>
Subject: Re: Performance testing with bcache
Date: Thu, 13 Mar 2014 20:53:02 +0000
Message-ID: <20140313205259.GA28293@sucs.org>
References: <155722734.53464.1394740311695.JavaMail.zimbra@xes-inc.com>
 <2000529324.55683.1394741536677.JavaMail.zimbra@xes-inc.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-bcache-owner@vger.kernel.org>
Received: from silver.sucs.swan.ac.uk ([137.44.10.1]:34250 "EHLO
	silver.sucs.swan.ac.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755259AbaCMUxE (ORCPT
	<rfc822;linux-bcache@vger.kernel.org>);
	Thu, 13 Mar 2014 16:53:04 -0400
Content-Disposition: inline
In-Reply-To: <2000529324.55683.1394741536677.JavaMail.zimbra@xes-inc.com>
Sender: linux-bcache-owner@vger.kernel.org
List-Id: linux-bcache@vger.kernel.org
To: Andrew Martin <amartin@xes-inc.com>
Cc: linux-bcache@vger.kernel.org

On Thu, Mar 13, 2014 at 03:12:16PM -0500, Andrew Martin wrote:
> 
> I am working on setting up bcache on Ubuntu 13.10 (with kernel 3.11.0-17) 
> for read performance testing in writethrough mode. I've written a test script 
> which uses dd to write data to the bcache device, read it back in, and then 
> attempt to read it again (to measure cache speed):
> # write the data to the disk
> dd if=/dev/zero of=/path/to/bcache/mount/file.raw bs=512 count=2

This will only tell you sequential speeds of small blocks. You may want
to use a tool like fio to let you generate different types of IO
patterns to see what the impact is. For example, the difference between
an hdd's and an sdd's top large block sequential speeds isn't nearly as
dramatic as the difference between their top small block random
speeds...

> # read the data (using iflag=nocache to make sure it gets into bcache's 
> # cache and doesn't use the kernel's cache) 
> dd if=/path/to/bcache/mount/file.raw of=/dev/null iflag=nocache
> 
> # now perform the read, which should read from bcache's cache
> dd if=/path/to/bcache/mount/file.raw of=/dev/null iflag=nocache

This may not perform as you expect it to do. My testing shows that the
read cache bcache is a bit quirky and to see it being used you have to
ensure that the blocks being read the second time are the exact same
size as the blocks that were read the first time. I think that
particular issue is alluded to in TROUBLESHOOTING PERFORMANCE on
http://evilpiepirate.org/git/linux-bcache.git/tree/Documentation/bcache.txt?h=bcache-dev#n126
(Still getting cache misses, of the same data). I would advise you to
warm the cache by doing writes as that doesn't seem to show the problem
but also see below.

> However, if I cat /sys/block/bcache0/bcache/cache/cache_available_percent
> before and after performing the read, the value is always 100. Would using
> iflag=direct be better than iflag=nocache in this case? Is there a better
> way to force data into the cache for this type of performance benchmarking?

The amount free isn't as important as the cache hits/misses ratio.
Additionally I would recommend reading the TROUBLESHOOTING PERFORMANCE
section mentioned above and posting your findings here because the
bcache defaults often defeat first attempt synthetic benchmarking...

-- 
Sitsofe | http://sucs.org/~sits/
