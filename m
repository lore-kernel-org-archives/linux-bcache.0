From: Denis Bychkov <manover@gmail.com>
Subject: Re: dynamically resizing bcache devices
Date: Wed, 23 Dec 2015 08:15:53 -0500
Message-ID: <CAO2mnowDF2MhHRLvHtag+Lv9_WdPnpRgKcZCCq==n9uWkdsDDg@mail.gmail.com>
References: <20151222124044.Horde.yBZenQERTNZN7P0HR3WeoI_@www3.nde.ag>
	<CAO2mnoyLrO9_GonWXmEpsPGVnKsfY-fs4QDBi-soo5eoQ2GycQ@mail.gmail.com>
	<20151223013330.Horde.hu4x2elBBw4DL-1d0S3qSot@www3.nde.ag>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-bcache-owner@vger.kernel.org>
Received: from mail-lf0-f52.google.com ([209.85.215.52]:33199 "EHLO
	mail-lf0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751382AbbLWNPz (ORCPT
	<rfc822;linux-bcache@vger.kernel.org>);
	Wed, 23 Dec 2015 08:15:55 -0500
Received: by mail-lf0-f52.google.com with SMTP id p203so148431584lfa.0
        for <linux-bcache@vger.kernel.org>; Wed, 23 Dec 2015 05:15:54 -0800 (PST)
In-Reply-To: <20151223013330.Horde.hu4x2elBBw4DL-1d0S3qSot@www3.nde.ag>
Sender: linux-bcache-owner@vger.kernel.org
List-Id: linux-bcache@vger.kernel.org
To: "Jens-U. Mozdzen" <jmozdzen@nde.ag>
Cc: linux-bcache@vger.kernel.org

On Tue, Dec 22, 2015 at 7:33 PM, Jens-U. Mozdzen <jmozdzen@nde.ag> wrote:
> Hi Denis,
>
> Zitat von Denis Bychkov <manover@gmail.com>:
>>
>> Why is it so important to grow the backing device online, without even
>> re-registering it? It should it be enough to unmount whatever FS is on
>> top of it, unregister the device and register it again to "resize" it.
>> (Or reboot the system for that matter). Is there really a pressuring
>> need to do it on the fly?
>
>
> from a professional standpoint, rebooting a SAN server just to have some
> subsystem recognize the increase in available space is a huge step
> backwards. As a matter of fact, in the chain of hardware - MDRAID - bcache -
> LVM - FS - NFS / SMB / SCST, bcache is the only component that requires to
> take the service offline (by umount / reboot). Yes, there is such a need.

Well, yeah, it's a philosophical question, I guess, I can always point
at Google's millions
arrays. In such a system it's not even easy to tell if a particular
array physically exists,
let alone guarantees to be up 24x7 and can go down any time without
notice or confirmation.
So, there could be different professional standpoints, depending on
your system architecture.
I can understand (although, not agree), how it may be important to
upgrade the system capacity
on the fly. Let me look at the code and maybe it's very easy to come
up with a patch for your needs.

>
>
>> On Tue, Dec 22, 2015 at 6:40 AM, Jens-U. Mozdzen <jmozdzen@nde.ag> wrote:
>>>
>>> Hi,
>>>
>>> an earlier, similar question went by unanswered, so let me give it
>>> another
>>> try:
>>>
>>> I have set up a bcache device on top of DMRAID devices for cache and
>>> backing
>>> device.
>>>
>>> While I can dynamically resize both RAIDs, the bcache device will not
>>> catch
>>> up with the changes "live". This conforms to what Kent wrote in 2012
>>> (http://comments.gmane.org/gmane.linux.kernel.bcache.devel/249):
>>>
>>> --- cut here ---
>>> For the backing device, I think things will just work - you'll just
>>> have to close and reopen the backing device in order for bcache to
>>> notice the new size. Bcache's superblock doesn't remember the size, it
>>> just goes off of what the size of the backing device is when it's
>>> registered.
>>>
>>> There's currently no way to make bcache notice the backing device has
>>> grown to do it at runtime, though that ought to be fairly simple too.
>>> --- cut here ---
>>>
>>> If this currently is still not implemented, has anyone started to work on
>>> some "resizebcache" tool, if only handling the backing device?
>>>
>>> Regards,
>>> Jens
>
>



-- 

Denis
