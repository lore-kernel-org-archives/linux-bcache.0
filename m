From: Marc MERLIN <marc@merlins.org>
Subject: Hard to delete/unregister caching device
Date: Thu, 18 Feb 2016 22:48:57 -0800
Message-ID: <20160219064857.GA29411@merlins.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-bcache-owner@vger.kernel.org>
Received: from magic.merlins.org ([209.81.13.136]:45437 "EHLO
	mail1.merlins.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756553AbcBSGtA (ORCPT
	<rfc822;linux-bcache@vger.kernel.org>);
	Fri, 19 Feb 2016 01:49:00 -0500
Content-Disposition: inline
Sender: linux-bcache-owner@vger.kernel.org
List-Id: linux-bcache@vger.kernel.org
To: linux-bcache@vger.kernel.org

So, I have this:
=E2=94=9C=E2=94=80nvme0n1p4   259:4    0    30G part  bcache           =
        8fd98dbd-4e87-4faa-8cec-d5f1e3910daa ae581b32-8c62-41a9-bfcf-ca=
8cec66e46a
=E2=94=82 =E2=94=94=E2=94=80bcache0   252:0    0   1.1T disk  crypto_LU=
KS              d6c98ca4-23b4-4aa3-819b-b384d4ac1b6a=20
=E2=94=82   =E2=94=94=E2=94=80pool2   251:3    0   1.1T crypt btrfs    =
   /mnt/btrfs_p 5ed9d54d-2f12-4735-85c2-e0445a316088=20
=E2=94=9C=E2=94=80sda7          8:7    0   1.1T part  bcache           =
        6d88cea7-6cfc-4d30-8cf5-8c8b216e019d 753dca8b-07
=E2=94=82 =E2=94=94=E2=94=80bcache0   252:0    0   1.1T disk  crypto_LU=
KS              d6c98ca4-23b4-4aa3-819b-b384d4ac1b6a=20
=E2=94=82   =E2=94=94=E2=94=80pool2   251:3    0   1.1T crypt btrfs    =
   /mnt/btrfs_p 5ed9d54d-2f12-4735-85c2-e0445a316088=20


=E2=94=9C=E2=94=80sda6          8:6    0    65G part  bcache           =
        21c07a2c-6ed2-42c2-aafb-8e1bbfa471a5 753dca8b-06
=E2=94=94=E2=94=80sdb1          8:17   0   1.8T part  bcache           =
        b324cfc4-a5ae-4888-ad6c-a5ba1002fdce 89ba6da8-01
  =E2=94=94=E2=94=80bcache1   252:1    0   1.8T disk  crypto_LUKS      =
        b519d6ce-291a-4500-937e-a5957e6ece6b=20
    =E2=94=94=E2=94=80pool3   251:4    0   1.8T crypt btrfs       /mnt/=
btrfs_p 5874cad5-d6dd-4b3d-a455-4e0ae2611f09=20

bcache0 is fine
bcache1 ended up in a bad state, I'm not sure how.
No biggie, right, just delete/recreate/re-register sda6, except how?

https://www.kernel.org/doc/Documentation/bcache.txt
SYSFS - CACHE DEVICE:
says nothing about how I can free/release sda6

saruman:~# echo /dev/sda6 > /sys/fs/bcache/unregister
-su: /sys/fs/bcache/unregister: Permission denied
is not helpful, nothing in kern.log

saruman:~# wipefs -a /dev/sda6
wipefs: error: /dev/sda6: probing initialization failed: Device or reso=
urce busy


saruman:~# l /dev/bcache/by-uuid/
total 0
drwxr-xr-x 2 root root 80 Feb 17 20:20 ./
drwxr-xr-x 3 root root 60 Feb 17 20:20 ../
lrwxrwxrwx 1 root root 13 Feb 17 20:20 6d88cea7-6cfc-4d30-8cf5-8c8b216e=
019d -> ../../bcache0
lrwxrwxrwx 1 root root 13 Feb 17 20:20 b324cfc4-a5ae-4888-ad6c-a5ba1002=
fdce -> ../../bcache1

Those UUIDs don't show up in lsblk

Oh my, what is this?
saruman:~# l /sys/block/sda/sda6/bcache/set
lrwxrwxrwx 1 root root 0 Feb 18 22:28 /sys/block/sda/sda6/bcache/set ->=
 ../../../../../../../../../../../fs/bcache/f419195d-184e-44b7-9f88-a83=
4a5458f8c/

This other UUID still does not show up in lsblk, by now I've lost count
of why I have 3 different kinds of UUIDs instead of 2.

Mmmh, now I'm starting to get it, I have to look at caching devices by =
UUID, find the right one, and stop it:
saruman:/sys/fs/bcache# l
total 0
drwxr-xr-x  5 root root    0 Feb 18 22:32 ./
drwxr-xr-x 10 root root    0 Feb 17 20:20 ../
drwxr-xr-x  7 root root    0 Feb 18 22:07 6698753e-78d0-4f6a-a8cb-fbb6a=
20ddae8/
drwxr-xr-x  7 root root    0 Feb 18 22:07 b7ba27a1-2398-4649-8ae3-0959f=
57ba128/
drwxr-xr-x  7 root root    0 Feb 18 22:32 f419195d-184e-44b7-9f88-a834a=
5458f8c/

Ok, let's try
saruman:/sys/fs/bcache/f419195d-184e-44b7-9f88-a834a5458f8c# echo 1 > s=
top

Ah, success:
saruman:~# wipefs -a /dev/sda6
/dev/sda6: 16 bytes were erased at offset 0x00001018 (bcache): c6 85 73=
 f6 4e 1a 45 ca 82 65 f5 7f 48 ba 6d 81

This isn't super obvious :)
Is there a howto document where those steps could be documented in a ho=
wto fashion?
(removing a caching device and replacing it with another one, maybe you=
 got a bigger/faster SSD)

In https://www.kernel.org/doc/Documentation/bcache.txt or otherwise?

Thanks,
Marc
--=20
"A mouse is a device used to point at the xterm you want to type in" - =
A.S.R.
Microsoft is to operating systems ....
                                      .... what McDonalds is to gourmet=
 cooking
Home page: http://marc.merlins.org/                         | PGP 1024R=
/763BE901
