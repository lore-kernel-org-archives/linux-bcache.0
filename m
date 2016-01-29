From: Johannes Thumshirn <jthumshirn@suse.de>
Subject: Re: bcache_gc: BUG: soft lockup
Date: Fri, 29 Jan 2016 12:54:44 +0100
Message-ID: <20160129115444.GA30565@c203.arch.suse.de>
References: <1448626993.2877.112.camel@suse.de>
 <2f979d1d6e991272cebc8ff40a955c8a@rcube.hebserv.net>
 <1447419912.2616.19.camel@suse.de>
 <1447418245.2616.15.camel@suse.de>
 <648d9a0567372b10a3861eee8320328c@rcube.hebserv.net>
 <7d53afb3c7a34bb1022f0d9b6c079022@rcube.hebserv.net>
 <9c96132d5fce4a5a77b1b086f7c6095d@rcube.hebserv.net>
 <594053ea9538352f4f3e01b954c6080d@rcube.hebserv.net>
 <alpine.LRH.2.11.1511291738340.5445@mail.ewheeler.net>
 <df4137dc888a7058b4b6a290613bf890@rcube.hebserv.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-bcache-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:48351 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752277AbcA2Lyv (ORCPT <rfc822;linux-bcache@vger.kernel.org>);
	Fri, 29 Jan 2016 06:54:51 -0500
Content-Disposition: inline
In-Reply-To: <df4137dc888a7058b4b6a290613bf890@rcube.hebserv.net>
Sender: linux-bcache-owner@vger.kernel.org
List-Id: linux-bcache@vger.kernel.org
To: Yannis Aribaud <bugs@d6bell.net>
Cc: Eric Wheeler <bcache@lists.ewheeler.net>, linux-bcache@vger.kernel.org, Kent Overstreet <kent.overstreet@gmail.com>

[ +cc Kent ]

On Wed, Jan 27, 2016 at 02:57:25PM +0000, Yannis Aribaud wrote:
> Hi,
>=20
> After several weeks using the 4.2.6 kernel + patches from Ewheeler we=
 just ran into a crash again.
> This time the kernel was still running and the server was responsive =
but not able to do any IO on the bcache devices.
>=20
> [696983.683498] bcache_writebac D ffffffff810643df     0  5741      2=
 0x00000000
> [696983.683505]  ffff88103d01f180 0000000000000046 ffff88107842d000 f=
fffffff811a95cd
> [696983.683510]  0000000000000000 ffff8810388c4000 ffff88103d01f180 0=
000000000000001
> [696983.683514]  ffff882034ae0c10 0000000000000000 ffff882034ae0000 f=
fffffff8139601e
> [696983.683518] Call Trace:
> [696983.683530]  [<ffffffff811a95cd>] ? blk_queue_bio+0x262/0x279
> [696983.683539]  [<ffffffff8139601e>] ? schedule+0x6b/0x78
> [696983.683553]  [<ffffffffa032ce9b>] ? closure_sync+0x66/0x91 [bcach=
e]
> [696983.683563]  [<ffffffffa033c89f>] ? bch_writeback_thread+0x622/0x=
6b5 [bcache]
> [696983.683569]  [<ffffffff8100265c>] ? __switch_to+0x1de/0x3f7
> [696983.683578]  [<ffffffffa033c89f>] ? bch_writeback_thread+0x622/0x=
6b5 [bcache]
> [696983.683586]  [<ffffffffa033c27d>] ? write_dirty_finish+0x1bf/0x1b=
f [bcache]
> [696983.683594]  [<ffffffff810589d6>] ? kthread+0x99/0xa1
> [696983.683598]  [<ffffffff8105893d>] ? kthread_parkme+0x16/0x16
> [696983.683603]  [<ffffffff813986df>] ? ret_from_fork+0x3f/0x70
> [696983.683607]  [<ffffffff8105893d>] ? kthread_parkme+0x16/0x16
>=20
> Don't know if this help.
> Unfortunately I thing that we will rollback and stop using Bcache unl=
ess this is really fixed :/
>=20

Hi Yannis,

Do you have a machine with a bcache setup running where you can reprodu=
ce the
error? Or do you know a method to reproduce the error?

What I'd be interested in is which locks are held when it locks up (you=
 can
acquire this information with SysRq+d or echo d > /proc/sysrq-trigger.

Kent, do you have an idea what's happening here?

> Regards,
>=20
> 7 d=E9cembre 2015 11:35 "Yannis Aribaud" <bugs@d6bell.net> a =E9crit:
> > Hi everyone,
> >=20
> > It's been one week I'm using a 4.2.6 kernel merged with the Bcache =
patches from Ewheeler and no
> > signs of any kind of trouble I had before.
> > Thus it seems your patches fix my soft lockup issue.
> > It's currently running on one of my ceph nodes, I will certainly pu=
sh it on the others during the
> > next weeks.
> >=20
> > It would be great to merge thoses patches upstream since it seems t=
hat using Bcache in production
> > requires those fixes.
> >=20
> > Anyway, thanks to all of you for your time, advices and work on Bca=
che. I'll keep you updated.
> >=20
> > Regards,
> > --=20
> > Open is better
> --=20
> Open is better

--=20
Johannes Thumshirn                                          Storage
jthumshirn@suse.de                                +49 911 74053 689
SUSE LINUX GmbH, Maxfeldstr. 5, 90409 N=FCrnberg
GF: Felix Imend=F6rffer, Jane Smithard, Graham Norton
HRB 21284 (AG N=FCrnberg)
Key fingerprint =3D EC38 9CAB C2C4 F25D 8600 D0D0 0393 969D 2D76 0850
