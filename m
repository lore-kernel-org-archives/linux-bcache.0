From: =?UTF-8?Q?Erik_Hjelm=C3=A5s?= <erik.hjelmas@gmail.com>
Subject: Re: Performance issues (XFS-bcache-P400-S3700)
Date: Sun, 9 Nov 2014 07:51:17 +0100
Message-ID: <CAPgH3iFpNSKXCy+ddJdENb03ywFjZMJexWcv1J_04jyN4q8Sew@mail.gmail.com>
References: <CAPgH3iFKnFs-96VRQ0VVLNmO9WHwdcv0QVrKsC6aDotkp4m+ag@mail.gmail.com>
	<20141108102337.GZ16293@teapot>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-bcache-owner@vger.kernel.org>
Received: from mail-ig0-f172.google.com ([209.85.213.172]:58548 "EHLO
	mail-ig0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751295AbaKIGvS convert rfc822-to-8bit (ORCPT
	<rfc822;linux-bcache@vger.kernel.org>);
	Sun, 9 Nov 2014 01:51:18 -0500
Received: by mail-ig0-f172.google.com with SMTP id a13so14952543igq.11
        for <linux-bcache@vger.kernel.org>; Sat, 08 Nov 2014 22:51:17 -0800 (PST)
In-Reply-To: <20141108102337.GZ16293@teapot>
Sender: linux-bcache-owner@vger.kernel.org
List-Id: linux-bcache@vger.kernel.org
To: Matthias Ferdinand <bcache@mfedv.net>
Cc: linux-bcache <linux-bcache@vger.kernel.org>

thanks Matthias, I just tried to upgrade to Ubunty 14.10 since it has
the 3.16 kernel and mentions bcache support in the release notes, but
didn't change anything,

I'll look into the change logs of of 3.17 and 3.18 to see if its worth
trying an even newer kernel

/Erik

2014-11-08 11:23 GMT+01:00 Matthias Ferdinand <bcache@mfedv.net>:
> Hi,
>
> sounds similar to the performance problems I had
> (http://comments.gmane.org/gmane.linux.kernel.bcache.devel/2542) with=
 an
> Intel 530 SSD. The SSD would perform great with linear io, but with
> random io it was great only for a short time and then slowing down. T=
he
> entire bcache+backing combo became slower than just the rotating disk=
s
> alone.
>
> In my case I found it to be the SSD, as performance was much better w=
hen
> I switched the caching device to rotating disk (!) on an old hardware
> raid-1 controller (w/128MB battery backed cache). In your case it sho=
uld
> be different as the S3700 seems to be an enterprise model.
>
> Also I do not use the 14.04 stock kernel, it was missing a lot of bca=
che
> patches, currently my system runs 3.18.0-rc2.
>
> I don't think the nobarrier option has something to do with it, as th=
e
> cache device will only see the random data + meta data updates of the
> underlying block device and that should still be an order of magnitud=
e
> faster than on the rotating disk.
>
> Regards
> Matthias
>
>
> On Sat, Nov 08, 2014 at 07:18:35AM +0100, Erik Hjelm=C3=A5s wrote:
>> Hi, I have a HP 380 G5 server (with P400 raid controller without bat=
tery
>> backup so not using write cache) where c0d0 is Intel S3500 SSD, c0d1=
 is Intel
>> S3700 SSD and c0d2 is a slow RAID5 array:
>>
>> root@storage01:~# fdisk -l /dev/cciss/c0d{0,1,2} | grep 'Disk /dev'
>> Disk /dev/cciss/c0d0: 80.0 GB, 79990456320 bytes
>> Disk /dev/cciss/c0d1: 100.0 GB, 99994337280 bytes
>> Disk /dev/cciss/c0d2: 2500.4 GB, 2500371439616 bytes
>>
>> c0d1 is the caching device and c0d2 is the backing device, and every=
thing
>> seems to look ok. Ive enabled drive write caches (since SSD's perfor=
mance
>> depend on it), running ubuntu 14.04 upgraded today (in case my probl=
em was
>> the uninterruptable sleep status of bcache_writebac, but it wasn't),=
 and
>> Ive mounted XFS with nobarrier since I also read something about tha=
t:
>>
>> root@storage01:~# mount | grep bcache
>> /dev/bcache0 on /brick0 type xfs (rw,nobarrier)
>>
>> status of bcache seems ok:
>>
>> root@storage01:~# dmesg | grep bcac
>> [    7.453145] bcache: bch_journal_replay() journal replay done, 101=
7
>> keys in 462 entries, seq 76745658
>> [    7.523539] bcache: register_cache() registered cache device ccis=
s/c0d1
>> [    7.561245] bcache: register_bdev() registered backing device cci=
ss/c0d2
>> [    7.684531] bcache: bch_cached_dev_attach() Caching cciss/c0d2 as
>> bcache0 on set 6c7ad3b1-388e-47df-904a-94da0a092669
>> [    8.781182] XFS (bcache0): Mounting Filesystem
>> [    8.980111] XFS (bcache0): Ending clean mount
>> root@storage01:~# cat /sys/block/bcache0/bcache/writeback_running
>> 1
>> root@storage01:~# cat /sys/block/bcache0/bcache/cache_mode
>> writethrough [writeback] writearound none
>> root@storage01:~# cat /sys/block/bcache0/bcache/dirty_data
>> 9.3G
>> root@storage01:~# cat /sys/block/bcache0/bcache/sequential_cutoff
>> 4.0M
>> root@storage01:~# cat /sys/block/bcache0/bcache/state
>> dirty
>> root@storage01:~# cat /sys/block/bcache0/bcache/writeback_rate_debug
>> rate:           512/sec
>> dirty:          9.2G
>> target:         9.3G
>> proportional:   -20.5k
>> derivative:     0
>> change:         -20.5k/sec
>> next io:        482ms
>>
>> Unfortunately performance is not very good (random write IOPS is abo=
ut 200
>> when I would expect it to be about 5000-10000):
>>
>> (the fio.bash script I run is available at
>> http://www.ansatt.hig.no/erikh/sysadm/fio.bash)
>>
>> root@storage01:~# ./fio.bash /brick0/tmp/
>> Baseline reads with hdparm
>>  /dev/bcache0:
>>   Timing cached reads:   5870 MB in  2.00 seconds =3D 2936.42 MB/sec
>>   Timing buffered disk reads: 252 MB in  3.01 seconds =3D  83.83 MB/=
sec
>> Sequential read
>>   read : io=3D359784KB, bw=3D35622KB/s, iops=3D8905, runt=3D 10100ms=
ec
>> Sequential write
>>   write: io=3D18508KB, bw=3D1745.8KB/s, iops=3D436, runt=3D 10602mse=
c
>> Random read
>>   read : io=3D43716KB, bw=3D4244.3KB/s, iops=3D1061, runt=3D 10300ms=
ec
>> Random write
>>   write: io=3D10288KB, bw=3D883208B/s, iops=3D215, runt=3D 11928msec
>> Mixed 70/30 random read and write with 8K block size
>>   read : io=3D23272KB, bw=3D2128.2KB/s, iops=3D266, runt=3D 10936mse=
c
>>   write: io=3D10376KB, bw=3D971564B/s, iops=3D118, runt=3D 10936msec
>>
>> If I run the same test on the root filesystem on c0d0 (which is EXT4=
-LVM on
>> Intel S3500 SSD, and the S3500 is supposed to have much worse random=
 write
>> performance compared to the much more expensive S3700 which my bcach=
e uses)
>> random write performance (and in general) is 50x better:
>>
>> root@storage01:~# ./fio.bash /root/
>> Baseline reads with hdparm
>>  /dev/mapper/storage01--vg-root:
>>   Timing cached reads:   6370 MB in  2.00 seconds =3D 3186.45 MB/sec
>>   Timing buffered disk reads: 392 MB in  3.00 seconds =3D 130.66 MB/=
sec
>> Sequential read
>>   read : io=3D490832KB, bw=3D48985KB/s, iops=3D12246, runt=3D 10020m=
sec
>> Sequential write
>>   write: io=3D492388KB, bw=3D49180KB/s, iops=3D12294, runt=3D 10012m=
sec
>> Random read
>>   read : io=3D262656KB, bw=3D26203KB/s, iops=3D6550, runt=3D 10024ms=
ec
>> Random write
>>   write: io=3D498980KB, bw=3D49848KB/s, iops=3D12462, runt=3D 10010m=
sec
>> Mixed 70/30 random read and write with 8K block size
>>   read : io=3D288480KB, bw=3D28773KB/s, iops=3D3596, runt=3D 10026ms=
ec
>>   write: io=3D121216KB, bw=3D12090KB/s, iops=3D1511, runt=3D 10026ms=
ec
>>
>> When I have IOPS-numbers around 200 that sounds very much like spinn=
ing
>> drives, but my setup is as far as I can tell correct with a Intel S3=
700
>> high performance SSD as caching device on c0d1, so I can't make sens=
e of
>> this.
>>
>> any help greatly appreciated :)
>>
>> /Erik
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-bcac=
he" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
