From: Stefan Seyfried <stefan.seyfried@googlemail.com>
Subject: Re: 3.17-rc6: bcache_gc: BUG: soft lockup - CPU#2 stuck for 23s!
Date: Sat, 22 Nov 2014 13:46:03 +0100
Message-ID: <5470858B.9090900@message-id.googlemail.com>
References: <alpine.DEB.2.00.1409281651340.15834@ware.dreamhost.com>	 <20141101204447.GB22219@kmo-pixel>	 <546FC2B4.5020201@message-id.invalid.com>	 <CALJ65znHdPCoYLKuGXrRtg9aUkoKgxmOVn=Bw04WP5f=Vt_DxA@mail.gmail.com> <1416615728.4084.325.camel@geekdesk.ewheeler.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-bcache-owner@vger.kernel.org>
Received: from mail-wi0-f177.google.com ([209.85.212.177]:47368 "EHLO
	mail-wi0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750822AbaKVMqI (ORCPT
	<rfc822;linux-bcache@vger.kernel.org>);
	Sat, 22 Nov 2014 07:46:08 -0500
Received: by mail-wi0-f177.google.com with SMTP id l15so1721446wiw.10
        for <linux-bcache@vger.kernel.org>; Sat, 22 Nov 2014 04:46:06 -0800 (PST)
In-Reply-To: <1416615728.4084.325.camel@geekdesk.ewheeler.net>
Sender: linux-bcache-owner@vger.kernel.org
List-Id: linux-bcache@vger.kernel.org
To: Eric Wheeler <ewheeler@ewheeler.net>, Kent Overstreet <kmo@daterainc.com>
Cc: "linux-bcache@vger.kernel.org" <linux-bcache@vger.kernel.org>, Ross Anderson <rosander@dsotm.net>, Stefan Priebe <s.priebe@profihost.ag>

Hi Eric,

Am 22.11.2014 um 01:22 schrieb Eric Wheeler:
>> Before the patch goes upstream I need it tested so I know if it fixe=
s=20
>> the actual issue or not.
>=20
> We have been using the rcu_sched patch and the cond_resched patch tog=
ether=20
> (both attached) since November 3rd on 3.17.2 without any bcache=20
> backtraces. bcache is running in writeback mode. The server is=20
> predominantly write-only with relatively few reads.

Is the rcu_sched patch supposed to help the same or a totally different
problem? Means: should I also apply it, rebuild the module and reboot
(resetting the test time to zero :-)

I had the "deadly" soft lockup once per week since updating to
3.16/3.17, so I can only tell if it might help in two weeks earliest.

> To sum up, the attached two patches (plus the for-jens pull) have fix=
ed all
> of our bcache problems since 3.14.y.  These patches on 3.17.2 seem qu=
ite stable.

That's good to hear :-)

Best regards,

	Stefan
--=20
Stefan Seyfried
Linux Consultant & Developer -- GPG Key: 0x731B665B

B1 Systems GmbH
Osterfeldstra=C3=9Fe 7 / 85088 Vohburg / http://www.b1-systems.de
GF: Ralph Dehner / Unternehmenssitz: Vohburg / AG: Ingolstadt,HRB 3537
