From: Jens Axboe <axboe@kernel.dk>
Subject: Re: block I/O accounting improvements v2
Date: Wed, 27 May 2020 05:22:03 -0600
Message-ID: <e807976c-4a6a-ac93-17b4-a6a7dfc438be@kernel.dk>
References: <20200527052419.403583-1-hch@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-bcache-owner@vger.kernel.org>
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43500 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726900AbgE0LWG (ORCPT
        <rfc822;linux-bcache@vger.kernel.org>);
        Wed, 27 May 2020 07:22:06 -0400
Received: from mail-pl1-x629.google.com (mail-pl1-x629.google.com [IPv6:2607:f8b0:4864:20::629])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B7FFDC03E979
        for <linux-bcache@vger.kernel.org>; Wed, 27 May 2020 04:22:06 -0700 (PDT)
Received: by mail-pl1-x629.google.com with SMTP id bg4so4726803plb.3
        for <linux-bcache@vger.kernel.org>; Wed, 27 May 2020 04:22:06 -0700 (PDT)
In-Reply-To: <20200527052419.403583-1-hch@lst.de>
Content-Language: en-US
Sender: linux-bcache-owner@vger.kernel.org
List-Id: linux-bcache@vger.kernel.org
To: Christoph Hellwig <hch@lst.de>
Cc: Konstantin Khlebnikov <khlebnikov@yandex-team.ru>, Minchan Kim <minchan@kernel.org>, Nitin Gupta <ngupta@vflare.org>, dm-devel@redhat.com, linux-block@vger.kernel.org, drbd-dev@lists.linbit.com, linux-bcache@vger.kernel.org, linux-nvdimm@lists.01.org, linux-kernel@vger.kernel.org

On 5/26/20 11:24 PM, Christoph Hellwig wrote:
> Hi Jens,
> 
> they series contains various improvement for block I/O accounting.  The
> first bunch of patches switch the bio based drivers to better accounting
> helpers compared to the current mess.  The end contains a fix and various
> performanc improvements.  Most of this comes from a series Konstantin
> sent a few weeks ago, rebased on changes that landed in your tree since
> and my change to always use the percpu version of the disk stats.

Applied, thanks.

-- 
Jens Axboe
