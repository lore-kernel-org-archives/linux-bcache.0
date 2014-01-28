From: matthew patton <pattonme@yahoo.com>
Subject: Re: Moving a backing device between 2 cachesets
Date: Tue, 28 Jan 2014 14:35:48 -0800 (PST)
Message-ID: <1390948548.72639.YahooMailNeo@web181502.mail.ne1.yahoo.com>
References: <338c5bf03af2422ab712a3552c981390@navex1.navixia.local>
Reply-To: matthew patton <pattonme@yahoo.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-bcache-owner@vger.kernel.org>
Received: from nm5-vm7.access.bullet.mail.bf1.yahoo.com ([216.109.114.134]:38479
	"EHLO nm5-vm7.access.bullet.mail.bf1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755483AbaA1Wmo (ORCPT
	<rfc822;linux-bcache@vger.kernel.org>);
	Tue, 28 Jan 2014 17:42:44 -0500
In-Reply-To: <338c5bf03af2422ab712a3552c981390@navex1.navixia.local>
Sender: linux-bcache-owner@vger.kernel.org
List-Id: linux-bcache@vger.kernel.org
To: Patrick Zwahlen <paz@navixia.com>, "linux-bcache@vger.kernel.org" <linux-bcache@vger.kernel.org>



>Scenario
>- md attached to cacheset1 and working (on node 1)
>- md detached from cacheset1

You can't just detach, you must flush everything out of cacheset1 and destroy/revoke/disassemble the relationship between the cache and MD. 'destroy-bcache(8) or make-bcache -D' if you will. Not that such a tool exists AFAIK.

>- md stopped on node 1
>- md started on node 2
>- md attached to cacheset2 on node 2

No, you don't attache it, you have to create a new relationship; ala 'make-bcache -C ...'

>At this point, cacheset1 is attached to nothing, but still has valid blocks
>"linked" to the backing md device

If you do, your data is hopelessly gone.

The only way you can bounce a bcache device from one node to the other is the ENTIRE stack moves back and forth. So the SSDs have to be in the shared JBOD. And you can skip all the malarky of attach/detach. You can write udev-rules to mask/ignore certain devices so that each node only knows about it's own devices and when it's time to cross-mount the peer's, you register them with the receiving system, do the 'probe-bcache' and resume operations. That's assuming the writes the client sent to the original node really got committed (write-thru not withstanding).
