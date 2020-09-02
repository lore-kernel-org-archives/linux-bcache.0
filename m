Return-Path: <SRS0=5amZ=CL=vger.kernel.org=linux-bcache-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.0 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 77A55C433E7
	for <linux-bcache@archiver.kernel.org>; Wed,  2 Sep 2020 06:05:44 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 5BE76206A5
	for <linux-bcache@archiver.kernel.org>; Wed,  2 Sep 2020 06:05:44 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726406AbgIBGFn (ORCPT
        <rfc822;linux-bcache@archiver.kernel.org>);
        Wed, 2 Sep 2020 02:05:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47962 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725774AbgIBGFn (ORCPT
        <rfc822;linux-bcache@vger.kernel.org>);
        Wed, 2 Sep 2020 02:05:43 -0400
Received: from smtp.mfedv.net (smtp.mfedv.net [IPv6:2a04:6c0:2::19])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BC050C061244
        for <linux-bcache@vger.kernel.org>; Tue,  1 Sep 2020 23:05:41 -0700 (PDT)
Received: from suse92host.mfedv.net (suse92host.mfedv.net [IPv6:2a04:6c0:2:3:0:0:0:ffff])
        by smtp.mfedv.net (8.15.2/8.15.2/Debian-10) with ESMTP id 08265UtW030280;
        Wed, 2 Sep 2020 06:05:31 GMT
Received: from xoff (klappe2.mfedv.net [192.168.71.72])
        by suse92host.mfedv.net (Postfix) with SMTP id CFF5CC80C7;
        Wed,  2 Sep 2020 08:05:29 +0200 (CEST)
        (envelope-from bcache@mfedv.net)
Date:   Wed, 2 Sep 2020 08:05:29 +0200
From:   Matthias Ferdinand <bcache@mfedv.net>
To:     Brendan Boerner <bboerner.biz@gmail.com>
Cc:     linux-bcache@vger.kernel.org
Subject: Re: Bcache in Ubuntu 18.04 kernel panic
Message-ID: <20200902060529.GI10169@xoff>
References: <CAKkfZL0FR=PX5roCpB9HQe5=F6T70F7+8EFL_yTZPEbqWWHKPA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <CAKkfZL0FR=PX5roCpB9HQe5=F6T70F7+8EFL_yTZPEbqWWHKPA@mail.gmail.com>
Sender: linux-bcache-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-bcache.vger.kernel.org>
X-Mailing-List: linux-bcache@vger.kernel.org

On Tue, Sep 01, 2020 at 03:42:54PM -0500, Brendan Boerner wrote:
> Hi,
> 
> I spent the weekend verifying and isolating a kernel panic in bcache
> on Ubuntu 18.04 (4.15.0-112-generic #113-Ubuntu SMP Thu Jul 9 23:41:39
> UTC 2020).
> 
> Is this the place to report it? I have kernel crash dumps.

I'm no bcache developer, but I see there are Ubuntu kernel updates
available, with bcache fixes.

From the changelogs for 4.15.0-113.114:

  * Regression in kernel 4.15.0-91 causes kernel panic with Bcache
    (LP: #1867916)
    - bcache: check and adjust logical block size for backing devices


Perhaps you used unorthodox (neither 512b nor 4k) block sizes at bcache creation?


Regards
Matthias
