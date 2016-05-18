From: Killian De Volder <killian.de.volder@megasoft.be>
Subject: Re: block size question
Date: Wed, 18 May 2016 16:14:06 +0200
Message-ID: <573C78AE.8010108@megasoft.be>
References: <573C02B3.5010501@net.home>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-bcache-owner@vger.kernel.org>
Received: from slow1-d.mail.gandi.net ([217.70.178.86]:47035 "EHLO
	slow1-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932223AbcEROSp (ORCPT
	<rfc822;linux-bcache@vger.kernel.org>);
	Wed, 18 May 2016 10:18:45 -0400
Received: from relay6-d.mail.gandi.net (relay6-d.mail.gandi.net [217.70.183.198])
	by slow1-d.mail.gandi.net (Postfix) with ESMTP id 3C66847E2DE
	for <linux-bcache@vger.kernel.org>; Wed, 18 May 2016 16:14:11 +0200 (CEST)
Received: from mfilter47-d.gandi.net (mfilter47-d.gandi.net [217.70.178.178])
	by relay6-d.mail.gandi.net (Postfix) with ESMTP id 9303AFBAB9
	for <linux-bcache@vger.kernel.org>; Wed, 18 May 2016 16:14:08 +0200 (CEST)
Received: from relay6-d.mail.gandi.net ([IPv6:::ffff:217.70.183.198])
	by mfilter47-d.gandi.net (mfilter47-d.gandi.net [::ffff:10.0.15.180]) (amavisd-new, port 10024)
	with ESMTP id wT1vqX0jz8WS for <linux-bcache@vger.kernel.org>;
	Wed, 18 May 2016 16:14:07 +0200 (CEST)
Received: from [172.17.0.70] (cable-213-34-255-70.zeelandnet.nl [213.34.255.70])
	(Authenticated sender: killian.de.volder@megasoft.be)
	by relay6-d.mail.gandi.net (Postfix) with ESMTPSA id 27AA6FBA97
	for <linux-bcache@vger.kernel.org>; Wed, 18 May 2016 16:14:06 +0200 (CEST)
In-Reply-To: <573C02B3.5010501@net.home>
Sender: linux-bcache-owner@vger.kernel.org
List-Id: linux-bcache@vger.kernel.org
To: linux-bcache@vger.kernel.org

PS you wish to use the real sector size of the SSD if applicaple according to make-bache -?
-w, --block		block size (hard sector size of SSD, often 2k

This also implies you should set the block-size of a backing device to 4K.

Killian De Volder


On 18-05-16 07:50, Vlad wrote:
> Hallo,
> 
> What would be the optimal block size in case if physical block sizes
> different for cache and backing devices? Can I use different block sizes
> for cache and backing devices, like:
> make-bcache --block 4k -B /dev/sdc
> make-bcache --block 512 -C /dev/sda
> 
> I have a feeling that the block size should be the same and the biggest
> block size should be used, but I'd appreciate any thoughts about that.
> 
> Thanks in advance,
> Vlad.
> --
> To unsubscribe from this list: send the line "unsubscribe linux-bcache" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
