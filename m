From: Michael Lyle <mlyle@lyle.org>
Subject: Re: [PATCH] bcache: fix race in setting bdev state
Date: Tue, 10 Oct 2017 00:46:05 -0700
Message-ID: <f6fe6362-ff20-6947-1f95-89ffa643e264@lyle.org>
References: <1507618264-2422-1-git-send-email-tang.junhui@zte.com.cn>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-bcache-owner@vger.kernel.org>
Received: from mail-pf0-f177.google.com ([209.85.192.177]:44437 "EHLO
        mail-pf0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1755470AbdJJHqI (ORCPT
        <rfc822;linux-bcache@vger.kernel.org>);
        Tue, 10 Oct 2017 03:46:08 -0400
Received: by mail-pf0-f177.google.com with SMTP id x7so6097330pfa.1
        for <linux-bcache@vger.kernel.org>; Tue, 10 Oct 2017 00:46:08 -0700 (PDT)
In-Reply-To: <1507618264-2422-1-git-send-email-tang.junhui@zte.com.cn>
Content-Language: en-US
Sender: linux-bcache-owner@vger.kernel.org
List-Id: linux-bcache@vger.kernel.org
To: tang.junhui@zte.com.cn
Cc: colyli@suse.de, linux-bcache@vger.kernel.org, linux-block@vger.kernel.org

Tang---

On 10/09/2017 11:51 PM, tang.junhui@zte.com.cn wrote:
[snip]
> Yes, It's true. but it's hard to resolve it by holding writeback lock, 
> since not all codes in bch_writeback_thread() are held in writeback lock, 
> actually in a previous patch I have resolved it by changing schedule() to 
> schedule_timeout(WRITE_BACK_WAIT_CYCLE) to avoid permanent sleep.

I'm not sure I understand.  The deeper stuff in bch_writeback_thread()
seems deterministic and guaranteed to wake on its own-- fixed delays
during writeback and waiting for IOs to complete.  Probably the worst
thing is dc->writeback_delay is very long.

It seems like that set_current_state(TASK_INTERRUPTIBLE) is the main
defective one-- and it can be fixed by moving it to above the unlock,
and having callers of bch_writeback_queue first acquire a shared
writeback lock.

>> There's a pretty intricate set of dependencies between the dirty bit, 
>> the state in the superblock, the refcount, the writeback lock, and the 
>> runnable state of the writeback thread.  It feels dangerous, but maybe 
>> after I draw graphs of all the dependencies I'll feel better.
> 
>> Writeback locking needs refactoring for performance anyways-- maybe this 
>> can simplified at the same time.
> Yes, we'd better make clear the process, and find the issues and point to 
> do refactor, but I think it is a long run, we need to do it step by step.

Yes, we should come up with a plan.

I like traversing the writeback lock on detach because all the critical
paths that touch state that detach cares about-- superblock state, dirty
state--- happen with the writeback lock acquired.  So it's easier to
reason about what happens if we acquire the lock exclusively-- we can be
sure that no one will set the device dirty again, that the wakeup to
writeback happens, that the ways that refcount can increase are limited,
etc.

That is, there's a lot less things to think about at once to be sure
it's correct.

Also, it seems like we need to do this to wake up the writeback thread
properly (rather than making it wake up and poll for detach).

> 
> Regards,
> Tang

Mike
