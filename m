From: Stefan Priebe <s.priebe@profihost.ag>
Subject: Re: Bcache power loss
Date: Thu, 01 Jan 2015 08:55:56 +0100
Message-ID: <54A4FD8C.5050606@profihost.ag>
References: <E5785778-CF11-4DC2-9E38-4F795B8D9C53@profihost.ag> <alpine.DEB.2.02.1412311244220.1491@ware.dreamhost.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-bcache-owner@vger.kernel.org>
Received: from mail-ph.de-nserver.de ([85.158.179.214]:27158 "EHLO
	mail-ph.de-nserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750701AbbAAHza (ORCPT
	<rfc822;linux-bcache@vger.kernel.org>);
	Thu, 1 Jan 2015 02:55:30 -0500
In-Reply-To: <alpine.DEB.2.02.1412311244220.1491@ware.dreamhost.com>
Sender: linux-bcache-owner@vger.kernel.org
List-Id: linux-bcache@vger.kernel.org
To: Eric Wheeler <bcache@lists.ewheeler.net>
Cc: linux-bcache@vger.kernel.org

Great, thanks!

Kent any chance to get those upstream? A lot of people really like 
bcache and even rely on it. It would be great to have a stable version 
in the kernel.

Greets,
Stefan
Am 31.12.2014 um 21:46 schrieb Eric Wheeler:
>> Has anybody ever tested bcache against power loss?
>
> We have had to hard reset our machine many times during the process of
> troubleshooting various lockups that have been since resolved by some of
> the patches posted to this list (attached).
>
> I did notice in the logs that it said something about replaying
> transactions when it came up after a hard reset, so that is promising.
> Still, we reformatted all of our bcache volumes after the lockups were
> resolved just to make sure that there were no unexpected side effects and
> have not had any issues since.
>
>
>> Stefan
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-bcache" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
