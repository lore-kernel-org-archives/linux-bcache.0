From: Johannes Thumshirn <jthumshirn@suse.de>
Subject: Re: bcache_gc: BUG: soft lockup
Date: Fri, 13 Nov 2015 14:05:12 +0100
Message-ID: <1447419912.2616.19.camel@suse.de>
References: <1447418245.2616.15.camel@suse.de>
	 <648d9a0567372b10a3861eee8320328c@rcube.hebserv.net>
	 <7d53afb3c7a34bb1022f0d9b6c079022@rcube.hebserv.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-bcache-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:46464 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752126AbbKMNFO (ORCPT <rfc822;linux-bcache@vger.kernel.org>);
	Fri, 13 Nov 2015 08:05:14 -0500
In-Reply-To: <7d53afb3c7a34bb1022f0d9b6c079022@rcube.hebserv.net>
Sender: linux-bcache-owner@vger.kernel.org
List-Id: linux-bcache@vger.kernel.org
To: Yannis Aribaud <bugs@d6bell.net>, linux-bcache@vger.kernel.org

On Fri, 2015-11-13 at 12:55 +0000, Yannis Aribaud wrote:
> 13 novembre 2015 13:37 "Johannes Thumshirn" <jthumshirn@suse.de> a
> =C3=A9crit:
> > Hi Yannis,
>=20
> Hi Johannes,
>=20
> > [...]
> >=20
> > do you have a stacktrace, so we can see where it's locking up?
>=20
> There is no stack trace as the kernel isn't crashed. But the system
> seems waiting for something that never happens and keep throwing the
> same message to the console (BUG: soft lockup - CPU#22 stuck for
> 23s!).
>=20
>=20

I see. Can you then please force a panic on soft-lockup
via=C2=A0softlockup_panic=3D1 passed to the kernel as a boot parameter =
or via
sysctl -w kernel.softlockup_panic=3D1 on a running system.

Without having any information on where it actually locked up, I see no
chance for fixing it.

Thanks,
	Johannes
