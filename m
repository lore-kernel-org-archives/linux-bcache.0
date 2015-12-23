From: "Jens-U. Mozdzen" <jmozdzen@nde.ag>
Subject: Re: dynamically resizing bcache devices
Date: Wed, 23 Dec 2015 01:33:30 +0100
Message-ID: <20151223013330.Horde.hu4x2elBBw4DL-1d0S3qSot@www3.nde.ag>
References: <20151222124044.Horde.yBZenQERTNZN7P0HR3WeoI_@www3.nde.ag>
 <CAO2mnoyLrO9_GonWXmEpsPGVnKsfY-fs4QDBi-soo5eoQ2GycQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed; DelSp=Yes
Return-path: <linux-bcache-owner@vger.kernel.org>
Received: from mo4-p05-ob.smtp.rzone.de ([81.169.146.180]:20886 "EHLO
	mo4-p05-ob.smtp.rzone.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932320AbbLWAde (ORCPT
	<rfc822;linux-bcache@vger.kernel.org>);
	Tue, 22 Dec 2015 19:33:34 -0500
In-Reply-To: <CAO2mnoyLrO9_GonWXmEpsPGVnKsfY-fs4QDBi-soo5eoQ2GycQ@mail.gmail.com>
Content-Disposition: inline
Sender: linux-bcache-owner@vger.kernel.org
List-Id: linux-bcache@vger.kernel.org
To: Denis Bychkov <manover@gmail.com>
Cc: linux-bcache@vger.kernel.org

Hi Denis,

Zitat von Denis Bychkov <manover@gmail.com>:
> Why is it so important to grow the backing device online, without even
> re-registering it? It should it be enough to unmount whatever FS is on
> top of it, unregister the device and register it again to "resize" it.
> (Or reboot the system for that matter). Is there really a pressuring
> need to do it on the fly?

from a professional standpoint, rebooting a SAN server just to have  
some subsystem recognize the increase in available space is a huge  
step backwards. As a matter of fact, in the chain of hardware - MDRAID  
- bcache - LVM - FS - NFS / SMB / SCST, bcache is the only component  
that requires to take the service offline (by umount / reboot). Yes,  
there is such a need.

> On Tue, Dec 22, 2015 at 6:40 AM, Jens-U. Mozdzen <jmozdzen@nde.ag> wrote:
>> Hi,
>>
>> an earlier, similar question went by unanswered, so let me give it another
>> try:
>>
>> I have set up a bcache device on top of DMRAID devices for cache and backing
>> device.
>>
>> While I can dynamically resize both RAIDs, the bcache device will not catch
>> up with the changes "live". This conforms to what Kent wrote in 2012
>> (http://comments.gmane.org/gmane.linux.kernel.bcache.devel/249):
>>
>> --- cut here ---
>> For the backing device, I think things will just work - you'll just
>> have to close and reopen the backing device in order for bcache to
>> notice the new size. Bcache's superblock doesn't remember the size, it
>> just goes off of what the size of the backing device is when it's
>> registered.
>>
>> There's currently no way to make bcache notice the backing device has
>> grown to do it at runtime, though that ought to be fairly simple too.
>> --- cut here ---
>>
>> If this currently is still not implemented, has anyone started to work on
>> some "resizebcache" tool, if only handling the backing device?
>>
>> Regards,
>> Jens
