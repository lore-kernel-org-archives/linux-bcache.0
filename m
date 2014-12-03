From: Stefan Seyfried <stefan.seyfried@googlemail.com>
Subject: Re: 3.17-rc6: bcache_gc: BUG: soft lockup - CPU#2 stuck for 23s!
Date: Wed, 03 Dec 2014 10:32:17 +0100
Message-ID: <547ED8A1.5050706@message-id.googlemail.com>
References: <alpine.DEB.2.00.1409281651340.15834@ware.dreamhost.com>  <20141101204447.GB22219@kmo-pixel>  <546FC2B4.5020201@message-id.invalid.com>  <CALJ65znHdPCoYLKuGXrRtg9aUkoKgxmOVn=Bw04WP5f=Vt_DxA@mail.gmail.com> <1416615728.4084.325.camel@geekdesk.ewheeler.net> <5470858B.9090900@message-id.googlemail.com> <alpine.DEB.2.02.1411241049410.18167@ware.dreamhost.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-bcache-owner@vger.kernel.org>
Received: from mail-wg0-f43.google.com ([74.125.82.43]:36652 "EHLO
	mail-wg0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752255AbaLCJcW (ORCPT
	<rfc822;linux-bcache@vger.kernel.org>);
	Wed, 3 Dec 2014 04:32:22 -0500
Received: by mail-wg0-f43.google.com with SMTP id l18so19506749wgh.2
        for <linux-bcache@vger.kernel.org>; Wed, 03 Dec 2014 01:32:20 -0800 (PST)
In-Reply-To: <alpine.DEB.2.02.1411241049410.18167@ware.dreamhost.com>
Sender: linux-bcache-owner@vger.kernel.org
List-Id: linux-bcache@vger.kernel.org
To: Eric Wheeler <bcache@lists.ewheeler.net>
Cc: Kent Overstreet <kmo@daterainc.com>, "linux-bcache@vger.kernel.org" <linux-bcache@vger.kernel.org>, Ross Anderson <rosander@dsotm.net>, Stefan Priebe <s.priebe@profihost.ag>

Hi all,

Am 24.11.2014 um 19:52 schrieb Eric Wheeler:
>>>> Before the patch goes upstream I need it tested so I know if it fi=
xes
>>>> the actual issue or not.
>>>
>>> We have been using the rcu_sched patch and the cond_resched patch
>>> together
>>> (both attached) since November 3rd on 3.17.2 without any bcache
>>> backtraces. bcache is running in writeback mode. The server is
>>> predominantly write-only with relatively few reads.
>>
>> Is the rcu_sched patch supposed to help the same or a totally differ=
ent
>> problem? Means: should I also apply it, rebuild the module and reboo=
t
>> (resetting the test time to zero :-)

Ok, I am also running both patches, my uptime is 10 days and I'm right
now doing a bit of the usual stress-testing on the bcached partitions
(find /m1 /m2 /m3 > /dev/null which does read-mostly, and a rebuild of
all my yocto-project embedded board targets, which does read-write)

I have not seen any problems yet, so the patches don't seem to hurt.

>> I had the "deadly" soft lockup once per week since updating to
>> 3.16/3.17, so I can only tell if it might help in two weeks earliest=
=2E

It's not two weeks yet, but getting close.

Load average never goes below 1 (with 3 bcache-backed mounts).

Best regards,

	Stefan
--=20
Stefan Seyfried
Linux Consultant & Developer -- GPG Key: 0x731B665B

B1 Systems GmbH
Osterfeldstra=C3=9Fe 7 / 85088 Vohburg / http://www.b1-systems.de
GF: Ralph Dehner / Unternehmenssitz: Vohburg / AG: Ingolstadt,HRB 3537
