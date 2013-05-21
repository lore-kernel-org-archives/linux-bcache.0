From: matthew patton <pattonme-/E1597aS9LQAvxtiuMwx3w@public.gmane.org>
Subject: Re: speed
Date: Tue, 21 May 2013 06:45:47 -0700 (PDT)
Message-ID: <1369143947.80902.YahooMailClassic@web181504.mail.ne1.yahoo.com>
References: <20130521121928.GO10944@belle.intranet.vanheusden.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-bcache-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20130521121928.GO10944-0UqbV+S8w/00yi0pm118jWr4lhVJriqTmjCW/i4Lttk@public.gmane.org>
Sender: linux-bcache-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-bcache-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, folkert <folkert-Beo89p9qyDM6GGFevw1D/A@public.gmane.org>
List-Id: linux-bcache@vger.kernel.org

> - any suggestions what SSD to buy? e.g. an OCZ Vertex 4?

OCZ is IMO a troubled company and their products are seriously hit/miss=
=2E I would go with Intel, samsung, micron/corsair in that order.

> - are there any suggestions on what size SSD to use for a
> certain size

It all depends on your workload. The "big boys" generally put at least =
5% of backend capacity in SSD. For normal singleton server/desktops you=
'd be hard-pressed to see any value. If you're running virtualized serv=
ers, the combined I/O patterns seen at the central array degenerate to =
random I/O and that is where tiering or Bcache can be useful. The indiv=
idual server running it's virtualized workload might see some benefit t=
oo but probably not to near the same extent. If you're using NFS datast=
ores running FS-cache on the virtual host might be a very useful thing =
but only if the local SSD/fast HD is big enough to grab the entire file=
 since virtual disk files tend to be sizable.

> - is it possible to use more than 1 SSD as a bcache for the
> same =A0 storage?

use LVM segments. ie. put <N> SSDs in a VGpool and then when allocating=
 the LV, specify extent ranges out of some/all of them. When you need t=
o remove the SSD, use pvchange to have LVM vacate the extents on that d=
rive. Then you can remove at will.

> - does bcache work with e.g. iscsi/nbd remote storage?
> =A0 - then maybe it would be nice if it is possible to
> temporarily bring
> =A0 =A0 down the remote-storage + bcache combination
> when the network
> =A0 =A0 connection goes down

If your iSCSI is unreachable your I/O will stall and timeout regardless=
 of any local Bcache. Oh you might get lucky for a couple seconds but a=
fter that, boom. Engineer your network-attached storage correctly.

> - is it possible to swap via bcache?

swap is generally a continuous write, so no. If you're swapping, you ne=
ed to fix the underlying problem, not play games with trying to make sw=
ap "faster". You can ofcourse mount your swap device from something tha=
t is locally attached and cut out the bandwidth and latency of an over-=
the-wire target.

> - does it keep track of checksums/crcs of the data it writes
> to the SSD?
> =A0 e.g. it writes a block to the SSD and then later on
> it reads that
> =A0 block back from the SSD (to write to e.g. HDD) and
> verifies that what
> =A0 it got back is what it expected

No. If you want ZFS' features use that. This whole silent block corrupt=
ion thing is a marketing gimmick by Sun because at some point 10+ years=
 ago they used a family of REALLY buggy controllers. Oh sure, if you've=
 got petabytes on your petabytes you'll run into it eventually. If you =
use crap hardware with half-baked drivers or shitty consumer hardware y=
ou may run into it too. But so you know, the PCIe busses use checksums =
and erasure-coding. As does the SATA/SAS chip when sending it down the =
wire to the drive interface. And the drive itself does checksums and in=
 fact writes the data using erasure coding too. So about the only time =
that 512bytes is just 512bytes of "fragile", unprotected data is when i=
t's in RAM be it system, controller, or disk. Not to say that bit-flips=
 don't happen where the drive miss-writes or miss-reads but the occuran=
ce is vanishingly rare and the drive already has mechanisms to deal wit=
h it.
