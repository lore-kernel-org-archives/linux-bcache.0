From: John Hendrikx <hjohn@xs4all.nl>
Subject: bcache: readahead option seems to prevent cache being filled
Date: Sat, 30 Sep 2017 17:35:30 +0200
Message-ID: <7cd019e6-e98f-9cca-99d8-367f825c6eae@xs4all.nl>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-bcache-owner@vger.kernel.org>
Received: from lb3-smtp-cloud9.xs4all.net ([194.109.24.30]:36270 "EHLO
        lb3-smtp-cloud9.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1751099AbdI3Pfe (ORCPT
        <rfc822;linux-bcache@vger.kernel.org>);
        Sat, 30 Sep 2017 11:35:34 -0400
Sender: linux-bcache-owner@vger.kernel.org
List-Id: linux-bcache@vger.kernel.org
To: linux-bcache@vger.kernel.org

I'm trying out bcache with a new use case.

I have a cache volume of 1350G and a backing raid array of 15TB.  The 
cache volume is a normal hard disk, not an SSD.  The goal is to prevent 
accesses to the raid array, allowing it to be kept in a spun down state. 
  My tests show that this indeed works.

I've set up the cache as write-through, disabled sequential cutoff and 
disabled read/write congestion by setting all of those to 0.

Here are some statistics:

--- bcache ---
Device                      /dev/bcache0 (251:0)
UUID                        4cc40843-962c-43b3-9fa2-a3b88f56c3d1
Block Size                  0.50KiB
Bucket Size                 512.00KiB
Congested?                  False
Read Congestion             0.0ms
Write Congestion            0.0ms
Total Cache Size            1.32TiB
Total Cache Used            256.50GiB   (19%)
Total Cache Unused          1.07TiB     (81%)
Dirty Data                  0B  (0%)
Evictable Cache             1.32TiB     (100%)
Replacement Policy          [lru] fifo random
Cache Mode                  [writethrough] writeback writearound none
Total Hits                  123136      (31%)
Total Misses                264135
Total Bypass Hits           2929        (100%)
Total Bypass Misses         0
Total Bypassed              11.40MiB (<-- before cutoff was set 0)

In the process of loading the cache with data, I've been accessing a few 
files (>20G+) to get them cached by hashing them with md5sum.  This 
works well when readahead=0.  The cache misses go up, total cache used 
goes up, etc. exactly what you would expect.  Resumming them again later 
results in all cache hits --> excellent.

However, when I set readahead to 1.0M, suddenly bcache is claiming that 
all reads I'm doing (of files I'm 100% sure are not in the cache yet) 
are cache *hits*, and total cache used stays the same.  However, even 
though bcache claims all reads are hits, I can see the backing device 
getting accessed... hardly hits then?  What's worse, it is not adding 
the data to the cache anymore.

As soon as I disable the readahead again by setting it to 0 (without 
even stopping the md5sum process), cache misses go up again and the 
total cache used value goes up as well.

Perhaps I'm misunderstanding what readahead does?  Or perhaps it is 
acting differently when the cache device is not an SSD?

--John
