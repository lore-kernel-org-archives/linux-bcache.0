From: Michele Brodoloni <mik.linux@gmail.com>
Subject: Re: bcache on shared storage
Date: Mon, 26 Sep 2016 08:09:23 +0200
Message-ID: <D0761DB0-DCF7-400D-AA08-0E966C2D6E0C@gmail.com>
References: <ns990l$c9$1@blaine.gmane.org> <alpine.LRH.2.11.1609251543210.29933@mail.ewheeler.net>
Mime-Version: 1.0 (1.0)
Content-Type: text/plain;
        charset=us-ascii
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-bcache-owner@vger.kernel.org>
Received: from mail-wm0-f52.google.com ([74.125.82.52]:35372 "EHLO
        mail-wm0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752313AbcIZGJ2 (ORCPT
        <rfc822;linux-bcache@vger.kernel.org>);
        Mon, 26 Sep 2016 02:09:28 -0400
Received: by mail-wm0-f52.google.com with SMTP id l132so132071222wmf.0
        for <linux-bcache@vger.kernel.org>; Sun, 25 Sep 2016 23:09:28 -0700 (PDT)
In-Reply-To: <alpine.LRH.2.11.1609251543210.29933@mail.ewheeler.net>
Sender: linux-bcache-owner@vger.kernel.org
List-Id: linux-bcache@vger.kernel.org
To: Eric Wheeler <bcache@lists.ewheeler.net>
Cc: "linux-bcache@vger.kernel.org" <linux-bcache@vger.kernel.org>

Hi Eric,
thank you for your reply.

The shared storage will have LVM on top and each node will have RW access on=
ly to its own LVs (actually, these will be the virtual disks of the vms runn=
ing on each node), this is meant to say that each node is likely going to ac=
cess different data -- unless a vm is migrated between nodes (??). Does this=
 change anything?

Unfortunately, exporting luns via iSCSI/AoE is not an option since I'm going=
 to use a DELL VRTX and the storage is provided by a DAS, where there will b=
e both rotational and solid-state disks.=20

Regards,
Michele



> Il giorno 26/set/2016, alle ore 00:47, Eric Wheeler <bcache@lists.ewheeler=
.net> ha scritto:
>=20
>> On Sun, 25 Sep 2016, Michele wrote:
>>=20
>> Hello everybody,
>>=20
>> I have a KVM virtualization cluster (3 nodes) which shares the same=20
>> storage. It would be possible to attach a caching device on each node to=20=

>> that storage?
>>=20
>> Let me explain better: I intend to create a raid-0 with two SSDs on each=20=

>> node as WT caching devices, then initialize the shared storage as bcache=20=

>> backing device, and then attach the caching device on each node to it.
>>=20
>> Is this going to work?
>=20
> No.  Even in writethrough mode, remote writes of one node would hit the=20=

> lower layer creating stale writethrough caches on the other nodes---that=20=

> is unless you would like to implement distributed cache coherency using=20=

> DLM.  That would be quite interesting!
>=20
> You could share bcache0 to multiple nodes if you control its export via=20=

> iSCSI or AoE and place a shared filesystem (gfs, ocfs, cLVM, etc) atop of=20=

> the exported volume.  I'm not sure if it has been tested, but it would be=20=

> neat to get feadback on the subject.
>=20
> --
> Eric Wheeler
>=20
>=20
>>=20
>>=20
>> Thanks,
>> Michele
>>=20
>>=20
>> --
>> Newsy for iOS
>> Download on the App Store:
>> https://itunes.apple.com/app/newsy/id598711199
>>=20
>>=20
>>=20
>>=20
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-bcache" i=
n
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>>=20
