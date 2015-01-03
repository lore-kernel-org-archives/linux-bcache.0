From: Rolf Fokkens <rolf@rolffokkens.nl>
Subject: Re: bcache fails after reboot if discard is enabled
Date: Sat, 03 Jan 2015 17:32:32 +0100
Message-ID: <54A819A0.9010501@rolffokkens.nl>
References: <54A66945.6030403@profihost.ag> <54A66C44.6070505@profihost.ag>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-bcache-owner@vger.kernel.org>
Received: from mail-wg0-f51.google.com ([74.125.82.51]:40582 "EHLO
	mail-wg0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750984AbbACQhn (ORCPT
	<rfc822;linux-bcache@vger.kernel.org>);
	Sat, 3 Jan 2015 11:37:43 -0500
Received: by mail-wg0-f51.google.com with SMTP id x12so25117903wgg.24
        for <linux-bcache@vger.kernel.org>; Sat, 03 Jan 2015 08:37:42 -0800 (PST)
In-Reply-To: <54A66C44.6070505@profihost.ag>
Sender: linux-bcache-owner@vger.kernel.org
List-Id: linux-bcache@vger.kernel.org
To: Stefan Priebe - Profihost AG <s.priebe@profihost.ag>, "linux-bcache@vger.kernel.org" <linux-bcache@vger.kernel.org>
Cc: Kent Overstreet <kmo@daterainc.com>

I've been using discard for a while, but I ran a few times in serious FS 
corruptions. After disabling discard bcache was stable again.

So far I tributed the corruptions to a low-cost SSD which probably 
didn't handle discard very well. But this was only an assumptions.

I didn't experience specific reboot problems like you describe.

On 01/02/2015 11:00 AM, Stefan Priebe - Profihost AG wrote:
> I'm sorry the backtraces were incomplete.
>
> Am 02.01.2015 um 10:47 schrieb Stefan Priebe - Profihost AG:
>> Hi,
>>
>> while running 3.10 or 3.18 kernel i've problems enabling discard.
>> Strangely this only appears on reboot or crash. While these situations
>> work fine without discard.
>>
>> bcache completely fails when discard is enabled for reboot or crash.
>> Strangely it works fine while "running".
> --
> To unsubscribe from this list: send the line "unsubscribe linux-bcache" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
