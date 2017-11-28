From: Stefan Priebe - Profihost AG <s.priebe@profihost.ag>
Subject: Re: ont out of 6 bcache devices does not register automatically
Date: Tue, 28 Nov 2017 10:36:57 +0100
Message-ID: <cb1cbbc1-194c-d583-07ed-9ff81777dace@profihost.ag>
References: <3ebfa7f8-cef6-ca8f-a56f-14a6bafd5bc6@profihost.ag>
 <22a61b57-1fbf-5ec4-383c-13b2cb8eaaf2@coly.li>
 <5c8958c1-acfd-14c9-d29f-0726ca92bc1c@profihost.ag>
 <58151524-1294-2c8a-42a0-a5f21886625d@coly.li>
 <6c624629-c528-fd92-420f-ea50c4e6e4c5@profihost.ag>
 <f6c02ce5-eeff-955f-53a6-0db07aaecd08@lyle.org>
 <eee65109-aa05-d639-e0fe-12259e726803@profihost.ag>
 <93a1e381-ea82-b5c0-444b-6bdd3062e7f0@profihost.ag>
 <73e9184b-c74b-fe92-bb87-a0b945931187@lyle.org>
 <91e9b95d-861e-13bb-2b61-5c010657c2af@profihost.ag>
 <864cbf6d-7e8d-7dd4-7417-3150fe019fd8@lyle.org>
 <3fde77da-e12f-7862-f3c5-2a3dad316b86@profihost.ag>
 <0387447a-cce1-4162-3458-03193e146732@lyle.org>
 <0ab9bd3f-f2ea-04d7-1416-941b3d93d410@profihost.ag>
 <e2acf9c9-9097-e24c-69dd-a56ec672f9ef@lyle.org>
 <e016c187-fb69-463b-8a1f-3c41fdec369a@profihost.ag>
 <03029ee8-2856-19a3-a44d-8fbdc3f27da4@profihost.ag>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-bcache-owner@vger.kernel.org>
Received: from cloud1-vm154.de-nserver.de ([178.250.10.56]:40314 "EHLO
        cloud1-vm154.de-nserver.de" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1751570AbdK1JhA (ORCPT
        <rfc822;linux-bcache@vger.kernel.org>);
        Tue, 28 Nov 2017 04:37:00 -0500
In-Reply-To: <03029ee8-2856-19a3-a44d-8fbdc3f27da4@profihost.ag>
Content-Language: de-DE
Sender: linux-bcache-owner@vger.kernel.org
List-Id: linux-bcache@vger.kernel.org
To: Michael Lyle <mlyle@lyle.org>, Coly Li <i@coly.li>
Cc: "linux-bcache@vger.kernel.org" <linux-bcache@vger.kernel.org>, n.fahldieck@profihost.ag

ping - nobody? Ideas?

Am 23.11.2017 um 08:10 schrieb Stefan Priebe - Profihost AG:
> Hello,
> 
> i got it...
> 
> first of all the same issue still applies to util-linux v2.31 which is
> the latest upstream version.
> 
> # ./blkid --version
> lt-blkid from util-linux 2.31  (libblkid 2.31.0, 19-Oct-2017)
> 
> # ./blkid -o udev -p /dev/sdf1
> ID_FS_AMBIVALENT=other:bcache other:xfs_external_log
> 
> The issue is somewhat different. The device is used for ceph which
> stores on on that Disk 4MB slices of VM block devices.
> 
> So we have:
> bcache => XFS on top => thousands of files containing VM images => XFS
> in those images
> 
> So the xfs_external_log superblock which is seen by blkid is in reality
> a superblock of a VM image inside a file which is saved in bcache.
> 
> This make even more sense as the system was bootable without any
> problems for the last few years without swapping a disk. But somewhat
> now a VM image file has exactly positioned it's superblock on a position
> blkid expects a superblock.
> 
> I see no way to solve it except for changing the udev rules file which
> comes with bcache-tools.
> 
> Instead of only checking:
> ENV{ID_FS_TYPE}=="bcache", GOTO="bcache_backing_found"
> 
> it also needs to check for:
> ID_FS_AMBIVALENT=other:bcache
> 
> Any opinions or suggestions?
> 
> Greets,
> Stefan
> 
> Am 22.11.2017 um 22:13 schrieb Stefan Priebe - Profihost AG:
>>
>> Am 22.11.2017 um 22:10 schrieb Michael Lyle:
>>> On 11/22/2017 01:07 PM, Stefan Priebe - Profihost AG wrote:
>>>> default debian jessie version:
>>>> # blkid -v
>>>> blkid from util-linux 2.25.2  (libblkid 2.25.0, 24-Oct-2014)
>>>
>>> OK, so it's ancient.
>>>
>>> One other thing that can get you-- if there was ever an xfs or other
>>> filesystem on this disk -without- bcache, then you created bcache & xfs
>>> on it without wipefs... the old superblock can still be hanging around
>>> and not having happened to been rewritten.
>>
>> no there shouldn't eb ever an xfs without it on disk - but i can't
>> guarantee that.
>>
>> To reproduce the isue you need the first 10MB of the disk.
>>
>> See below:
>>
>> Still ok:
>>
>> # dd if=/dev/sdf1 of=/tmp/8k bs=8M count=1
>> 1+0 records in
>> 1+0 records out
>> 8388608 bytes (8,4 MB) copied, 0,01318 s, 636 MB/s
>> # /sbin/blkid -o udev -p /tmp/8k
>> ID_FS_UUID=65811163-4ffc-4823-ad72-bae10ce85b63
>> ID_FS_UUID_ENC=65811163-4ffc-4823-ad72-bae10ce85b63
>> ID_FS_TYPE=bcache
>> ID_FS_USAGE=other
>>
>> not anymore:
>>
>> # dd if=/dev/sdf1 of=/tmp/8k bs=10M count=1
>> 1+0 records in
>> 1+0 records out
>> 10485760 bytes (10 MB) copied, 0,0115798 s, 906 MB/s
>> # /sbin/blkid -o udev -p /tmp/8k
>> ID_FS_AMBIVALENT=other:bcache other:xfs_external_log
>>
>> Stefan
>>
>>>
>>> Mike
>>>
>>>>
>>>>>
>>>>> Mike
>>>>> --
>>>>> To unsubscribe from this list: send the line "unsubscribe linux-bcache" in
>>>>> the body of a message to majordomo@vger.kernel.org
>>>>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>>>>>
>>>> --
>>>> To unsubscribe from this list: send the line "unsubscribe linux-bcache" in
>>>> the body of a message to majordomo@vger.kernel.org
>>>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>>>>
>>>
