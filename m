From: Killian De Volder <killian.de.volder@megasoft.be>
Subject: Re: bcache wont register cache and attempt to access beyond end of
 device
Date: Wed, 05 Aug 2015 15:03:59 +0200
Message-ID: <55C209BF.1020708@megasoft.be>
References: <CAOOKTyBAb4H1COk4-zmamsR4i4G+oomDQfR7W4vG3opx7mS+6w@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-bcache-owner@vger.kernel.org>
Received: from relay6-d.mail.gandi.net ([217.70.183.198]:47811 "EHLO
	relay6-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751915AbbHENED convert rfc822-to-8bit (ORCPT
	<rfc822;linux-bcache@vger.kernel.org>);
	Wed, 5 Aug 2015 09:04:03 -0400
Received: from mfilter17-d.gandi.net (mfilter17-d.gandi.net [217.70.178.145])
	by relay6-d.mail.gandi.net (Postfix) with ESMTP id 96A82FB8D6
	for <linux-bcache@vger.kernel.org>; Wed,  5 Aug 2015 15:04:01 +0200 (CEST)
Received: from relay6-d.mail.gandi.net ([IPv6:::ffff:217.70.183.198])
	by mfilter17-d.gandi.net (mfilter17-d.gandi.net [::ffff:10.0.15.180]) (amavisd-new, port 10024)
	with ESMTP id NVzr-FVB3EIk for <linux-bcache@vger.kernel.org>;
	Wed,  5 Aug 2015 15:04:00 +0200 (CEST)
Received: from [172.17.0.70] (cable-213-34-255-70.zeelandnet.nl [213.34.255.70])
	(Authenticated sender: killian.de.volder@megasoft.be)
	by relay6-d.mail.gandi.net (Postfix) with ESMTPSA id 27EBAFB8D8
	for <linux-bcache@vger.kernel.org>; Wed,  5 Aug 2015 15:03:59 +0200 (CEST)
In-Reply-To: <CAOOKTyBAb4H1COk4-zmamsR4i4G+oomDQfR7W4vG3opx7mS+6w@mail.gmail.com>
Sender: linux-bcache-owner@vger.kernel.org
List-Id: linux-bcache@vger.kernel.org
To: linux-bcache@vger.kernel.org

If I am not mistaking you have to register the CUID of the chache devic=
e.
Not the block device. (Or it has been fixed.)

Killian De Volder

On 05-08-15 14:52, =D0=93=D0=B5=D0=BE=D1=80=D0=B3=D0=B8=D0=B9 =D0=A1=D1=
=82=D0=B0=D1=80=D0=B8=D0=BA=D0=BE=D0=B2 wrote:
> Hello,
> bcache worked fine until i rebooted server. Now, bcache wont register
> cache device. Backing registered successfully.
> Is there a way to fix it?
> Configuration was : cache - sdc, backing - md0 (md raid6)
>=20
> Details:
>=20
> # echo /dev/sdc > /sys/fs/bcache/register
>=20
> dmesg
> [ 1004.580163] bcache: prio_read() bad csum reading priorities
> [ 1004.580167] bcache: prio_read() bad magic reading priorities
> [ 1004.580497] attempt to access beyond end of device
> [ 1004.580499] sdc: rw=3D48, want=3D12989067124903043072, limit=3D468=
862128
> [ 1004.580501] bcache: error on 4ca0fbc9-d20b-4a3d-bbd1-38d9a5810c27:
> accessing priorities, disabling caching
> [ 1004.582053] bcache: prio_read() bad csum reading priorities
> [ 1004.582055] bcache: prio_read() bad magic reading priorities
> [ 1004.582395] attempt to access beyond end of device
> [ 1004.582397] sdc: rw=3D48, want=3D12989067124903043072, limit=3D468=
862128
> [ 1004.583942] bcache: prio_read() bad csum reading priorities
> [ 1004.583944] bcache: prio_read() bad magic reading priorities
> [ 1004.584997] bcache: register_cache() registered cache device sdc
> [ 1004.585504] bcache: cache_set_free() Cache set
> 4ca0fbc9-d20b-4a3d-bbd1-38d9a5810c27 unregistered
>=20
> # bcache-super-show /dev/sdc
> sb.magic                ok
> sb.first_sector         8 [match]
> sb.csum                 44826230D24195E8 [match]
> sb.version              3 [cache device]
>=20
> dev.label               (empty)
> dev.uuid                cd4241f5-1271-4a1a-a530-58d3ccc2f97e
> dev.sectors_per_block   1
> dev.sectors_per_bucket  1024
> dev.cache.first_sector  1024
> dev.cache.cache_sectors 468860928
> dev.cache.total_sectors 468861952
> dev.cache.ordered       yes
> dev.cache.discard       yes
> dev.cache.pos           0
> dev.cache.replacement   0 [lru]
>=20
> cset.uuid               4ca0fbc9-d20b-4a3d-bbd1-38d9a5810c27
>=20
> # bcache-super-show /dev/md0
> sb.magic                ok
> sb.first_sector         8 [match]
> sb.csum                 F3A7C3593D24C25A [match]
> sb.version              1 [backing device]
>=20
> dev.label               (empty)
> dev.uuid                80bdbcce-f1e1-4af9-a2bd-e4be24067fc5
> dev.sectors_per_block   1
> dev.sectors_per_bucket  1024
> dev.data.first_sector   16
> dev.data.cache_mode     1 [writeback]
> dev.data.cache_state    1 [clean]
>=20
> cset.uuid               4ca0fbc9-d20b-4a3d-bbd1-38d9a5810c27
> --
> To unsubscribe from this list: send the line "unsubscribe linux-bcach=
e" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>=20
