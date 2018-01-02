From: Michael Lyle <mlyle@lyle.org>
Subject: Re: [for-416 PATCH 3/3] bcache: allow quick writeback when backing idle
Date: Tue, 2 Jan 2018 00:18:45 -0800
Message-ID: <CAJ+L6qfmWSZ0bn06pa4UjXn_G2-t-ZX=J9KBAWE8dP-kQLK_Qw@mail.gmail.com>
References: <1514876572-10611-1-git-send-email-tang.junhui@zte.com.cn>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-bcache-owner@vger.kernel.org>
Received: from mail-qk0-f196.google.com ([209.85.220.196]:39452 "EHLO
        mail-qk0-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751712AbeABISr (ORCPT
        <rfc822;linux-bcache@vger.kernel.org>);
        Tue, 2 Jan 2018 03:18:47 -0500
Received: by mail-qk0-f196.google.com with SMTP id c5so1494478qkg.6
        for <linux-bcache@vger.kernel.org>; Tue, 02 Jan 2018 00:18:46 -0800 (PST)
In-Reply-To: <1514876572-10611-1-git-send-email-tang.junhui@zte.com.cn>
Sender: linux-bcache-owner@vger.kernel.org
List-Id: linux-bcache@vger.kernel.org
To: Junhui Tang <tang.junhui@zte.com.cn>
Cc: linux-bcache <linux-bcache@vger.kernel.org>, linux-block@vger.kernel.org

On Mon, Jan 1, 2018 at 11:02 PM,  <tang.junhui@zte.com.cn> wrote:
> From: Tang Junhui <tang.junhui@zte.com.cn>
>
> I noticed you add "closure_sync(&cl)" before assigning delay to zero in your patch,
> I think we should add it before:
> delay = writeback_delay(dc, size)
> otherwise we would alays get a wrong value of delay after calling writeback_delay(),
> since the write-back IO is just sended out and not finished yet.
>
> Am I right?

I don't think so.   The thing that is controlled (in current code, and
this patch set) is the rate of issuance, not of completion (though
issuance rate is guaranteed not to exceed completion rate, because of
the semaphore for the maximum number of I/Os outstanding).

The intention with this code is to notice when we are ahead on
schedule on writeback, and if so, start the next I/O after all of the
current set finishes.  Only in this case do we do closure_sync, as a
way to wait for all the existing I/Os to complete.  This guarantees
that we never have more than one I/O outstanding when doing
"opportunistic idle writeback", and that new front-end I/O never has
to compete with more than one thing in the queue in this case.

Mike
