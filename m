From: Dan Merillat <dan.merillat@gmail.com>
Subject: Re: bcache fails after reboot if discard is enabled
Date: Sat, 11 Apr 2015 14:53:26 -0400
Message-ID: <CAPL5yKfpk8+6VwcUVcwJ9QxAZJQmqaa98spCyT7+LekkRvkeAw@mail.gmail.com>
References: <54A66945.6030403@profihost.ag>
	<54A66C44.6070505@profihost.ag>
	<54A819A0.9010501@rolffokkens.nl>
	<54A843BC.608@profihost.ag>
	<loom.20150105T010336-763@post.gmane.org>
	<tcfnqb-u59.ln1@hurikhan77.spdns.de>
	<CAPL5yKf4Tz1oUDNTEz20+CXh-UEeZaNBZCD9pevg47kGnWmDQQ@mail.gmail.com>
	<alpine.DEB.2.02.1504081115550.2587@ware.dreamhost.com>
	<55257303.8020008@profihost.ag>
	<alpine.DEB.2.02.1504081228581.2587@ware.dreamhost.com>
	<3ldgvb-het.ln1@hurikhan77.spdns.de>
	<CAPL5yKdH97vJaYZxdu9ZHhrmK0OOAvEqtAk3Efz2+TvtOBUShw@mail.gmail.com>
	<5a1mvb-6k.ln1@hurikhan77.spdns.de>
	<3k5mvb-c14.ln1@hurikhan77.spdns.de>
	<CAPL5yKdfdtwPOQM-edwNJPkQDoBR2Oyagb6JWRP+-26xQvxyKQ@mail.gmail.com>
	<CAPL5yKcGvjC7ubzdKNjCFX6ZLc+qrr-Q0BQCX6W0zbueTkndPg@mail.gmail.com>
	<bf0nvb-uvd.ln1@hurikhan77.spdns.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-bcache-owner@vger.kernel.org>
Received: from mail-ig0-f169.google.com ([209.85.213.169]:33306 "EHLO
	mail-ig0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751292AbbDKSx1 (ORCPT
	<rfc822;linux-bcache@vger.kernel.org>);
	Sat, 11 Apr 2015 14:53:27 -0400
Received: by igbpi8 with SMTP id pi8so4283470igb.0
        for <linux-bcache@vger.kernel.org>; Sat, 11 Apr 2015 11:53:27 -0700 (PDT)
In-Reply-To: <bf0nvb-uvd.ln1@hurikhan77.spdns.de>
Sender: linux-bcache-owner@vger.kernel.org
List-Id: linux-bcache@vger.kernel.org
To: Kai Krakow <hurikhan77@gmail.com>
Cc: linux-bcache@vger.kernel.org

On Sat, Apr 11, 2015 at 3:52 AM, Kai Krakow <hurikhan77@gmail.com> wrote:
> Dan Merillat <dan.merillat@gmail.com> schrieb:
>
>> Looking through the kernel log, this may be related: I booted into
>> 4.0-rc7, and attempted to run it there at first:
>> Apr  7 12:54:08 fileserver kernel: [ 2028.533893] bcache-register:
>> page allocation failure: order:8, mode:0x
>> ... memory dump
>> Apr  7 12:54:08 fileserver kernel: [ 2028.541396] bcache:
>> register_cache() error opening sda4: cannot allocate memory
>
> Is your system under memory stress? Are you maybe using the huge memory page
> allocation policy in your kernel? If yes, could you retry without or at
> least set it to madvice mode?

No, it's right after bootup, nothing heavy running yet.  No idea why
memory is already so fragmented - it's something to do with 4.0-rc7,
since it never has had that problem on 3.18.

>> Apr  7 12:55:29 fileserver kernel: [ 2109.303315] bcache:
>> run_cache_set() invalidating existing data
>> Apr  7 12:55:29 fileserver kernel: [ 2109.408255] bcache:
>> bch_cached_dev_attach() Caching md127 as bcache0 on set
>> 804d6906-fa80-40ac-9081-a71a4d595378
>
> Why is it on md? I thought you are not using intermediate layers like LVM...

The backing device is MD, the cdev is directly on sda4

>> Apr  7 12:55:29 fileserver kernel: [ 2109.408443] bcache:
>> register_cache() registered cache device sda4
>> Apr  7 12:55:33 fileserver kernel: [ 2113.307687] bcache:
>> bch_cached_dev_attach() Can't attach md127: already attached
>
> And why is it done twice? Something looks strange here... What is your
> device layout?

2100 seconds after boot?  That's me doing it manually to try to figure
out why I can't access my filesystem.

>
>> Apr  7 12:55:33 fileserver kernel: [ 2113.307747] bcache:
>> __cached_dev_store() Can't attach 804d6906-fa80-40ac-9081-a71a4d595378
>> Apr  7 12:55:33 fileserver kernel: [ 2113.307747] : cache set not found
>
> My first guess would be that two different caches overlap and try to share
> the same device space. I had a similar problem after repartitioning because
> I did not "wipefs" the device first.

I had to wipefs, it wouldn't let me create the bcache super until I did.

> If you are using huge memory this may be an artifact of your initial
> finding.

I'm not using it for anything, but it's configured.  It's never given
this problem in 3.18, so something changed in 4.0.

>
>> So I rebooted to 4.0-rc7 again:
>> Apr  7 19:36:23 fileserver kernel: [    2.145004] bcache:
>> journal_read_bucket() 157: too big, 552 bytes, offset 2047
>> Apr  7 19:36:23 fileserver kernel: [    2.154586] bcache: prio_read()
>> bad csum reading priorities
>> Apr  7 19:36:23 fileserver kernel: [    2.154643] bcache: prio_read()
>> bad magic reading priorities
>> Apr  7 19:36:23 fileserver kernel: [    2.158008] bcache: error on
>> 804d6906-fa80-40ac-9081-a71a4d595378: bad btree header at bucket
>> 65638, block 0, 0 keys, disabling caching
>
> Same here: If somehow two different caches overwrite each other, this could
> explain the problem.

Possibly!  So wipefs wasn't good enough, I should have done a discard
on the entire cdev
to make sure?

>
>> Apr  7 19:36:23 fileserver kernel: [    2.158408] bcache:
>> cache_set_free() Cache set 804d6906-fa80-40ac-9081-a71a4d595378
>> unregistered
>> Apr  7 19:36:23 fileserver kernel: [    2.158468] bcache:
>> register_cache() registered cache device sda4
>>
>> Apr  7 19:36:23 fileserver kernel: [    2.226581] md127: detected
>> capacity change from 0 to 12001954234368
>
> I wonder where md127 comes from... Maybe bcache probing is running too early
> and should run after md setup.

No, that's how udev works, it registers things as it finds them.  So
on raw disks it finds
the bcache cdev, and registers it.  Then it finds the raid signature
and sets it up.  When the new md127 shows up, it finds the bdev
signature and registers that.   Bog-standard setup, most people never
look this closely at the startup.  I'd hope bcache wouldn't screw up
if its pieces get registered in a different order.
