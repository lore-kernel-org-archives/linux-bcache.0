From: =?UTF-8?Q?Erik_Hjelm=C3=A5s?= <erik.hjelmas@gmail.com>
Subject: Performance issues (XFS-bcache-P400-S3700)
Date: Sat, 8 Nov 2014 07:18:35 +0100
Message-ID: <CAPgH3iFKnFs-96VRQ0VVLNmO9WHwdcv0QVrKsC6aDotkp4m+ag@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-bcache-owner@vger.kernel.org>
Received: from mail-ie0-f179.google.com ([209.85.223.179]:52275 "EHLO
	mail-ie0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753125AbaKHGSg (ORCPT
	<rfc822;linux-bcache@vger.kernel.org>);
	Sat, 8 Nov 2014 01:18:36 -0500
Received: by mail-ie0-f179.google.com with SMTP id rl12so6579203iec.38
        for <linux-bcache@vger.kernel.org>; Fri, 07 Nov 2014 22:18:36 -0800 (PST)
Sender: linux-bcache-owner@vger.kernel.org
List-Id: linux-bcache@vger.kernel.org
To: linux-bcache <linux-bcache@vger.kernel.org>

Hi, I have a HP 380 G5 server (with P400 raid controller without battery
backup so not using write cache) where c0d0 is Intel S3500 SSD, c0d1 is Intel
S3700 SSD and c0d2 is a slow RAID5 array:

root@storage01:~# fdisk -l /dev/cciss/c0d{0,1,2} | grep 'Disk /dev'
Disk /dev/cciss/c0d0: 80.0 GB, 79990456320 bytes
Disk /dev/cciss/c0d1: 100.0 GB, 99994337280 bytes
Disk /dev/cciss/c0d2: 2500.4 GB, 2500371439616 bytes

c0d1 is the caching device and c0d2 is the backing device, and everything
seems to look ok. Ive enabled drive write caches (since SSD's performance
depend on it), running ubuntu 14.04 upgraded today (in case my problem was
the uninterruptable sleep status of bcache_writebac, but it wasn't), and
Ive mounted XFS with nobarrier since I also read something about that:

root@storage01:~# mount | grep bcache
/dev/bcache0 on /brick0 type xfs (rw,nobarrier)

status of bcache seems ok:

root@storage01:~# dmesg | grep bcac
[    7.453145] bcache: bch_journal_replay() journal replay done, 1017
keys in 462 entries, seq 76745658
[    7.523539] bcache: register_cache() registered cache device cciss/c0d1
[    7.561245] bcache: register_bdev() registered backing device cciss/c0d2
[    7.684531] bcache: bch_cached_dev_attach() Caching cciss/c0d2 as
bcache0 on set 6c7ad3b1-388e-47df-904a-94da0a092669
[    8.781182] XFS (bcache0): Mounting Filesystem
[    8.980111] XFS (bcache0): Ending clean mount
root@storage01:~# cat /sys/block/bcache0/bcache/writeback_running
1
root@storage01:~# cat /sys/block/bcache0/bcache/cache_mode
writethrough [writeback] writearound none
root@storage01:~# cat /sys/block/bcache0/bcache/dirty_data
9.3G
root@storage01:~# cat /sys/block/bcache0/bcache/sequential_cutoff
4.0M
root@storage01:~# cat /sys/block/bcache0/bcache/state
dirty
root@storage01:~# cat /sys/block/bcache0/bcache/writeback_rate_debug
rate:           512/sec
dirty:          9.2G
target:         9.3G
proportional:   -20.5k
derivative:     0
change:         -20.5k/sec
next io:        482ms

Unfortunately performance is not very good (random write IOPS is about 200
when I would expect it to be about 5000-10000):

(the fio.bash script I run is available at
http://www.ansatt.hig.no/erikh/sysadm/fio.bash)

root@storage01:~# ./fio.bash /brick0/tmp/
Baseline reads with hdparm
 /dev/bcache0:
  Timing cached reads:   5870 MB in  2.00 seconds = 2936.42 MB/sec
  Timing buffered disk reads: 252 MB in  3.01 seconds =  83.83 MB/sec
Sequential read
  read : io=359784KB, bw=35622KB/s, iops=8905, runt= 10100msec
Sequential write
  write: io=18508KB, bw=1745.8KB/s, iops=436, runt= 10602msec
Random read
  read : io=43716KB, bw=4244.3KB/s, iops=1061, runt= 10300msec
Random write
  write: io=10288KB, bw=883208B/s, iops=215, runt= 11928msec
Mixed 70/30 random read and write with 8K block size
  read : io=23272KB, bw=2128.2KB/s, iops=266, runt= 10936msec
  write: io=10376KB, bw=971564B/s, iops=118, runt= 10936msec

If I run the same test on the root filesystem on c0d0 (which is EXT4-LVM on
Intel S3500 SSD, and the S3500 is supposed to have much worse random write
performance compared to the much more expensive S3700 which my bcache uses)
random write performance (and in general) is 50x better:

root@storage01:~# ./fio.bash /root/
Baseline reads with hdparm
 /dev/mapper/storage01--vg-root:
  Timing cached reads:   6370 MB in  2.00 seconds = 3186.45 MB/sec
  Timing buffered disk reads: 392 MB in  3.00 seconds = 130.66 MB/sec
Sequential read
  read : io=490832KB, bw=48985KB/s, iops=12246, runt= 10020msec
Sequential write
  write: io=492388KB, bw=49180KB/s, iops=12294, runt= 10012msec
Random read
  read : io=262656KB, bw=26203KB/s, iops=6550, runt= 10024msec
Random write
  write: io=498980KB, bw=49848KB/s, iops=12462, runt= 10010msec
Mixed 70/30 random read and write with 8K block size
  read : io=288480KB, bw=28773KB/s, iops=3596, runt= 10026msec
  write: io=121216KB, bw=12090KB/s, iops=1511, runt= 10026msec

When I have IOPS-numbers around 200 that sounds very much like spinning
drives, but my setup is as far as I can tell correct with a Intel S3700
high performance SSD as caching device on c0d1, so I can't make sense of
this.

any help greatly appreciated :)

/Erik
