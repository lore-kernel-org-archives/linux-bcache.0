From: Matthias Ferdinand <mf@mferd.de>
Subject: Re: Small Cache Dev Tuning
Date: Tue, 16 Jun 2020 19:54:03 +0200
Message-ID: <20200616175403.GB626279@xoff>
References: <CAH6h+hcikX895gU2mGC05MTw7BCdV+kPeqGgrSRPwKXe1hjw+g@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Return-path: <linux-bcache-owner@vger.kernel.org>
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38948 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727083AbgFPSAm (ORCPT
        <rfc822;linux-bcache@vger.kernel.org>);
        Tue, 16 Jun 2020 14:00:42 -0400
Received: from smtp.mfedv.net (smtp.mfedv.net [IPv6:2a04:6c0:2::19])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C4390C061573
        for <linux-bcache@vger.kernel.org>; Tue, 16 Jun 2020 11:00:41 -0700 (PDT)
Content-Disposition: inline
In-Reply-To: <CAH6h+hcikX895gU2mGC05MTw7BCdV+kPeqGgrSRPwKXe1hjw+g@mail.gmail.com>
Sender: linux-bcache-owner@vger.kernel.org
List-Id: linux-bcache@vger.kernel.org
To: Marc Smith <msmith626@gmail.com>
Cc: linux-bcache@vger.kernel.org

On Tue, Jun 16, 2020 at 10:57:43AM -0400, Marc Smith wrote:
> This certainly helps me allow more dirty data than what the defaults
> are set to.

I only have production experience with slightly older kernels (4.15) and
~40GB partition of an Intel DC SATA SSD (XFS fs). Average latency of the
bcache device improved a lot with _reduced_ writeback_percent. I guess
dirty block bookkeeping adds its own I/O.
Currently I run them even at writeback_percent=1.

Not exactly answering your question, though :-)

Matthias


 But a couple other followup questions:
> - Any additional recommended tuning/settings for small cache devices?
> - Is the soft threshold for dirty writeback data 70% so there is
> always room for metadata on the cache device? Dangerous to try and
> recompile with larger maximums?
> - I'm still studying the code, but so far I don't see this, and wanted
> to confirm that: The writeback thread doesn't look at congestion on
> the backing device when flushing out data (and say pausing the
> writeback thread as needed)? For spinning media, if lots of latency
> sensitive reads are going directly to the backing device, and we're
> flushing a lot of data from cache to backing, that hurts.
> 
> 
> Thanks,
> 
> Marc
