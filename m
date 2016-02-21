From: Kent Overstreet <kent.overstreet@gmail.com>
Subject: Re: Hard to delete/unregister caching device
Date: Sat, 20 Feb 2016 19:17:53 -0900
Message-ID: <20160221041753.GB24735@kmo-pixel>
References: <20160219064857.GA29411@merlins.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-bcache-owner@vger.kernel.org>
Received: from mail-pf0-f178.google.com ([209.85.192.178]:35883 "EHLO
	mail-pf0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751715AbcBURtp (ORCPT
	<rfc822;linux-bcache@vger.kernel.org>);
	Sun, 21 Feb 2016 12:49:45 -0500
Received: by mail-pf0-f178.google.com with SMTP id e127so79591980pfe.3
        for <linux-bcache@vger.kernel.org>; Sun, 21 Feb 2016 09:49:45 -0800 (PST)
Content-Disposition: inline
In-Reply-To: <20160219064857.GA29411@merlins.org>
Sender: linux-bcache-owner@vger.kernel.org
List-Id: linux-bcache@vger.kernel.org
To: Marc MERLIN <marc@merlins.org>
Cc: linux-bcache@vger.kernel.org

On Thu, Feb 18, 2016 at 10:48:57PM -0800, Marc MERLIN wrote:
> So, I have this:
> =E2=94=9C=E2=94=80nvme0n1p4   259:4    0    30G part  bcache         =
          8fd98dbd-4e87-4faa-8cec-d5f1e3910daa ae581b32-8c62-41a9-bfcf-=
ca8cec66e46a
> =E2=94=82 =E2=94=94=E2=94=80bcache0   252:0    0   1.1T disk  crypto_=
LUKS              d6c98ca4-23b4-4aa3-819b-b384d4ac1b6a=20
> =E2=94=82   =E2=94=94=E2=94=80pool2   251:3    0   1.1T crypt btrfs  =
     /mnt/btrfs_p 5ed9d54d-2f12-4735-85c2-e0445a316088=20
> =E2=94=9C=E2=94=80sda7          8:7    0   1.1T part  bcache         =
          6d88cea7-6cfc-4d30-8cf5-8c8b216e019d 753dca8b-07
> =E2=94=82 =E2=94=94=E2=94=80bcache0   252:0    0   1.1T disk  crypto_=
LUKS              d6c98ca4-23b4-4aa3-819b-b384d4ac1b6a=20
> =E2=94=82   =E2=94=94=E2=94=80pool2   251:3    0   1.1T crypt btrfs  =
     /mnt/btrfs_p 5ed9d54d-2f12-4735-85c2-e0445a316088=20
>=20
>=20
> =E2=94=9C=E2=94=80sda6          8:6    0    65G part  bcache         =
          21c07a2c-6ed2-42c2-aafb-8e1bbfa471a5 753dca8b-06
> =E2=94=94=E2=94=80sdb1          8:17   0   1.8T part  bcache         =
          b324cfc4-a5ae-4888-ad6c-a5ba1002fdce 89ba6da8-01
>   =E2=94=94=E2=94=80bcache1   252:1    0   1.8T disk  crypto_LUKS    =
          b519d6ce-291a-4500-937e-a5957e6ece6b=20
>     =E2=94=94=E2=94=80pool3   251:4    0   1.8T crypt btrfs       /mn=
t/btrfs_p 5874cad5-d6dd-4b3d-a455-4e0ae2611f09=20
>=20
> bcache0 is fine
> bcache1 ended up in a bad state, I'm not sure how.
> No biggie, right, just delete/recreate/re-register sda6, except how?
>=20
> https://www.kernel.org/doc/Documentation/bcache.txt
> SYSFS - CACHE DEVICE:
> says nothing about how I can free/release sda6
>=20
> saruman:~# echo /dev/sda6 > /sys/fs/bcache/unregister
> -su: /sys/fs/bcache/unregister: Permission denied
> is not helpful, nothing in kern.log

echo 1 > /sys/fs/bcache/<uuid>/unregister
