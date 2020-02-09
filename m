From: Postgarage Graz IT <it@postgarage.at>
Subject: reads no longer cached since kernel 4.19
Date: Sun, 9 Feb 2020 22:31:05 +0100
Message-ID: <d2691cbb-0364-825c-4fd5-4ff8dc733644@postgarage.at>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-bcache-owner@vger.kernel.org>
Received: from cuba.postgarage.at ([148.251.14.253]:48077 "EHLO
        cuba.postgarage.at" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726626AbgBIVgr (ORCPT
        <rfc822;linux-bcache@vger.kernel.org>);
        Sun, 9 Feb 2020 16:36:47 -0500
Received: from localhost (localhost [127.0.0.1])
        by cuba.postgarage.at (Postfix) with ESMTP id 4E68B3463CC
        for <linux-bcache@vger.kernel.org>; Sun,  9 Feb 2020 22:31:08 +0100 (CET)
Received: from cuba.postgarage.at ([127.0.0.1])
        by localhost (cuba.postgarage.at [127.0.0.1]) (amavisd-new, port 10026)
        with ESMTP id zs-rUwK1WNdn for <linux-bcache@vger.kernel.org>;
        Sun,  9 Feb 2020 22:31:06 +0100 (CET)
Received: from [10.0.0.254] (c-82-150-210-9.dsl.hotze.com [82.150.210.9])
        by cuba.postgarage.at (Postfix) with ESMTPSA id F13A93462A8
        for <linux-bcache@vger.kernel.org>; Sun,  9 Feb 2020 22:31:05 +0100 (CET)
Content-Language: en-US
Sender: linux-bcache-owner@vger.kernel.org
List-Id: linux-bcache@vger.kernel.org
To: linux-bcache@vger.kernel.org

Hello!

I noticed, that bcache is no longer caching reads on my system which
makes it behave like if there were only hdds.

I'm using two hdds in a raid 1 as the backing device and a single ssd as
cache device:

sda             8:0    0 111,8G  0 disk
=E2=94=94=E2=94=80bcache0     252:0    0 921,9G  0 disk  /
sdb             8:16   0 931,5G  0 disk
=E2=94=9C=E2=94=80sdb1          8:17   0   922G  0 part
=E2=94=82 =E2=94=94=E2=94=80md0         9:0    0 921,9G  0 raid1
=E2=94=82   =E2=94=94=E2=94=80bcache0 252:0    0 921,9G  0 disk  /
=E2=94=9C=E2=94=80sdb2          8:18   0     1K  0 part
=E2=94=9C=E2=94=80sdb5          8:21   0   1,9G  0 part
=E2=94=82 =E2=94=94=E2=94=80md1         9:1    0   1,9G  0 raid1 /boot
=E2=94=94=E2=94=80sdb6          8:22   0   7,6G  0 part  [SWAP]
sdc             8:32   0 931,5G  0 disk
=E2=94=9C=E2=94=80sdc1          8:33   0   922G  0 part
=E2=94=82 =E2=94=94=E2=94=80md0         9:0    0 921,9G  0 raid1
=E2=94=82   =E2=94=94=E2=94=80bcache0 252:0    0 921,9G  0 disk  /
=E2=94=9C=E2=94=80sdc2          8:34   0     1K  0 part
=E2=94=9C=E2=94=80sdc5          8:37   0   1,9G  0 part
=E2=94=82 =E2=94=94=E2=94=80md1         9:1    0   1,9G  0 raid1 /boot
=E2=94=94=E2=94=80sdc6          8:38   0   7,6G  0 part  [SWAP]


For benchmarking every time I detach the cache device, stop the bcache
device, do a wipefs on the cache device, then make-bcache -C /dev/sda
and finally reattach the cache.
After that, I'm using the following script to repeatedly read a 1gb file:

