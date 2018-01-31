From: tang.junhui@zte.com.cn
Subject: Re: Bcache status and queue
Date: Wed, 31 Jan 2018 16:26:17 +0800
Message-ID: <1517387177-31805-1-git-send-email-tang.junhui@zte.com.cn>
Return-path: <linux-bcache-owner@vger.kernel.org>
Received: from mxhk.zte.com.cn ([63.217.80.70]:49426 "EHLO mxhk.zte.com.cn"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751816AbeAaIYA (ORCPT <rfc822;linux-bcache@vger.kernel.org>);
        Wed, 31 Jan 2018 03:24:00 -0500
Sender: linux-bcache-owner@vger.kernel.org
List-Id: linux-bcache@vger.kernel.org
To: mlyle@lyle.org
Cc: colyli@suse.de, linux-bcache@vger.kernel.org, tang.junhui@zte.com.cn

From: Tang Junhui <tang.junhui@zte.com.cn>


Hell Mike,

I hope these patches can be reviwed and inclued in
4.16, since they are bugs to me.
[PATCH] bcache: fix error return value in memory shrink
[PATCH] bcache: fix error count in memory shrink
[PATCH 2/2] bcache: fix high CPU occupancy during journal
[PATCH 1/2] bcache: add journal statistic
[PATCH] [PATCH v2] bcache: fix for allocator and register thread race
[PATCH v4 09/13] bcache: fix inaccurate io state for detached bcache devices

I hope bellow patch can be reviewd, since I need it very much:
[PATCH] bcache: finish incremental GC

And Coly's patches is also important, but thanks to Hannes,
most of them have been already well reviewed.


Thanks.
Tang Junhui
