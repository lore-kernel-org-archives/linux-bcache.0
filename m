From: matthew patton <pattonme@yahoo.com>
Subject: Re: [Scst-devel] How important is bcache cache device in write-thru mode? (was Re: Tiered bcache)
Date: Tue, 28 Jan 2014 07:45:31 -0800 (PST)
Message-ID: <1390923931.67583.YahooMailNeo@web181502.mail.ne1.yahoo.com>
References: Patrick Zwahlen <paz@navixia.com> "RE: How important is bcache cache device in write-thru mode? (was Re: Tiered bcache)" (Jan 21, 6:44pm) <201401281420.s0SEK0sb008045@wind.enjellic.com>
Reply-To: matthew patton <pattonme@yahoo.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-bcache-owner@vger.kernel.org>
Received: from nm14.access.bullet.mail.gq1.yahoo.com ([216.39.62.45]:26811
	"EHLO nm14.access.bullet.mail.gq1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755118AbaA1Pv2 convert rfc822-to-8bit
	(ORCPT <rfc822;linux-bcache@vger.kernel.org>);
	Tue, 28 Jan 2014 10:51:28 -0500
In-Reply-To: <201401281420.s0SEK0sb008045@wind.enjellic.com>
Sender: linux-bcache-owner@vger.kernel.org
List-Id: linux-bcache@vger.kernel.org
To: "linux-bcache@vger.kernel.org" <linux-bcache@vger.kernel.org>
Cc: "scst-devel@lists.sourceforge.net" <scst-devel@lists.sourceforge.net>

<quote>
SCST using FILEIO is blindingly fast but I don't know of any serious
storage architects that are going to trust 50-60 gigabytes of a
database or filesystem to the Linux pagecache and associated vagaries
of VM writeback behavior.
</quote>

Maybe it's not much and with memory footprints that big, my solution is=
 too small. But why not write the EXT3/4 journal to a NVRAM board? The =
512MB ones are pretty darn cheap on EBAY. I've got a fistful myself. If=
 you journal meta+data at least you have recovery points. Otherwise a R=
AID set of high-quality SSD could be a reliable journal, no?

Linux VFS has lots of tunables, and I think you'd be able to find a hap=
py medium between absorbing sudden, big writes, and reliably de-staging=
 to disk. I wish EXT4/XFS et. al. had the ability to do round-robbin jo=
urnaling ala Oracle LogWriter so that once the first chunk of ~256MB wa=
s written to the journal everything didn't come to a screeching stop un=
til the corresponding bits got written out to 'permanent' storage. But =
I guess at that point maybe the answer is to use ZFS?

>=A0block based interface to RAM

I could have sworn there already was such a driver...Yeah 'brd'. Did th=
at not fit the intended use?
http://www.cs.fsu.edu/~baker/devices/lxr/http/source/linux/drivers/bloc=
k/brd.c

and another exercise
http://www.linuxforu.com/2012/02/device-drivers-disk-on-ram-block-drive=
rs/


though this one is probably more interesting yet
http://rapiddisk.org/index.php?title=3DChangelog

http://rapiddisk.org/index.php?title=3DRapidCache
