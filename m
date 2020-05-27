From: Jens Axboe <axboe@kernel.dk>
Subject: Re: [PATCH v2 0/5] bcache patches for Linux-5.8
Date: Wed, 27 May 2020 05:20:02 -0600
Message-ID: <75af2ed6-9dec-a99c-76e1-4708aec30b76@kernel.dk>
References: <20200527040155.43690-1-colyli@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-bcache-owner@vger.kernel.org>
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43180 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2388192AbgE0LUE (ORCPT
        <rfc822;linux-bcache@vger.kernel.org>);
        Wed, 27 May 2020 07:20:04 -0400
Received: from mail-pj1-x1041.google.com (mail-pj1-x1041.google.com [IPv6:2607:f8b0:4864:20::1041])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CB6F7C061A0F
        for <linux-bcache@vger.kernel.org>; Wed, 27 May 2020 04:20:04 -0700 (PDT)
Received: by mail-pj1-x1041.google.com with SMTP id q9so1400070pjm.2
        for <linux-bcache@vger.kernel.org>; Wed, 27 May 2020 04:20:04 -0700 (PDT)
In-Reply-To: <20200527040155.43690-1-colyli@suse.de>
Content-Language: en-US
Sender: linux-bcache-owner@vger.kernel.org
List-Id: linux-bcache@vger.kernel.org
To: Coly Li <colyli@suse.de>
Cc: linux-bcache@vger.kernel.org, linux-block@vger.kernel.org

On 5/26/20 10:01 PM, Coly Li wrote:
> Hi Jens,
> 
> This is the bcache patches for Linux v5.8.
> 
> Patches from Colin Ian King and Joe Perches are sent again for v5.8
> merge windows. The first patch from me is to fix a refcount underflow
> issue when stopping a pending backing device without created bcache
> device. The last two patches from me is for an experiment sysfs
> interface to register bcache devices in asynchronous way, to avoid
> the udevd timeout issue which I tried before.
> 
> Please take them for v5.8, and thank you in advance.

Applied for 5.8, thanks.

-- 
Jens Axboe
