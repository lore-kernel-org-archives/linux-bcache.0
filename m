From: Kai Krakow <hurikhan77@gmail.com>
Subject: Re: bcache fails after reboot if discard is enabled
Date: Sat, 11 Apr 2015 22:09:46 +0200
Message-ID: <albovb-v7m.ln1@hurikhan77.spdns.de>
References: <54A66945.6030403@profihost.ag> <54A66C44.6070505@profihost.ag> <54A819A0.9010501@rolffokkens.nl> <54A843BC.608@profihost.ag> <loom.20150105T010336-763@post.gmane.org> <tcfnqb-u59.ln1@hurikhan77.spdns.de> <CAPL5yKf4Tz1oUDNTEz20+CXh-UEeZaNBZCD9pevg47kGnWmDQQ@mail.gmail.com> <alpine.DEB.2.02.1504081115550.2587@ware.dreamhost.com> <55257303.8020008@profihost.ag> <alpine.DEB.2.02.1504081228581.2587@ware.dreamhost.com> <3ldgvb-het.ln1@hurikhan77.spdns.de> <CAPL5yKdH97vJaYZxdu9ZHhrmK0OOAvEqtAk3Efz2+TvtOBUShw@mail.gmail.com> <5a1mvb-6k.ln1@hurikhan77.spdns.de> <3k5mvb-c14.ln1@hurikhan77.spdns.de> <CAPL5yKdfdtwPOQM-edwNJPkQDoBR2Oyagb6JWRP+-26xQvxyKQ@mail.gmail.com> <CAPL5yKcGvjC7ubzdKNjCFX6ZLc+qrr-Q0BQCX6W0zbueTkndPg@mail.gmail.com> <bf0nvb-uvd.ln1@hurikhan77.spdns.de> <CAPL5yKfpk8+6Vw
 cUVcwJ9QxAZJQmqaa98spCyT7+LekkRvkeAw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7Bit
Return-path: <linux-bcache-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:60770 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755304AbbDKUJz (ORCPT <rfc822;linux-bcache@vger.kernel.org>);
	Sat, 11 Apr 2015 16:09:55 -0400
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <glbd-linux-bcache@m.gmane.org>)
	id 1Yh1iz-0003GN-6b
	for linux-bcache@vger.kernel.org; Sat, 11 Apr 2015 22:09:53 +0200
Received: from ip18864262.dynamic.kabel-deutschland.de ([24.134.66.98])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-bcache@vger.kernel.org>; Sat, 11 Apr 2015 22:09:53 +0200
Received: from hurikhan77 by ip18864262.dynamic.kabel-deutschland.de with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-bcache@vger.kernel.org>; Sat, 11 Apr 2015 22:09:53 +0200
Sender: linux-bcache-owner@vger.kernel.org
List-Id: linux-bcache@vger.kernel.org
To: linux-bcache@vger.kernel.org

Dan Merillat <dan.merillat@gmail.com> schrieb:

> On Sat, Apr 11, 2015 at 3:52 AM, Kai Krakow <hurikhan77@gmail.com> wrote:
>> Dan Merillat <dan.merillat@gmail.com> schrieb:
>>
>>> Looking through the kernel log, this may be related: I booted into
>>> 4.0-rc7, and attempted to run it there at first:
>>> Apr  7 12:54:08 fileserver kernel: [ 2028.533893] bcache-register:
>>> page allocation failure: order:8, mode:0x
>>> ... memory dump
>>> Apr  7 12:54:08 fileserver kernel: [ 2028.541396] bcache:
>>> register_cache() error opening sda4: cannot allocate memory
>>
>> Is your system under memory stress? Are you maybe using the huge memory
>> page allocation policy in your kernel? If yes, could you retry without or
>> at least set it to madvice mode?
> 
> No, it's right after bootup, nothing heavy running yet.  No idea why
> memory is already so fragmented - it's something to do with 4.0-rc7,
> since it never has had that problem on 3.18.

I'm thinking of the same: something new in 4.0-*. And it is early boot, so 
huge memory should make no difference. Yet, I had problems with it when it 
was configured - memory became heavily fragmented and swapping a very slow 
process. So I set it to madvice policy and had no problems since. Maybe 
worth a try, tho still I couldn't imagine why this became a problem in early 
boot then.

>>> Apr  7 12:55:29 fileserver kernel: [ 2109.303315] bcache:
>>> run_cache_set() invalidating existing data
>>> Apr  7 12:55:29 fileserver kernel: [ 2109.408255] bcache:
>>> bch_cached_dev_attach() Caching md127 as bcache0 on set
>>> 804d6906-fa80-40ac-9081-a71a4d595378
>>
>> Why is it on md? I thought you are not using intermediate layers like
>> LVM...
> 
> The backing device is MD, the cdev is directly on sda4

Ah okay...

>>> Apr  7 12:55:29 fileserver kernel: [ 2109.408443] bcache:
>>> register_cache() registered cache device sda4
>>> Apr  7 12:55:33 fileserver kernel: [ 2113.307687] bcache:
>>> bch_cached_dev_attach() Can't attach md127: already attached
>>
>> And why is it done twice? Something looks strange here... What is your
>> device layout?
> 
> 2100 seconds after boot?  That's me doing it manually to try to figure
> out why I can't access my filesystem.

