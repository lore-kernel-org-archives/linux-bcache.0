From: Vlad <vovan@vovan.nl>
Subject: Re: block size question
Date: Wed, 18 May 2016 18:24:45 +0200
Message-ID: <573C974D.3040008@net.home>
References: <573C02B3.5010501@net.home> <573C8E6E.8030008@megasoft.be>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-bcache-owner@vger.kernel.org>
Received: from smtp-3.concepts.nl ([213.197.30.127]:40443 "EHLO
	smtp-3.concepts.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752609AbcERQZU (ORCPT
	<rfc822;linux-bcache@vger.kernel.org>);
	Wed, 18 May 2016 12:25:20 -0400
Received: from [77.174.73.212] (helo=srv2.net.home)
	by smtp-3.concepts.nl with esmtp (Exim 4.80.1)
	(envelope-from <vovan@vovan.nl>)
	id 1b34Hc-000ClD-Hy
	for linux-bcache@vger.kernel.org; Wed, 18 May 2016 18:25:16 +0200
Received: from localhost (localhost [127.0.0.1])
	by srv2.net.home (Postfix) with ESMTP id 3506175846C
	for <linux-bcache@vger.kernel.org>; Wed, 18 May 2016 18:24:46 +0200 (CEST)
Received: from srv2.net.home ([127.0.0.1])
	by localhost (webmail.net.home [127.0.0.1]) (amavisd-new, port 10024)
	with LMTP id cbC-TwfwJ1g0 for <linux-bcache@vger.kernel.org>;
	Wed, 18 May 2016 18:24:46 +0200 (CEST)
Received: from [192.168.1.2] (vovan.net.home [192.168.1.2])
	(Authenticated sender: vovan)
	by srv2.net.home (Postfix) with ESMTPSA id 08941758465
	for <linux-bcache@vger.kernel.org>; Wed, 18 May 2016 18:24:46 +0200 (CEST)
In-Reply-To: <573C8E6E.8030008@megasoft.be>
Sender: linux-bcache-owner@vger.kernel.org
List-Id: linux-bcache@vger.kernel.org
To: linux-bcache@vger.kernel.org

Killian,

Thanks for your help! I think it's the best to reformat both bcache
devices with block size of 4k in my case where cached device has block
size of 512 and backing device 4k.

Regards,
Vlad.

On 18/05/16 17:46, Killian De Volder wrote:
> Done some testing for you:
> The -B --block size has to be a a power2 of -C --block size.
>
> (Note: all information is about bcache1 not bcachefs if that is what you are talking about)
>
> Killian De Volder
>
>
> On 18-05-16 07:50, Vlad wrote:
>> Hallo,
>>
>> What would be the optimal block size in case if physical block sizes
>> different for cache and backing devices? Can I use different block sizes
>> for cache and backing devices, like:
>> make-bcache --block 4k -B /dev/sdc
>> make-bcache --block 512 -C /dev/sda
>>
>> I have a feeling that the block size should be the same and the biggest
>> block size should be used, but I'd appreciate any thoughts about that.
>>
>> Thanks in advance,
>> Vlad.
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-bcache" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-bcache" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