#!/bin/sh
echo 0 > /sys/block/bcache0/bcache/sequential_cutoff
echo 0 > /sys/block/bcache0/bcache/cache/congested_read_threshold_us
echo 0 > /sys/block/bcache0/bcache/cache/congested_write_threshold_us
uname -a
echo
bcache-status
echo
echo "1st pass"
sync; echo 3 > /proc/sys/vm/drop_caches
(time cat 1GB.bin > /dev/null)
echo
echo "2nd pass"
sync; echo 3 > /proc/sys/vm/drop_caches
(time cat 1GB.bin > /dev/null)
echo
echo "3rd pass"
sync; echo 3 > /proc/sys/vm/drop_caches
(time cat 1GB.bin > /dev/null)
bcache-status



As you can see from the results below, kernel 4.18.20 is the last
kernel, where the cache grows and the performance goes up.

I also compiled 4.19.0 with the bcache files from 4.18.20 and much to my
suprise, that didn't change 4.19's behavior - still no caching. So some
other changes must be the culprit or I did something wrong.
I'm not that much into compiling the kernel, but I checked out the
4.19.0 and 4.18.20 commits and replaced the 4.19.0 drivers/md/bcache
directory with the one from 4.18.20 - then recompiled and installed the
new kernel.

So i am at my wits end. Any help would be appreciated.
Thanks
Flo


Linux kkb 4.18.20-041820-generic #201812030624 SMP Mon Dec 3 11:25:55
UTC 2018 x86_64 x86_64 x86_64 GNU/Linux

--- bcache ---
Device                      /dev/md0 (9:0)
UUID                        8275bf01-f0b3-423e-87fa-48336ce33068
Block Size                  0.50KiB
Bucket Size                 512.00KiB
Congested?                  False
Read Congestion             0.0ms
Write Congestion            0.0ms
Total Cache Size            111.79GiB
Total Cache Used            1.12GiB	(0%)
Total Cache Unused          110.67GiB	(99%)
Evictable Cache             111.79GiB	(100%)
Replacement Policy          [lru] fifo random
Cache Mode                  writethrough [writeback] writearound none
Total Hits                  0	(0%)
Total Misses                6
Total Bypass Hits           0
Total Bypass Misses         0
Total Bypassed              0B

1st pass
0.00user 0.36system 0:08.58elapsed 4%CPU (0avgtext+0avgdata
2196maxresident)k
2097608inputs+0outputs (1major+113minor)pagefaults 0swaps

2nd pass
0.00user 0.32system 0:03.29elapsed 9%CPU (0avgtext+0avgdata
2100maxresident)k
2097184inputs+0outputs (1major+110minor)pagefaults 0swaps

3rd pass
0.00user 0.32system 0:02.64elapsed 12%CPU (0avgtext+0avgdata
2092maxresident)k
2097280inputs+0outputs (1major+111minor)pagefaults 0swaps
--- bcache ---
Device                      /dev/md0 (9:0)
UUID                        8275bf01-f0b3-423e-87fa-48336ce33068
Block Size                  0.50KiB
Bucket Size                 512.00KiB
Congested?                  False
Read Congestion             0.0ms
Write Congestion            0.0ms
Total Cache Size            111.79GiB
Total Cache Used            2.24GiB	(2%)
Total Cache Unused          109.55GiB	(98%)
Evictable Cache             110.67GiB	(99%)
Replacement Policy          [lru] fifo random
Cache Mode                  writethrough [writeback] writearound none
Total Hits                  5	(0%)
Total Misses                4079
Total Bypass Hits           0	(0%)
Total Bypass Misses         615
Total Bypassed              2.40MiB



Linux kkb 4.19.0-041900-generic #201810221809 SMP Mon Oct 22 22:11:45
UTC 2018 x86_64 x86_64 x86_64 GNU/Linux

--- bcache ---
Device                      /dev/md0 (9:0)
UUID                        67269654-92e8-4c3b-a524-8e8910082146
Block Size                  0.50KiB
Bucket Size                 512.00KiB
Congested?                  False
Read Congestion             0.0ms
Write Congestion            0.0ms
Total Cache Size            111.79GiB
Total Cache Used            1.12GiB	(0%)
Total Cache Unused          110.67GiB	(99%)
Evictable Cache             111.79GiB	(100%)
Replacement Policy          [lru] fifo random
Cache Mode                  writethrough [writeback] writearound none
Total Hits                  0	(0%)
Total Misses                1
Total Bypass Hits           0
Total Bypass Misses         0
Total Bypassed              0B

