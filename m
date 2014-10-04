From: Stan Hoeppner <stan@hardwarefreak.com>
Subject: tuning for mixed rate 800 stream write application
Date: Fri, 03 Oct 2014 21:22:52 -0500
Message-ID: <542F59FC.1080806@hardwarefreak.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-bcache-owner@vger.kernel.org>
Received: from mo-65-41-216-221.sta.embarqhsd.net ([65.41.216.221]:29082 "EHLO
	greer.hardwarefreak.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750859AbaJDCWf (ORCPT
	<rfc822;linux-bcache@vger.kernel.org>);
	Fri, 3 Oct 2014 22:22:35 -0400
Received: from [134.64.128.215] (unknown [192.65.45.20])
	by greer.hardwarefreak.com (Postfix) with ESMTPA id F39466C0F6
	for <linux-bcache@vger.kernel.org>; Fri,  3 Oct 2014 21:22:33 -0500 (CDT)
Sender: linux-bcache-owner@vger.kernel.org
List-Id: linux-bcache@vger.kernel.org
To: linux-bcache@vger.kernel.org

Hello fellow bcache users/developers,

A couple of questions.

1.  How do I disable write caching?
2.  How do I increase the sequential IO tracking window from 128 IOs to say 4096 IOs or nmore?

Our application does small random reads and data is never read twice, so we don't want any read caching.  Reads comprise less than 20% of the IO workload.  It writes ~800 streams to hundreds of preallocated files in parallel using O_DIRECT and AIO.  The stream rates vary from ~50MB/s to less than 2KB/s.  bcache currently seems to be writing a lot of data to cache that should be going directly to the two RAID LUNs, bcache0 and bcache1.  These each show over 150GB cache used or 300GB total of a 400GB SSD, with only 10GB bypassed.  It seems to be writing sequential IO to cache because it's unable to properly classify it due to the small 128 entry tracking window.  Thus throughput is actually about 20 lower than direct to LUN.  It seems clear bcache isn't doing the right thing with classificat
 ion due to the large number of mixed sequential/random IOs in flight.

The boxes have 32 cores and 256GB of RAM so we have plenty of horsepower and memory to dedicate to bcache use.  These boxes are totally IO bound with little CPU/memory use.

Please advise.

Thanks,
Stan
