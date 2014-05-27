From: Eitan Mosenkis <eitan@mosenkis.net>
Subject: Repeated corruption after reboot (using ext4 on Ubuntu 14.04)
Date: Tue, 27 May 2014 11:10:15 -0400
Message-ID: <CAH_5vAn7zMpNC2axhAbjZciFF3s_iAuVe5y31Or9fWG1y0=D9A@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-bcache-owner@vger.kernel.org>
Received: from mail-ve0-f175.google.com ([209.85.128.175]:55321 "EHLO
	mail-ve0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752606AbaE0PKh (ORCPT
	<rfc822;linux-bcache@vger.kernel.org>);
	Tue, 27 May 2014 11:10:37 -0400
Received: by mail-ve0-f175.google.com with SMTP id jw12so10777461veb.20
        for <linux-bcache@vger.kernel.org>; Tue, 27 May 2014 08:10:37 -0700 (PDT)
Received: from mail-ve0-f181.google.com (mail-ve0-f181.google.com [209.85.128.181])
        by mx.google.com with ESMTPSA id ew15sm16350871veb.4.2014.05.27.08.10.35
        for <linux-bcache@vger.kernel.org>
        (version=TLSv1 cipher=ECDHE-RSA-RC4-SHA bits=128/128);
        Tue, 27 May 2014 08:10:35 -0700 (PDT)
Received: by mail-ve0-f181.google.com with SMTP id pa12so10702277veb.26
        for <linux-bcache@vger.kernel.org>; Tue, 27 May 2014 08:10:35 -0700 (PDT)
Sender: linux-bcache-owner@vger.kernel.org
List-Id: linux-bcache@vger.kernel.org
To: linux-bcache@vger.kernel.org

bcache seems to work fine, but after rebooting, the ext4 filesystem
stored in /dev/bcache0 frequently, but not always, becomes corrupted -
seemingly, it only damages metadata for recently modified files (after
e2fsck -y finished, I found in /lost+found a lot of files from my
browser cache, some file lists from recently installed packages, etc.)
Any idea what was causing the corruption or how to use bcache without
encountering it again?

Timeline:
1. I installed Ubuntu 14.04 and Windows 8.1 to a 1TB HDD.
2. I later added a 64GB SSD.
3. My first attempts to install blocks to convert my root partition
failed because it depends on Python 3.3, while Ubuntu 14.04 only
packages Python 3.4.
4. I rebooted into Windows to look into enabling Intel Smart Response
(the Windows equivalent of bcache), rebooted to switch the SATA mode
from AHCI to RAID (because that's the only way Smart Response can be
enabled), booted Windows again and enabled Smart Response to use
~18.6GB of the SSD as cache.
5. I booted Ubuntu and discovered that the disk partitions used by
Windows/Smart Response were not visible.
6. After some investigation, I discovered that Smart Response, rather
that just using disk partitions, had created a fake RAID array,
splitting the SSD into two parts.
7. I installed mdadm and was able to see the two parts of the SSD under Ubuntu.
8. I used make-bcache -C to create a cache on the rest of the SSD.
9. I booted into Windows again, only to discover that Smart Response
was no longer enabled and the RAID array seemed to have disappeared
10. After a lot of work, I forced python3-blocks and its dependencies
to install despite the Python version mismatch (it seems that Python
3.4 is almost completely backwards compatible with Python 3.3). With a
bit more work, I attempted to use "blocks to-bcache --maintboot
/dev/sda8 --join some-uuid-that-looks-like-this" to convert my root
partition to a bcache backing device. It rebooted, but when the system
resumed, it was still using /dev/sda8 directly, the conversion hadn't
happened.
11. I put the Ubuntu installer image on a USB stick and booted from it
12. I moved /boot from the HDD to the SSD.
13. I installed Python 3.3 from the deadsnakes PPA, then forced
python3-blocks and dependencies to install as before.
14. I modified blocks/__main__.py to do "_ped =
imp.load_dynamic('_ped', '/usr/lib/.../_ped.something.so')" instead of
"import _ped" to load pyparted because it couldn't find it for reasons
that I don't understand
15. I successfully ran "blocks to-bcache /dev/sda8 --join
some-uuid-that-looks-like-this"
16. I helped Grub find /boot, then booted into Ubuntu, now with
/dev/bcache0 mounted as the root partition, and regenerated grub's
config.
17. I successfully rebooted into the (now much faster) Ubuntu install.
I rebooted several more times just to admire how fast it was. No signs
of trouble.
18. I turned on the computer the next morning and it booted, but found
that Chrome wouldn't open because it couldn't get a lock to prevent
user profile corruption, which in turn was due to the fact that the
root partition had been automatically remounted read-only after an
ext4 error (it was mounted originally with errors=remount-ro)
19. I rebooted, and now found that the kernel couldn't find the root
partition by its UUID. Running blkid on /dev/bcache0 confirmed that
its UUID was not to be found.
20. I rebooted to the USB stick, and ran "e2fsck -f -y" repeatedly
until it came up clean. The first time it couldn't even find the
superblock and I had to follow its suggestion to specify an alternate
superblock location.
21. I rebooted to Ubuntu running on bcache - it seemed to work fine.
22. I reinstalled all of the installed packages one by one with
"apt-get --reinstall" to guard against later trouble caused by
corrupted or lost files.
23. After the package reinstallation completed, I followed its request
to reboot.
24. Upon booting, it again experienced ext4 errors. I ran "e2fsck -y"
and rebooted.
25. Everything seemed fine again, but I had no idea what kept causing
the corruption. I resized the Windows partition, created a new ext4
partition, and copied /home and /root into the new partition.
26. I deleted the partitions that I had used as cache and backing
device and did a clean install of Ubuntu with /boot and / on the SSD
and /home on the HDD.
27. I restored my data from the backup partition onto the new /home
and resized the Windows partition back to its original size.
28. No problems since.

Throughout all of this, the SMART self-tests on both SSD and HDD
claimed that they were passing.
