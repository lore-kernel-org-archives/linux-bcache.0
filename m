From: Kent Overstreet <kmo-PEzghdH756F8UrSeD/g0lQ@public.gmane.org>
Subject: Re: Silent data corruption (3.11-rc4) in writethrough mode
Date: Mon, 12 Aug 2013 10:57:25 -0700
Message-ID: <20130812175725.GA7662@moria.home.lan>
References: <52089B57.8000104@planet-work.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-bcache-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <52089B57.8000104-RVWVJRqVLmoxnA8XTFIEbw@public.gmane.org>
Sender: linux-bcache-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: =?utf-8?B?RnLDqWTDqXJpYyBWQU5OScOIUkU=?= <f.vanniere-RVWVJRqVLmoxnA8XTFIEbw@public.gmane.org>
Cc: linux-bcache-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-bcache@vger.kernel.org

On Mon, Aug 12, 2013 at 10:22:47AM +0200, Fr=C3=A9d=C3=A9ric VANNI=C3=88=
RE wrote:
> Hello,
>=20
> I'm using bcache for Xen hosting. The configuration is :
>   - Servers HP Proliant DL360 G5/G7/Gen8
>   - Backend : HP Smart Array with 2GB write cache (protected), it's a=
 partition like /dev/sda2
>   - Cache device : OWC Mercury Accelsior PCIe (2 x Sandforce in RAID0=
 on Marvell 88SE9230), the whole disk like /dev/sdb
>   - Cache mode : writethrough
>   - Kernel : 3.10.5 with bcache driver from 3.11-rc4
>   - Setup process : make-bcache -B /dev/sda2 ; make-bcache -C /dev/sd=
b ; then attached cache device to backend.
>   - LVM setup : pvcreate /dev/bcache0  , vgcreate xen_data /dev/bcach=
e0 . Each VM has a LV volume on "xen_data"
>=20
> On some hosts I've noticed very strange behavior with random mysql cr=
ashes, mysql innodb data corruption, filesystem corruption.
>=20
> I'm running md5 check on system files each night and compares it to d=
ebian's database, on some VMs there where modified files (bad MD5).
> When I detached the cache device, dropped virtualmemory cache on gues=
t and synced FS, the MD5 of the files where OK again without rebooting.
>=20
> It lookes like bcache had corrupted data in cache, they are no kernel=
 logs on the host, no errors.

Ouch... This wasn't occuring on 3.10?
