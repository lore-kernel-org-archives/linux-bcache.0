From: Ian Pilcher <arequipeno@gmail.com>
Subject: "device busy" error when registering device
Date: Fri, 18 Jul 2014 19:11:50 -0500
Message-ID: <lqcd46$hvl$1@ger.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-bcache-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:45596 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750790AbaGSAMH (ORCPT <rfc822;linux-bcache@vger.kernel.org>);
	Fri, 18 Jul 2014 20:12:07 -0400
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <glbd-linux-bcache@m.gmane.org>)
	id 1X8IFx-0001H2-7D
	for linux-bcache@vger.kernel.org; Sat, 19 Jul 2014 02:12:05 +0200
Received: from pool-173-57-185-5.dllstx.fios.verizon.net ([173.57.185.5])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-bcache@vger.kernel.org>; Sat, 19 Jul 2014 02:12:05 +0200
Received: from arequipeno by pool-173-57-185-5.dllstx.fios.verizon.net with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-bcache@vger.kernel.org>; Sat, 19 Jul 2014 02:12:05 +0200
Sender: linux-bcache-owner@vger.kernel.org
List-Id: linux-bcache@vger.kernel.org
To: linux-bcache@vger.kernel.org

I just finished moving my existing Fedora 20 root filesystem onto a
bcache device (actually LVM on top of a bcache physical volume).

The bcache cache device is /dev/sda2, a partition on my SSD; the backing
device is /dev/md126p5, a partition on an Intel RAID (imsm) volume.

This configuration only boots successfully about 50% of the time.  The
other 50% of the time, the bcache device is not created, and dracut
times out and dumps me into an emergency shell.

After changing the bcache-register script to use /sys/fs/bcache/register
(instead of register_quiet), I see a "device busy" error when udev
attempts to register the backing device:

  [    2.105581] bcache: register_bcache() error opening /dev/md126p5:
device busy

This is kernel 3.5.15, so this doesn't mean that the device is already
registered; something else has it (temporarily) opened.  I say that it's
opened temporarily, because I am able to register the backing device
manually from the dracut shell -- which starts the the bcache device.

Looking at /usr/lib/udev/bcache-register and the bcache_register source
in drivers/md/bcache/super.c, I notice 2 things.

(1) bcache-register gives up immediately when an error occurs because of
    a (possibly temporary) conflict.

(2) Although the driver logs a different message in the already
    registered case ("device already registered" instead of "device
    busy"), it doesn't provide userspace with any way to distinguish the
    two cases; it always returns -EINVAL.

Suggested fix:

(1) Change bcache_register to return -EBUSY in the device busy case
    (while still returning -EINVAL in the already registered case).

(2) Change bcache-register to check the exit code of the registration
    attempt and retry in the EBUSY case.

Does this make sense?

-- 
========================================================================
Ian Pilcher                                         arequipeno@gmail.com
-------- "I grew up before Mark Zuckerberg invented friendship" --------
========================================================================
