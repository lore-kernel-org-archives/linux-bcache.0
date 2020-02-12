From: Postgarage Graz IT <it@postgarage.at>
Subject: reads no longer cached since kernel 4.19
Date: Wed, 12 Feb 2020 07:02:28 +0100
Message-ID: <98d03769-c58d-98dc-64aa-7d8fbf39ceea@postgarage.at>
References: <b039d510-9b03-e6a3-499a-1dbe72764cbe@postgarage.at>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-bcache-owner@vger.kernel.org>
Received: from cuba.postgarage.at ([148.251.14.253]:56898 "EHLO
        cuba.postgarage.at" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726448AbgBLGCg (ORCPT
        <rfc822;linux-bcache@vger.kernel.org>);
        Wed, 12 Feb 2020 01:02:36 -0500
Received: from localhost (localhost [127.0.0.1])
        by cuba.postgarage.at (Postfix) with ESMTP id BD0013A8145
        for <linux-bcache@vger.kernel.org>; Wed, 12 Feb 2020 07:02:31 +0100 (CET)
Received: from cuba.postgarage.at ([127.0.0.1])
        by localhost (cuba.postgarage.at [127.0.0.1]) (amavisd-new, port 10026)
        with ESMTP id DmBaxC5sJyBT for <linux-bcache@vger.kernel.org>;
        Wed, 12 Feb 2020 07:02:29 +0100 (CET)
Received: from [10.0.0.254] (c-82-150-210-9.dsl.hotze.com [82.150.210.9])
        by cuba.postgarage.at (Postfix) with ESMTPSA id CC2FA3A7FF1
        for <linux-bcache@vger.kernel.org>; Wed, 12 Feb 2020 07:02:28 +0100 (CET)
In-Reply-To: <b039d510-9b03-e6a3-499a-1dbe72764cbe@postgarage.at>
Content-Language: en-US
Sender: linux-bcache-owner@vger.kernel.org
List-Id: linux-bcache@vger.kernel.org
To: linux-bcache@vger.kernel.org

On 10.02.20 17:10, Ville Aakko wrote:
> Hi,
>=20
> A fellow user responding here.
>=20
> I've noticed similar behavior and have asked on this same mailing list
> previously. See:
> https://www.spinics.net/lists/linux-bcache/msg07859.html
>=20
> Also seems there are other users with this issue on the Arch Forum,
> where I have also started a discussion:
> https://bbs.archlinux.org/viewtopic.php?id=3D250525
> There is yet to be a single user to reply there (or on this mailing
> list) claiming they have a working setup (for caching reads).
>=20
> Judging from the Arch Linux thread, I have a hunch there were some
> changes ~4.18, which broke read caching for many (all?) desktop users
> (as anything which is flagged as readahed will not be cached, despite
> setting sequential_cutoff). Also (again from the Arch thread) a
> planned patch might enable expected read caching: "[PATCH 3/5] bcache:
> add readahead cache policy options via sysfs interface" / see:
> https://www.spinics.net/lists/linux-bcache/msg08074.html

Indeed that patch works.
Now I'm using the 5.6-rc1 kernel and the performance gain is huge.

I only wonder, why the used cache number doesn't go up anymore like it
did for pre-4.19 kernels.


Linux kkb 5.6.0-050600rc1-generic #202002092032 SMP Mon Feb 10 01:36:50
UTC 2020 x86_64 x86_64 x86_64 GNU/Linux

--- bcache ---
Device                      /dev/md0 (9:0)
UUID                        d4f0e4cd-c2dc-4cec-bf5b-96f1f87ff0b8
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
Total Hits                  0
Total Misses                0
Total Bypass Hits           0
Total Bypass Misses         0
Total Bypassed              0B

1st pass
0.00user 0.60system 0:08.66elapsed 6%CPU (0avgtext+0avgdata
2220maxresident)k
2097632inputs+0outputs (1major+115minor)pagefaults 0swaps

2nd pass
0.00user 0.47system 0:03.34elapsed 14%CPU (0avgtext+0avgdata
2216maxresident)k
2097128inputs+0outputs (1major+113minor)pagefaults 0swaps

