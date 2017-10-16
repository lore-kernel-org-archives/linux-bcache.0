From: Michael Lyle <mlyle@lyle.org>
Subject: Re: [PATCH] bcache: writeback rate clamping: make 32 bit safe
Date: Mon, 16 Oct 2017 12:07:47 -0700
Message-ID: <CAJ+L6qcdCDP=G4FUQphESad6zcSTExYp_6KP8jQSmb9Y9CB-3g@mail.gmail.com>
References: <20171016173447.27253-1-mlyle@lyle.org> <20f5b753-1d5f-eb7d-cbb9-6ecaf43294f8@kernel.dk>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-bcache-owner@vger.kernel.org>
Received: from mail-qk0-f196.google.com ([209.85.220.196]:55624 "EHLO
        mail-qk0-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1757069AbdJPTHt (ORCPT
        <rfc822;linux-bcache@vger.kernel.org>);
        Mon, 16 Oct 2017 15:07:49 -0400
Received: by mail-qk0-f196.google.com with SMTP id x82so14192359qkb.12
        for <linux-bcache@vger.kernel.org>; Mon, 16 Oct 2017 12:07:48 -0700 (PDT)
In-Reply-To: <20f5b753-1d5f-eb7d-cbb9-6ecaf43294f8@kernel.dk>
Sender: linux-bcache-owner@vger.kernel.org
List-Id: linux-bcache@vger.kernel.org
To: Jens Axboe <axboe@kernel.dk>
Cc: linux-bcache@vger.kernel.org, linux-block@vger.kernel.org

Jens--

Thanks for your patience.

On Mon, Oct 16, 2017 at 12:01 PM, Jens Axboe <axboe@kernel.dk> wrote:
> On 10/16/2017 11:34 AM, Michael Lyle wrote:
>> Sorry this got through to linux-block, was detected by the kbuilds test
>> robot.  NSEC_PER_SEC is a long constant; 2.5 * 10^9 doesn't fit in a
>> signed long constant.
>
> Applied, but you should remember to add Fixes lines when a patch
> explicitly fixes a problem introduced by a previous patch. Ala:
>
> Fixes: e41166c5c44e ("bcache: writeback rate shouldn't artifically clamp")
>
> so that backports have an easier time finding dependent fixes.

Sorry about that too. I considered the Fixes: tag but didn't know if
the hashes would "hold true" into mainline.  Now I see Linus merges
your tree so the hash should be durable.

>
> --
> Jens Axboe
>

Mike
