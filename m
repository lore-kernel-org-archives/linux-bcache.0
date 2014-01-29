From: matthew patton <pattonme@yahoo.com>
Subject: Re: Moving a backing device between 2 cachesets
Date: Wed, 29 Jan 2014 09:50:55 -0800 (PST)
Message-ID: <1391017855.88192.YahooMailNeo@web181502.mail.ne1.yahoo.com>
References: <338c5bf03af2422ab712a3552c981390@navex1.navixia.local> <lcalu5$iek$1@ger.gmane.org> <56b62eb646f94bbe868ae6b2f26d94e8@navex1.navixia.local>
Reply-To: matthew patton <pattonme@yahoo.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-bcache-owner@vger.kernel.org>
Received: from nm25-vm6.access.bullet.mail.gq1.yahoo.com ([216.39.63.173]:22751
	"EHLO nm25-vm6.access.bullet.mail.gq1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751040AbaA2R5K (ORCPT
	<rfc822;linux-bcache@vger.kernel.org>);
	Wed, 29 Jan 2014 12:57:10 -0500
In-Reply-To: <56b62eb646f94bbe868ae6b2f26d94e8@navex1.navixia.local>
Sender: linux-bcache-owner@vger.kernel.org
List-Id: linux-bcache@vger.kernel.org
To: "linux-bcache@vger.kernel.org" <linux-bcache@vger.kernel.org>



> When you register a newly formatted backing device it'll come up
> in passthrough mode, and then you can attach and detach a backing device
> from
> a cache set at runtime - while it's mounted and in use. Detaching
> implicitly
> invalidates any cached data for that backing device.


so it's better to think of bcache as adding and subtracting backing (aka real devices with user data) from a notionally "static" cacheset?
