From: Shay Gover <govershay@gmail.com>
Subject: Debug cache miss
Date: Fri, 14 Apr 2017 16:21:00 +0300
Message-ID: <CANM5d8cpE55Wi_Dj2Ah-EG2_cHneDX9iNJpYMTsFr1pYV9s1jQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-bcache-owner@vger.kernel.org>
Received: from mail-io0-f171.google.com ([209.85.223.171]:36070 "EHLO
        mail-io0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751522AbdDNNVV (ORCPT
        <rfc822;linux-bcache@vger.kernel.org>);
        Fri, 14 Apr 2017 09:21:21 -0400
Received: by mail-io0-f171.google.com with SMTP id l7so109429720ioe.3
        for <linux-bcache@vger.kernel.org>; Fri, 14 Apr 2017 06:21:21 -0700 (PDT)
Sender: linux-bcache-owner@vger.kernel.org
List-Id: linux-bcache@vger.kernel.org
To: linux-bcache@vger.kernel.org

Hi everyone,

Recently I'm getting complete I/O freezes (mouse still working).
I think, it's a cache miss.
Sometimes I see on dmesg this error:
kernel: perf: interrupt took too long (2575 > 2500), lowering
kernel.perf_event_max_sample_rate to 77400
(Numbers change)

How can I debug this? Where should I look?
Currently I'm watching cache_bypass_misses

Thanks,

Shay
