From: matthew patton <pattonme@yahoo.com>
Subject: How important is bcache cache device in write-thru mode? (was Re: Tiered bcache)
Date: Tue, 21 Jan 2014 09:35:06 -0800 (PST)
Message-ID: <1390325706.9841.YahooMailNeo@web181504.mail.ne1.yahoo.com>
References: <b7031efdcd6440b983eff36b67873eee@navex1.navixia.local> <FA5AF690-E0B7-4AE2-ACF3-CA7C67AEFF96@gmail.com> <fccc7e213e1c451ab6e9189821924205@navex1.navixia.local> <1390314565.24447.YahooMailNeo@web181503.mail.ne1.yahoo.com> <9bfdb3a8cc1a4d55b4df233e2646ccf0@navex1.navixia.local> <1390321548.6065.YahooMailNeo@web181504.mail.ne1.yahoo.com> <72162e596cdd4b5ca00fcf061471ebd6@navex1.navixia.local>
Reply-To: matthew patton <pattonme@yahoo.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-bcache-owner@vger.kernel.org>
Received: from nm16-vm3.access.bullet.mail.bf1.yahoo.com ([216.109.115.50]:29010
	"EHLO nm16-vm3.access.bullet.mail.bf1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755089AbaAURlS (ORCPT
	<rfc822;linux-bcache@vger.kernel.org>);
	Tue, 21 Jan 2014 12:41:18 -0500
In-Reply-To: <72162e596cdd4b5ca00fcf061471ebd6@navex1.navixia.local>
Sender: linux-bcache-owner@vger.kernel.org
List-Id: linux-bcache@vger.kernel.org
To: "linux-bcache@vger.kernel.org" <linux-bcache@vger.kernel.org>
Cc: Patrick Zwahlen <paz@navixia.com>

>>  wait, the cache DEVICE for bcache is a Btier device composed of an SSD

>>  and RAM? So in effect you want btier to move the really hot blocks
>>  within the bcache cache device into RAM? So effectively bcache metadata
>>  and any really hot blocks will live in RAM and the rest of the 
> 'read'
>>  cache will sit on the SSD.
> 
> Exactly! Apologies if that wasn't clear in the first place but that
> describes 100% what we're currently testing.


you REALLY want to check with Kent as to what happens when the bcache caching device (and any meta-data it stores there) routinely get blown away or run a high risk of experiencing sudden destruction. I'm afraid this is not a test case that has undergone enough scrutiny.
