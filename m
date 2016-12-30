From: =?UTF-8?Q?Jure_Erzno=C5=BEnik?= <jure.erznoznik@gmail.com>
Subject: Cache everything
Date: Fri, 30 Dec 2016 09:38:21 +0100
Message-ID: <CAJ=9zif=Lxgcgv0EW8O7hfKDHn5g8acXKnbvygda6LjarL65Xg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-bcache-owner@vger.kernel.org>
Received: from mail-yw0-f179.google.com ([209.85.161.179]:35674 "EHLO
        mail-yw0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751785AbcL3IiW (ORCPT
        <rfc822;linux-bcache@vger.kernel.org>);
        Fri, 30 Dec 2016 03:38:22 -0500
Received: by mail-yw0-f179.google.com with SMTP id v81so120005364ywb.2
        for <linux-bcache@vger.kernel.org>; Fri, 30 Dec 2016 00:38:22 -0800 (PST)
Sender: linux-bcache-owner@vger.kernel.org
List-Id: linux-bcache@vger.kernel.org
To: linux-bcache@vger.kernel.org

I have a large array sitting in my server containing a bit of data
that is used ofter and a lot of data that is used rarely.
My goal is to make the platters spin up as rarely as possible while
bcache handles most of the requests to the array.

I have set the disks spin-down time to 15 minutes so that during
high-activity periods they don't cycle power states too much.

I have set bcache parameters such:
cache_mode - writeback
readahead - 0
sequential_cutoff - 0
writeback_delay - 3600 (one hour)
writeback_percent - 40 (won't go higher)

I was hoping that this would make bcache cache everything leaving the
array practically untouched for an hour. However, stats_hour/bypassed
still shows megabytes of bypassed data and a cache_hit ratio of ~50%
even when I'm working ONLY with the frequently accessed data portion
(some 20% of total cache capacity). Also tiny writes are being made to
the array despite writeback_delay not expiring.

What other parameter am I forgetting to achieve what I want?

Thanks,
Jure
