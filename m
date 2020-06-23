From: Marc Smith <msmith626@gmail.com>
Subject: Re: Small Cache Dev Tuning
Date: Tue, 23 Jun 2020 13:44:53 -0400
Message-ID: <CAH6h+hdGgQpsAX_ub-QXdbTczSWv_0zO7yadhBn-rBu33om10Q@mail.gmail.com>
References: <CAH6h+hcikX895gU2mGC05MTw7BCdV+kPeqGgrSRPwKXe1hjw+g@mail.gmail.com>
 <b9961963-224a-ab6b-890b-3da73b5eb338@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-bcache-owner@vger.kernel.org>
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56518 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1733075AbgFWRpF (ORCPT
        <rfc822;linux-bcache@vger.kernel.org>);
        Tue, 23 Jun 2020 13:45:05 -0400
Received: from mail-ua1-x936.google.com (mail-ua1-x936.google.com [IPv6:2607:f8b0:4864:20::936])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2EA1DC061573
        for <linux-bcache@vger.kernel.org>; Tue, 23 Jun 2020 10:45:05 -0700 (PDT)
Received: by mail-ua1-x936.google.com with SMTP id i8so7077942uak.9
        for <linux-bcache@vger.kernel.org>; Tue, 23 Jun 2020 10:45:05 -0700 (PDT)
In-Reply-To: <b9961963-224a-ab6b-890b-3da73b5eb338@suse.de>
Sender: linux-bcache-owner@vger.kernel.org
List-Id: linux-bcache@vger.kernel.org
To: Coly Li <colyli@suse.de>
Cc: linux-bcache@vger.kernel.org

On Mon, Jun 22, 2020 at 10:26 AM Coly Li <colyli@suse.de> wrote:
>
> On 2020/6/16 22:57, Marc Smith wrote:
> > Hi,
> >
> > I'm using bcache in Linux 5.4.45 and have been doing a number of
> > experiments, and tuning some of the knobs in bcache. I have a very
> > small cache device (~16 GiB) and I'm trying to make full use of it w/
> > bcache. I've increased the two module parameters to their maximum
> > values:
> > bch_cutoff_writeback=70
> > bch_cutoff_writeback_sync=90
> >
>
> These two parameters are only for experimental purpose for people who
> want to research bcache writeback bahavior, I don't recommend/support to
> change the default value in meaningful deployment. A large number may
> cause unpredictable behavior e.g. deadlock or I/O hang. If you decide to
> change these values in your environment, you have to take the risk for
> the above negative situation.
>
>
> > This certainly helps me allow more dirty data than what the defaults
> > are set to. But a couple other followup questions:
> > - Any additional recommended tuning/settings for small cache devices?
>
> Do not change the default values in your deployment.
>
> > - Is the soft threshold for dirty writeback data 70% so there is
> > always room for metadata on the cache device? Dangerous to try and
> > recompile with larger maximums?
>
> It is dangerous. People required such configurable value for research
> and study, it may cause deadlock if there is no room to allocate meta
> data. Setting {70, 90} is higher probably to trigger such deadlock.
>
> > - I'm still studying the code, but so far I don't see this, and wanted
> > to confirm that: The writeback thread doesn't look at congestion on
> > the backing device when flushing out data (and say pausing the
> > writeback thread as needed)? For spinning media, if lots of latency
> > sensitive reads are going directly to the backing device, and we're
> > flushing a lot of data from cache to backing, that hurts.
>
> This is quite tricky, the writeback I/O rate is controlled by a PD
> controller, when there are more regular I/Os coming, the writeback I/O
> will reduce to a minimum rate. But this is a try best effort, no real
> time throttle guaranteed.
>
> If you want to see in your workload which bch_cutoff_writeback or
> bch_cutoff_writeback_sync may finally hang your system, it is OK to
> change the default value for a research purpose. Otherwise please use
> the default value. I only look into related bug for the default value.

Okay, understood. Appreciate the guidance and information, thanks.

--Marc


>
> Coly Li
>
