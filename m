From: Kent Overstreet <kent.overstreet@gmail.com>
Subject: Re: bcache making tiny writes to backing device every second
Date: Wed, 21 Dec 2016 13:22:59 -0900
Message-ID: <20161221222259.d2kkv6iwv2uwocu2@moria.home.lan>
References: <CAJ=9zieFuHeo+9n9tOjMHcCRo+rB8hpPHw3GyF2JTa8jPM0VCw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Return-path: <linux-bcache-owner@vger.kernel.org>
Received: from mail-pg0-f46.google.com ([74.125.83.46]:35427 "EHLO
        mail-pg0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1755814AbcLUWXH (ORCPT
        <rfc822;linux-bcache@vger.kernel.org>);
        Wed, 21 Dec 2016 17:23:07 -0500
Received: by mail-pg0-f46.google.com with SMTP id i5so24767988pgh.2
        for <linux-bcache@vger.kernel.org>; Wed, 21 Dec 2016 14:23:07 -0800 (PST)
Content-Disposition: inline
In-Reply-To: <CAJ=9zieFuHeo+9n9tOjMHcCRo+rB8hpPHw3GyF2JTa8jPM0VCw@mail.gmail.com>
Sender: linux-bcache-owner@vger.kernel.org
List-Id: linux-bcache@vger.kernel.org
To: Jure =?utf-8?Q?Erzno=C5=BEnik?= <jure.erznoznik@gmail.com>
Cc: linux-bcache@vger.kernel.org

On Wed, Dec 21, 2016 at 02:36:02PM +0100, Jure Erznožnik wrote:
> Hello,
> 
> I apologise if this is something known, but my searching across the
> internet has revealed no answer for my issue, so I am attempting to
> find one here.
> 
> uname -a: Linux htpc 4.8.0-32-generic #34-Ubuntu SMP Tue Dec 13
> 14:30:43 UTC 2016 x86_64 x86_64 x86_64 GNU/Linux
> bcache-tools version: 1.0.8-2 (as provided in ubuntu yakkety apt repository)
> 
> I have placed bcache in writeback mode over an mdadm array, followed
> by LVM and actual volumes that are then used by various services. The
> problem I'm experiencing is that for every write I make into the
> array, bcache makes periodic writes every second a few KB (less than
> 20KB/s) to the backing device.
> 
> All bcache parameters are at default, here I list the writeback relevant ones:
> writeback_delay=30
> writeback_percent=10
> writeback_rate=512 (reverts to soon 512 even if changed)
> writeback_rate_d_term=30
> writeback_rate_p_term_inverse=6000
> writeback_rate_update_seconds=5
> writeback_running=5
> 
> I don't see how writeback would be running every second, except if
> that's implied by writeback_rate. Increasing that to a large value
> temporarily causes the cache to flush much faster thus reducing the
> number of disk "clicks". It reverts to 512 again as soon as dirty_data
> goes below the large value.
> 
> looking at writeback_rate_debug when the one-second flushes start, I
> can see that a few kilobytes are being flushed each second. Values of
> "writeback_rate_debug->dirty" field during one such session: 880k,
> 784k, 624k, 524k, 460k, 408k, 300k, 160k, 128k (128k remains and
> doesn't get flushed)
> 
> I'm not sure what size one block is, but I configured the cache device
> with 4KB block size, so here's what I expected to happen:
> 30 seconds after the 880k write to disk, writeback should trigger and
> write up to 512*4KB = 2MB of data to the disk. Since the write was
> only 880k, that would be written in one go. Instead I got at least 8
> writes, each with only a few kilobytes.
> 
> I have three questions about this:
> 1. What am I missing? Why does the data get flushed so slowly? These
> flushes can take hours for larger writes causing the disks to
> constantly work with only kilobytes per second.

It's because when writeback_percent is nonzero, we try to keep some amount of
dirty data in the cache: the assumption is that recent writes are more likely to
either be overwritten, or to have new data written that's contiguous or nearly
contiguous, so we'll do less work if we delay writeback.

We could have better hysteresis though, so we're not doing that slow steady
trickle of writes.

> 2. I'd like bcache to flush the dirty data (entirely) ASAP after the
> writeback_delay. How can I tell it to do that?

Set writeback_percent to 0.

The downside though is that scanning for dirty data when there's very little
dirty data is expensive, and we have to block foreground writes while we're
scanning - so doing that will adversely affect performance.

> 3. Is it possible to configure it such that the flushing would only
> take place if backing device wasn't under heavy read use at the time?
> I don't mind dirty data residing on SSD if that allows for faster
> overall operation.

Unfortunately, we don't have anything like that implemented.

That would be a really nice feature, but it'd be difficult to get right, since
it requires knowing the future (if we issue this write, will it end up blocking
a read? To answer that, we have to know if a read is going to come in before the
write completes). We can guess - we can estimate how much read traffic is going
to come in in the next few seconds based on how much read traffic we've seen
recently, on the assumption that read traffic is bursty - on timescales long
enough to be useful - and not completely random. However, this would mean we'd
be adding yet another feedback control loop to writeback - such things are
tricky to get right, and adding another would make the overall behaviour of
writeback even more complicated and difficult to understand and debug.

Ideally, we'd be able to just issue writeback writes with an appropriate IO
priority and the IO scheduler would just do the right thing - it just wouldn't
issue writeback writes if there was a higher priority read to be issued (that
is, any foreground read).

Unfortunately, this doesn't work in practice because of the writeback caching
that disk drives do: the (kernel side) IO scheduler has no ability to schedule
writes because writes just go into the disks's write cache, and then the disk
itself schedules it later (and the disk has no knowledge of IO priorities).
