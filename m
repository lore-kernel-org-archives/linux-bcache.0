From: "Yannis Aribaud" <bugs@d6bell.net>
Subject: Re: bcache_writeback: bch_writeback_thread...blk_queue_bio IO
 hang [was BUG: soft lockup]
Date: Tue, 02 Feb 2016 07:58:24 +0000
Message-ID: <c110be9e2bccb346cf07c76f29a95a06@rcube.hebserv.net>
References: <alpine.LRH.2.11.1602011108460.21204@mail.ewheeler.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-bcache-owner@vger.kernel.org>
Received: from dbmail.hebserv.net ([78.40.121.80]:52610 "EHLO
	dbmail.hebserv.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751261AbcBBH61 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-bcache@vger.kernel.org>);
	Tue, 2 Feb 2016 02:58:27 -0500
In-Reply-To: <alpine.LRH.2.11.1602011108460.21204@mail.ewheeler.net>
Sender: linux-bcache-owner@vger.kernel.org
List-Id: linux-bcache@vger.kernel.org
To: Eric Wheeler <bcache@lists.ewheeler.net>, Johannes Thumshirn <jthumshirn@suse.de>
Cc: linux-bcache@vger.kernel.org, Kent Overstreet <kent.overstreet@gmail.com>, linux-kernel@vger.kernel.org, vojtech@suse.com

Hi,

1 f=C3=A9vrier 2016 20:42 "Eric Wheeler" <bcache@lists.ewheeler.net> a =
=C3=A9crit:
> [ changed subject, more below ]

> Are you using md-based raid5/raid6?

Not at all. In my setup Bcache is used on two bare drives (HDD and SSD)=
=20
behing a hardware RAID controller (disks configured in non-RAID mode).

>=20
> If so, it could be the raid_partial_stripes_expensive bug.
>=20
> If it *is* the bcache optimizations around partial_stripes_expensive,=
 then
> please try the patch below and then do this *before* loading the bcac=
he
> module (or at least before registering the bcache backing volume):
> echo 0 > /sys/block/BLK/queue/limits/raid_partial_stripes_expensive
> where BLK is your backing volume.
>=20
> I wrote this patch because we use hardware RAID5/6 and wanted to get =
the
> partial_stripes_expensive optimizations on by setting
> raid_partial_stripes_expensive=3D1 and io_opt=3Dour_stride_width.
> Unfortunately it caused the backtrace in the LKML thread below, so we
> stopped using it.
>=20
> See also this thread, however, it shows a backtrace prior to
> removing the bio splitting code:
> https://lkml.org/lkml/2016/1/7/844

I'll take a look.

> Note that commit 749b61dab30736eb95b1ee23738cae90973d4fc3 might not
> exactly address this issue, but it might prevent full hangs. Make sur=
e
> you cherry-pick commit 749b61dab30736eb95b1ee23738cae90973d4fc3 and
> hand-clean-up as necessary. It simplifies the bio code and deletes a =
bunch
> of stuff. It showed up in 4.4 and isn't in my patchset.
>=20
> After commit the commit above and setting
> raid_partial_stripes_expensive=3D1
> we still get errors like this:
> bcache: bch_count_io_errors() dm-3: IO error on writing data to cache=
,
> recovering but they don't lock up the system. Ultimately we run with
> raid_partial_stripes_expensive=3D0 because of these related problemsa=
nd
> haven't had any issues. Also, fwiw, we run 4.1.y as our stable branch
> backed by hardware raid.

I'll give a try if find some time to do so.

Thks.
--=20
Open is better
