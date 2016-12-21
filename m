From: =?UTF-8?Q?Jure_Erzno=C5=BEnik?= <jure.erznoznik@gmail.com>
Subject: bcache making tiny writes to backing device every second
Date: Wed, 21 Dec 2016 14:36:02 +0100
Message-ID: <CAJ=9zieFuHeo+9n9tOjMHcCRo+rB8hpPHw3GyF2JTa8jPM0VCw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-bcache-owner@vger.kernel.org>
Received: from mail-yw0-f170.google.com ([209.85.161.170]:35268 "EHLO
        mail-yw0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752675AbcLUNgD (ORCPT
        <rfc822;linux-bcache@vger.kernel.org>);
        Wed, 21 Dec 2016 08:36:03 -0500
Received: by mail-yw0-f170.google.com with SMTP id i145so99683353ywg.2
        for <linux-bcache@vger.kernel.org>; Wed, 21 Dec 2016 05:36:03 -0800 (PST)
Sender: linux-bcache-owner@vger.kernel.org
List-Id: linux-bcache@vger.kernel.org
To: linux-bcache@vger.kernel.org

Hello,

I apologise if this is something known, but my searching across the
internet has revealed no answer for my issue, so I am attempting to
find one here.

uname -a: Linux htpc 4.8.0-32-generic #34-Ubuntu SMP Tue Dec 13
14:30:43 UTC 2016 x86_64 x86_64 x86_64 GNU/Linux
bcache-tools version: 1.0.8-2 (as provided in ubuntu yakkety apt repository)

I have placed bcache in writeback mode over an mdadm array, followed
by LVM and actual volumes that are then used by various services. The
problem I'm experiencing is that for every write I make into the
array, bcache makes periodic writes every second a few KB (less than
20KB/s) to the backing device.

All bcache parameters are at default, here I list the writeback relevant ones:
writeback_delay=30
writeback_percent=10
writeback_rate=512 (reverts to soon 512 even if changed)
writeback_rate_d_term=30
writeback_rate_p_term_inverse=6000
writeback_rate_update_seconds=5
writeback_running=5

I don't see how writeback would be running every second, except if
that's implied by writeback_rate. Increasing that to a large value
temporarily causes the cache to flush much faster thus reducing the
number of disk "clicks". It reverts to 512 again as soon as dirty_data
goes below the large value.

looking at writeback_rate_debug when the one-second flushes start, I
can see that a few kilobytes are being flushed each second. Values of
"writeback_rate_debug->dirty" field during one such session: 880k,
784k, 624k, 524k, 460k, 408k, 300k, 160k, 128k (128k remains and
doesn't get flushed)

I'm not sure what size one block is, but I configured the cache device
with 4KB block size, so here's what I expected to happen:
30 seconds after the 880k write to disk, writeback should trigger and
write up to 512*4KB = 2MB of data to the disk. Since the write was
only 880k, that would be written in one go. Instead I got at least 8
writes, each with only a few kilobytes.

I have three questions about this:
1. What am I missing? Why does the data get flushed so slowly? These
flushes can take hours for larger writes causing the disks to
constantly work with only kilobytes per second.
2. I'd like bcache to flush the dirty data (entirely) ASAP after the
writeback_delay. How can I tell it to do that?
3. Is it possible to configure it such that the flushing would only
take place if backing device wasn't under heavy read use at the time?
I don't mind dirty data residing on SSD if that allows for faster
overall operation.

Thanks,
Jure
