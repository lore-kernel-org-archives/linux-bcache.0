From: tang.junhui@zte.com.cn
Subject: Re: Re: [PATCH] bcache: add a separate open bucket list for flash devices
Date: Wed, 22 Nov 2017 09:29:02 +0800
Message-ID: <1511314142-19225-1-git-send-email-tang.junhui@zte.com.cn>
Return-path: <linux-bcache-owner@vger.kernel.org>
Received: from out1.zte.com.cn ([202.103.147.172]:35598 "EHLO mxct.zte.com.cn"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751344AbdKVB3S (ORCPT <rfc822;linux-bcache@vger.kernel.org>);
        Tue, 21 Nov 2017 20:29:18 -0500
Sender: linux-bcache-owner@vger.kernel.org
List-Id: linux-bcache@vger.kernel.org
To: kent.overstreet@gmail.com, colyli@suse.de, mlyle@lyle.org
Cc: linux-bcache@vger.kernel.org, linux-block@vger.kernel.org, tang.junhui@zte.com.cn

From: Tang Junhui <tang.junhui@zte.com.cn>

Hello Coly, Kent

> Correct me if I am wrong. I guess the reason why you care about flash
> only volume is because ceph users use flash only volume to store some
> metadata only on SSD ?

Yes, we store ceph metadata in flash only volume and object data in 
cached device. The buckets reclaimer performs badly, buckets often 
be exhaustion.

> If that's the goal the way to do it would be to segregate the write points, not
> the open buckets.
This patch is simple and effective, but I will try the method of segregating
the write points, and send a patch V2 later.        

Thanks,
Tang
