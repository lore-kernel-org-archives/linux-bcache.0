From: Kai Krakow <hurikhan77@gmail.com>
Subject: Re: bcache fails after reboot if discard is enabled
Date: Wed, 29 Apr 2015 21:57:19 +0200
Message-ID: <vlp71c-j63.ln1@hurikhan77.spdns.de>
References: <54A66945.6030403@profihost.ag> <54A66C44.6070505@profihost.ag> <54A819A0.9010501@rolffokkens.nl> <54A843BC.608@profihost.ag> <loom.20150105T010336-763@post.gmane.org> <tcfnqb-u59.ln1@hurikhan77.spdns.de> <CAPL5yKf4Tz1oUDNTEz20+CXh-UEeZaNBZCD9pevg47kGnWmDQQ@mail.gmail.com> <alpine.DEB.2.02.1504081115550.2587@ware.dreamhost.com> <55257303.8020008@profihost.ag> <alpine.DEB.2.02.1504081228581.2587@ware.dreamhost.com> <3ldgvb-het.ln1@hurikhan77.spdns.de> <CAPL5yKdH97vJaYZxdu9ZHhrmK0OOAvEqtAk3Efz2+TvtOBUShw@mail.gmail.com> <5a1mvb-6k.ln1@hurikhan77.spdns.de> <3k5mvb-c14.ln1@hurikhan77.spdns.de> <CAPL5yKdfdtwPOQM-edwNJPkQDoBR2Oyagb6JWRP+-26xQvxyKQ@mail.gmail.com> <CAPL5yKcGvjC7ubzdKNjCFX6ZLc+qrr-Q0BQCX6W0zbueTkndPg@mail.gmail.com> <bf0nvb-uvd.ln1@hurikhan77.spdns.de> <CAPL5yKfpk8+6Vw
 cUVcwJ9QxAZJQmqaa98spCyT7+LekkRvkeAw@mail.gmail.com> <albovb-v7m.ln1@hurikhan77.spdns.de> <CAPL5yKdFhQ+7wwfTj-8i6bm1RHGKZbMPNzEEt=rffKqeRQEn=w@mail.gmail.com> <CAPL5yKe63Q4mTkNqvVW1jYAsdU=ftS3eQS+RzhCpX1WxcXg3hQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7Bit
Return-path: <linux-bcache-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:42532 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750767AbbD2T5d (ORCPT <rfc822;linux-bcache@vger.kernel.org>);
	Wed, 29 Apr 2015 15:57:33 -0400
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <glbd-linux-bcache@m.gmane.org>)
	id 1YnY6q-0001u4-Hj
	for linux-bcache@vger.kernel.org; Wed, 29 Apr 2015 21:57:28 +0200
Received: from ip18864262.dynamic.kabel-deutschland.de ([24.134.66.98])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-bcache@vger.kernel.org>; Wed, 29 Apr 2015 21:57:28 +0200
Received: from hurikhan77 by ip18864262.dynamic.kabel-deutschland.de with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-bcache@vger.kernel.org>; Wed, 29 Apr 2015 21:57:28 +0200
Sender: linux-bcache-owner@vger.kernel.org
List-Id: linux-bcache@vger.kernel.org
To: linux-bcache@vger.kernel.org

Dan Merillat <dan.merillat@gmail.com> schrieb:

> Killed it again - enabled bcache discard, copied a few TB of data from
> the backup the the drive, rebooted, different error
> "bcache: bch_cached_dev_attach() Couldn't find uuid for <REDACTED> in set"
> 
> The exciting failure that required reboot this time was an infinite
> spin in bcache_writeback.
> 
> I'll give it another shot at narrowing down exactly what causes the
> failure before I give up on bcache entirely.

I wonder what is "wrong" with your setup... Using bcache with online discard 
works rock solid for me. So your access patterns either trigger a bug in 
your storage software stack (driver/md/bcache/fs) or in your hardware's 
firmware (bcache probably exposes very different access patterns from normal 
filesystem access).

I think the frustation level is already pretty high but given that you take 
either discard or bcache out of the stack and it works, I wonder what 
happens if you take maybe md out of the stack instead.

I also wonder if you could trigger the problem if you enable online discard 
on the fs only while using bcache. I have enabled discard for both bcache 
and the fs. I don't know how it would pass from the fs down the storage 
layer but at least I could enable it: it's announced to be supported by the 
virtual bcache block device.

Then, I'd also take chance to try a completely different SSD hardware which 
has proven to work, and use it for the same setup and see if it works then 
to rule the firmware out.

For the last part, I can say that a Crucial MX100 128GB works for me, tho I 
don't use md. I applied a firmware updates lately (MU02) which, from the 
Changelog, stated that it fixed NCQ TRIM commands (queued discards, but the 
kernel blacklisted queued discards for my model) and improved cable signal 
issues. I wonder if the kernel enabled NCQ TRIM for your drive and you could 
maybe blacklist your drive manually in the kernel source and see if "normal" 
TRIM command would work.

Could you maybe try libata.force=noncq or libata.force=X.YY:noncq? Since 
bcache is a huge, block sorting elevator, it shouldn't hurt too much.
 
> On Sun, Apr 12, 2015 at 1:56 AM, Dan Merillat <dan.merillat@gmail.com>
> wrote:
>> On Sat, Apr 11, 2015 at 4:09 PM, Kai Krakow <hurikhan77@gmail.com> wrote:
>>
>>> With this knowledge, I guess that bcache could probably detect its
>>> backing device signature twice - once through the underlying raw device
>>> and once through the md device. From your logs I'm not sure if they were
>>> complete
>>
>> It doesn't, the system is smarter than you think it is.
>>
>>> enough to see that case. But to be sure I'd modify the udev rules to
>>> exclude the md parent devices from being run through probe-bcache.
>>> Otherwise all sorts of strange things may happen (like one process
>>> accessing the backing device through md, while bcache access it through
>>> the parent device - probably even on different mirror stripes).
>>
>> This didn't occur, I copied all the lines pertaining to bcache but
>> skipped the superfluous ones.
>>
>>> It's your setup, but personally I'd avoid MD for that reason and go with
>>> lvm. MD is just not modern, neither appropriate for modern system
>>> setups. It should really be just there for legacy setups and migration
>>> paths.
>>
>> Not related to bcache at all.  Perhaps complain about MD on the
>> appropriate list?  I'm not seeing any evidence that MD had anything to
>> do with this, especially since the issues with bcache are entirely
>> confined to the direct SATA access to /dev/sda4.
>>
>> In that vein, I'm reading the on-disk format of bcache and seeing
>> exactly what's still valid on my system.  It looks like I've got
>> 65,000 good buckets before the first bad one.  My idea is to go
>> through, look for valid data in the buckets and use a COW in
>> user-mode-linux to write that data back to the (copy-on-write version
>> of) the backing device.  Basically, anything that passes checksum and
>> is still 'dirty', force-write-it-out.  Then see what the status of my
>> backing-store is.  If it works, do it outside UML to the real backing
>> store.
>>
>> Are there any diagnostic tools outside the bcache-tools repo? Not much
>> there other than show the superblock info.  Otherwise I'll just finish
>> writing it myself.
-- 
Replies to list only preferred.
