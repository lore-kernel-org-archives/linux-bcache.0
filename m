From: "Yannis Aribaud" <bugs@d6bell.net>
Subject: Re: bcache_gc: BUG: soft lockup
Date: Fri, 29 Jan 2016 12:54:32 +0000
Message-ID: <6ee4d38a0d4cfffc288f0ee527ea7d14@rcube.hebserv.net>
References: <20160129115444.GA30565@c203.arch.suse.de>
 <1448626993.2877.112.camel@suse.de>
 <2f979d1d6e991272cebc8ff40a955c8a@rcube.hebserv.net>
 <1447419912.2616.19.camel@suse.de> <1447418245.2616.15.camel@suse.de>
 <648d9a0567372b10a3861eee8320328c@rcube.hebserv.net>
 <7d53afb3c7a34bb1022f0d9b6c079022@rcube.hebserv.net>
 <9c96132d5fce4a5a77b1b086f7c6095d@rcube.hebserv.net>
 <594053ea9538352f4f3e01b954c6080d@rcube.hebserv.net>
 <alpine.LRH.2.11.1511291738340.5445@mail.ewheeler.net>
 <df4137dc888a7058b4b6a290613bf890@rcube.hebserv.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-bcache-owner@vger.kernel.org>
Received: from dbmail.hebserv.net ([78.40.121.80]:45862 "EHLO
	dbmail.hebserv.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751307AbcA2Myf convert rfc822-to-8bit (ORCPT
	<rfc822;linux-bcache@vger.kernel.org>);
	Fri, 29 Jan 2016 07:54:35 -0500
In-Reply-To: <20160129115444.GA30565@c203.arch.suse.de>
Sender: linux-bcache-owner@vger.kernel.org
List-Id: linux-bcache@vger.kernel.org
To: Johannes Thumshirn <jthumshirn@suse.de>
Cc: Eric Wheeler <bcache@lists.ewheeler.net>, linux-bcache@vger.kernel.org, Kent Overstreet <kent.overstreet@gmail.com>

29 janvier 2016 12:54 "Johannes Thumshirn" <jthumshirn@suse.de> a =C3=A9=
crit:
> Hi Yannis,

Hi Johannes,

> Do you have a machine with a bcache setup running where you can repro=
duce the
> error? Or do you know a method to reproduce the error?

I don't know how to reproduce this issue. As I told the server was runn=
ing=20
correctly in production for more than 6 weeks when the problem appeared=
=2E
This server is still running Bcache in production for now...

No idea what trigger this :/

> What I'd be interested in is which locks are held when it locks up (y=
ou can
> acquire this information with SysRq+d or echo d > /proc/sysrq-trigger=
=2E

I'll try to get those informations if the bug strikes again.

Regards,

--=20
Open is better