1st pass
0.00user 0.33system 0:09.29elapsed 3%CPU (0avgtext+0avgdata
2280maxresident)k
2097624inputs+0outputs (1major+113minor)pagefaults 0swaps

2nd pass
0.00user 0.33system 0:08.47elapsed 4%CPU (0avgtext+0avgdata
2248maxresident)k
2097280inputs+0outputs (1major+111minor)pagefaults 0swaps

3rd pass
0.00user 0.37system 0:10.46elapsed 3%CPU (0avgtext+0avgdata
2220maxresident)k
2097616inputs+0outputs (1major+114minor)pagefaults 0swaps
--- bcache ---
Device                      /dev/md0 (9:0)
UUID                        67269654-92e8-4c3b-a524-8e8910082146
Block Size                  0.50KiB
Bucket Size                 512.00KiB
Congested?                  False
Read Congestion             0.0ms
Write Congestion            0.0ms
Total Cache Size            111.79GiB
Total Cache Used            1.12GiB	(0%)
Total Cache Unused          110.67GiB	(99%)
Evictable Cache             111.79GiB	(100%)
Replacement Policy          [lru] fifo random
Cache Mode                  writethrough [writeback] writearound none
Total Hits                  132	(23%)
Total Misses                436
Total Bypass Hits           51	(0%)
Total Bypass Misses         17399
Total Bypassed              43.50MiB




Linux kkb 5.5.2-050502-generic #202002041931 SMP Tue Feb 4 19:33:15 UTC
2020 x86_64 x86_64 x86_64 GNU/Linux

--- bcache ---
Device                      /dev/md0 (9:0)
UUID                        38a8b675-e332-4076-b0cf-44e4be72c300
Block Size                  0.50KiB
Bucket Size                 512.00KiB
Congested?                  False
Read Congestion             0.0ms
Write Congestion            0.0ms
Total Cache Size            111.79GiB
Total Cache Used            1.12GiB	(0%)
Total Cache Unused          110.67GiB	(99%)
Evictable Cache             111.79GiB	(100%)
Replacement Policy          [lru] fifo random
Cache Mode                  writethrough [writeback] writearound none
Total Hits                  0	(0%)
Total Misses                1
Total Bypass Hits           0	(0%)
Total Bypass Misses         3
Total Bypassed              52.00KiB

1st pass
0.00user 0.42system 0:09.21elapsed 4%CPU (0avgtext+0avgdata
2216maxresident)k
2097608inputs+0outputs (1major+112minor)pagefaults 0swaps

2nd pass
0.00user 0.42system 0:09.62elapsed 4%CPU (0avgtext+0avgdata
2248maxresident)k
2097280inputs+0outputs (1major+112minor)pagefaults 0swaps

3rd pass
0.00user 0.43system 0:08.75elapsed 5%CPU (0avgtext+0avgdata
2220maxresident)k
2097224inputs+0outputs (1major+114minor)pagefaults 0swaps
--- bcache ---
Device                      /dev/md0 (9:0)
UUID                        38a8b675-e332-4076-b0cf-44e4be72c300
Block Size                  0.50KiB
Bucket Size                 512.00KiB
Congested?                  False
Read Congestion             0.0ms
Write Congestion            0.0ms
Total Cache Size            111.79GiB
Total Cache Used            1.12GiB	(0%)
Total Cache Unused          110.67GiB	(99%)
Evictable Cache             111.79GiB	(100%)
Replacement Policy          [lru] fifo random
Cache Mode                  writethrough [writeback] writearound none
Total Hits                  121	(32%)
Total Misses                246
Total Bypass Hits           15	(0%)
Total Bypass Misses         12811
Total Bypassed              39.70MiB
