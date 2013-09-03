From: Rolf Fokkens <rolf-6w2rdlBuEQTpMFipWq+H6g@public.gmane.org>
Subject: Re: [RFC] bcache-status
Date: Tue, 03 Sep 2013 22:46:37 +0200
Message-ID: <52264AAD.3050401@rolffokkens.nl>
References: <521A55D4.20908@rolffokkens.nl> <521A6B92.60001@rolffokkens.nl> <20130826163055.GB4780@blackbox.djwong.org> <521BBC3B.9010003@rolffokkens.nl> <20130829004646.GA3099@blackbox.djwong.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-bcache-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20130829004646.GA3099-yuuUpGxbzT9UbpRmUfBrXUB+6BGkLq7r@public.gmane.org>
Sender: linux-bcache-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Darrick J. Wong" <darrick.wong-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Cc: linux-bcache-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-bcache@vger.kernel.org

Hi,

bcache-status renders some weird output:

- "Total Cache Used" and "Total Cache Unused" don't always add up to 
"Total Cache Size"
- "Dirty Data" is -6 MB?

Seems like bugs to me. Details below.

Rolf

[root@localhost bcache]# bcache-status -s
--- bcache ---
UUID c318c0b2-0b69-4f66-a729-23b82a9d0e91
Block Size                  0.00KiB
Bucket Size                 512.00KiB
Congested?                  False
Read Congestion             2.0ms
Write Congestion            20.0ms
Total Cache Size            1.00GiB
Total Cache Used            20.00MiB    (1%)
Total Cache Unused          1.00GiB    (99%)
Dirty Data                  0B    (0%)
Evictable Cache             1.00GiB    (100%)
Replacement Policy          [lru] fifo random
Cache Mode                  [writethrough] writeback writearound none
Total Hits                  122    (100%)
Total Misses                0
Total Bypass Hits           0
Total Bypass Misses         0
Total Bypassed              0B
--- Backing Device ---
   Device File               /dev/sda3 (8:3)
   bcache Device File        /dev/bcache1 (252:1)
   Size                      7.00GiB
   Cache Mode                [writethrough] writeback writearound none
   Readahead                 0
   Sequential Cutoff         4.00MiB
   Merge sequential?         True
   State                     clean
   Writeback?                True
   Dirty Data                0B
   Total Hits                122    (100%)
   Total Misses              0
   Total Bypass Hits         0
   Total Bypass Misses       0
   Total Bypassed            0B
--- Cache Device ---
   Device File               /dev/sdb1 (8:17)
   Size                      1.00GiB
   Block Size                0.00KiB
   Bucket Size               512.00KiB
   Replacement Policy        [lru] fifo random
   Discard?                  False
   I/O Errors                0
   Metadata Written          1.00KiB
   Data Written              0B
   Buckets                   4094
   Cache Used                20.00MiB    (1%)
   Cache Unused              1.00GiB    (99%)
--- bcache ---
UUID d07cd9a1-6211-4bba-bc37-a8ba8858ef4d
Block Size                  0.00KiB
Bucket Size                 512.00KiB
Congested?                  False
Read Congestion             2.0ms
Write Congestion            20.0ms
Total Cache Size            1.00GiB
Total Cache Used            204.00MiB    (10%)
Total Cache Unused          1.00GiB    (90%)
Dirty Data                  0B    (0%)
Evictable Cache             1.00GiB    (100%)
Replacement Policy          [lru] fifo random
Cache Mode                  writethrough [writeback] writearound none
Total Hits                  1365    (81%)
Total Misses                318
Total Bypass Hits           3191    (100%)
Total Bypass Misses         0
Total Bypassed              46.00MiB
--- Backing Device ---
   Device File               /dev/sdc1 (8:33)
   bcache Device File        /dev/bcache0 (252:0)
   Size                      19.00GiB
   Cache Mode                writethrough [writeback] writearound none
   Readahead                 0
   Sequential Cutoff         0B
   Merge sequential?         True
   State                     dirty
   Writeback?                True
   Dirty Data                -6.00MiB
   Total Hits                1365    (81%)
   Total Misses              318
   Total Bypass Hits         3191    (100%)
   Total Bypass Misses       0
   Total Bypassed            46.00MiB
--- Cache Device ---
   Device File               /dev/sdd1 (8:49)
   Size                      1.00GiB
   Block Size                0.00KiB
   Bucket Size               512.00KiB
   Replacement Policy        [lru] fifo random
   Discard?                  False
   I/O Errors                0
   Metadata Written          281.00KiB
   Data Written              18.00MiB
   Buckets                   4094
   Cache Used                204.00MiB    (10%)
   Cache Unused              1.00GiB    (90%)
[root@localhost bcache]#