Oh, I didn't get the time difference here.

>>> Apr  7 12:55:33 fileserver kernel: [ 2113.307747] bcache:
>>> __cached_dev_store() Can't attach 804d6906-fa80-40ac-9081-a71a4d595378
>>> Apr  7 12:55:33 fileserver kernel: [ 2113.307747] : cache set not found
>>
>> My first guess would be that two different caches overlap and try to
>> share the same device space. I had a similar problem after repartitioning
>> because I did not "wipefs" the device first.
> 
> I had to wipefs, it wouldn't let me create the bcache super until I did.

Yes same here. But that is not what I meant. Some years back I created btrfs 
on raw device, then decided to prefer partitioning, did that, and created 
btrfs inside that partition. The kernel (or udev) saw two btrfs now. Another 
user here reported the same problem when creating bcache first on raw 
device, then in a partition. The kernel saw two bcache devices, with one 
being broken. The fix was to kill the superblock signature that was still 
lingering around in the raw device. But it would have just been easier to 
wipefs in the first place before partitioning.

>> If you are using huge memory this may be an artifact of your initial
>> finding.
> 
> I'm not using it for anything, but it's configured.  It's never given
> this problem in 3.18, so something changed in 4.0.

Maybe want to try without huge memory option? Just to sort things out?

>>> So I rebooted to 4.0-rc7 again:
>>> Apr  7 19:36:23 fileserver kernel: [    2.145004] bcache:
>>> journal_read_bucket() 157: too big, 552 bytes, offset 2047
>>> Apr  7 19:36:23 fileserver kernel: [    2.154586] bcache: prio_read()
>>> bad csum reading priorities
>>> Apr  7 19:36:23 fileserver kernel: [    2.154643] bcache: prio_read()
>>> bad magic reading priorities
>>> Apr  7 19:36:23 fileserver kernel: [    2.158008] bcache: error on
>>> 804d6906-fa80-40ac-9081-a71a4d595378: bad btree header at bucket
>>> 65638, block 0, 0 keys, disabling caching
>>
>> Same here: If somehow two different caches overwrite each other, this
>> could explain the problem.
> 
> Possibly!  So wipefs wasn't good enough, I should have done a discard
> on the entire cdev
> to make sure?

See above... And I have another idea below:

>>> Apr  7 19:36:23 fileserver kernel: [    2.158408] bcache:
>>> cache_set_free() Cache set 804d6906-fa80-40ac-9081-a71a4d595378
>>> unregistered
>>> Apr  7 19:36:23 fileserver kernel: [    2.158468] bcache:
>>> register_cache() registered cache device sda4
>>>
>>> Apr  7 19:36:23 fileserver kernel: [    2.226581] md127: detected
>>> capacity change from 0 to 12001954234368
>>
>> I wonder where md127 comes from... Maybe bcache probing is running too
>> early and should run after md setup.
> 
> No, that's how udev works, it registers things as it finds them.  So
> on raw disks it finds
> the bcache cdev, and registers it.  Then it finds the raid signature
> and sets it up.  When the new md127 shows up, it finds the bdev
> signature and registers that.   Bog-standard setup, most people never
> look this closely at the startup.  I'd hope bcache wouldn't screw up
> if its pieces get registered in a different order.

I don't think that order is a problem. But I remember my md times back in 
kernel 2.2 when I used it to mirror two hard disks. The problem with md (and 
that's why I never again used it later and avoided it), at least at that 
time, was: Any software would see the same data through two devices: The md 
device and the underlying raw device. MD didn't hide it away the way bcache 
or lvm do it (by using a private superblock), it is simply dependent on a 
configuration file and some auto-detection through some partition signature. 
This is an artifact from the fact that you could easily migrate from single 
device to md raid device using md without backup/restore as outlined here:

http://tldp.org/HOWTO/Software-RAID-HOWTO-7.html

With this knowledge, I guess that bcache could probably detect its backing 
device signature twice - once through the underlying raw device and once 
through the md device. From your logs I'm not sure if they were complete 
enough to see that case. But to be sure I'd modify the udev rules to exclude 
the md parent devices from being run through probe-bcache. Otherwise all 
sorts of strange things may happen (like one process accessing the backing 
device through md, while bcache access it through the parent device - 
probably even on different mirror stripes).

It's your setup, but personally I'd avoid MD for that reason and go with 
lvm. MD is just not modern, neither appropriate for modern system setups. It 
should really be just there for legacy setups and migration paths.

I'm also not sure if MD is able to pass-through write barriers correctly 
which is needed to stay with consistent filesystems in case of 
crashes/reboots. Even LVM/device-mapper ignored them back some (more) kernel 
versions and I am not sure if they are respected for every target type as of 
now - why I always recommend to avoid them if not needed.

I could also imagine that ignoring write-barriers (not passing them down to 
the hardware while the filesystem driver expected it to work) and using 
discard may lead to filesystem corruption upon reboots or crashes.

-- 
Replies to list only preferred.
