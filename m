From: Eric Wheeler <bcache@lists.ewheeler.net>
Subject: Re: 3.17-rc6: bcache_gc: BUG: soft lockup - CPU#2 stuck for 23s!
Date: Mon, 24 Nov 2014 10:52:40 -0800 (PST)
Message-ID: <alpine.DEB.2.02.1411241049410.18167@ware.dreamhost.com>
References: <alpine.DEB.2.00.1409281651340.15834@ware.dreamhost.com>  <20141101204447.GB22219@kmo-pixel>  <546FC2B4.5020201@message-id.invalid.com>  <CALJ65znHdPCoYLKuGXrRtg9aUkoKgxmOVn=Bw04WP5f=Vt_DxA@mail.gmail.com> <1416615728.4084.325.camel@geekdesk.ewheeler.net>
 <5470858B.9090900@message-id.googlemail.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Return-path: <linux-bcache-owner@vger.kernel.org>
Received: from homie.mail.dreamhost.com ([208.97.132.208]:34399 "EHLO
	homiemail-a99.g.dreamhost.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753652AbaKXSwm (ORCPT
	<rfc822;linux-bcache@vger.kernel.org>);
	Mon, 24 Nov 2014 13:52:42 -0500
In-Reply-To: <5470858B.9090900@message-id.googlemail.com>
Sender: linux-bcache-owner@vger.kernel.org
List-Id: linux-bcache@vger.kernel.org
To: Stefan Seyfried <stefan.seyfried@googlemail.com>
Cc: Kent Overstreet <kmo@daterainc.com>, "linux-bcache@vger.kernel.org" <linux-bcache@vger.kernel.org>, Ross Anderson <rosander@dsotm.net>, Stefan Priebe <s.priebe@profihost.ag>

>>> Before the patch goes upstream I need it tested so I know if it fixes
>>> the actual issue or not.
>>
>> We have been using the rcu_sched patch and the cond_resched patch together
>> (both attached) since November 3rd on 3.17.2 without any bcache
>> backtraces. bcache is running in writeback mode. The server is
>> predominantly write-only with relatively few reads.
>
> Is the rcu_sched patch supposed to help the same or a totally different
> problem? Means: should I also apply it, rebuild the module and reboot
> (resetting the test time to zero :-)

The second backtrace mentioned on this link is the issue that I believe is 
fixed with the rcu_sched patch:

https://www.mail-archive.com/linux-bcache@vger.kernel.org/msg02623.html

The error starts with a message like "INFO: rcu_sched self-detected stall 
on CPU"

-Eric



> I had the "deadly" soft lockup once per week since updating to
> 3.16/3.17, so I can only tell if it might help in two weeks earliest.
>
>> To sum up, the attached two patches (plus the for-jens pull) have fixed all
>> of our bcache problems since 3.14.y.  These patches on 3.17.2 seem quite stable.
>
> That's good to hear :-)
>
> Best regards,
>
> 	Stefan
> -- 
> Stefan Seyfried
> Linux Consultant & Developer -- GPG Key: 0x731B665B
>
> B1 Systems GmbH
> Osterfeldstra?e 7 / 85088 Vohburg / http://www.b1-systems.de
> GF: Ralph Dehner / Unternehmenssitz: Vohburg / AG: Ingolstadt,HRB 3537
> --
> To unsubscribe from this list: send the line "unsubscribe linux-bcache" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>
