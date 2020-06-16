From: Marc Smith <msmith626@gmail.com>
Subject: Small Cache Dev Tuning
Date: Tue, 16 Jun 2020 10:57:43 -0400
Message-ID: <CAH6h+hcikX895gU2mGC05MTw7BCdV+kPeqGgrSRPwKXe1hjw+g@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-bcache-owner@vger.kernel.org>
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38832 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729239AbgFPO54 (ORCPT
        <rfc822;linux-bcache@vger.kernel.org>);
        Tue, 16 Jun 2020 10:57:56 -0400
Received: from mail-vs1-xe2d.google.com (mail-vs1-xe2d.google.com [IPv6:2607:f8b0:4864:20::e2d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 66591C061573
        for <linux-bcache@vger.kernel.org>; Tue, 16 Jun 2020 07:57:55 -0700 (PDT)
Received: by mail-vs1-xe2d.google.com with SMTP id o15so1836695vsp.12
        for <linux-bcache@vger.kernel.org>; Tue, 16 Jun 2020 07:57:55 -0700 (PDT)
Sender: linux-bcache-owner@vger.kernel.org
List-Id: linux-bcache@vger.kernel.org
To: linux-bcache@vger.kernel.org

Hi,

I'm using bcache in Linux 5.4.45 and have been doing a number of
experiments, and tuning some of the knobs in bcache. I have a very
small cache device (~16 GiB) and I'm trying to make full use of it w/
bcache. I've increased the two module parameters to their maximum
values:
bch_cutoff_writeback=70
bch_cutoff_writeback_sync=90

This certainly helps me allow more dirty data than what the defaults
are set to. But a couple other followup questions:
- Any additional recommended tuning/settings for small cache devices?
- Is the soft threshold for dirty writeback data 70% so there is
always room for metadata on the cache device? Dangerous to try and
recompile with larger maximums?
- I'm still studying the code, but so far I don't see this, and wanted
to confirm that: The writeback thread doesn't look at congestion on
the backing device when flushing out data (and say pausing the
writeback thread as needed)? For spinning media, if lots of latency
sensitive reads are going directly to the backing device, and we're
flushing a lot of data from cache to backing, that hurts.


Thanks,

Marc
