From: Michael Lyle <mlyle@lyle.org>
Subject: Re: [for-416 PATCH 1/3] bcache: writeback: collapse contiguous IO
 better
Date: Wed, 27 Dec 2017 16:52:36 -0800
Message-ID: <a2b093ac-7c9e-c791-808c-04dc1392d28e@lyle.org>
References: <20171228004744.3522-1-mlyle@lyle.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-bcache-owner@vger.kernel.org>
Received: from mail-pf0-f172.google.com ([209.85.192.172]:38412 "EHLO
        mail-pf0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752016AbdL1Awi (ORCPT
        <rfc822;linux-bcache@vger.kernel.org>);
        Wed, 27 Dec 2017 19:52:38 -0500
Received: by mail-pf0-f172.google.com with SMTP id u25so20363946pfg.5
        for <linux-bcache@vger.kernel.org>; Wed, 27 Dec 2017 16:52:38 -0800 (PST)
In-Reply-To: <20171228004744.3522-1-mlyle@lyle.org>
Content-Language: en-US
Sender: linux-bcache-owner@vger.kernel.org
List-Id: linux-bcache@vger.kernel.org
To: linux-bcache@vger.kernel.org, linux-block@vger.kernel.org

Hey everyone,

These were previously sent and there was an extension discussion about
performance, finding that there was some slight regression on very large
extent workloads and significant performance improvement on smaller
extents.  This is a *huge* performance increase on my workload,
especially the behavior enabled in the #3 patch that allows dirty data
to be trimmed quickly during idle periods.

Reviewed-by tags would be appreciated so that these can be staged for 4.16.

I have additional changes coming in the next couple of days-- changes to
the closure code picked from kmo's bcachefs tree that both improve
performance and enhance correctness.  Just need a little more test and
to work on the commit comments some.

Thanks,

Mike
