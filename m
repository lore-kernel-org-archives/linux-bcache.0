From: Nicholas Cull <run2000@gmail.com>
Subject: bcache-tools, udev, and floppy drive slowness
Date: Fri, 25 Apr 2014 14:18:12 +1000
Message-ID: <CABKYNdBEgtLNvgRAbpW2ELDd2wkeRF9tkAHNXP+Vt5E6FoxGbA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-bcache-owner@vger.kernel.org>
Received: from mail-we0-f180.google.com ([74.125.82.180]:38800 "EHLO
	mail-we0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751334AbaDYESO (ORCPT
	<rfc822;linux-bcache@vger.kernel.org>);
	Fri, 25 Apr 2014 00:18:14 -0400
Received: by mail-we0-f180.google.com with SMTP id k48so3128342wev.11
        for <linux-bcache@vger.kernel.org>; Thu, 24 Apr 2014 21:18:12 -0700 (PDT)
Sender: linux-bcache-owner@vger.kernel.org
List-Id: linux-bcache@vger.kernel.org
To: linux-bcache@vger.kernel.org

Hi all,

First of all apologies if this is the wrong place to send this report,
this looked like the right area.

I recently updated my Linux workstation to Ubuntu 14.04, which came
with the Linux 3.13 kernel. This meant bcache became available to try
out.

I installed bcache-tools from the PPA at
https://launchpad.net/~g2p/+archive/storage/

After installing bcache-tools and rebooting, I noticed considerable
lag when starting up the workstation. Looking in /var/log/dmesg I saw
pauses like this:

[    3.256014] ata6: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
[    3.291801] ata6.00: ATA-7: WDC WD4000AAKS-00TMA0, 12.01C01, max UDMA/133
[    3.291804] ata6.00: 781422768 sectors, multi 0: LBA48
[    3.292659] ata6.00: configured for UDMA/133
[    3.292750] scsi 5:0:0:0: Direct-Access     ATA      WDC
WD4000AAKS-0 12.0 PQ: 0 ANSI: 5
[    3.292898] sd 5:0:0:0: Attached scsi generic sg7 type 0
[    3.292899] sd 5:0:0:0: [sdg] 781422768 512-byte logical blocks:
(400 GB/372 GiB)
[    3.292942] sd 5:0:0:0: [sdg] Write Protect is off
[    3.292945] sd 5:0:0:0: [sdg] Mode Sense: 00 3a 00 00
[    3.292964] sd 5:0:0:0: [sdg] Write cache: enabled, read cache:
enabled, doesn't support DPO or FUA
[    3.358883]  sdg: sdg1 sdg2 sdg3 < sdg5 sdg6 sdg7 sdg8 >
[    3.359236] sd 5:0:0:0: [sdg] Attached SCSI disk
[    4.022378] random: nonblocking pool is initialized
[   13.284572] end_request: I/O error, dev fd0, sector 0
[   25.444523] end_request: I/O error, dev fd0, sector 0
[   25.444526] Buffer I/O error on device fd0, logical block 0
[   32.749886] EXT4-fs (sda1): mounted filesystem with ordered data
mode. Opts: (null)
[   32.878527] init: ureadahead main process (264) terminated with status 5

Tracing this back, I noticed that bcache-tools installs a new script
in /lib/udev/rules.d/ to look for the bcache superblock. It looks for
this on all block devices, including the floppy drive (/dev/fd0) on my
workstation.

I ran the command line to see how /dev/fd0 appears to udev:

udevadm info -a -p  $(udevadm info -q path -n /dev/fd0)

The results look like this:
  looking at device '/devices/platform/floppy.0/block/fd0':
    KERNEL=="fd0"
    SUBSYSTEM=="block"
    DRIVER==""
    ATTR{ro}=="0"
    ATTR{size}=="0"
    ATTR{stat}=="       0        0        0        0        0        0
       0        0        0        0        0"
    ATTR{range}=="1"
    ATTR{discard_alignment}=="0"
    ATTR{events}==""
    ATTR{ext_range}=="1"
    ATTR{events_poll_msecs}=="2000"
    ATTR{alignment_offset}=="0"
    ATTR{inflight}=="       0        0"
    ATTR{removable}=="1"
    ATTR{capability}=="11"
    ATTR{events_async}==""

  looking at parent device '/devices/platform/floppy.0':
    KERNELS=="floppy.0"
    SUBSYSTEMS=="platform"
    DRIVERS=="floppy"
    ATTRS{cmos}=="4"

  looking at parent device '/devices/platform':
    KERNELS=="platform"
    SUBSYSTEMS==""
    DRIVERS==""

To avoid checking the floppy drive, I made a change to explicitly
filter out block devices whose DRIVERS matches floppy. Doing this
directly in /lib/udev/rules.d/ is discouraged, so I copied it and
modified it in /etc/udev/rules.d/ instead.

This patch to 69-bcache.rules performs this filter:

------

diff --git a/69-bcache.rules b/69-bcache.rules
index b83f6bc..bddf309 100644
--- a/69-bcache.rules
+++ b/69-bcache.rules
@@ -2,6 +2,8 @@
 # man 7 udev for syntax

 SUBSYSTEM!="block", GOTO="bcache_end"
+DRIVERS=="floppy", GOTO="bcache_end"
+# KERNEL=="fd[0-9]*", GOTO="bcache_end"
 ACTION=="remove", GOTO="bcache_end"

 # blkid was run by the standard udev rules

------

Note that I also tried using a KERNEL match for fd0 etc, but looking
at the DRIVERS line seemed more correct. (Am I right?)

Making this change and rebooting the system made most pauses
disappear. One pause remained, which was the one immediately after
BIOS POST, before the Ubuntu startup screen appears.

Digging a little further revealed the
/usr/share/initramfs-tools/hooks/ directory, and the bcache hook
script in there. Here the problem was that the modified script I'd put
in /etc/udev/rules.d/ doesn't get copied into the initramfs image.
Looking around a few of the other hook scripts in this directory, and
seeing how they handle custom udev rules, I changed the bcache hook to
check and copy the bcache udev rules file from /etc/udev/rules.d/ if
present, otherwise copying from /lib/udev/rules.d/ instead. This patch
fixes that behaviour:

------

diff --git a/initramfs/hook b/initramfs/hook
index e618e1a..a6baa24 100755
--- a/initramfs/hook
+++ b/initramfs/hook
@@ -16,7 +16,12 @@ esac

 . /usr/share/initramfs-tools/hook-functions

-cp -pt "${DESTDIR}/lib/udev/rules.d" /lib/udev/rules.d/69-bcache.rules
+if   [ -e /etc/udev/rules.d/69-bcache.rules ]; then
+    cp -pt "${DESTDIR}/lib/udev/rules.d" /etc/udev/rules.d/69-bcache.rules
+elif [ -e /lib/udev/rules.d/69-bcache.rules ]; then
+    cp -pt "${DESTDIR}/lib/udev/rules.d" /lib/udev/rules.d/69-bcache.rules
+fi
+
 copy_exec /lib/udev/bcache-register
 copy_exec /lib/udev/probe-bcache
 manual_add_modules bcache

------

It would be good if one, or even both, of these changes could be made
to the bcache-tools repository, or at least the bcache-tools PPA for
Ubuntu. This would make setting up bcache easier to maintain in the
future.

Best regards,

Nicholas.
