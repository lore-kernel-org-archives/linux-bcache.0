From: Kai Krakow <hurikhan77@gmail.com>
Subject: Re: Improving the performance of my secondary HDD
Date: Sun, 15 Mar 2015 21:15:51 +0100
Message-ID: <ns5htb-vkb.ln1@hurikhan77.spdns.de>
References: <CAJ5s_igfWQCUfzJ11OC-8uJ_DUc5s95sHYTfKN9Pp6L4LKrp6g@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7Bit
Return-path: <linux-bcache-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:52298 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751262AbbCOUQC (ORCPT <rfc822;linux-bcache@vger.kernel.org>);
	Sun, 15 Mar 2015 16:16:02 -0400
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <glbd-linux-bcache@m.gmane.org>)
	id 1YXEx2-0003ds-HZ
	for linux-bcache@vger.kernel.org; Sun, 15 Mar 2015 21:15:56 +0100
Received: from ip18864262.dynamic.kabel-deutschland.de ([24.134.66.98])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-bcache@vger.kernel.org>; Sun, 15 Mar 2015 21:15:56 +0100
Received: from hurikhan77 by ip18864262.dynamic.kabel-deutschland.de with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-bcache@vger.kernel.org>; Sun, 15 Mar 2015 21:15:56 +0100
Sender: linux-bcache-owner@vger.kernel.org
List-Id: linux-bcache@vger.kernel.org
To: linux-bcache@vger.kernel.org

Sameer Naik <sameer.subscriptions@damagehead.com> schrieb:

> Recently I purchased an SSD and started using bcache to speed up my
> secondary HDD. My entire linux installation and home directory is
> setup on the SSD and I have set aside a 20GB partition for bcache.
> 
> My secondary storage has multiple partitions all of which are setup as
> backing devices and are used to store various types of file,
> virtualbox disk images, etc. which are seldom accessed.
> 
> I would like to know if bcache would really be effective in my setup,
> say for example to speed up the virtual machines since the HDD
> partitions are being cached using bcache? Considering that my virtual
> machine image sizes would be between 8 - 16 GB, would I need to
> perform some level of tuning to achieve a noticeable performance
> improvement.

Bcache speeds up random accesses where SSDs excel at. You do not need to 
worry about fitting a whole VM inside of bcache. Sequential access goes to 
HDD and can run in parallel with SSD accesses. That means, only when HDD 
access would be slow, it goes through the SSD and uses cache space, and if 
your SSD becomes saturated (and latencies grow), it falls back to passing 
data directly to HDD. It may be worth noting that defragmenting VMs may make 
sense, as it may make sense to mark the VM images as running on SSD (at 
least in VirtualBox that is a setting per image in the machine settings). 
The speedups for VMs is noticable but not magic. Native Linux file accesses 
gain much more performance from bcache setups.

> Lastly, should I be noticing a marked improvement in the HDD write
> operations or would I need to turn on "write back" mode?

If you have many random access write patterns or a lot of data that was 
written may be read later, it should make a noticable difference. And write 
back mode seems to be very stable - I didn't have any problem with it yet 
although I had some hard reboots. Just a dying SSD could become a huge PITA.

I suggest to leave some spare space unpartitioned in the SSD to keep high 
performance and long health, because with unused (and trimmed) space around 
the wear levelling can perform much better. Your SSD probably already has 
some spare space for this hidden from you - like 120GB vs 128GB, or 240GB 
vs. 256GB. I'd recommend going with around 15-20% from the full SSD size 
(read: calculate from 128 or 256 GB or whatever size it internally has) - at 
least if you expect to write much data. That means, for a 256GB SSD (which 
announces 240GB) you partition only around 210GB.

In case you are interested in some numbers: I'm running my rootfs through 
bcache on btrfs, and boot to full desktop has dropped from around >90s 
(30-45s in systemd) down to maybe 20s (5-8s in systemd). I'm using write-
back mode, however. At least it shows: Bcache can be very effective.

VM boot times (Windows 7 in VirtualBox) has dropped to something around 
20-30s with responsive desktop. It hasn't been much slower before (maybe 
30-35s) but it took much longer before the desktop became responsive. So you 
should see improvement there, too. 

-- 
Replies to list only preferred.
