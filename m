From: Emmanuel Florac <eflorac@intellique.com>
Subject: Re: Bcache stuck at writeback of a key, consuming 100% CPU, not
 possible to detach
Date: Mon, 31 Aug 2015 17:09:28 +0200
Message-ID: <20150831170928.56fa9bbd@harpe.intellique.com>
References: <20150830085442.GA31722@suse.com>
	<20150831163937.00ca3f7a@harpe.intellique.com>
	<20150831144949.GA3276@suse.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-bcache-owner@vger.kernel.org>
Received: from smtp5-g21.free.fr ([212.27.42.5]:53458 "EHLO smtp5-g21.free.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753226AbbHaPJZ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-bcache@vger.kernel.org>);
	Mon, 31 Aug 2015 11:09:25 -0400
In-Reply-To: <20150831144949.GA3276@suse.com>
Sender: linux-bcache-owner@vger.kernel.org
List-Id: linux-bcache@vger.kernel.org
To: Vojtech Pavlik <vojtech@suse.cz>
Cc: kmo@daterainc.com, linux-bcache@vger.kernel.org

Le Mon, 31 Aug 2015 16:49:49 +0200
Vojtech Pavlik <vojtech@suse.cz> =C3=A9crivait:

> >=20
> > The bcache_writeback stays at 100% _even_ when in writethrough mode=
,
> > alas. So this looks normal. However dirty_data definitely should
> > drop to zero... =20
>=20
> This most certainly isn't normal. The ftrace shows it's looping in a
> loop doing nothing useful.
>=20

Yep, I've had a quick look at the code, however it's not very
inspiring. It very much looks like there's a missing test. From your
trace it looks like it finds a key_bad (?) -- from the struct
bch_extent_keys_ops in bcache/extents.c -- but there is no code anywher=
e
to manage this case apparently.

Ah, and I can't download your complete trace, too : twilight.ucw.cz
isn't responding. :)

--=20
-----------------------------------------------------------------------=
-
Emmanuel Florac     |   Direction technique
                    |   Intellique
                    |	<eflorac@intellique.com>
                    |   +33 1 78 94 84 02
-----------------------------------------------------------------------=
-
