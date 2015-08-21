From: Christoph Nelles <evilazrael@evilazrael.de>
Subject: Unblocking Writeback modus
Date: Fri, 21 Aug 2015 17:01:08 +0200
Message-ID: <mr7efk$isu$1@ger.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-bcache-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:44210 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751570AbbHUPUH (ORCPT <rfc822;linux-bcache@vger.kernel.org>);
	Fri, 21 Aug 2015 11:20:07 -0400
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <glbd-linux-bcache@m.gmane.org>)
	id 1ZSo6v-0001nV-Tr
	for linux-bcache@vger.kernel.org; Fri, 21 Aug 2015 17:20:05 +0200
Received: from evilazrael.net ([5.10.172.2])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-bcache@vger.kernel.org>; Fri, 21 Aug 2015 17:20:05 +0200
Received: from evilazrael by evilazrael.net with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-bcache@vger.kernel.org>; Fri, 21 Aug 2015 17:20:05 +0200
Sender: linux-bcache-owner@vger.kernel.org
List-Id: linux-bcache@vger.kernel.org
To: linux-bcache@vger.kernel.org

Hi,

i am currently evaluating bcache and my experience sofar is really great 
:-) . I am having an issue with an artificial workload, but this 
indicates a serious general issue for me.

Setup:
- 800GB SSD on top of HW & SW RAID as cache device, 920MB/s max 
sequential write
- 9TB HDD on top of HW & SW RAID  as backing device
- bcache0 is XFS formatted, OS is SLES 12 with Linux kernel  3.12.44-52.10
- writeback is enabled, congested_read & congested_write set to 0, 
bucket_size default = 512k, block_size 512B or 4kB

Test is to write 1TB randomly with 64k IO size with fio:
fio --name=test --filename=/testme/fio.dat --rw=randwrite --bs=64k 
--size=1T  --ioengine=libaio --direct=1 --iodepth=10000

The 1TB > 800GB was choosen to see what happens when the cache is full. 
  The main purpose of the cache is write buffering.

Observation:
1) fio achieves 700 to 1000 MB/s throughput with that workload. Great!
2) Migration to the backing storage happens at the same with 25-80MB/s. 
Device is fully saturated, so writeback_rate is not limiting
3) After  ~530-540GB writeback seems to turns off and fio seems to drop 
down to 0-70MB/s with the average and mean more <10MB/s, 
stats_five_minute show only zeros for all values, cache_mode still writeback
4) Cancelling fio and waiting letting the cache clean. The backing 
device dirty data will drop slowly to zero and then the backing device 
will be marked as clean
5) Restarting fio during the migration or even after the cache has been 
marked as clean will bypass the cache and write directly to the HDDs
bcache-status -s shows
Total Cache Used            742.94GiB   (100%)
Dirty Data                  521.00GiB   (70%)
Evictable Cache             178.31GiB   (24%)

6) echo 1 > /sys/fs/bcache/<cset>/internal/trigger_gc and waiting 1-2 
seconds will change cache usage to
Total Cache Used            742.94GiB   (100%)
Dirty Data                  0B  (0%)
Evictable Cache             742.94GiB   (100%)

7) Restarting fio will now show the full cache speed again. This is also 
possible if the dirty data was partially cleaned


Questions:
1) How is this state "write buffer depleted" detectable?  I can see it 
at the current fio write speed and the IO distribution. But bcache gives 
me no indication for this. I would expect that 
stats_five_minute/*bypass* would show any number > 0, but all numbers 
are 0. cache_mode still shows writeback
2) Dirty Data shows only 70%, what is about the other 30%?
3) Evictable Cache means for me that this cache could be use released 
for other purposes. Why is that remaining part not used for "dirty data"?
4) Triggering trigger_gc helps to free the cache for write buffering 
again. It's part of internal/. Is it okay to call this function and 
advisable? And when should I call this? Is the garbage collection not 
supposed to called automatically?
5) The only indication for calling trigger_gc I see is that 
sum(backingdevice.dirty_data) < cache.dirty_data falls below some 
threshold is
6) Is there a setting to prefer write buffering over read caching?
7) any other comments?
8) Small configuration question. Discard is not possible, as the HW RAID 
is not TRIM-capable. Are there any drawbacks if I reduce the bucket_size 
to 64k to match the chunk size and set the block size to 8kb to match 
the SSD page size? Or is 128k for the bucket_size preferable to match 
the stripe size?

Thanks for this great software and thanks in advance for any replies

Christoph Nelles
