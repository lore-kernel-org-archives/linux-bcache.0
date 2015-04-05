From: Kai Krakow <hurikhan77@gmail.com>
Subject: Re: Issue when mkfs.btrfs on a bcached partition
Date: Sun, 05 Apr 2015 17:23:20 +0200
Message-ID: <8k08vb-a59.ln1@hurikhan77.spdns.de>
References: <CAK1hC9v+ghET3=XAStWzofF-4But=sGhFgA-jhHZOobe2jSEzg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-bcache-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:34459 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751992AbbDEPXb (ORCPT <rfc822;linux-bcache@vger.kernel.org>);
	Sun, 5 Apr 2015 11:23:31 -0400
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <glbd-linux-bcache@m.gmane.org>)
	id 1YemOU-0005DP-JD
	for linux-bcache@vger.kernel.org; Sun, 05 Apr 2015 17:23:26 +0200
Received: from ip18864262.dynamic.kabel-deutschland.de ([24.134.66.98])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-bcache@vger.kernel.org>; Sun, 05 Apr 2015 17:23:26 +0200
Received: from hurikhan77 by ip18864262.dynamic.kabel-deutschland.de with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-bcache@vger.kernel.org>; Sun, 05 Apr 2015 17:23:26 +0200
Sender: linux-bcache-owner@vger.kernel.org
List-Id: linux-bcache@vger.kernel.org
To: linux-bcache@vger.kernel.org

arnaud gaboury <arnaud.gaboury@gmail.com> schrieb:

> Here is what I did:
>  # make-bcache -C /dev/sdb1
>  # echo "UUID" > /sys/block/bcache0/bcache/attach
> --------------------------------------
> $ lsblk -o
> .......................
> sdb                      sdb
> =E2=94=94=E2=94=80sdb1                   sdb1    bcache
>   =E2=94=94=E2=94=80bcache0              bcache0
> --------------------------------
> # mkfs.btrfs -L poppy-root /dev/sdb1
> /dev/sdb1 appears to contain an existing filesystem (bcache).
> Error: Use the -f option to force overwrite.
>=20
>=20
> Please may you tell what is wrong and how can I make btrfs on bcached
> partition?

You need to mkfs on /dev/bcache0. Bcache itself reserves the partition =
with=20
its own superblock and creates a subdevice so you cannot accidently acc=
ess=20
the data without passing through the cache layer. This means you will a=
lso=20
mount /dev/bcache0 as your btrfs in fstab (or simply use LABEL=3Dpoppy-=
root or=20
/dev/disk/by-label/...).

If you already overwrote something, I suggest to wipefs first on the=20
partitions, otherwise the kernel may accidently misdetect filesystems t=
hat=20
are no longer there.

--=20
Replies to list only preferred.
