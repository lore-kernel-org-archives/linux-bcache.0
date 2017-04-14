From: Killian De Volder <killian.de.volder@megasoft.be>
Subject: Re: Debug cache miss
Date: Fri, 14 Apr 2017 17:05:53 +0200
Message-ID: <ca584b26-362b-0c22-e964-651c9f27514f@megasoft.be>
References: <CANM5d8cpE55Wi_Dj2Ah-EG2_cHneDX9iNJpYMTsFr1pYV9s1jQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-bcache-owner@vger.kernel.org>
Received: from relay2-d.mail.gandi.net ([217.70.183.194]:47566 "EHLO
        relay2-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751761AbdDNPF4 (ORCPT
        <rfc822;linux-bcache@vger.kernel.org>);
        Fri, 14 Apr 2017 11:05:56 -0400
Received: from mfilter14-d.gandi.net (mfilter14-d.gandi.net [217.70.178.142])
        by relay2-d.mail.gandi.net (Postfix) with ESMTP id A45CBC5A73
        for <linux-bcache@vger.kernel.org>; Fri, 14 Apr 2017 17:05:55 +0200 (CEST)
Received: from relay2-d.mail.gandi.net ([IPv6:::ffff:217.70.183.194])
        by mfilter14-d.gandi.net (mfilter14-d.gandi.net [::ffff:10.0.15.180]) (amavisd-new, port 10024)
        with ESMTP id N_bbsy-vpfmW for <linux-bcache@vger.kernel.org>;
        Fri, 14 Apr 2017 17:05:54 +0200 (CEST)
Received: from [172.17.0.70] (host-e0vuwqj.cbn1.zeelandnet.nl [213.34.255.70])
        (Authenticated sender: killian.de.volder@megasoft.be)
        by relay2-d.mail.gandi.net (Postfix) with ESMTPSA id 3D8BBC5A46
        for <linux-bcache@vger.kernel.org>; Fri, 14 Apr 2017 17:05:54 +0200 (CEST)
In-Reply-To: <CANM5d8cpE55Wi_Dj2Ah-EG2_cHneDX9iNJpYMTsFr1pYV9s1jQ@mail.gmail.com>
Sender: linux-bcache-owner@vger.kernel.org
List-Id: linux-bcache@vger.kernel.org
To: linux-bcache@vger.kernel.org

Cache misses should not be causing this, if the data is not found, a BIO (Kernel Block IO request) is submitted to the backing device, and everything should be fine.

I'm not familiar enough with the kernel code;
but if bcache is the cause of this, this would imply the bcache code is ran during the interrupt until it is done.
I suspect the kernel does not do this (I could be wrong).

Now in principle this is a warning, your computers should continue to run.

I have personally had bug with bcache in the past, but it either froze the kernel with a panic.
Or continue working (with some buts but still working).

Questions / tests :

1) Can you confirm the problem disappears when not using bcache ?
(But please try to still use all block devices you use when you are testing without bcache.)

2) When did this problem start ?

3) Does the computer freeze and stop, or continue ?

4) Check the smart of your devices: "smartctl -a /dev/sdX"

Killian De Volder


On 14-04-17 15:21, Shay Gover wrote:
> Hi everyone,
> 
> Recently I'm getting complete I/O freezes (mouse still working).
> I think, it's a cache miss.
> Sometimes I see on dmesg this error:
> kernel: perf: interrupt took too long (2575 > 2500), lowering
> kernel.perf_event_max_sample_rate to 77400
> (Numbers change)
> 
> How can I debug this? Where should I look?
> Currently I'm watching cache_bypass_misses
> 
> Thanks,
> 
> Shay
> --
> To unsubscribe from this list: send the line "unsubscribe linux-bcache" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
