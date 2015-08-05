From: "Jens-U. Mozdzen" <jmozdzen@nde.ag>
Subject: Re: layering question.
Date: Wed, 05 Aug 2015 08:56:23 +0200
Message-ID: <20150805085623.Horde.YqOkb3jnfl5LjG9wNUI308t@www3.nde.ag>
References: <20150804190107.Horde.CuYUHXjE-ddVDzpxOLcbbPH@www3.nde.ag>
 <55C0F352.8080602@fsck.co.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed; DelSp=Yes
Return-path: <linux-bcache-owner@vger.kernel.org>
Received: from mo4-p05-ob.smtp.rzone.de ([81.169.146.183]:28182 "EHLO
	mo4-p05-ob.smtp.rzone.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751218AbbHEG4b (ORCPT
	<rfc822;linux-bcache@vger.kernel.org>);
	Wed, 5 Aug 2015 02:56:31 -0400
In-Reply-To: <55C0F352.8080602@fsck.co.uk>
Content-Disposition: inline
Sender: linux-bcache-owner@vger.kernel.org
List-Id: linux-bcache@vger.kernel.org
To: "A. James Lewis" <james@fsck.co.uk>
Cc: linux-bcache@vger.kernel.org

Hi James,

Zitat von "A. James Lewis" <james@fsck.co.uk>:
> Thanks for the details... to clarify, you are using raid1 for SSD  
> cache devices, and then creating a RAID6 MD device to act as backing  
> store?

yes - my two SSDs are RAID1 (I named it /dev/md/linux:san02-cache),  
seven 1TB disks are RAID6 (/dev/md/linux:san02-data), and these two  
were prepared using "make-bcache -C /dev/md/linux\:san02-cache -B  
/dev/md/linux\:san02-data" to create /dev/bcach0.

> What kernel are you using? You are having some stability issues, but  
> in principle it works?...  what is performance like?

Originally, I used the latest OpenSUSE 13.1 stable kernel  
(kernel-default-3.11.10-29.1), but seeing random reboots that seemed  
to match bugs fixed in later DRBD versions, the servers were updated  
to kernel-default-3.18.8-5.1.

Basically, the system works like a charm, we were enthusiastic with  
the first results. I don't have absolute numbers in terms of  
throughput, but since switching to bcache, or I/O waits dropped from  
"5 to 45 %" to "0 to 5%". The servers are mainly used to provide  
virtual disks for about virtual machines, which are running on a  
separate server farm connected via Fiber Channel. Additionally, the  
servers provide NFS access to various file system (among them the home  
directories of the local users and the working area for a distributed  
development environment). Add in a small amount of SMB traffic for a  
few MS-Win machines and you have the overall picture... mostly  
small-sized accesses, with plenty of reads and writes from various  
sources. Even with lots of memory caching, that mix did bring our  
servers to a user-noticable i/o load, which basically vanished when  
introducing bcache. Only large consecutive writes (i.e. ISOs) do go  
the disks directly and hence lead to measurable I/O waits... but  
that's rare and only turns up in monitoring, rather than "felt by  
users".

As I detailed in the other recent thread, when switching to 3.18.8 we  
suddenly were unable to create new file systems on one of the servers,  
mkfs reproducibly lead to a server reboot. Turning bcache to  
"writethrough" solved this, but made MD report disks in our backing  
device as failing, always in the context of what seemed to be hanging  
disk accesses, matching the "bcache locking problem" pattern. (I did  
apply the set of known patches from this mailing list.)

Since last Saturday, we're back to "writeback" and no more disks  
failed - but I haven't tried creating new file systems since, I'll  
have to wait for a maintenance window ;)

Just for completeness: We use /dev/bcache0 as the only "physical  
volume" to a LVM volume group, and create various logical volumes on  
top (both for local system use, and many that are used per NFS  
resource and per "Fiber Channel"-connected VM). The non-system LVs are  
mirrored to a separate machine via DRBD (which then will periodically  
break the link and backup the "snapshots" to external media) and the  
actual file systems (Ext4) are created based on these DRBD resources.

Regards,
Jens
