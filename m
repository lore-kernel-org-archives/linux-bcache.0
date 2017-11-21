From: Michael Lyle <mlyle@lyle.org>
Subject: Re: Urgent fix for 4.14: 62530ed8b1d (bio: ensure __bio_clone_fast
 copies bi_partno)
Date: Tue, 21 Nov 2017 00:53:17 -0800
Message-ID: <40fca5c8-e751-35d6-0a77-9a3cfba212bb@lyle.org>
References: <CAJ+L6qdy2TQ0K=syErR_OEvAGJF7Cacc_79mnD=SEC=uQTYVpA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-bcache-owner@vger.kernel.org>
Received: from mail-pg0-f67.google.com ([74.125.83.67]:36134 "EHLO
        mail-pg0-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751537AbdKUIxU (ORCPT
        <rfc822;linux-bcache@vger.kernel.org>);
        Tue, 21 Nov 2017 03:53:20 -0500
Received: by mail-pg0-f67.google.com with SMTP id k190so4984542pga.3
        for <linux-bcache@vger.kernel.org>; Tue, 21 Nov 2017 00:53:20 -0800 (PST)
In-Reply-To: <CAJ+L6qdy2TQ0K=syErR_OEvAGJF7Cacc_79mnD=SEC=uQTYVpA@mail.gmail.com>
Content-Language: en-US
Sender: linux-bcache-owner@vger.kernel.org
List-Id: linux-bcache@vger.kernel.org
To: stable <stable@vger.kernel.org>, gregkh@linuxfoundation.org, linux-bcache <linux-bcache@vger.kernel.org>

I don't know what I was thinking here, but I meant 4.14/4.15 and not
4.15/4.16.  :P

Mike

On 11/20/2017 03:47 PM, Michael Lyle wrote:
> Hi---
> 
> Previously sent to stable was this patch, and it's made it into
> Linus's tree for 4.16.  It's a rather urgent data corruption issue
> that affects at minimum bcache but possibly other block subsystems.
> Several users have lost data.  The issue was introduced in the 4.15
> branch by 74d46992e0d9 ("block: replace bi_bdev with a gendisk pointer
> and partitions index").
> 
> I'd really appreciate anything that can be done to get this into a
> stable 4.15 release soon.
> 
> Thanks--
> 
> Mike
> --
> To unsubscribe from this list: send the line "unsubscribe linux-bcache" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
