From: Matthias Ferdinand <bcache@mfedv.net>
Subject: md-raid5 with bcache member devices => kernel panic
Date: Thu, 5 Dec 2013 22:29:13 +0100
Message-ID: <20131205212913.GE1848@teapot>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Return-path: <linux-bcache-owner@vger.kernel.org>
Received: from sw.mfedv.net ([212.82.36.162]:41247 "EHLO sw.mfedv.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753021Ab3LEV3T (ORCPT <rfc822;linux-bcache@vger.kernel.org>);
	Thu, 5 Dec 2013 16:29:19 -0500
Content-Disposition: inline
Sender: linux-bcache-owner@vger.kernel.org
List-Id: linux-bcache@vger.kernel.org
To: linux-bcache@vger.kernel.org

Hi,

I am currently experimenting with bcache. The hardware is rather old:
Intel Core2 6600, 2.4GHz, 8GB RAM. I intend using it as a KVM host. OS
is Ubuntu 13.10 amd64.

SSD: single Intel 530 series 120G (SSDSC2BW120A4), i.e. same cache
device for all backing devices

My test procedure:

  - prepare VMs:
       foreach vm in x y z
         copy VM image to volume (dd_rescue)
           (Ubuntu 12.04 amd64 Webservers, XFS filesystem)
         start up VM

  - wait at least 5 min so any writeback can settle down

  - synchronously start "apt-get dist-upgrade" inside the
    VMs (includes linux-image-... and linux-headers-...,
    which makes for lot of small files)

I did this with various values of bcache cache_mode and KVM virtual
disk caching options.

Bcaches 'writeback' cache_mode is fastest, of course. But now the KVM
setting "writeback" is slower than "writethrough" - in the same setup
with no bcache involved, KVMs "writeback" would be far ahead.

Storage setup:

  LVM
   |
  md-raid5 (chunksize 512k)
   |
  3x SATA 2TB Seagate ST2000DM001-1CH1; Partition 6


I tried putting bcache at different levels in the storage stack:

  [bcache <1a> <1b> <1c>]
   |
  LVM
   |
  [bcache <2>]
   |
  md-raid5 (chunksize 512k)
   |
  [bcache <3a> <3b> <3c>]
   |
  3x SATA 2TB Seagate ST2000DM001-1CH1; Partition 6


1) 3 bcache devices on top of LVs (<1a>, <1b>, <1c>).

2) 1 bcache device above the md-raid5 (<2>), used as LVM PV.

3) 3 bcache devices on top of the partitions (<3a>, <3b>, <3c>),
      used as member devices for md-raid5.

The higher bcache was in this hierarchy, the better the
performance was. An md-raid5 made of bcaches (that use the same cache
device) is horribly slow.

But not only is it rather slow, it reliably (but nondeterministically)
produces kernel panics. It might panic while copying the first VM image
(dd_rescue), or during startup of the first VM, while the copy process
for the second VM image (dd_rescue) is already running.

Tried with different kernels, all produce the panics:
  - Ubuntu 3.11.0-13.20
  - kernel.org 3.12.2
  - kernel.org 3.13-rc2

Having so many layers on top of bcache may be stupid, but sure it should
not panic :-)

You can find the complete serial console output of those crashing runs
at http://dl.mfedv.net/md5raid_on_bcache_panic/

I can't see bcache mentioned in those kernel backtraces - perhaps it's
not really bcaches fault. (there is a single bcache line in the 3.12.2
trace, though)

Any ideas?

Regards
Matthias
