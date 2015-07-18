From: Killian De Volder <killian.de.volder@megasoft.be>
Subject: Re: Unable to detach caching device
Date: Sat, 18 Jul 2015 21:26:50 +0200
Message-ID: <55AAA87A.7080407@megasoft.be>
References: <55AA70CC.9000101@megasoft.be>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-bcache-owner@vger.kernel.org>
Received: from relay5-d.mail.gandi.net ([217.70.183.197]:50597 "EHLO
	relay5-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751704AbbGRT0y (ORCPT
	<rfc822;linux-bcache@vger.kernel.org>);
	Sat, 18 Jul 2015 15:26:54 -0400
Received: from mfilter16-d.gandi.net (mfilter16-d.gandi.net [217.70.178.144])
	by relay5-d.mail.gandi.net (Postfix) with ESMTP id AE40C41C04E
	for <linux-bcache@vger.kernel.org>; Sat, 18 Jul 2015 21:26:52 +0200 (CEST)
Received: from relay5-d.mail.gandi.net ([217.70.183.197])
	by mfilter16-d.gandi.net (mfilter16-d.gandi.net [10.0.15.180]) (amavisd-new, port 10024)
	with ESMTP id bl6ehppjM5If for <linux-bcache@vger.kernel.org>;
	Sat, 18 Jul 2015 21:26:51 +0200 (CEST)
Received: from [172.17.0.70] (cable-213-34-255-70.zeelandnet.nl [213.34.255.70])
	(Authenticated sender: killian.de.volder@megasoft.be)
	by relay5-d.mail.gandi.net (Postfix) with ESMTPSA id 511C441C054
	for <linux-bcache@vger.kernel.org>; Sat, 18 Jul 2015 21:26:51 +0200 (CEST)
In-Reply-To: <55AA70CC.9000101@megasoft.be>
Sender: linux-bcache-owner@vger.kernel.org
List-Id: linux-bcache@vger.kernel.org
To: linux-bcache@vger.kernel.org

Moved issue to new bugtracker:
https://github.com/koverstreet/linux-bcache/issues/1

---
Killian De Volder


On 18-07-15 17:29, Killian De Volder wrote:
> I'm attempting to detach a a caching device.
> However it's not working, the bcache device stays dirty.
> 
> # pwd
> /sys/block/bcache0/bcache
> 
> # cat cache_mode state dirty_data writeback_running writeback_rate
> writethrough writeback writearound [none]
> dirty
> 2.0M
> 1
> 512
> 
> # cat writeback_rate_debug
> rate:        512/sec
> dirty:        2.0M
> target:        3.2G
> proportional:    -3.2M
> derivative:    0
> change:        -3.2M/sec
> next io:    0ms
> 
> I'm going to leave the machine on so I can extract any information you need.
> (dmesg contains no errors)
> 
> Kind regards,
> Killian De Volder
> --
> To unsubscribe from this list: send the line "unsubscribe linux-bcache" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
