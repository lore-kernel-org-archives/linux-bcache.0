From: Josep Lladonosa <jlladono@gmail.com>
Subject: Re: bcache and memory at boot. Bug?
Date: Mon, 10 Feb 2014 14:15:14 +0100
Message-ID: <CAPBO7TZBgfa2CftYZYv2+dTteyBYJYyXD8vuw7KQNN5xexFjpQ@mail.gmail.com>
References: <CAPBO7TbEAf7Bhb-kTFQ00CmBih5CdsXRHeOSf4STxQ+ndy66dQ@mail.gmail.com>
	<ldadrd$4a2$1@ger.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-bcache-owner@vger.kernel.org>
Received: from mail-ob0-f179.google.com ([209.85.214.179]:61510 "EHLO
	mail-ob0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752195AbaBJNPQ (ORCPT
	<rfc822;linux-bcache@vger.kernel.org>);
	Mon, 10 Feb 2014 08:15:16 -0500
Received: by mail-ob0-f179.google.com with SMTP id wo20so7171749obc.38
        for <linux-bcache@vger.kernel.org>; Mon, 10 Feb 2014 05:15:14 -0800 (PST)
In-Reply-To: <ldadrd$4a2$1@ger.gmane.org>
Sender: linux-bcache-owner@vger.kernel.org
List-Id: linux-bcache@vger.kernel.org
To: Gabriel de Perthuis <g2p.code@gmail.com>
Cc: "linux-bcache@vger.kernel.org" <linux-bcache@vger.kernel.org>

On 10 February 2014 12:40, Gabriel de Perthuis <g2p.code@gmail.com> wrote:
>> Hello,
>>
>> I am using bcache in my laptop (RAM 32 GiB). I have been using it
>> perfectly for a month. ext4 + bcache.
>>
>> Yesterday, system did not want do to a normal startup. Messages where
>> from udev out of memory (and udevadm killed?) and system was not
>> mounting / (/dev/bcache0).
>>
>> [    6.823222] bcache-register invoked oom-killer: gfp_mask=0x82d2,
>> order=0, oom_score_adj=0
>
> Build your kernel with CONFIG_COMPACTION.  I've added it to the FAQ:
> http://bcache.evilpiepirate.org/~kent/bcache/FAQ/


Hello Gabriel,

Thanks for your reply.

My .config file has already:
...
CONFIG_COMPACTION=y
...

I have been digging around to find information and sometimes bugs come
related to unsigned variables and their operations when storing large
numbers (reserved memory?). Kernel is 64 bits. Memory is 32 GiB.
Perhaps it could happen that the allocated memory is not totally
freed.

When kernel has been able to boot with 32 GiB (having bcache0 messed
up and bcache1 mountable), it seems that bcache has more than 16 GiB
allocated and kept.

-Free memory with kernel 3.11.0-rc7 with 32GiB and bcache0 (halved?)
and bcache1 (mounted)

$ head -2 /proc/meminfo
MemTotal:       32913872 kB
MemFree:        12376640 kB


- Free memory with kernel 3.12.9 with mem=16G and bcache0 (mounted)

$ head -2 /proc/meminfo
MemTotal:       15602144 kB
MemFree:        14005372 kB



>
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-bcache" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html



-- 
--
Salutacions...Josep
--
