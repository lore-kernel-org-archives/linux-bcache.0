From: Kai Krakow <hurikhan77@gmail.com>
Subject: Re: Migrating layout
Date: Wed, 06 May 2015 08:38:52 +0200
Message-ID: <tgpo1c-nt7.ln1@hurikhan77.spdns.de>
References: <CAGCathyee47D7ivdr0_uyZe+gSDobMHOC7sSG1Dd7Rcra2cs9g@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7Bit
Return-path: <linux-bcache-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:60700 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751018AbbEFGjA (ORCPT <rfc822;linux-bcache@vger.kernel.org>);
	Wed, 6 May 2015 02:39:00 -0400
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <glbd-linux-bcache@m.gmane.org>)
	id 1Ypsyw-0008Vb-LJ
	for linux-bcache@vger.kernel.org; Wed, 06 May 2015 08:38:58 +0200
Received: from ip18864262.dynamic.kabel-deutschland.de ([24.134.66.98])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-bcache@vger.kernel.org>; Wed, 06 May 2015 08:38:58 +0200
Received: from hurikhan77 by ip18864262.dynamic.kabel-deutschland.de with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-bcache@vger.kernel.org>; Wed, 06 May 2015 08:38:58 +0200
Sender: linux-bcache-owner@vger.kernel.org
List-Id: linux-bcache@vger.kernel.org
To: linux-bcache@vger.kernel.org

Lucas Clemente Vella <lvella@gmail.com> schrieb:

> I made the bad decision of setting up this layout:
> 
> SSD:
>  - /boot
>  - swap
>  - cache space
> 
> HDD:
>  - cached /
>  - cached /home
> 
> With my old PC it was OK, but with my new PC it is a martyrdom to try
> to boot the machine, because due to the fast BIOS, there is race
> condition between the BIOS to be ready to boot and my crappy cheap SSD
> from China to be ready for reading. So booting frequently fails and I
> must reset it over and over again so that, by chance, the BIOS will
> recognize it as a bootable device soon enough.
> 
> Thus my questions:
> 
> - If I copy the contents of /boot to my HDD, and install GRUB there
> making it bootable, will GRUB be able to boot from a bcached
> partition?

No, grub cannot read bcache partitions. Thus, you need an initramfs anyways 
to let udev setup the bcache devices.

> - Will bcache bypass the cache while the SSD is not yet ready/attached
> to the kernel, but work correctly afterwards, when it is ready?

I suggest to only ever try this with bcache in write-around mode. But it 
won't act that way anyways unless you do some udev wizardry.

> - Is it a good idea to have a swap file inside a cached partition of my
> HDD?

No idea... I wouldn't try without a backup.

> I don't want to repartition my HDD, so if I can have a swap file and
> boot from a cached ext4, repartitioning won't be necessary.

I suggest looking into zswap if you can offer only a small swap partition, 
or looking into zram if you can offer no swap partition. However, do not use 
zram with physical swap - it doesn't have the effect you might expect.

As a possible solution I'd boot from initramfs (you probably have to do it 
anyways), and pass "rootwait" on the kernel command line for the initramfs 
to wait until the rootfs is ready. You could also try "rootdelay=<seconds>" 
to make the kernel wait a little.

-- 
Replies to list only preferred.
