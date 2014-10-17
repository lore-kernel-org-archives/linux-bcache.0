From: "T. Bolten" <t.bolten@gmx.com>
Subject: Re: Multiple BLE connections to one GATT-Server
Date: Fri, 17 Oct 2014 11:31:24 +0200
Message-ID: <5440E1EC.2080207@gmx.com>
References: <trinity-16d4caae-4274-403b-b40b-3565db16dd0e-1413535730986@3capp-mailcom-bs11>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-bcache-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.15.19]:51037 "EHLO mout.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750835AbaJQJb2 (ORCPT <rfc822;linux-bcache@vger.kernel.org>);
	Fri, 17 Oct 2014 05:31:28 -0400
In-Reply-To: <trinity-16d4caae-4274-403b-b40b-3565db16dd0e-1413535730986@3capp-mailcom-bs11>
Sender: linux-bcache-owner@vger.kernel.org
List-Id: linux-bcache@vger.kernel.org
To: linux-bcache@vger.kernel.org

Sorry at all.

I hit the send button while the wrong address was set - please simply 
ignore my embarrassing mistake.

Sorry and greetings
T. Bolten

Am 17.10.2014 um 10:48 schrieb T. Bolten:
> Hello,
>
> I'm new in the area of Bluetooth-programming and I hope this is the right place for my question. A web search at the usual web portals was not very helpful due to contradictory statements and I'm "lost" in the Bluetooth Core specification.
>
> Basically my question related to Bluetooth Low Energy is the following:
>
> Is it technically possible to connect multiple BLE GATT Clients (in my case smartphones, called in the bluetooth terminology central/master device?) to one BLE GATT Server (in my case a Linux box with Bluez, called in the bluetooth terminology slave or peripheral device?)?
>
>
> The basic idea here is that several different smartphones should simultaneously read (read-only, not write) some self-defined service characteristics to inform the clients about some kind of progress or event state. These progress-information is unfortunately to large to be included in the advertisement package.
>
>
> I have already an implementation that advertises a service with some self defined characteristics but I can connect to this GATT service only with one smartphone - then the advertising stops and I'm unable to connect to this service with an other device.
>
> After reading a lot of web posts I'm unsure if my idea can work or it is already "broken by design"?
>
> I am grateful for any suggestion.
>
> Greetings
> T. Bolten
