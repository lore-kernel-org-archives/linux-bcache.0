From: Vojtech Pavlik <vojtech@suse.com>
Subject: Re: Bcache stuck at writeback of a key, consuming 100% CPU, not
 possible to detach
Date: Mon, 31 Aug 2015 17:54:15 +0200
Message-ID: <20150831155415.GA7394@suse.com>
References: <20150830085442.GA31722@suse.com>
 <20150831163937.00ca3f7a@harpe.intellique.com>
 <20150831144949.GA3276@suse.com>
 <20150831170928.56fa9bbd@harpe.intellique.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-bcache-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:34150 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753125AbbHaPyR (ORCPT <rfc822;linux-bcache@vger.kernel.org>);
	Mon, 31 Aug 2015 11:54:17 -0400
Content-Disposition: inline
In-Reply-To: <20150831170928.56fa9bbd@harpe.intellique.com>
Sender: linux-bcache-owner@vger.kernel.org
List-Id: linux-bcache@vger.kernel.org
To: Emmanuel Florac <eflorac@intellique.com>
Cc: kmo@daterainc.com, linux-bcache@vger.kernel.org

On Mon, Aug 31, 2015 at 05:09:28PM +0200, Emmanuel Florac wrote:
> Le Mon, 31 Aug 2015 16:49:49 +0200
> Vojtech Pavlik <vojtech@suse.cz> =C3=A9crivait:
>=20
> > >=20
> > > The bcache_writeback stays at 100% _even_ when in writethrough mo=
de,
> > > alas. So this looks normal. However dirty_data definitely should
> > > drop to zero... =20
> >=20
> > This most certainly isn't normal. The ftrace shows it's looping in =
a
> > loop doing nothing useful.
> >=20
>=20
> Yep, I've had a quick look at the code, however it's not very
> inspiring. It very much looks like there's a missing test. From your
> trace it looks like it finds a key_bad (?) -- from the struct
> bch_extent_keys_ops in bcache/extents.c -- but there is no code anywh=
ere
> to manage this case apparently.
>=20
> Ah, and I can't download your complete trace, too : twilight.ucw.cz
> isn't responding. :)

Sadly, the bcache array crashed hard earlier today (with a bug in  and =
the machine
doesn't boot anymore. I'm recovering it now.

--=20
Vojtech Pavlik
Director SuSE Labs
