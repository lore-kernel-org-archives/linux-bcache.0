From: Dan Merillat <dan.merillat@gmail.com>
Subject: Re: bcache fails after reboot if discard is enabled
Date: Sat, 11 Apr 2015 02:54:16 -0400
Message-ID: <CAPL5yKcGvjC7ubzdKNjCFX6ZLc+qrr-Q0BQCX6W0zbueTkndPg@mail.gmail.com>
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
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-bcache-owner@vger.kernel.org>
Received: from mail-ie0-f178.google.com ([209.85.223.178]:35513 "EHLO
	mail-ie0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752176AbbDKGyQ (ORCPT
	<rfc822;linux-bcache@vger.kernel.org>);
	Sat, 11 Apr 2015 02:54:16 -0400
Received: by iejt8 with SMTP id t8so33035826iej.2
        for <linux-bcache@vger.kernel.org>; Fri, 10 Apr 2015 23:54:16 -0700 (PDT)
In-Reply-To: <CAPL5yKdfdtwPOQM-edwNJPkQDoBR2Oyagb6JWRP+-26xQvxyKQ@mail.gmail.com>
Sender: linux-bcache-owner@vger.kernel.org
List-Id: linux-bcache@vger.kernel.org
To: Kai Krakow <hurikhan77@gmail.com>
Cc: linux-bcache@vger.kernel.org

Looking through the kernel log, this may be related: I booted into
4.0-rc7, and attempted to run it there at first:
Apr  7 12:54:08 fileserver kernel: [ 2028.533893] bcache-register:
page allocation failure: order:8, mode:0x
... memory dump
Apr  7 12:54:08 fileserver kernel: [ 2028.541396] bcache:
register_cache() error opening sda4: cannot allocate memory


Apr  7 12:55:08 fileserver kernel: [ 2088.639190] bcache:
__cached_dev_store() Can't attach 804d6906-fa80-40ac-9081-a71a4d595378
Apr  7 12:55:08 fileserver kernel: [ 2088.639190] : cache set not found

I poked the vm.min_free_kbytes and retried, and got the following:

Apr  7 12:55:29 fileserver kernel: [ 2109.303315] bcache:
run_cache_set() invalidating existing data
Apr  7 12:55:29 fileserver kernel: [ 2109.408255] bcache:
bch_cached_dev_attach() Caching md127 as bcache0 on set
804d6906-fa80-40ac-9081-a71a4d595378
Apr  7 12:55:29 fileserver kernel: [ 2109.408443] bcache:
register_cache() registered cache device sda4
Apr  7 12:55:33 fileserver kernel: [ 2113.307687] bcache:
bch_cached_dev_attach() Can't attach md127: already attached
Apr  7 12:55:33 fileserver kernel: [ 2113.307747] bcache:
__cached_dev_store() Can't attach 804d6906-fa80-40ac-9081-a71a4d595378
Apr  7 12:55:33 fileserver kernel: [ 2113.307747] : cache set not found

A few hours later, I was getting stalls:
Apr  7 18:00:20 fileserver kernel: [20400.288049] INFO: task java:3610
blocked for more than 120 seconds.
Apr  7 18:00:20 fileserver kernel: [20400.288069]       Not tainted 4.0.0-rc7 #1
Apr  7 18:00:20 fileserver kernel: [20400.288085] "echo 0 >
/proc/sys/kernel/hung_task_timeout_secs" disables this
 message.
Apr  7 18:00:20 fileserver kernel: [20400.293521] INFO: task
nmbd:22692 blocked for more than 120 seconds.
Apr  7 18:00:20 fileserver kernel: [20400.293532]       Not tainted 4.0.0-rc7 #1
Apr  7 18:00:20 fileserver kernel: [20400.293545] "echo 0 >
/proc/sys/kernel/hung_task_timeout_secs" disables this
 message.

So I rebooted to 4.0-rc7 again:
Apr  7 19:36:23 fileserver kernel: [    2.145004] bcache:
journal_read_bucket() 157: too big, 552 bytes, offset 2047
Apr  7 19:36:23 fileserver kernel: [    2.154586] bcache: prio_read()
bad csum reading priorities
Apr  7 19:36:23 fileserver kernel: [    2.154643] bcache: prio_read()
bad magic reading priorities
Apr  7 19:36:23 fileserver kernel: [    2.158008] bcache: error on
804d6906-fa80-40ac-9081-a71a4d595378: bad btree header at bucket
65638, block 0, 0 keys, disabling caching
Apr  7 19:36:23 fileserver kernel: [    2.158408] bcache:
cache_set_free() Cache set 804d6906-fa80-40ac-9081-a71a4d595378
unregistered
Apr  7 19:36:23 fileserver kernel: [    2.158468] bcache:
register_cache() registered cache device sda4

Apr  7 19:36:23 fileserver kernel: [    2.226581] md127: detected
capacity change from 0 to 12001954234368
Apr  7 19:36:23 fileserver kernel: [    2.265347] bcache:
register_bdev() registered backing device md127

Apr  7 19:36:23 fileserver kernel: [   21.423819] bcache:
journal_read_bucket() 157: too big, 552 bytes, offset 2047
Apr  7 19:36:23 fileserver kernel: [   21.432091] bcache: prio_read()
bad csum reading priorities
Apr  7 19:36:23 fileserver kernel: [   21.432138] bcache: prio_read()
bad magic reading priorities
Apr  7 19:36:23 fileserver kernel: [   21.435613] bcache: error on
804d6906-fa80-40ac-9081-a71a4d595378: bad btree header at bucket
65638, block 0, 0 keys, disabling caching
Apr  7 19:36:23 fileserver kernel: [   21.436225] bcache:
cache_set_free() Cache set 804d6906-fa80-40ac-9081-a71a4d595378
unregistered
Apr  7 19:36:23 fileserver kernel: [   21.436273] bcache:
register_cache() registered cache device sda4

At this point, everything is gone, and that's where I'm at right now.
