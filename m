From: Eric Wheeler <bcache@lists.ewheeler.net>
Subject: Re: Writeback rate is at minimum 1 block per second
Date: Mon, 22 May 2017 18:44:45 +0000 (UTC)
Message-ID: <alpine.LRH.2.11.1705221842420.19359@mail.ewheeler.net>
References: <CAF_5NuX+nZ=x36L3uP8kmzr1DQOatbbou=J6PsWS_b9Gd5VA0Q@mail.gmail.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-bcache-owner@vger.kernel.org>
Received: from mx.ewheeler.net ([66.155.3.69]:45506 "EHLO mail.ewheeler.net"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1760756AbdEVSoq (ORCPT <rfc822;linux-bcache@vger.kernel.org>);
        Mon, 22 May 2017 14:44:46 -0400
In-Reply-To: <CAF_5NuX+nZ=x36L3uP8kmzr1DQOatbbou=J6PsWS_b9Gd5VA0Q@mail.gmail.com>
Sender: linux-bcache-owner@vger.kernel.org
List-Id: linux-bcache@vger.kernel.org
To: Kuba Sztandera <kubuxu@ipfs.io>
Cc: linux-bcache@vger.kernel.org

On Mon, 22 May 2017, Kuba Sztandera wrote:

> I have following scenario:
>  - 450GiB cache device
>  - writeback enabled with target of 10%
> 
> What happens is when the space taken by writeback cache is less than 45GiB
> then the bcache writes one block per second every second which isn't the best.

I think others have noted this as well related to a laptop.  You might 
consider implementing a writeback_min_rate sysfs entry or something which 
skips writeback below some threshold.

Please send us a patch if you come up with a good solution.

--
Eric Wheeler


> 
> Example:
> 
>     rate:           512/sec
>     dirty:          11.9G
>     target:         45.6G
>     proportional:   -29.2M
>     derivative:     0
>     change:         -29.2M/sec
>     next io:        328ms
> 
> This means that:
>  - one can hear drives clicking every second as heads snap into place
>  - disks never spin down even though box is fully idle
> 
> At this rate the writeback will be flushed in about a year which is
> pointless and only uses more power as disks are being kept active even
> tough they don't need to.
> Ssometimes it reduces sequential read performance as disks are being
> wrote in random spot every second.
> 
> Solution IMO would be either to schedule in interval longer than one
> every second or let the the rate to go to 0 blocks per second when
> there is not enough data in writeback cache.
> Currently the writeback rate is capped to 1 block per second at minimum.
> 
> --
> Best Regards
> Jakub "Kubuxu" Sztandera
> --
> To unsubscribe from this list: send the line "unsubscribe linux-bcache" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
