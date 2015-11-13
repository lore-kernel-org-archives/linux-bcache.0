From: "Yannis Aribaud" <bugs@d6bell.net>
Subject: Re: bcache_gc: BUG: soft lockup
Date: Fri, 13 Nov 2015 13:27:43 +0000
Message-ID: <2f979d1d6e991272cebc8ff40a955c8a@rcube.hebserv.net>
References: <1447419912.2616.19.camel@suse.de>
 <1447418245.2616.15.camel@suse.de>
 <648d9a0567372b10a3861eee8320328c@rcube.hebserv.net>
 <7d53afb3c7a34bb1022f0d9b6c079022@rcube.hebserv.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-bcache-owner@vger.kernel.org>
Received: from dbmail.hebserv.net ([78.40.121.80]:33300 "EHLO
	dbmail.hebserv.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754334AbbKMN1s convert rfc822-to-8bit (ORCPT
	<rfc822;linux-bcache@vger.kernel.org>);
	Fri, 13 Nov 2015 08:27:48 -0500
In-Reply-To: <1447419912.2616.19.camel@suse.de>
Sender: linux-bcache-owner@vger.kernel.org
List-Id: linux-bcache@vger.kernel.org
To: Johannes Thumshirn <jthumshirn@suse.de>, linux-bcache@vger.kernel.org

13 novembre 2015 14:05 "Johannes Thumshirn" <jthumshirn@suse.de> a =C3=A9=
crit:
> I see. Can you then please force a panic on soft-lockup
> via softlockup_panic=3D1 passed to the kernel as a boot parameter or =
via
> sysctl -w kernel.softlockup_panic=3D1 on a running system.

Ok I'll try to reproduce it with this option set.


--=20
Open is better
