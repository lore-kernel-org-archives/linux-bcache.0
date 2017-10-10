From: tang.junhui@zte.com.cn
Subject: Re: [PATCH] bcache: fix race in setting bdev state
Date: Tue, 10 Oct 2017 14:51:04 +0800
Message-ID: <1507618264-2422-1-git-send-email-tang.junhui@zte.com.cn>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Return-path: <linux-bcache-owner@vger.kernel.org>
Received: from out1.zte.com.cn ([202.103.147.172]:44652 "EHLO mxct.zte.com.cn"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750950AbdJJGvb (ORCPT <rfc822;linux-bcache@vger.kernel.org>);
        Tue, 10 Oct 2017 02:51:31 -0400
Sender: linux-bcache-owner@vger.kernel.org
List-Id: linux-bcache@vger.kernel.org
To: mlyle@lyle.org
Cc: colyli@suse.de, linux-bcache@vger.kernel.org, linux-block@vger.kernel.org, tang.junhui@zte.com.cn

From: Tang Junhui <tang.junhui@zte.com.cn>

Hello Mike:

> One race I think I see: we unset the dirty bit before setting ourselves 
> interruptible.  Can bch_writeback_add/queue wake writeback before then 
> (and then writeback sets itself interruptible and never wakes up)?
> bch_writeback_add usually holds the writeback lock, but the writeback 
> lock is already released at this time (and bch_writeback_queue as used 
> by bch_cached_dev_detach doesn't traverse the writeback lock).
Yes, It's true. but it's hard to resolve it by holding writeback lock, 
since not all codes in bch_writeback_thread() are held in writeback lock, 
actually in a previous patch I have resolved it by changing schedule() to 
schedule_timeout(WRITE_BACK_WAIT_CYCLE) to avoid permanent sleep.


> There's a pretty intricate set of dependencies between the dirty bit, 
> the state in the superblock, the refcount, the writeback lock, and the 
> runnable state of the writeback thread.  It feels dangerous, but maybe 
> after I draw graphs of all the dependencies I'll feel better.

> Writeback locking needs refactoring for performance anyways-- maybe this 
> can simplified at the same time.
Yes, we'd better make clear the process, and find the issues and point to 
do refactor, but I think it is a long run, we need to do it step by step.

Regards,
Tang
