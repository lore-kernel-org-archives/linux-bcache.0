From: =?ISO-8859-1?Q?Fr=E9d=E9ric_VANNI=C8RE?=
	<f.vanniere-RVWVJRqVLmoxnA8XTFIEbw@public.gmane.org>
Subject: Silent data corruption (3.11-rc4) in writethrough mode
Date: Mon, 12 Aug 2013 10:22:47 +0200
Message-ID: <52089B57.8000104@planet-work.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1;
	format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-bcache-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-bcache-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-bcache-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-bcache@vger.kernel.org

Hello,

I'm using bcache for Xen hosting. The configuration is :
   - Servers HP Proliant DL360 G5/G7/Gen8
   - Backend : HP Smart Array with 2GB write cache (protected), it's a =
partition like /dev/sda2
   - Cache device : OWC Mercury Accelsior PCIe (2 x Sandforce in RAID0 =
on Marvell 88SE9230), the whole disk like /dev/sdb
   - Cache mode : writethrough
   - Kernel : 3.10.5 with bcache driver from 3.11-rc4
   - Setup process : make-bcache -B /dev/sda2 ; make-bcache -C /dev/sdb=
 ; then attached cache device to backend.
   - LVM setup : pvcreate /dev/bcache0  , vgcreate xen_data /dev/bcache=
0 . Each VM has a LV volume on "xen_data"

On some hosts I've noticed very strange behavior with random mysql cras=
hes, mysql innodb data corruption, filesystem corruption.

I'm running md5 check on system files each night and compares it to deb=
ian's database, on some VMs there where modified files (bad MD5).
When I detached the cache device, dropped virtualmemory cache on guest =
and synced FS, the MD5 of the files where OK again without rebooting.

It lookes like bcache had corrupted data in cache, they are no kernel l=
ogs on the host, no errors.

=46r=E9d=E9ric.
