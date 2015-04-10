From: arnaud gaboury <arnaud.gaboury@gmail.com>
Subject: Re: Bcache on btrfs: the perfect setup or the perfect storm?
Date: Fri, 10 Apr 2015 16:42:24 +0200
Message-ID: <CAK1hC9t85qM+DACbwWKFwM-7sO3eyBD6jRrYfg658pyKAwRscQ@mail.gmail.com>
References: <CAK1hC9v9ADdguR+frFPix02U2u-+fuJgaV-cJi0F55fOfeECtg@mail.gmail.com>
	<55257b31.0308c20a.75a0.7849@mx.google.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-bcache-owner@vger.kernel.org>
Received: from mail-la0-f46.google.com ([209.85.215.46]:34149 "EHLO
	mail-la0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932414AbbDJOmZ (ORCPT
	<rfc822;linux-bcache@vger.kernel.org>);
	Fri, 10 Apr 2015 10:42:25 -0400
Received: by laat2 with SMTP id t2so14866784laa.1
        for <linux-bcache@vger.kernel.org>; Fri, 10 Apr 2015 07:42:24 -0700 (PDT)
In-Reply-To: <55257b31.0308c20a.75a0.7849@mx.google.com>
Sender: linux-bcache-owner@vger.kernel.org
List-Id: linux-bcache@vger.kernel.org
To: Kai Krakow <kai@kaishome.de>
Cc: linux-bcache@vger.kernel.org

On Wed, Apr 8, 2015 at 9:02 PM, Kai Krakow <kai@kaishome.de> wrote:
> arnaud gaboury <arnaud.gaboury@gmail.com> schrieb:
>
>> I plan to setup Bcache on  Btrfs SSD/HD caching/backing device. The
>> box will be a server, but not a production one.
>>
>> I know this scheme is not recommended and can be a cause of filesystem
>> corruption. But as I like living on the edge, I want to give a try,
>> with a tight backup policy.
>>
>> Any advice? Any settings that could be worth to avoid future drama?
>
> See my recommendations about partitioning here I just posted:
> http://permalink.gmane.org/gmane.linux.kernel.bcache.devel/2865
>
> Take care of the warnings about trimming/enabling discard. I'd at least test
> it if you want to use it before trusting your kitty to it. ;-)
>
> BTW: I'm planning on a similar system tho the plans may well be 1 or 2 years
> in the future and the system is planned to be based off bcache/btrfs. It
> should become a production container-VM host. We'll see. Fallback plan is to
> use a battery-backed RAID controller with CacheCade (SSDs as volume cache).


>
> --
> Replies to list only preferred.

Thank you.
Here is what I did to prevent any drama:

the caching device, a SSD:
- GPT partitions.

-------------------------------------------------------
# gisk /dev/sdd
Command: p
Disk /dev/sdb: 224674128 sectors, 107.1 GiB
Logical sector size: 512 bytes
Disk identifier (GUID): EAAC52BC-8236-483F-9875-744AF7031E72
Partition table holds up to 128 entries
First usable sector is 34, last usable sector is 224674094
Partitions will be aligned on 2048-sector boundaries
Total free space is 2014 sectors (1007.0 KiB)

Number  Start (sector)    End (sector)  Size       Code  Name
   1            2048       167774207   80.0 GiB    8300  poppy-root
   2       167774208       224674094   27.1 GiB    8300  poppy-cache
---------------------------------------------------------------------------------------

Then :

# make-bcache --wipe-bcache --block 4k --bucket 2M -B /dev/sdd4 -C
/dev/sdb2 --discard

Now, when referring to your post, I have no idea about:
 Fourth - wear-levelling reservation.

Shall I change my partition table for /dev/sdd2 and leave some space?

Below are some infos about the SSD:

-----------------------------------------------------------------------------------------
# hdparm -I /dev/sdb

/dev/sdb:

ATA device, with non-removable media
Model Number:       OCZ-VERTEX2 3.5
Serial Number:      OCZ-52181PZL67XEETUZ
Firmware Revision:  1.33
Transport:          Serial
Standards:
Used: unknown (minor revision code 0x0028)
Supported: 8 7 6 5
Likely used: 8
Configuration:
Logical max current
cylinders 16383 16383
heads 16 16
sectors/track 63 63
--
CHS current addressable sectors:   16514064
LBA    user addressable sectors:  224674128
LBA48  user addressable sectors:  224674128
Logical  Sector size:                   512 bytes
Physical Sector size:                   512 bytes
Logical Sector-0 offset:                  0 bytes
device size with M = 1024*1024:      109704 MBytes
device size with M = 1000*1000:      115033 MBytes (115 GB)
cache/buffer size  = unknown
Nominal Media Rotation Rate: Solid State Device
Capabilities:
LBA, IORDY(can be disabled)
Queue depth: 32
Standby timer values: spec'd by Standard, no device specific minimum
R/W multiple sector transfer: Max = 16 Current = 16
DMA: mdma0 mdma1 mdma2 udma0 udma1 udma2 udma3 udma4 udma5 *udma6
    Cycle time: min=120ns recommended=120ns
PIO: pio0 pio1 pio2 pio3 pio4
    Cycle time: no flow control=120ns  IORDY flow control=120ns
-------------------------------------------------------------------------------------------------

-- 

google.com/+arnaudgabourygabx
