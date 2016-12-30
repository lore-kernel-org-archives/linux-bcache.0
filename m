From: Killian De Volder <killian.de.volder@megasoft.be>
Subject: Re: Cache everything
Date: Fri, 30 Dec 2016 09:58:19 +0100
Message-ID: <586621AB.7040208@megasoft.be>
References: <CAJ=9zif=Lxgcgv0EW8O7hfKDHn5g8acXKnbvygda6LjarL65Xg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Return-path: <linux-bcache-owner@vger.kernel.org>
Received: from relay6-d.mail.gandi.net ([217.70.183.198]:33611 "EHLO
        relay6-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752412AbcL3I6Y (ORCPT
        <rfc822;linux-bcache@vger.kernel.org>);
        Fri, 30 Dec 2016 03:58:24 -0500
Received: from mfilter27-d.gandi.net (mfilter27-d.gandi.net [217.70.178.155])
        by relay6-d.mail.gandi.net (Postfix) with ESMTP id 6FF55FB877
        for <linux-bcache@vger.kernel.org>; Fri, 30 Dec 2016 09:58:21 +0100 (CET)
Received: from relay6-d.mail.gandi.net ([IPv6:::ffff:217.70.183.198])
        by mfilter27-d.gandi.net (mfilter27-d.gandi.net [::ffff:10.0.15.180]) (amavisd-new, port 10024)
        with ESMTP id TFnIeTC3NDrM for <linux-bcache@vger.kernel.org>;
        Fri, 30 Dec 2016 09:58:19 +0100 (CET)
Received: from [172.17.0.70] (host-e0vuwqj.cbn1.zeelandnet.nl [213.34.255.70])
        (Authenticated sender: killian.de.volder@megasoft.be)
        by relay6-d.mail.gandi.net (Postfix) with ESMTPSA id AF513FB8A1
        for <linux-bcache@vger.kernel.org>; Fri, 30 Dec 2016 09:58:19 +0100 (CET)
In-Reply-To: <CAJ=9zif=Lxgcgv0EW8O7hfKDHn5g8acXKnbvygda6LjarL65Xg@mail.gmail.com>
Sender: linux-bcache-owner@vger.kernel.org
List-Id: linux-bcache@vger.kernel.org
To: linux-bcache@vger.kernel.org

Also check  congested_write_threshold_us, if the SSD is "congested" it bypasses it to speedup writes.

Killian De Volder


On 30-12-16 09:38, Jure Erznožnik wrote:
> I have a large array sitting in my server containing a bit of data
> that is used ofter and a lot of data that is used rarely.
> My goal is to make the platters spin up as rarely as possible while
> bcache handles most of the requests to the array.
> 
> I have set the disks spin-down time to 15 minutes so that during
> high-activity periods they don't cycle power states too much.
> 
> I have set bcache parameters such:
> cache_mode - writeback
> readahead - 0
> sequential_cutoff - 0
> writeback_delay - 3600 (one hour)
> writeback_percent - 40 (won't go higher)
> 
> I was hoping that this would make bcache cache everything leaving the
> array practically untouched for an hour. However, stats_hour/bypassed
> still shows megabytes of bypassed data and a cache_hit ratio of ~50%
> even when I'm working ONLY with the frequently accessed data portion
> (some 20% of total cache capacity). Also tiny writes are being made to
> the array despite writeback_delay not expiring.
> 
> What other parameter am I forgetting to achieve what I want?
> 
> Thanks,
> Jure
> --
> To unsubscribe from this list: send the line "unsubscribe linux-bcache" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
