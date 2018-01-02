From: tang.junhui@zte.com.cn
Subject: Re: [for-416 PATCH 3/3] bcache: allow quick writeback when backing idle
Date: Tue, 2 Jan 2018 16:53:56 +0800
Message-ID: <1514883236-11844-1-git-send-email-tang.junhui@zte.com.cn>
Return-path: <linux-bcache-owner@vger.kernel.org>
Received: from mxhk.zte.com.cn ([63.217.80.70]:56264 "EHLO mxhk.zte.com.cn"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751666AbeABIwg (ORCPT <rfc822;linux-bcache@vger.kernel.org>);
        Tue, 2 Jan 2018 03:52:36 -0500
Sender: linux-bcache-owner@vger.kernel.org
List-Id: linux-bcache@vger.kernel.org
To: mlyle@lyle.org
Cc: linux-bcache@vger.kernel.org, linux-block@vger.kernel.org, tang.junhui@zte.com.cn

From: Tang Junhui <tang.junhui@zte.com.cn>

>I don't think so.   The thing that is controlled (in current code, and
>this patch set) is the rate of issuance, not of completion (though
>issuance rate is guaranteed not to exceed completion rate, because of
>the semaphore for the maximum number of I/Os outstanding).

OK, I see.

>The intention with this code is to notice when we are ahead on
>schedule on writeback, and if so, start the next I/O after all of the
>current set finishes.  Only in this case do we do closure_sync, as a
>way to wait for all the existing I/Os to complete.  This guarantees
>that we never have more than one I/O outstanding when doing
>"opportunistic idle writeback", and that new front-end I/O never has
>to compete with more than one thing in the queue in this case.

If no front-end I/O coming, would this cause write-back IOs one by one
(one write-back IO issued must after the completion of the previous IO)?
though with zero delay time, is the write-back performance still good?

Thanks,
Tang Junhui
