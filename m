From: Marc MERLIN <marc@merlins.org>
Subject: Accessing /dev/bcache/by-uuid/xxxx deletes the device
Date: Thu, 24 Mar 2016 21:04:41 -0700
Message-ID: <20160325040441.GA512@merlins.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-bcache-owner@vger.kernel.org>
Received: from magic.merlins.org ([209.81.13.136]:39043 "EHLO
	mail1.merlins.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750828AbcCYEEq (ORCPT
	<rfc822;linux-bcache@vger.kernel.org>);
	Fri, 25 Mar 2016 00:04:46 -0400
Received: from svh-gw.merlins.org ([173.11.111.145]:53700 helo=legolas.merlins.org)
	by mail1.merlins.org with esmtps
	(Cipher TLS1.2:DHE_RSA_AES_128_CBC_SHA1:128) (Exim 4.80 #2)
	id 1ajIzK-0003ki-EM
	for <linux-bcache@vger.kernel.org>; Thu, 24 Mar 2016 21:04:45 -0700
Received: from merlin by legolas.merlins.org with local (Exim 4.80)
	(envelope-from <marc@merlins.org>)
	id 1ajIzJ-0000FZ-KB
	for linux-bcache@vger.kernel.org; Thu, 24 Mar 2016 21:04:41 -0700
Content-Disposition: inline
Sender: linux-bcache-owner@vger.kernel.org
List-Id: linux-bcache@vger.kernel.org
To: linux-bcache@vger.kernel.org

This is the weirdest bug.

gargamel:~# l /dev/bcache/by-uuid/
total 0
drwxr-xr-x 2 root root 60 Mar 24 20:53 ./
drwxr-xr-x 3 root root 60 Mar 24 20:53 ../
lrwxrwxrwx 1 root root 13 Mar 24 20:53 efa850e6-a82b-4b9b-9ae7-1ab9798a25ca -> ../../bcache1

gargamel:~#  cryptsetup luksOpen /dev/bcache/by-uuid/efa850e6-a82b-4b9b-9ae7-1ab9798a25ca dshelf1
Enter passphrase for /dev/bcache/by-uuid/efa850e6-a82b-4b9b-9ae7-1ab9798a25ca:
device-mapper: remove ioctl on temporary-cryptsetup-27100 failed: Device or resource busy
No key available with this passphrase.

gargamel:~# l /dev/bcache*
brw-rw---- 1 root disk 251, 0 Mar 24 21:00 /dev/bcache0
brw-rw---- 1 root disk 251, 1 Mar 24 21:01 /dev/bcache1

Now the /dev/bcache/by-uuid directory is gone (I had already lost the
uuid link for bcache0 ealier).
But the devices under /dev/bcache work fine.

Is that a udev bug of some kind?

I have udev 158-1, I guess I can upgrade but I thought I'd check first.

Thanks,
Marc
-- 
"A mouse is a device used to point at the xterm you want to type in" - A.S.R.
Microsoft is to operating systems ....
                                      .... what McDonalds is to gourmet cooking
Home page: http://marc.merlins.org/                         | PGP 1024R/763BE901
