From: Stefan Priebe <s.priebe@profihost.ag>
Subject: Re: bcache cant register cache device "bad csum" & "bad magic"
Date: Sat, 15 Aug 2015 20:25:56 +0200
Message-ID: <55CF8434.20602@profihost.ag>
References: <CAOOKTyDfZ8-Zv4qj4zYj6hYsMzMryLtE6Lfvj5ZyCuE0d-XEhw@mail.gmail.com>
 <77CE39AF-AD1A-4F4D-94EB-7D199EC60C74@profihost.ag>
 <CAOOKTyA_3agb0jNpB8RumB+8iRX=BnmmhCj6tKM6kzYWAU0AVw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8;
	format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-bcache-owner@vger.kernel.org>
Received: from mail-ph.de-nserver.de ([85.158.179.214]:34426 "EHLO
	mail-ph.de-nserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752109AbbHOSZ5 (ORCPT
	<rfc822;linux-bcache@vger.kernel.org>);
	Sat, 15 Aug 2015 14:25:57 -0400
In-Reply-To: <CAOOKTyA_3agb0jNpB8RumB+8iRX=BnmmhCj6tKM6kzYWAU0AVw@mail.gmail.com>
Sender: linux-bcache-owner@vger.kernel.org
List-Id: linux-bcache@vger.kernel.org
To: =?UTF-8?B?0JPQtdC+0YDQs9C40Lkg0KHRgtCw0YDQuNC60L7Qsg==?= <gstarikov@gmail.com>
Cc: "linux-bcache@vger.kernel.org" <linux-bcache@vger.kernel.org>


Am 15.08.2015 um 20:24 schrieb =D0=93=D0=B5=D0=BE=D1=80=D0=B3=D0=B8=D0=B9=
 =D0=A1=D1=82=D0=B0=D1=80=D0=B8=D0=BA=D0=BE=D0=B2:
> how?
> as i see, discard is disabled...
>
> # cat /sys/block/sdc/bcache/discard
> 0
>
> # ./bcache-status -s | grep Discard
>    Discard?                  False

OK sorry. I've only seen exactly this issue after reboot with discard=20
enabled.

Sorry.

Stefan

>
>
> 2015-08-15 21:12 GMT+03:00 Stefan Priebe - Profihost AG <s.priebe@pro=
fihost.ag>:
>> Disable discard ;-) no fix available.
>>
>> Stefan
>>
>> Excuse my typo sent from my mobile phone.
>>
>> Am 15.08.2015 um 19:54 schrieb =D0=93=D0=B5=D0=BE=D1=80=D0=B3=D0=B8=D0=
=B9 =D0=A1=D1=82=D0=B0=D1=80=D0=B8=D0=BA=D0=BE=D0=B2 <gstarikov@gmail.c=
om>:
>>
>> Hi!
>> I lost bcache device after a reboot and dmesg contains the following=
:
>> [   26.991085] bcache: prio_read() bad csum reading priorities
>> [   26.991088] bcache: prio_read() bad magic reading priorities
>> [   26.991425] attempt to access beyond end of device
>> [   26.991428] sdc: rw=3D48, want=3D3405010361836132352, limit=3D468=
862128
>> [   26.991430] bcache: error on 4ca0fbc9-d20b-4a3d-bbd1-38d9a5810c27=
:
>> accessing                                            priorities,
>> disabling caching
>>
>> how to fix it?
>>
>> i am using the following fix (recreate cache device with the old cui=
d)
>> and it works till next reboot.
>>
>> # bcache-super-show /dev/sdc
>> sb.magic                ok
>> sb.first_sector         8 [match]
>> sb.csum                 F19B35ED4C357841 [match]
>> sb.version              3 [cache device]
>>
>> dev.label               (empty)
>> dev.uuid                7dddbf16-ca58-48e3-82d8-da47ae7726dc
>> dev.sectors_per_block   1
>> dev.sectors_per_bucket  1024
>> dev.cache.first_sector  1024
>> dev.cache.cache_sectors 468860928
>> dev.cache.total_sectors 468861952
>> dev.cache.ordered       yes
>> dev.cache.discard       no
>> dev.cache.pos           0
>> dev.cache.replacement   0 [lru]
>>
>> cset.uuid               4ca0fbc9-d20b-4a3d-bbd1-38d9a5810c27
>>
>> # make-bcache -C --cset-uuid 4ca0fbc9-d20b-4a3d-bbd1-38d9a5810c27 /d=
ev/sdc
>> Already a bcache device on /dev/sdc, overwrite with --wipe-bcache
>>
>> make-bcache -C --wipe-bcache --cset-uuid
>> 4ca0fbc9-d20b-4a3d-bbd1-38d9a5810c27 /dev/sdc
>> Device /dev/sdc already has a non-bcache superblock, remove it using
>> wipefs and wipefs -a
>>
>> # wipefs -a /dev/sdc
>>
>> # make-bcache -C --wipe-bcache --cset-uuid
>> 4ca0fbc9-d20b-4a3d-bbd1-38d9a5810c27 /dev/sdc
>> UUID:                   f7d97543-69ea-4636-a4ff-ab925ab5abdd
>> Set UUID:               4ca0fbc9-d20b-4a3d-bbd1-38d9a5810c27
>> version:                0
>> nbuckets:               457873
>> block_size:             1
>> bucket_size:            1024
>> nr_in_set:              1
>> nr_this_dev:            0
>> first_bucket:           1
>>
>> # echo /dev/sdc > /sys/fs/bcache/register
>>
>> dmesg:
>> [42999.742342] bcache: run_cache_set() invalidating existing data
>> [42999.900046] bcache: bch_cached_dev_attach() Caching md0 as bcache=
0
>> on set 4ca0fbc9-d20b-4a3d-bbd1-38d9a5810c27
>> [42999.900067] bcache: register_cache() registered cache device sdc
>> [43002.019693] EXT4-fs (bcache0): recovery complete
>> [43002.043362] EXT4-fs (bcache0): mounted filesystem with ordered da=
ta
>> mode. Opts: discard,errors=3Dremount-ro
>>
>> and final steps:
>> # echo writethrough > /sys/block/bcache0/bcache/cache_mode
>> # echo 128k > /sys/block/bcache0/bcache/sequential_cutoff
>>
>> # ./bcache-status -s
>> --- bcache ---
>> Device                      /dev/bcache0 (251:0)
>> UUID                        4ca0fbc9-d20b-4a3d-bbd1-38d9a5810c27
>> Block Size                  0.50KiB
>> Bucket Size                 512.00KiB
>> Congested?                  False
>> Read Congestion             2.0ms
>> Write Congestion            20.0ms
>> Total Cache Size            223.57GiB
>> Total Cache Used            2.24GiB     (0%)
>> Total Cache Unused          221.34GiB   (99%)
>> Dirty Data                  0B  (0%)
>> Evictable Cache             223.57GiB   (100%)
>> Replacement Policy          [lru] fifo random
>> Cache Mode                  [writethrough] writeback writearound non=
e
>> Total Hits                  139 (3%)
>> Total Misses                3816
>> Total Bypass Hits           0
>> Total Bypass Misses         0
>> Total Bypassed              0B
>> --- Backing Device ---
>>   Device                    /dev/md0 (9:0)
>>   Size                      5.46TiB
>>   Cache Mode                [writethrough] writeback writearound non=
e
>>   Readahead                 0
>>   Sequential Cutoff         128.00KiB
>>   Merge sequential?         False
>>   State                     clean
>>   Writeback?                True
>>   Dirty Data                0B
>>   Total Hits                139 (3%)
>>   Total Misses              3816
>>   Total Bypass Hits         0
>>   Total Bypass Misses       0
>>   Total Bypassed            0B
>> --- Cache Device ---
>>   Device                    /dev/sdc (8:32)
>>   Size                      223.57GiB
>>   Block Size                0.50KiB
>>   Bucket Size               512.00KiB
>>   Replacement Policy        [lru] fifo random
>>   Discard?                  False
>>   I/O Errors                0
>>   Metadata Written          1.60MiB
>>   Data Written              19.20MiB
>>   Buckets                   457873
>>   Cache Used                2.24GiB     (0%)
>>   Cache Unused              221.34GiB   (99%)
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-bcac=
he" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> --
> To unsubscribe from this list: send the line "unsubscribe linux-bcach=
e" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>
