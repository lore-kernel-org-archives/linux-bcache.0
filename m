From: FERNANDO FREDIANI <fernando.frediani@upx.com>
Subject: Re: Add Bcache to an existing Filesystem
Date: Mon, 26 Jun 2017 15:14:42 -0300
Message-ID: <864cf409-86ca-dbe1-c6bc-89667a978f44@upx.com>
References: <46fc48b2-55db-471f-8318-5e60555e228e@upx.com>
 <CAPmG0jZyiA-3xbjoQFRP4X9Xkra6aOsbojK8HJqAALdycPkajQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-bcache-owner@vger.kernel.org>
Received: from mail-qt0-f180.google.com ([209.85.216.180]:33007 "EHLO
        mail-qt0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751376AbdFZSOr (ORCPT
        <rfc822;linux-bcache@vger.kernel.org>);
        Mon, 26 Jun 2017 14:14:47 -0400
Received: by mail-qt0-f180.google.com with SMTP id r30so7817473qtc.0
        for <linux-bcache@vger.kernel.org>; Mon, 26 Jun 2017 11:14:47 -0700 (PDT)
In-Reply-To: <CAPmG0jZyiA-3xbjoQFRP4X9Xkra6aOsbojK8HJqAALdycPkajQ@mail.gmail.com>
Content-Language: en-US
Sender: linux-bcache-owner@vger.kernel.org
List-Id: linux-bcache@vger.kernel.org
To: Henk Slager <eye1tm@gmail.com>
Cc: linux-bcache@vger.kernel.org

Well, just a bit more detail of my scenario. This 8TB is a Linux RAID 10 
on the top of 4 x 4TB disks, therefore the filesystem is currently 
mounted in a /dev/md124 which is a ext4. The physical disks in turn have 
each a single partition with type "Linux RAID" and they apparently start 
on sector 2048 (see below on of these disks):

Disk /dev/sdd: 4000.8 GB, 4000787030016 bytes, 7814037168 sectors
Units = sectors of 1 * 512 = 512 bytes
Sector size (logical/physical): 512 bytes / 512 bytes
I/O size (minimum/optimal): 512 bytes / 512 bytes
Disk label type: gpt
#         Start          End    Size  Type            Name
  1         2048   7814037134    3.7T  Linux RAID

Fernando

On 26/06/2017 15:05, Henk Slager wrote:
> On Mon, Jun 26, 2017 at 6:12 PM, FERNANDO FREDIANI
> <fernando.frediani@upx.com> wrote:
>> Hello folks.
>>
>> I have been using Bcache in a server in production with pretty good results
>> so far.
>>
>> Now I am looking to add it also to another server that is suffering from
>> disk I/O. However this server in question has a fairly large storage running
>> (circa 8TB of used data) and therefore stopping it for a long period becomes
>> difficult.
>>
>> Question is: Can I add an SSD and Bcache to this server and use it for the
>> existing 8TB filesystem ? If so when I run make-bcache -B /dev/sdx1 to
>> create the backing device will it not overwrite what is currently on
>> /dev/sdx1 ?
> Yes you can if you are prepared to do some re-partition tricks. Maybe
> there is a tool/script that can do that, AFAIK there is some python
> prog called blocks for this.
>
> Anyhow, what make-bcache -B /dev/sdx1 does is write an 8KiB sized
> header at the start of /dev/sdx1. So in case this is the only GPT
> based partition on the diskdevice that currently starts at
> 512-byte-sized sector 2048, there is usually some free space between
> GPT table and 2048. So make sure you have all backupped, then unmount
> the fs and use gdisk to set the starting sector of /dev/sdx1 to 2032,
> by delete first and re-create (with alignment set to 16 sectors
> first).
>
> Then make sure the kernel uses the new partition table (partprobe or
> reboot) and run make-bcache -C <SSD> -B /dev/sdx1. You can now access
> the fs via /dev/bcache0
>
> Some people might consider this way too risky, but I have successfully
> used it, also in reverse order for removal of bcache. You might have a
> slighty different disk setup than I assume, but I hope th eprinciple
> is clear. If you would script it, it takes about the time of an
> unmount+mount, so seconds instead of hours or even days.
