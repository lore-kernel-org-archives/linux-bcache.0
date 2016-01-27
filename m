From: "Yannis Aribaud" <bugs@d6bell.net>
Subject: Re: bcache_gc: BUG: soft lockup
Date: Wed, 27 Jan 2016 14:57:25 +0000
Message-ID: <df4137dc888a7058b4b6a290613bf890@rcube.hebserv.net>
References: <c5d6be2727642ec01b53cd8d28c962bf@rcube.hebserv.net>
 <06d43fd0101a31a3a3bd4896ba50e4cc@rcube.hebserv.net>
 <20151130070743.11343yqeihgbzfsv@imap.suse.de>
 <1448626993.2877.112.camel@suse.de>
 <2f979d1d6e991272cebc8ff40a955c8a@rcube.hebserv.net>
 <1447419912.2616.19.camel@suse.de> <1447418245.2616.15.camel@suse.de>
 <648d9a0567372b10a3861eee8320328c@rcube.hebserv.net>
 <7d53afb3c7a34bb1022f0d9b6c079022@rcube.hebserv.net>
 <9c96132d5fce4a5a77b1b086f7c6095d@rcube.hebserv.net>
 <594053ea9538352f4f3e01b954c6080d@rcube.hebserv.net>
 <alpine.LRH.2.11.1511291738340.5445@mail.ewheeler.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-bcache-owner@vger.kernel.org>
Received: from dbmail.hebserv.net ([78.40.121.80]:43862 "EHLO
	dbmail.hebserv.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933280AbcA0PG0 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-bcache@vger.kernel.org>);
	Wed, 27 Jan 2016 10:06:26 -0500
In-Reply-To: <c5d6be2727642ec01b53cd8d28c962bf@rcube.hebserv.net>
Sender: linux-bcache-owner@vger.kernel.org
List-Id: linux-bcache@vger.kernel.org
To: Johannes Thumshirn <jthumshirn@suse.de>, Eric Wheeler <bcache@lists.ewheeler.net>
Cc: linux-bcache@vger.kernel.org

Hi,

After several weeks using the 4.2.6 kernel + patches from Ewheeler we j=
ust ran into a crash again.
This time the kernel was still running and the server was responsive bu=
t not able to do any IO on the bcache devices.

[696983.683498] bcache_writebac D ffffffff810643df     0  5741      2 0=
x00000000
[696983.683505]  ffff88103d01f180 0000000000000046 ffff88107842d000 fff=
fffff811a95cd
[696983.683510]  0000000000000000 ffff8810388c4000 ffff88103d01f180 000=
0000000000001
[696983.683514]  ffff882034ae0c10 0000000000000000 ffff882034ae0000 fff=
fffff8139601e
[696983.683518] Call Trace:
[696983.683530]  [<ffffffff811a95cd>] ? blk_queue_bio+0x262/0x279
[696983.683539]  [<ffffffff8139601e>] ? schedule+0x6b/0x78
[696983.683553]  [<ffffffffa032ce9b>] ? closure_sync+0x66/0x91 [bcache]
[696983.683563]  [<ffffffffa033c89f>] ? bch_writeback_thread+0x622/0x6b=
5 [bcache]
[696983.683569]  [<ffffffff8100265c>] ? __switch_to+0x1de/0x3f7
[696983.683578]  [<ffffffffa033c89f>] ? bch_writeback_thread+0x622/0x6b=
5 [bcache]
[696983.683586]  [<ffffffffa033c27d>] ? write_dirty_finish+0x1bf/0x1bf =
[bcache]
[696983.683594]  [<ffffffff810589d6>] ? kthread+0x99/0xa1
[696983.683598]  [<ffffffff8105893d>] ? kthread_parkme+0x16/0x16
[696983.683603]  [<ffffffff813986df>] ? ret_from_fork+0x3f/0x70
[696983.683607]  [<ffffffff8105893d>] ? kthread_parkme+0x16/0x16

Don't know if this help.
Unfortunately I thing that we will rollback and stop using Bcache unles=
s this is really fixed :/

Regards,

7 d=C3=A9cembre 2015 11:35 "Yannis Aribaud" <bugs@d6bell.net> a =C3=A9c=
rit:
> Hi everyone,
>=20
> It's been one week I'm using a 4.2.6 kernel merged with the Bcache pa=
tches from Ewheeler and no
> signs of any kind of trouble I had before.
> Thus it seems your patches fix my soft lockup issue.
> It's currently running on one of my ceph nodes, I will certainly push=
 it on the others during the
> next weeks.
>=20
> It would be great to merge thoses patches upstream since it seems tha=
t using Bcache in production
> requires those fixes.
>=20
> Anyway, thanks to all of you for your time, advices and work on Bcach=
e. I'll keep you updated.
>=20
> Regards,
> --=20
> Open is better
--=20
Open is better
