From: Andrew Martin <amartin@xes-inc.com>
Subject: Performance testing with bcache
Date: Thu, 13 Mar 2014 15:12:16 -0500 (CDT)
Message-ID: <2000529324.55683.1394741536677.JavaMail.zimbra@xes-inc.com>
References: <155722734.53464.1394740311695.JavaMail.zimbra@xes-inc.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-bcache-owner@vger.kernel.org>
Received: from xes-mad.com ([216.165.139.218]:36368 "EHLO xes-mad.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754408AbaCMUMS (ORCPT <rfc822;linux-bcache@vger.kernel.org>);
	Thu, 13 Mar 2014 16:12:18 -0400
In-Reply-To: <155722734.53464.1394740311695.JavaMail.zimbra@xes-inc.com>
Sender: linux-bcache-owner@vger.kernel.org
List-Id: linux-bcache@vger.kernel.org
To: linux-bcache@vger.kernel.org

Hello,

I am working on setting up bcache on Ubuntu 13.10 (with kernel 3.11.0-17) 
for read performance testing in writethrough mode. I've written a test script 
which uses dd to write data to the bcache device, read it back in, and then 
attempt to read it again (to measure cache speed):
# write the data to the disk
dd if=/dev/zero of=/path/to/bcache/mount/file.raw bs=512 count=2

# read the data (using iflag=nocache to make sure it gets into bcache's 
# cache and doesn't use the kernel's cache) 
dd if=/path/to/bcache/mount/file.raw of=/dev/null iflag=nocache

# now perform the read, which should read from bcache's cache
dd if=/path/to/bcache/mount/file.raw of=/dev/null iflag=nocache

However, if I cat /sys/block/bcache0/bcache/cache/cache_available_percent
before and after performing the read, the value is always 100. Would using
iflag=direct be better than iflag=nocache in this case? Is there a better
way to force data into the cache for this type of performance benchmarking?

Thanks,

Andrew Martin
