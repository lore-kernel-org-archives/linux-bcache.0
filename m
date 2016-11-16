From: Karl-Philipp Richter <krichter@posteo.de>
Subject: Re: bcachefs bug during file creation and removal
Date: Wed, 16 Nov 2016 11:50:16 +0100
Message-ID: <139a663a-6f2d-3110-4c72-fbeb28a0b386@posteo.de>
References: <99daab89-f7ba-25cb-f20d-503f171e2699@posteo.de>
 <20161115173234.z4gpy5tojxuillmm@kmo-pixel>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="Vioo84hxg2d8pmMTxCrTgWRWECU2XIek7"
Return-path: <linux-bcache-owner@vger.kernel.org>
Received: from mout02.posteo.de ([185.67.36.66]:47491 "EHLO mout02.posteo.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751335AbcKPKuW (ORCPT <rfc822;linux-bcache@vger.kernel.org>);
        Wed, 16 Nov 2016 05:50:22 -0500
Received: from submission (posteo.de [89.146.220.130])
        by mout02.posteo.de (Postfix) with ESMTPS id 409BD20824
        for <linux-bcache@vger.kernel.org>; Wed, 16 Nov 2016 11:50:18 +0100 (CET)
In-Reply-To: <20161115173234.z4gpy5tojxuillmm@kmo-pixel>
Sender: linux-bcache-owner@vger.kernel.org
List-Id: linux-bcache@vger.kernel.org
To: Kent Overstreet <kent.overstreet@gmail.com>
Cc: "linux-bcache@vger.kernel.org" <linux-bcache@vger.kernel.org>

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--Vioo84hxg2d8pmMTxCrTgWRWECU2XIek7
Content-Type: multipart/mixed; boundary="xABVwSKQt1bmqg4Ri7WJQsW0Bt8vboIFo";
 protected-headers="v1"
From: Karl-Philipp Richter <krichter@posteo.de>
To: Kent Overstreet <kent.overstreet@gmail.com>
Cc: "linux-bcache@vger.kernel.org" <linux-bcache@vger.kernel.org>
Message-ID: <139a663a-6f2d-3110-4c72-fbeb28a0b386@posteo.de>
Subject: Re: bcachefs bug during file creation and removal
References: <99daab89-f7ba-25cb-f20d-503f171e2699@posteo.de>
 <20161115173234.z4gpy5tojxuillmm@kmo-pixel>
In-Reply-To: <20161115173234.z4gpy5tojxuillmm@kmo-pixel>

--xABVwSKQt1bmqg4Ri7WJQsW0Bt8vboIFo
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable

Hi,

Am 15.11.2016 um 18:32 schrieb Kent Overstreet:
>> Hi,
>> > During creation of an OpenAFS cache on a bcachefs mount (ca. 1 M fil=
es
>> > and directories) I probably got the error
> The two errors are unrelated. The first warning is spurious - we fall b=
ack to
> vmalloc() if kmalloc() fails, so I'll silence that.
I still get the same warning for a multi-device setup (besides some
different address offsets) followed by

    [  196.220085] bcache: bch_open_as_blockdevs() register_cache_set
err insufficient devices
    [  196.259971] bcache (936fcb06-4a1a-4219-a6ff-eca785c178a0): stopped=


printed after `sudo mount -t bcache [partition device file]
[mountpoint]` (e.g. `sudo mount -t bcache /dev/sdb7 /mnt/data`) after
creating a bcachefs with `sudo bcache format /dev/sda1 /dev/sdb7`. I
don't get the warning if I format only one device and mount it.

I'm not really sure if that's sufficient for a multi-device setup since
I only found https://bcache.evilpiepirate.org/Bcachefs/ explaining a
single partition setup and there's a difference between commands
explained in `man bcache` and `bcache -h` and `bcache -h` isn't
sufficiently helpful to work with the command.

Are you looking for quite naive end-user testers annoying you about
every minor issue in the documentation and command feedback or isn't
bcachefs ready for that yet?

-Kalle


--xABVwSKQt1bmqg4Ri7WJQsW0Bt8vboIFo--

--Vioo84hxg2d8pmMTxCrTgWRWECU2XIek7
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEcBAEBCAAGBQJYLDnoAAoJEGadKJ8eJ7ZG5PYH+gJCZz8qVYo/6EctRBSB44wi
rnbll0OlZr7eHFYKneKeRYNkb6nFwOyWaLhjWWHLyBusvhuRAtAdAzmq6+Bq25oe
eT5DzQc7F5ZTQF7tS1mWwz7UR8/IgGltss1CqAap1rNgN2EfUgAYuzw73DaRZPqf
8RZ5mGHxlvXpLqzdyLiuaZ9Y4jN5Onnvd2fabk4kWvVz0qWWjohIWm+BlIkDbIIq
/wdwfamFZIKgmx+vU5k3yRCh6S448gqhuYYV+1uij30EGCktaMVtd90kBtAg70sl
eL1wIuB0RRPMKDMbqM/QzWHuOVzL9PeOfJx7Byo678jALtsUtXC+oPUfJ5AWEWE=
=/Smq
-----END PGP SIGNATURE-----

--Vioo84hxg2d8pmMTxCrTgWRWECU2XIek7--
