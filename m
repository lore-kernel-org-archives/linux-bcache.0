From: Stefan Priebe - Profihost AG <s.priebe-2Lf/h1ldwEHR5kwTpVNS9A@public.gmane.org>
Subject: Re: blkid always detects FS
Date: Tue, 27 Aug 2013 15:04:02 +0200
Message-ID: <521CA3C2.9040100@profihost.ag>
References: <521C71FD.1030704@profihost.ag> <kvi4bp$nvo$2@ger.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-bcache-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <kvi4bp$nvo$2@ger.gmane.org>
Sender: linux-bcache-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Gabriel de Perthuis <g2p.code-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: linux-bcache-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-bcache@vger.kernel.org


Am 27.08.2013 13:59, schrieb Gabriel de Perthuis:
> On Tue, 27 Aug 2013 11:31:41 +0200, Stefan Priebe - Profihost AG wrot=
e:
>> For all my bcache devices blkid returns:
>>
>> # /sbin/blkid -o udev /dev/sdd1
>> ID_FS_UUID=3D6937d2e6-c8e3-4590-954b-65937fc23a52
>> ID_FS_UUID_ENC=3D6937d2e6-c8e3-4590-954b-65937fc23a52
>> ID_FS_TYPE=3Dxfs
>>
>> What's wrong here? All disks have XFS on top of bcache running.
>=20
> The udev rules were changed to reject bcache devices with a
> pre-existing superblock (xfs in your case).
>=20
> This was done to fail early when there's a risk of exposing an
> unsynchronised backend device, which would be a bad thing=E2=84=A2.
>=20
> You can remove the stray superblocks with wipefs.
shouldn't bcache-create wipe the superblock?
Stefan
