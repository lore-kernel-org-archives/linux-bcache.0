From: Michael Lyle <mlyle@lyle.org>
Subject: Re: [PATCH] bcache: fix race in setting bdev state
Date: Mon, 9 Oct 2017 23:04:28 -0700
Message-ID: <6869122b-7310-c90b-f9bb-5fbd89e17422@lyle.org>
References: <1507613910-1156-1-git-send-email-tang.junhui@zte.com.cn>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-bcache-owner@vger.kernel.org>
Received: from mail-pf0-f174.google.com ([209.85.192.174]:53082 "EHLO
        mail-pf0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750950AbdJJGEb (ORCPT
        <rfc822;linux-bcache@vger.kernel.org>);
        Tue, 10 Oct 2017 02:04:31 -0400
Received: by mail-pf0-f174.google.com with SMTP id a1so12940867pfj.9
        for <linux-bcache@vger.kernel.org>; Mon, 09 Oct 2017 23:04:31 -0700 (PDT)
In-Reply-To: <1507613910-1156-1-git-send-email-tang.junhui@zte.com.cn>
Content-Language: en-US
Sender: linux-bcache-owner@vger.kernel.org
List-Id: linux-bcache@vger.kernel.org
To: tang.junhui@zte.com.cn
Cc: colyli@suse.de, linux-bcache@vger.kernel.org, linux-block@vger.kernel.org

Tang,

On 10/09/2017 10:38 PM, tang.junhui@zte.com.cn wrote:
> [snip]
> 
> As Far as now, except this issue, I can't see any more race during detach,
> so I don't think we need to take a writeback lock. Could you please show me
> what problem you worried about?

Ugh, this is partially my fault for not knowing the code path well. 
keep confusing myself.

One race I think I see: we unset the dirty bit before setting ourselves 
interruptible.  Can bch_writeback_add/queue wake writeback before then 
(and then writeback sets itself interruptible and never wakes up)?

bch_writeback_add usually holds the writeback lock, but the writeback 
lock is already released at this time (and bch_writeback_queue as used 
by bch_cached_dev_detach doesn't traverse the writeback lock).

There's a pretty intricate set of dependencies between the dirty bit, 
the state in the superblock, the refcount, the writeback lock, and the 
runnable state of the writeback thread.  It feels dangerous, but maybe 
after I draw graphs of all the dependencies I'll feel better.

Writeback locking needs refactoring for performance anyways-- maybe this 
can simplified at the same time.

Mike


> Regards,
> Tang
> --
> To unsubscribe from this list: send the line "unsubscribe linux-bcache" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
