From: Kuba Sztandera <kubuxu@ipfs.io>
Subject: Writeback rate is at minimum 1 block per second
Date: Mon, 22 May 2017 14:44:51 +0200
Message-ID: <CAF_5NuX+nZ=x36L3uP8kmzr1DQOatbbou=J6PsWS_b9Gd5VA0Q@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-bcache-owner@vger.kernel.org>
Received: from mail-ua0-f171.google.com ([209.85.217.171]:34995 "EHLO
        mail-ua0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751746AbdEVMox (ORCPT
        <rfc822;linux-bcache@vger.kernel.org>);
        Mon, 22 May 2017 08:44:53 -0400
Received: by mail-ua0-f171.google.com with SMTP id y4so51909783uay.2
        for <linux-bcache@vger.kernel.org>; Mon, 22 May 2017 05:44:52 -0700 (PDT)
Received: from mail-ua0-f178.google.com (mail-ua0-f178.google.com. [209.85.217.178])
        by smtp.gmail.com with ESMTPSA id j22sm3614036uaa.14.2017.05.22.05.44.51
        for <linux-bcache@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 22 May 2017 05:44:51 -0700 (PDT)
Received: by mail-ua0-f178.google.com with SMTP id e28so58257604uah.0
        for <linux-bcache@vger.kernel.org>; Mon, 22 May 2017 05:44:51 -0700 (PDT)
Sender: linux-bcache-owner@vger.kernel.org
List-Id: linux-bcache@vger.kernel.org
To: linux-bcache@vger.kernel.org

I have following scenario:
 - 450GiB cache device
 - writeback enabled with target of 10%

What happens is when the space taken by writeback cache is less than 45GiB
then the bcache writes one block per second every second which isn't the best.

Example:

    rate:           512/sec
    dirty:          11.9G
    target:         45.6G
    proportional:   -29.2M
    derivative:     0
    change:         -29.2M/sec
    next io:        328ms

This means that:
 - one can hear drives clicking every second as heads snap into place
 - disks never spin down even though box is fully idle

At this rate the writeback will be flushed in about a year which is
pointless and only uses more power as disks are being kept active even
tough they don't need to.
Ssometimes it reduces sequential read performance as disks are being
wrote in random spot every second.

Solution IMO would be either to schedule in interval longer than one
every second or let the the rate to go to 0 blocks per second when
there is not enough data in writeback cache.
Currently the writeback rate is capped to 1 block per second at minimum.

--
Best Regards
Jakub "Kubuxu" Sztandera
