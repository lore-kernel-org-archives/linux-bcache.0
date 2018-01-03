From: Michael Lyle <mlyle@lyle.org>
Subject: Re: Re: Re: [for-416 PATCH 3/3] bcache: allow quick writeback when backingidle
Date: Tue, 2 Jan 2018 18:52:49 -0800
Message-ID: <CAJ+L6qfzd-MKABBhoeumuOGtR-TJy-DTxR_J7qh9i+mYjdnYJA@mail.gmail.com>
References: <1514903698-19103-1-git-send-email-tang.junhui@zte.com.cn>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-bcache-owner@vger.kernel.org>
Received: from mail-qt0-f195.google.com ([209.85.216.195]:40914 "EHLO
        mail-qt0-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751283AbeACCwv (ORCPT
        <rfc822;linux-bcache@vger.kernel.org>);
        Tue, 2 Jan 2018 21:52:51 -0500
Received: by mail-qt0-f195.google.com with SMTP id u42so704596qte.7
        for <linux-bcache@vger.kernel.org>; Tue, 02 Jan 2018 18:52:51 -0800 (PST)
In-Reply-To: <1514903698-19103-1-git-send-email-tang.junhui@zte.com.cn>
Sender: linux-bcache-owner@vger.kernel.org
List-Id: linux-bcache@vger.kernel.org
To: Junhui Tang <tang.junhui@zte.com.cn>
Cc: linux-bcache <linux-bcache@vger.kernel.org>, linux-block@vger.kernel.org

On Tue, Jan 2, 2018 at 6:34 AM,  <tang.junhui@zte.com.cn> wrote:
> From: Tang Junhui <tang.junhui@zte.com.cn>
>
>>On 01/02/2018 12:53 AM, tang.junhui@zte.com.cn wrote:
>>> If no front-end I/O coming, would this cause write-back IOs one by one
>>> (one write-back IO issued must after the completion of the previous IO)?
>>> though with zero delay time, is the write-back performance still good?
>>
>>Yes-- this speeds up writeback during idle from 4k/sec to about 10MB/sec
>>on my slow 5400RPM disk.  (It writes back at about 20MB/sec with deep
>>queues in the same scenario).  So in this case it's about 2500x faster
>>than current idle writeback, but half as fast as writeback with full
>>device utilization.
>>
>>With only one I/O outstanding at a time, if front-end I/O starts latency
>>for the first request is still good.
>>
>
> OK, LGTM.

Excellent, thank you!

> Reviewed-by: Tang Junhui <tang.junhui@zte.com.cn>

Added to bcache-for-next.

Mike

>
> Thanks,
> Tang Junhui
> --
> To unsubscribe from this list: send the line "unsubscribe linux-bcache" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
