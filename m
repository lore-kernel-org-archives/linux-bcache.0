From: "Jens-U. Mozdzen" <jmozdzen@nde.ag>
Subject: Re: layering question.
Date: Tue, 04 Aug 2015 19:01:07 +0200
Message-ID: <20150804190107.Horde.CuYUHXjE-ddVDzpxOLcbbPH@www3.nde.ag>
References: <55C0E63F.2030007@fsck.co.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed; DelSp=Yes
Return-path: <linux-bcache-owner@vger.kernel.org>
Received: from mo4-p05-ob.smtp.rzone.de ([81.169.146.181]:34435 "EHLO
	mo4-p05-ob.smtp.rzone.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752932AbbHDRBQ (ORCPT
	<rfc822;linux-bcache@vger.kernel.org>);
	Tue, 4 Aug 2015 13:01:16 -0400
In-Reply-To: <55C0E63F.2030007@fsck.co.uk>
Content-Disposition: inline
Sender: linux-bcache-owner@vger.kernel.org
List-Id: linux-bcache@vger.kernel.org
To: "A. James Lewis" <james@fsck.co.uk>
Cc: linux-bcache@vger.kernel.org

Hi James,

Zitat von "A. James Lewis" <james@fsck.co.uk>:
> Hi all...
>
> I've heard rumours that layering bcache with other block device  
> drivers might not be recommended... I wonder what the truth really  
> is... perhaps someone can advise.

to me it's more than rumors. We're facing severe difficulties (server  
reboots, disks marked faulty by MDRAID, hangs) in our layered setup:

- physical disks MD-RAID6 (data) plus two SSDs MD-RAID1 (cache)
- bcache
- LVM
- DRBD for many of the logical volumes (always primary, no fail-overs)
- ext4 fs
- NFS / Samba / SCST (fileio)

> I was planning to use 2 SSD's... combined with 4 large spinning  
> drives to create a large filesystem with BTRFS...  my questions are  
> as follows.
>
> 1. Is there a way to use 2 SSD's directly, or would it be OK to use  
> MD to stripe them?... then used the MD array as the cache device?

MD-RAID1 is what our current configuration looks like. We've also  
combined the spinning disks into a RAID6.

> 2. I would be using BTRFS, so would it be better to create 4  
> separate bcache devices each attached to the single cache device,  
> and then use BTRFS to raid 4 bcache devices... obviously this would  
> be more flexible, or would I need to make an MD raid of the 4  
> devices, and then use that to create a single bcache device and  
> build a BTRFS filesystem on top of that.

I have no btrfs experience, so I cannot answer that one. I went for a  
single data and cache device (via RAID) so I won't have to partition  
my SSDs - that would not have been scalable (we're planning to add  
plenty of physical disks over time, and to use many LVs/file systems).

> Also, there's talk about a pending on-disk cache format change some  
> time around 3.19, but no details... is this over with, or still  
> pending?

Someone else might want to help with that one as well?

Regards,
Jens
