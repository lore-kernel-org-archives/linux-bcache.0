From: "Lulina (A)" <lina.lulina@huawei.com>
Subject: Question about bcache buckets utilization
Date: Tue, 9 Sep 2014 08:07:35 +0000
Message-ID: <E5D59058E6941147BD3ACF9CB4AA49E336BD4F29@szxema508-mbx.china.huawei.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-bcache-owner@vger.kernel.org>
Received: from [119.145.14.66] ([119.145.14.66]:40938 "EHLO
	szxga03-in.huawei.com" rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org
	with ESMTP id S1755873AbaIIIIP convert rfc822-to-8bit (ORCPT
	<rfc822;linux-bcache@vger.kernel.org>);
	Tue, 9 Sep 2014 04:08:15 -0400
Content-Language: zh-CN
Sender: linux-bcache-owner@vger.kernel.org
List-Id: linux-bcache@vger.kernel.org
To: "kmo@daterainc.com" <kmo@daterainc.com>
Cc: Guohongzhen <guohongzhen@huawei.com>, "linux-bcache@vger.kernel.org" <linux-bcache@vger.kernel.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>

Hi! Kent Overstreet, I tested bcache branch for jens:
http://evilpiepirate.org/git/linux-bcache.git/log/?h=for-jens

I have a question about buckets utilization, can you help me to resolve it?

This is the test fio cmd:
fio -name iops -rw=randwrite -iodepth=32 -numjobs=1 -filename=/dev/bcache0 -ioengine libaio -direct=1 -bs=4k -size=500M -runtime=600 -time_based -random_distribution=zipf:1.2

My cache device is 1G size, and Hdd device is 5G size. The bucket size is default 512k.
When the test is run, cache is over CUTOFF_WRITEBACK_SYNC after 3 or 4 seconds. The test result is as follows: 

Device:         rrqm/s   wrqm/s     r/s     w/s    rMB/s    wMB/s avgrq-sz avgqu-sz   await  svctm  %util
bcache0           0.00     0.00    0.00 62081.00     0.00   242.50     8.00     0.00    0.01   0.00   0.00
bcache0           0.00     0.00    0.00 72407.00     0.00   282.84     8.00     0.00    0.01   0.00   0.00
bcache0           0.00     0.00    0.00 62990.00     0.00   246.05     8.00     0.00    0.08   0.00   0.00
bcache0           0.00     0.00    0.00  511.00     0.00     2.00     8.00     0.00   62.53   0.00   0.00
bcache0           0.00     0.00    0.00  601.00     0.00     2.35     8.00     0.00   52.73   0.00   0.00

After cache is over CUTOFF_WRITEBACK_SYNC, all writes come down to the hdd, then I got a pool performance.

As the random rang is set to 500M, It will all overlapped in the cache device. 
Why the overlapped buckets can't be reused? Is there any other conditions need to meet?

Thanks,
Lina Lu
