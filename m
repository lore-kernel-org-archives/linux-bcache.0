From: Stefan Priebe - Profihost AG <s.priebe@profihost.ag>
Subject: Re: ont out of 6 bcache devices does not register automatically
Date: Wed, 22 Nov 2017 13:26:45 +0100
Message-ID: <5c8958c1-acfd-14c9-d29f-0726ca92bc1c@profihost.ag>
References: <3ebfa7f8-cef6-ca8f-a56f-14a6bafd5bc6@profihost.ag>
 <22a61b57-1fbf-5ec4-383c-13b2cb8eaaf2@coly.li>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-bcache-owner@vger.kernel.org>
Received: from cloud1-vm154.de-nserver.de ([178.250.10.56]:54616 "EHLO
        cloud1-vm154.de-nserver.de" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1752358AbdKVM0r (ORCPT
        <rfc822;linux-bcache@vger.kernel.org>);
        Wed, 22 Nov 2017 07:26:47 -0500
In-Reply-To: <22a61b57-1fbf-5ec4-383c-13b2cb8eaaf2@coly.li>
Content-Language: de-DE
Sender: linux-bcache-owner@vger.kernel.org
List-Id: linux-bcache@vger.kernel.org
To: Coly Li <i@coly.li>, "linux-bcache@vger.kernel.org" <linux-bcache@vger.kernel.org>


Am 22.11.2017 um 13:16 schrieb Coly Li:
> On 22/11/2017 7:23 PM, Stefan Priebe - Profihost AG wrote:
>> Hello,
>>
>> i've 6 bcache blk devices attached to 3 caching ssds (2 each). One fails
>> to register automatically at boot time.
>>
>> After reboot i always need to execute:
>> echo /dev/sdf1 >/sys/fs/bcache/register
>>
>> to bring up the bcache device.
>>
>> Any idea?
> 
> Hi Stefan,
> 
> Is there any clue from kernel message ?

Sadly not.

Working one:
]# dmesg | grep sdi
[    1.060377] sd 5:0:0:0: [sdi] 1953525168 512-byte logical blocks:
(1.00 TB/932 GiB)
[    1.060393] sd 5:0:0:0: [sdi] Write Protect is off
[    1.060396] sd 5:0:0:0: [sdi] Mode Sense: 00 3a 00 00
[    1.060425] sd 5:0:0:0: [sdi] Write cache: enabled, read cache:
enabled, doesn't support DPO or FUA
[    1.104341]  sdi: sdi1
[    1.104644] sd 5:0:0:0: [sdi] Attached SCSI disk
[    2.005452] bcache: register_bdev() registered backing device sdi1
[    2.045211] bcache: bch_cached_dev_attach() Caching sdi1 as bcache0
on set 76b95bf8-9cc7-407f-9f9e-a42b6d1bcb27


not working one:
# dmesg | grep sdf
[    0.946107] sd 0:0:5:0: [sdf] 1953525168 512-byte logical blocks:
(1.00 TB/932 GiB)
[    1.400267] sd 0:0:5:0: [sdf] Write Protect is off
[    1.400267] sd 0:0:5:0: [sdf] Mode Sense: 00 00 00 00
[    1.401347] sd 0:0:5:0: [sdf] Write cache: enabled, read cache:
enabled, supports DPO and FUA
[    1.902910]  sdf: sdf1
[    2.341289] sd 0:0:5:0: [sdf] Attached SCSI disk
[  295.458804] bcache: register_bdev() registered backing device sdf1
[  295.506656] bcache: bch_cached_dev_attach() Caching sdf1 as bcache5
on set 76b95bf8-9cc7-407f-9f9e-a42b6d1bcb27

At 295s i registeeed it manually.

Greets,
Stefan

> 
> Thanks.
> 
> Coly Li
> 
>> Register happens through the following udev file:
>> # register bcache devices as they come up
>> # man 7 udev for syntax
>>
>> SUBSYSTEM!="block", GOTO="bcache_end"
>> ACTION=="remove", GOTO="bcache_end"
>>
>> # blkid was run by the standard udev rules
>> # It recognised bcache (util-linux 2.24+)
>> ENV{ID_FS_TYPE}=="bcache", GOTO="bcache_backing_found"
>> # It recognised something else; bail
>> ENV{ID_FS_TYPE}=="?*", GOTO="bcache_backing_end"
>>
>> # Backing devices: scan, symlink, register
>> IMPORT{program}="probe-bcache -o udev $tempnode"
>> ENV{ID_FS_TYPE}!="bcache", GOTO="bcache_backing_end"
>> ENV{ID_FS_UUID_ENC}=="?*", SYMLINK+="disk/by-uuid/$env{ID_FS_UUID_ENC}"
>>
>> LABEL="bcache_backing_found"
>> RUN+="bcache-register $tempnode"
>> LABEL="bcache_backing_end"
>>
>> # Cached devices: symlink
>> DRIVER=="bcache", ENV{CACHED_UUID}=="?*", \
>>         SYMLINK+="bcache/by-uuid/$env{CACHED_UUID}"
>> DRIVER=="bcache", ENV{CACHED_LABEL}=="?*", \
>>         SYMLINK+="bcache/by-label/$env{CACHED_LABEL}"
>>
>> LABEL="bcache_end"
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-bcache" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>>
> 
> 
