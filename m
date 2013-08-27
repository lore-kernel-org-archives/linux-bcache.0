From: Gabriel de Perthuis <g2p.code-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: blkid always detects FS
Date: Tue, 27 Aug 2013 11:59:54 +0000 (UTC)
Message-ID: <kvi4bp$nvo$2@ger.gmane.org>
References: <521C71FD.1030704@profihost.ag>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-bcache-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-bcache-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-bcache-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-bcache@vger.kernel.org

On Tue, 27 Aug 2013 11:31:41 +0200, Stefan Priebe - Profihost AG wrote:
> For all my bcache devices blkid returns:
>=20
> # /sbin/blkid -o udev /dev/sdd1
> ID_FS_UUID=3D6937d2e6-c8e3-4590-954b-65937fc23a52
> ID_FS_UUID_ENC=3D6937d2e6-c8e3-4590-954b-65937fc23a52
> ID_FS_TYPE=3Dxfs
>=20
> What's wrong here? All disks have XFS on top of bcache running.

The udev rules were changed to reject bcache devices with a
pre-existing superblock (xfs in your case).

This was done to fail early when there's a risk of exposing an
unsynchronised backend device, which would be a bad thing=E2=84=A2.

You can remove the stray superblocks with wipefs.