3rd pass
0.00user 0.45system 0:02.58elapsed 17%CPU (0avgtext+0avgdata
2096maxresident)k
2097296inputs+0outputs (1major+110minor)pagefaults 0swaps
--- bcache ---
Device                      /dev/md0 (9:0)
UUID                        d4f0e4cd-c2dc-4cec-bf5b-96f1f87ff0b8
Block Size                  0.50KiB
Bucket Size                 512.00KiB
Congested?                  False
Read Congestion             0.0ms
Write Congestion            0.0ms
Total Cache Size            111.79GiB
Total Cache Used            1.12GiB	(0%)
Total Cache Unused          110.67GiB	(99%)
Evictable Cache             110.67GiB	(99%)
Replacement Policy          [lru] fifo random
Cache Mode                  writethrough [writeback] writearound none
Total Hits                  6352	(51%)
Total Misses                6075
Total Bypass Hits           0
Total Bypass Misses         0


As you can see, the reads must come from the SSD in the 2nd and 3rd
pass, still "Total Cache Used" stays the same.


>=20
> However this is highly speculative from someone not understanding file
> systems or insides of bcache or the code at all.
>=20
> Perhaps someone more involved can reply: is the current behavior
> expected (reads are not getting cached practically at all). Also, is
> the patch I've linked possibly going to fix the current issues?
>=20
> Kind Regards,
> Ville Aakko
>=20
>=20
>=20
> su 9. helmik. 2020 klo 23.37 Postgarage Graz IT (it@postgarage.at) kirj=
oitti:
>>
>> Hello!
>>
>> I noticed, that bcache is no longer caching reads on my system which
>> makes it behave like if there were only hdds.
>>
>> I'm using two hdds in a raid 1 as the backing device and a single ssd =
as
>> cache device:
>>
>> sda             8:0    0 111,8G  0 disk
>> =E2=94=94=E2=94=80bcache0     252:0    0 921,9G  0 disk  /
>> sdb             8:16   0 931,5G  0 disk
>> =E2=94=9C=E2=94=80sdb1          8:17   0   922G  0 part
>> =E2=94=82 =E2=94=94=E2=94=80md0         9:0    0 921,9G  0 raid1
>> =E2=94=82   =E2=94=94=E2=94=80bcache0 252:0    0 921,9G  0 disk  /
>> =E2=94=9C=E2=94=80sdb2          8:18   0     1K  0 part
>> =E2=94=9C=E2=94=80sdb5          8:21   0   1,9G  0 part
>> =E2=94=82 =E2=94=94=E2=94=80md1         9:1    0   1,9G  0 raid1 /boot
>> =E2=94=94=E2=94=80sdb6          8:22   0   7,6G  0 part  [SWAP]
>> sdc             8:32   0 931,5G  0 disk
>> =E2=94=9C=E2=94=80sdc1          8:33   0   922G  0 part
>> =E2=94=82 =E2=94=94=E2=94=80md0         9:0    0 921,9G  0 raid1
>> =E2=94=82   =E2=94=94=E2=94=80bcache0 252:0    0 921,9G  0 disk  /
>> =E2=94=9C=E2=94=80sdc2          8:34   0     1K  0 part
>> =E2=94=9C=E2=94=80sdc5          8:37   0   1,9G  0 part
>> =E2=94=82 =E2=94=94=E2=94=80md1         9:1    0   1,9G  0 raid1 /boot
>> =E2=94=94=E2=94=80sdc6          8:38   0   7,6G  0 part  [SWAP]
>>
>>
>> For benchmarking every time I detach the cache device, stop the bcache
>> device, do a wipefs on the cache device, then make-bcache -C /dev/sda
>> and finally reattach the cache.
>> After that, I'm using the following script to repeatedly read a 1gb fi=
le:
>>
>> #!/bin/sh
>> echo 0 > /sys/block/bcache0/bcache/sequential_cutoff
>> echo 0 > /sys/block/bcache0/bcache/cache/congested_read_threshold_us
>> echo 0 > /sys/block/bcache0/bcache/cache/congested_write_threshold_us
>> uname -a
>> echo
>> bcache-status
>> echo
>> echo "1st pass"
>> sync; echo 3 > /proc/sys/vm/drop_caches
>> (time cat 1GB.bin > /dev/null)
>> echo
>> echo "2nd pass"
>> sync; echo 3 > /proc/sys/vm/drop_caches
>> (time cat 1GB.bin > /dev/null)
>> echo
>> echo "3rd pass"
>> sync; echo 3 > /proc/sys/vm/drop_caches
>> (time cat 1GB.bin > /dev/null)
>> bcache-status
>>
>>
>>
>> As you can see from the results below, kernel 4.18.20 is the last
>> kernel, where the cache grows and the performance goes up.
>>
>> I also compiled 4.19.0 with the bcache files from 4.18.20 and much to =
my
>> suprise, that didn't change 4.19's behavior - still no caching. So som=
e
>> other changes must be the culprit or I did something wrong.
>> I'm not that much into compiling the kernel, but I checked out the
>> 4.19.0 and 4.18.20 commits and replaced the 4.19.0 drivers/md/bcache
>> directory with the one from 4.18.20 - then recompiled and installed th=
e
>> new kernel.
>>
>> So i am at my wits end. Any help would be appreciated.
>> Thanks
>> Flo
>>
>>
>> Linux kkb 4.18.20-041820-generic #201812030624 SMP Mon Dec 3 11:25:55
>> UTC 2018 x86_64 x86_64 x86_64 GNU/Linux
>>
>> --- bcache ---
>> Device                      /dev/md0 (9:0)
>> UUID                        8275bf01-f0b3-423e-87fa-48336ce33068
>> Block Size                  0.50KiB
>> Bucket Size                 512.00KiB
>> Congested?                  False
>> Read Congestion             0.0ms
>> Write Congestion            0.0ms
>> Total Cache Size            111.79GiB
>> Total Cache Used            1.12GiB     (0%)
>> Total Cache Unused          110.67GiB   (99%)
>> Evictable Cache             111.79GiB   (100%)
>> Replacement Policy          [lru] fifo random
>> Cache Mode                  writethrough [writeback] writearound none
>> Total Hits                  0   (0%)
>> Total Misses                6
>> Total Bypass Hits           0
>> Total Bypass Misses         0
>> Total Bypassed              0B
>>
>> 1st pass
>> 0.00user 0.36system 0:08.58elapsed 4%CPU (0avgtext+0avgdata
>> 2196maxresident)k
>> 2097608inputs+0outputs (1major+113minor)pagefaults 0swaps
>>
>> 2nd pass
>> 0.00user 0.32system 0:03.29elapsed 9%CPU (0avgtext+0avgdata
>> 2100maxresident)k
>> 2097184inputs+0outputs (1major+110minor)pagefaults 0swaps
>>
>> 3rd pass
>> 0.00user 0.32system 0:02.64elapsed 12%CPU (0avgtext+0avgdata
>> 2092maxresident)k
>> 2097280inputs+0outputs (1major+111minor)pagefaults 0swaps
>> --- bcache ---
>> Device                      /dev/md0 (9:0)
>> UUID                        8275bf01-f0b3-423e-87fa-48336ce33068
>> Block Size                  0.50KiB
>> Bucket Size                 512.00KiB
>> Congested?                  False
>> Read Congestion             0.0ms
>> Write Congestion            0.0ms
>> Total Cache Size            111.79GiB
>> Total Cache Used            2.24GiB     (2%)
>> Total Cache Unused          109.55GiB   (98%)
>> Evictable Cache             110.67GiB   (99%)
>> Replacement Policy          [lru] fifo random
>> Cache Mode                  writethrough [writeback] writearound none
>> Total Hits                  5   (0%)
>> Total Misses                4079
>> Total Bypass Hits           0   (0%)
>> Total Bypass Misses         615
>> Total Bypassed              2.40MiB
>>
>>
>>
>> Linux kkb 4.19.0-041900-generic #201810221809 SMP Mon Oct 22 22:11:45
>> UTC 2018 x86_64 x86_64 x86_64 GNU/Linux
>>
>> --- bcache ---
>> Device                      /dev/md0 (9:0)
>> UUID                        67269654-92e8-4c3b-a524-8e8910082146
>> Block Size                  0.50KiB
>> Bucket Size                 512.00KiB
>> Congested?                  False
>> Read Congestion             0.0ms
>> Write Congestion            0.0ms
>> Total Cache Size            111.79GiB
>> Total Cache Used            1.12GiB     (0%)
>> Total Cache Unused          110.67GiB   (99%)
>> Evictable Cache             111.79GiB   (100%)
>> Replacement Policy          [lru] fifo random
>> Cache Mode                  writethrough [writeback] writearound none
>> Total Hits                  0   (0%)
>> Total Misses                1
>> Total Bypass Hits           0
>> Total Bypass Misses         0
>> Total Bypassed              0B
>>
>> 1st pass
>> 0.00user 0.33system 0:09.29elapsed 3%CPU (0avgtext+0avgdata
>> 2280maxresident)k
>> 2097624inputs+0outputs (1major+113minor)pagefaults 0swaps
>>
>> 2nd pass
>> 0.00user 0.33system 0:08.47elapsed 4%CPU (0avgtext+0avgdata
>> 2248maxresident)k
>> 2097280inputs+0outputs (1major+111minor)pagefaults 0swaps
>>
>> 3rd pass
>> 0.00user 0.37system 0:10.46elapsed 3%CPU (0avgtext+0avgdata
>> 2220maxresident)k
>> 2097616inputs+0outputs (1major+114minor)pagefaults 0swaps
>> --- bcache ---
>> Device                      /dev/md0 (9:0)
>> UUID                        67269654-92e8-4c3b-a524-8e8910082146
>> Block Size                  0.50KiB
>> Bucket Size                 512.00KiB
>> Congested?                  False
>> Read Congestion             0.0ms
>> Write Congestion            0.0ms
>> Total Cache Size            111.79GiB
>> Total Cache Used            1.12GiB     (0%)
>> Total Cache Unused          110.67GiB   (99%)
>> Evictable Cache             111.79GiB   (100%)
>> Replacement Policy          [lru] fifo random
>> Cache Mode                  writethrough [writeback] writearound none
>> Total Hits                  132 (23%)
>> Total Misses                436
>> Total Bypass Hits           51  (0%)
>> Total Bypass Misses         17399
>> Total Bypassed              43.50MiB
>>
>>
>>
>>
>> Linux kkb 5.5.2-050502-generic #202002041931 SMP Tue Feb 4 19:33:15 UT=
C
>> 2020 x86_64 x86_64 x86_64 GNU/Linux
>>
>> --- bcache ---
>> Device                      /dev/md0 (9:0)
>> UUID                        38a8b675-e332-4076-b0cf-44e4be72c300
>> Block Size                  0.50KiB
>> Bucket Size                 512.00KiB
>> Congested?                  False
>> Read Congestion             0.0ms
>> Write Congestion            0.0ms
>> Total Cache Size            111.79GiB
>> Total Cache Used            1.12GiB     (0%)
>> Total Cache Unused          110.67GiB   (99%)
>> Evictable Cache             111.79GiB   (100%)
>> Replacement Policy          [lru] fifo random
>> Cache Mode                  writethrough [writeback] writearound none
>> Total Hits                  0   (0%)
>> Total Misses                1
>> Total Bypass Hits           0   (0%)
>> Total Bypass Misses         3
>> Total Bypassed              52.00KiB
>>
>> 1st pass
>> 0.00user 0.42system 0:09.21elapsed 4%CPU (0avgtext+0avgdata
>> 2216maxresident)k
>> 2097608inputs+0outputs (1major+112minor)pagefaults 0swaps
>>
>> 2nd pass
>> 0.00user 0.42system 0:09.62elapsed 4%CPU (0avgtext+0avgdata
>> 2248maxresident)k
>> 2097280inputs+0outputs (1major+112minor)pagefaults 0swaps
>>
>> 3rd pass
>> 0.00user 0.43system 0:08.75elapsed 5%CPU (0avgtext+0avgdata
>> 2220maxresident)k
>> 2097224inputs+0outputs (1major+114minor)pagefaults 0swaps
>> --- bcache ---
>> Device                      /dev/md0 (9:0)
>> UUID                        38a8b675-e332-4076-b0cf-44e4be72c300
>> Block Size                  0.50KiB
>> Bucket Size                 512.00KiB
>> Congested?                  False
>> Read Congestion             0.0ms
>> Write Congestion            0.0ms
>> Total Cache Size            111.79GiB
>> Total Cache Used            1.12GiB     (0%)
>> Total Cache Unused          110.67GiB   (99%)
>> Evictable Cache             111.79GiB   (100%)
>> Replacement Policy          [lru] fifo random
>> Cache Mode                  writethrough [writeback] writearound none
>> Total Hits                  121 (32%)
>> Total Misses                246
>> Total Bypass Hits           15  (0%)
>> Total Bypass Misses         12811
>> Total Bypassed              39.70MiB
>=20
>=20
>=20
> --
> --
> Ville Aakko - ville.aakko@gmail.com
>=20
