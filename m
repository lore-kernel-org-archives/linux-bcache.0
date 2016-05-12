From: "Jens-U. Mozdzen" <jmozdzen@nde.ag>
Subject: Re: bcache_gc: BUG: soft lockup
Date: Thu, 12 May 2016 13:51:39 +0200
Message-ID: <20160512135139.Horde.hocaq550rxfiWkSip8HAIFE@www3.nde.ag>
References: <6ee4d38a0d4cfffc288f0ee527ea7d14@rcube.hebserv.net>
 <20160129115444.GA30565@c203.arch.suse.de>
 <1448626993.2877.112.camel@suse.de>
 <2f979d1d6e991272cebc8ff40a955c8a@rcube.hebserv.net>
 <1447419912.2616.19.camel@suse.de> <1447418245.2616.15.camel@suse.de>
 <648d9a0567372b10a3861eee8320328c@rcube.hebserv.net>
 <7d53afb3c7a34bb1022f0d9b6c079022@rcube.hebserv.net>
 <9c96132d5fce4a5a77b1b086f7c6095d@rcube.hebserv.net>
 <594053ea9538352f4f3e01b954c6080d@rcube.hebserv.net>
 <alpine.LRH.2.11.1511291738340.5445@mail.ewheeler.net>
 <df4137dc888a7058b4b6a290613bf890@rcube.hebserv.net>
 <b91ce8156337b782c82317d25b3228bd@rcube.hebserv.net>
 <alpine.LRH.2.11.1605101750050.22680@mx.ewheeler.net>
 <20160511113310.Horde.RDd2DNU6iws5IFalOeBLL89@www3.nde.ag>
 <alpine.LRH.2.11.1605111114190.22680@mx.ewheeler.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed; DelSp=Yes
Return-path: <linux-bcache-owner@vger.kernel.org>
Received: from mo4-p05-ob.smtp.rzone.de ([81.169.146.183]:14087 "EHLO
	mo4-p05-ob.smtp.rzone.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751743AbcELLvo (ORCPT
	<rfc822;linux-bcache@vger.kernel.org>);
	Thu, 12 May 2016 07:51:44 -0400
In-Reply-To: <alpine.LRH.2.11.1605111114190.22680@mx.ewheeler.net>
Content-Disposition: inline
Sender: linux-bcache-owner@vger.kernel.org
List-Id: linux-bcache@vger.kernel.org
To: Eric Wheeler <bcache@lists.ewheeler.net>
Cc: linux-bcache@vger.kernel.org

Hi Eric,

Zitat von Eric Wheeler <bcache@lists.ewheeler.net>:
> On Wed, 11 May 2016, Jens-U. Mozdzen wrote:
>
>> Hi *,
>>
>> Zitat von Eric Wheeler <bcache@lists.ewheeler.net>:
>> >[...]
>> >I think this is the first time I've heard of Ceph being used in a bcache
>> >stack on the list.  Are there any others out there with success?  If so,
>> >what kernel versions and disk stack configuration?
>>
>> After an extensive test period, we have just started a productive Ceph
>> environment on our bcache-based SAN servers:
>>
>> - MD-RAID6 (several SAS disks) as bcache backing device
>> - MD-RAID1 (two SAS SSDs) as bcache cache device, only for that  
>> single backing
>> device
>> - LVM on top of /dev/bcache0
>> - LVs, xfs-formatted, mounted at a convenient place, used by OSDs
>
> So no ceph here?

Ceph OSDs. This differs from the OP's situation in that the bcache  
device isn't given to Ceph directly. But IIRC, Ceph does the same  
(partition the device and put XFS file systems on these partitions).  
And as already pointed out, we (currently) don't use the single SSD  
for multiple backing stores for these systems (but do so on other  
devices with high i/o load).

I responded because you seemed to be asking for any stack setup  
involving bcache and Ceph.

> If you're using 4.4.y then you definitely need the patch from Ming Lei.
> [...]
> OTOH, 4.1 is rock solid.  As of 4.1.21 or so it has all of the bcache
> stability fixes to date.
> [...]
> Same as above I think.  When bcache writebacks in opt_io sized writes that
> exceed 256 bvecs then you run into issues.  It only does that if
> raid_partial_stripes_expensive=1 like raid5/6 when it tries to prevent
> re-writes to the same stride.

>> kernel on our SAN nodes is 4.1.13-5-default (64 bit)

As mentioned, we're currently on 4.1.13, so no need to worry for me.  
Thank you for clarifying!

Regards,
Jens
