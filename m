From: Jens Axboe <axboe@kernel.dk>
Subject: Re: [PATCH 0/2] bcache patches for Linux v5.7-rc5
Date: Mon, 4 May 2020 09:52:01 -0600
Message-ID: <ade380f2-e124-9e64-572a-3299bebcd658@kernel.dk>
References: <20200504153529.2242-1-colyli@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-bcache-owner@vger.kernel.org>
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36704 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1725941AbgEDPwF (ORCPT
        <rfc822;linux-bcache@vger.kernel.org>);
        Mon, 4 May 2020 11:52:05 -0400
Received: from mail-io1-xd44.google.com (mail-io1-xd44.google.com [IPv6:2607:f8b0:4864:20::d44])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 106E4C061A0E
        for <linux-bcache@vger.kernel.org>; Mon,  4 May 2020 08:52:04 -0700 (PDT)
Received: by mail-io1-xd44.google.com with SMTP id w4so12803091ioc.6
        for <linux-bcache@vger.kernel.org>; Mon, 04 May 2020 08:52:04 -0700 (PDT)
In-Reply-To: <20200504153529.2242-1-colyli@suse.de>
Content-Language: en-US
Sender: linux-bcache-owner@vger.kernel.org
List-Id: linux-bcache@vger.kernel.org
To: Coly Li <colyli@suse.de>
Cc: linux-bcache@vger.kernel.org, linux-block@vger.kernel.org

On 5/4/20 9:35 AM, Coly Li wrote:
> Hi Jens,
> 
> These two patches are in my testing directory for weeks and it is
> about time to submit them for Linux v5.7-rc5.
> 
> The first one from Colin helps to remove unncessary local variables.
> And Joe contributes second patch to improve the kernel message format
> by remove extra '\n' from existing pr_format() and adds the '\n' to
> the location of printing kernel messages. 
> 
> Please them for v5.7.

Why not 5.8? Doesn't look critical, nor something that was introduced
in this series. More like cleanups, hence should go into 5.8 instead.

-- 
Jens Axboe
