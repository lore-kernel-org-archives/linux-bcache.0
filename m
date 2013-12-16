From: Jakub Witkowski <skylynx@wp.pl>
Subject: Re: register_bcache() error opening /dev/md2: bad block/bucket size
Date: Mon, 16 Dec 2013 01:39:45 +0100
Message-ID: <52AE4BD1.3080001@wp.pl>
References: <20131130033736.GF5195@bender.unx.csupomona.edu> <000401ceefb5$f0aa6160$d1ff2420$@acm.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-bcache-owner@vger.kernel.org>
Received: from mx3.wp.pl ([212.77.101.7]:51615 "EHLO mx3.wp.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751825Ab3LPAj7 (ORCPT <rfc822;linux-bcache@vger.kernel.org>);
	Sun, 15 Dec 2013 19:39:59 -0500
In-Reply-To: <000401ceefb5$f0aa6160$d1ff2420$@acm.org>
Sender: linux-bcache-owner@vger.kernel.org
List-Id: linux-bcache@vger.kernel.org
To: "Paul B. Henson" <henson@acm.org>
Cc: linux-bcache@vger.kernel.org

On 12/03/2013 12:26 AM, Paul B. Henson wrote:
> Haven't seen much traffic on the list, maybe everybody is still recovering
> from turkey comas (at least in the US ;) ).
>
> No thoughts on this issue? Am I misunderstanding the purpose of the -w
> argument, is it not intended to align with the SSD page size?

After deep digging in this area I would say that the problem is 
somewhere else. All internal stuff of Linux kernel has default memory 
page size of 4kB. That's way You can't use ext4 filesystem with 8kB 
block size on x86 which is related to memory page size (4kB). Linus in 
the mailing list said that using larger pages will be huge waste of 
memory so that way the didn't do it for now. Anyway I think that with 
this approach that is implemented in bcache it's not possible to use 
different size of block size larger than 4kB (smaller is not the issue). 
Maybe using different soft there is different approach so it is possible 
to use larger block but bcache I think I use this. The another problem 
is that SSD's manufacturers don't release information about some basic 
info about SSD like page size or nand erase block size (I spent long 
hours to get some information from forums but is not official info from 
manufacturers). So that way it's hard to say if SSD disk will wait for 
another 4kB of page and create 2x4kB = 8kB and write "full" page and how 
it will hit performance during reads and writes. Some controllers use 
compression during write so it's hard to get any info how is works.
Now I'm trying to get some info from SSD manufacturer of my SSD's disks 
(I also have disks that have 8kB page size) how disk will work with 
smaller size of page.

regards
Jakub Witkowski

>
>> -----Original Message-----
>> From: Paul Henson [mailto:paul.b.henson@gmail.com] On Behalf Of Paul B.
>> Henson
>> Sent: Friday, November 29, 2013 7:38 PM
>> To: linux-bcache@vger.kernel.org
>> Subject: register_bcache() error opening /dev/md2: bad block/bucket size
>>
>> I'm trying to set up a mirror of two Samsung 840 Pro 256GB SSDs as a
>> cache device. Per their specs, the page size is 8k, and the erase block
>> size is 1024k, so I created the cache device as:
>>
>> make-bcache --wipe-bcache -b 1024k -w 8k -C /dev/md2
>>
>> With a bucket size equal to the erase block, and a block size equal to
>> the page size. The documentation on block size wasn't really clear, but
>> I believe it's supposed to equal the ssd page size, ie, the minimum io
>> size for the device.
>>
>> However, when trying to register this cache device, it fails with:
>>
>> bcache: register_bcache() error opening /dev/md2: Bad block/bucket size
>>
>> Looking at the code:
>>
>>                  err = "Bad block/bucket size";
>>                  if (!is_power_of_2(sb->block_size) ||
>>                      sb->block_size > PAGE_SECTORS ||
>>                      !is_power_of_2(sb->bucket_size) ||
>>                      sb->bucket_size < PAGE_SECTORS)
>>                          goto err;
>>
>> and given PAGE_SIZE = 4096 and PAGE_SECTORS = 8, it's complaining that my
>> cache device block size of 8k is greater than the page size of 4k. I guess
>> I could create my cache device with a block size of 4k to make it work,
> but
>> that seems inefficient as it does not match the page size. What's this
>> limitation about? Can it be changed? Are SSD's with a > 4k page size just
>> poor choices for a cache device?
>>
>> Thanks...
>
>
