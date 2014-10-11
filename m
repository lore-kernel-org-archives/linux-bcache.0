From: Tero Marttila <tero.marttila@paivola.fi>
Subject: initramfs issues with mdraid/bcache-tools/lvm2 on debian wheezy-backports
 3.16
Date: Sat, 11 Oct 2014 18:42:09 +0300
Message-ID: <54394FD1.4090708@paivola.fi>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-bcache-owner@vger.kernel.org>
Received: from tonttu.paivola.fi ([194.197.235.227]:56544 "EHLO
	tonttu.paivola.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751818AbaJKPt2 (ORCPT
	<rfc822;linux-bcache@vger.kernel.org>);
	Sat, 11 Oct 2014 11:49:28 -0400
Received: from [194.197.235.130] (munkibari.paivola.fi [194.197.235.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by tonttu.paivola.fi (Postfix) with ESMTPSA id 3E93D1F5F6
	for <linux-bcache@vger.kernel.org>; Sat, 11 Oct 2014 18:42:10 +0300 (EEST)
Sender: linux-bcache-owner@vger.kernel.org
List-Id: linux-bcache@vger.kernel.org
To: linux-bcache@vger.kernel.org

Hi,

I had some difficulty getting an md-raid1 / bcache / lvm stack to boot up
succesfully on the recent debian wheezy-backports 3.16-0.bpo.2-amd64 kernel
with the rootfs on bcache (and a separate /boot).

I ended up having to patch two parts of the initramfs to get it working.
The bcache-tools patch is probably not the correct solution, but I'm not sure
what the exact issue is which causes bcache-register to fail for a newly added
md device..

1)

In bcache-tools, the /dev/md0 udev rule to invoke

	/lib/udev/bcache-register /dev/md0

has some timing constraint; namely, during initramfs bootup the

	echo "$1" > /sys/fs/bcache/register_quiet

part seems to give (based on udev_log="debug" output): 

	write error: Invalid arument

without any additional info in dmesg.

However, running the identical command:

	/lib/udev/bcache-register /dev/md0

by hand a short while later from within the initramfs prompts works..

I modified bcache-register to include include a sleep, and now the
/dev/bcache0 device registers during boot.

2)

This exposes a related bug within the mdadm initramfs scripts, as per

	https://bugs.debian.org/cgi-bin/bugreport.cgi?bug=644876#85

So the mdadm part of local-top has to wait for udev to settle and the /dev/bcache0
devices to show up before attempting to activate the lvm VGs.

Not a bcache issues, but part of the workaround...

 -- Tero Marttila

--- bcache-tools-1.0.7/bcache-register  2014-05-10 16:38:21.000000000 +0300
+++ /lib/udev/bcache-register   2014-10-11 18:27:42.641482307 +0300
@@ -1,4 +1,7 @@
 #!/bin/sh
 /sbin/modprobe -qba bcache
+
+echo "$0 sleeping for $1 to settle, while we have:" /dev/bcache* >&2; sleep 5
+
 test -f /sys/fs/bcache/register_quiet && echo "$1" > /sys/fs/bcache/register_quiet

--- mdadm-3.2.5/debian/initramfs/script.local-top       2012-08-25 22:29:05.000000000 +0300
+++ /usr/share/initramfs-tools/scripts/local-top/mdadm  2014-10-11 18:15:23.804520521 +0300
@@ -97,11 +97,8 @@
   done
 fi
 
-if [ -x "$(command -v udevsettle)" ]; then
-  verbose && log_begin_msg "Waiting for udev to process events"
-  udevsettle 10
-  verbose && log_end_msg
-fi
+# XXX: https://bugs.debian.org/cgi-bin/bugreport.cgi?bug=644876
+wait_for_udev 10
 
 maybe_break post-mdadm
