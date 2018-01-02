From: Michael Lyle <mlyle@lyle.org>
Subject: Re: [for-416 PATCH 3/3] bcache: allow quick writeback when backing
 idle
Date: Tue, 2 Jan 2018 08:23:14 -0800
Message-ID: <0fdcfaaf-af7a-adb8-075d-b321b9df4ef7@lyle.org>
References: <1514883236-11844-1-git-send-email-tang.junhui@zte.com.cn>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-bcache-owner@vger.kernel.org>
Received: from mail-pl0-f45.google.com ([209.85.160.45]:39090 "EHLO
        mail-pl0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750945AbeABQXS (ORCPT
        <rfc822;linux-bcache@vger.kernel.org>);
        Tue, 2 Jan 2018 11:23:18 -0500
Received: by mail-pl0-f45.google.com with SMTP id bi12so28938169plb.6
        for <linux-bcache@vger.kernel.org>; Tue, 02 Jan 2018 08:23:18 -0800 (PST)
In-Reply-To: <1514883236-11844-1-git-send-email-tang.junhui@zte.com.cn>
Content-Language: en-US
Sender: linux-bcache-owner@vger.kernel.org
List-Id: linux-bcache@vger.kernel.org
To: tang.junhui@zte.com.cn
Cc: linux-bcache@vger.kernel.org, linux-block@vger.kernel.org

On 01/02/2018 12:53 AM, tang.junhui@zte.com.cn wrote:
> If no front-end I/O coming, would this cause write-back IOs one by one
> (one write-back IO issued must after the completion of the previous IO)?
> though with zero delay time, is the write-back performance still good?

Yes-- this speeds up writeback during idle from 4k/sec to about 10MB/sec
on my slow 5400RPM disk.  (It writes back at about 20MB/sec with deep
queues in the same scenario).  So in this case it's about 2500x faster
than current idle writeback, but half as fast as writeback with full
device utilization.

With only one I/O outstanding at a time, if front-end I/O starts latency
for the first request is still good.

> Thanks,
> Tang Junhui

Mike
