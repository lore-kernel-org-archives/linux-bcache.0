From: Lucas Clemente Vella <lvella@gmail.com>
Subject: Migrating layout
Date: Wed, 6 May 2015 01:26:46 -0300
Message-ID: <CAGCathyee47D7ivdr0_uyZe+gSDobMHOC7sSG1Dd7Rcra2cs9g@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-bcache-owner@vger.kernel.org>
Received: from mail-ie0-f170.google.com ([209.85.223.170]:33932 "EHLO
	mail-ie0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759159AbbEFE1H (ORCPT
	<rfc822;linux-bcache@vger.kernel.org>);
	Wed, 6 May 2015 00:27:07 -0400
Received: by iedfl3 with SMTP id fl3so6187309ied.1
        for <linux-bcache@vger.kernel.org>; Tue, 05 May 2015 21:27:07 -0700 (PDT)
Sender: linux-bcache-owner@vger.kernel.org
List-Id: linux-bcache@vger.kernel.org
To: linux-bcache@vger.kernel.org

I made the bad decision of setting up this layout:

SSD:
 - /boot
 - swap
 - cache space

HDD:
 - cached /
 - cached /home

With my old PC it was OK, but with my new PC it is a martyrdom to try
to boot the machine, because due to the fast BIOS, there is race
condition between the BIOS to be ready to boot and my crappy cheap SSD
from China to be ready for reading. So booting frequently fails and I
must reset it over and over again so that, by chance, the BIOS will
recognize it as a bootable device soon enough.

Thus my questions:

- If I copy the contents of /boot to my HDD, and install GRUB there
making it bootable, will GRUB be able to boot from a bcached
partition?

- Will bcache bypass the cache while the SSD is not yet ready/attached
to the kernel, but work correctly afterwards, when it is ready?

- Is it a good idea to have a swap file inside a cached partition of my HDD?

I don't want to repartition my HDD, so if I can have a swap file and
boot from a cached ext4, repartitioning won't be necessary.

-- 
Lucas Clemente Vella
lvella@gmail.com
