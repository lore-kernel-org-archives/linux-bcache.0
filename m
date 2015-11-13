From: "Yannis Aribaud" <bugs@d6bell.net>
Subject: Re: bcache_gc: BUG: soft lockup
Date: Fri, 13 Nov 2015 12:55:17 +0000
Message-ID: <7d53afb3c7a34bb1022f0d9b6c079022@rcube.hebserv.net>
References: <1447418245.2616.15.camel@suse.de>
 <648d9a0567372b10a3861eee8320328c@rcube.hebserv.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-bcache-owner@vger.kernel.org>
Received: from dbmail.hebserv.net ([78.40.121.80]:33152 "EHLO
	dbmail.hebserv.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751939AbbKMMzV convert rfc822-to-8bit (ORCPT
	<rfc822;linux-bcache@vger.kernel.org>);
	Fri, 13 Nov 2015 07:55:21 -0500
In-Reply-To: <1447418245.2616.15.camel@suse.de>
Sender: linux-bcache-owner@vger.kernel.org
List-Id: linux-bcache@vger.kernel.org
To: Johannes Thumshirn <jthumshirn@suse.de>, linux-bcache@vger.kernel.org

13 novembre 2015 13:37 "Johannes Thumshirn" <jthumshirn@suse.de> a =C3=A9=
crit:
> Hi Yannis,

Hi Johannes,

> [...]
>=20
> do you have a stacktrace, so we can see where it's locking up?

There is no stack trace as the kernel isn't crashed. But the system see=
ms waiting for something that never happens and keep throwing the same =
message to the console (BUG: soft lockup - CPU#22 stuck for 23s!).


--=20
Open is better
