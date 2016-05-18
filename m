From: Killian De Volder <killian.de.volder@megasoft.be>
Subject: Re: block size question
Date: Wed, 18 May 2016 17:46:54 +0200
Message-ID: <573C8E6E.8030008@megasoft.be>
References: <573C02B3.5010501@net.home>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-bcache-owner@vger.kernel.org>
Received: from relay5-d.mail.gandi.net ([217.70.183.197]:56922 "EHLO
	relay5-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932419AbcERPq7 (ORCPT
	<rfc822;linux-bcache@vger.kernel.org>);
	Wed, 18 May 2016 11:46:59 -0400
Received: from mfilter38-d.gandi.net (mfilter38-d.gandi.net [217.70.178.169])
	by relay5-d.mail.gandi.net (Postfix) with ESMTP id 01E7041C08F
	for <linux-bcache@vger.kernel.org>; Wed, 18 May 2016 17:46:57 +0200 (CEST)
Received: from relay5-d.mail.gandi.net ([IPv6:::ffff:217.70.183.197])
	by mfilter38-d.gandi.net (mfilter38-d.gandi.net [::ffff:10.0.15.180]) (amavisd-new, port 10024)
	with ESMTP id C0SHWo-ZifDg for <linux-bcache@vger.kernel.org>;
	Wed, 18 May 2016 17:46:55 +0200 (CEST)
Received: from [172.17.0.70] (cable-213-34-255-70.zeelandnet.nl [213.34.255.70])
	(Authenticated sender: killian.de.volder@megasoft.be)
	by relay5-d.mail.gandi.net (Postfix) with ESMTPSA id 47A2D41C09D
	for <linux-bcache@vger.kernel.org>; Wed, 18 May 2016 17:46:55 +0200 (CEST)
In-Reply-To: <573C02B3.5010501@net.home>
Sender: linux-bcache-owner@vger.kernel.org
List-Id: linux-bcache@vger.kernel.org
To: linux-bcache@vger.kernel.org

Done some testing for you:
The -B --block size has to be a a power2 of -C --block size.

(Note: all information is about bcache1 not bcachefs if that is what you are talking about)

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
