From: Jens Axboe <axboe@kernel.dk>
Subject: Re: [PATCH 0/4] bcache: more fixes for v5.8-rc1
Date: Sun, 14 Jun 2020 16:48:53 -0600
Message-ID: <595e3582-980e-6cac-66d6-9ced628239e6@kernel.dk>
References: <20200614165333.124999-1-colyli@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-bcache-owner@vger.kernel.org>
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34742 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727928AbgFNWs5 (ORCPT
        <rfc822;linux-bcache@vger.kernel.org>);
        Sun, 14 Jun 2020 18:48:57 -0400
Received: from mail-pf1-x441.google.com (mail-pf1-x441.google.com [IPv6:2607:f8b0:4864:20::441])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C6D8EC05BD43
        for <linux-bcache@vger.kernel.org>; Sun, 14 Jun 2020 15:48:55 -0700 (PDT)
Received: by mail-pf1-x441.google.com with SMTP id s23so6991164pfh.7
        for <linux-bcache@vger.kernel.org>; Sun, 14 Jun 2020 15:48:55 -0700 (PDT)
In-Reply-To: <20200614165333.124999-1-colyli@suse.de>
Content-Language: en-US
Sender: linux-bcache-owner@vger.kernel.org
List-Id: linux-bcache@vger.kernel.org
To: colyli@suse.de
Cc: linux-bcache@vger.kernel.org, linux-block@vger.kernel.org

On 6/14/20 10:53 AM, colyli@suse.de wrote:
> From: Coly Li <colyli@suse.de>
> 
> Hi Jens,
> 
> Here are more following up fixes for bcache v5.8-rc1.
> 
> The two patches from me are minor clean up. Rested two patches
> are important.
> 
> - Mauricio Faria de Oliveira contributes a fix for a potential
>   kernel panic when users configures improper block size value
>   to bcache backing device. This problem should be fixed as soon
>   as possible IMHO.
> - Zhiqiang Liu contributes a fix for a potential deadlock (even quite
>   hard to trigger), which I want to have it as soon as possible.
> 
> Please take these patches for v5.8-rc1, or -rc2 if it is late for -rc1.

A few hours before -rc1 release is indeed too late. I'd only queue and
push anything this late if there was a very compelling reason to do so.

I've queued them up for -rc2.

-- 
Jens Axboe
