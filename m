From: Jens Axboe <axboe@kernel.dk>
Subject: Re: [PATCH] bcache: writeback rate clamping: make 32 bit safe
Date: Mon, 16 Oct 2017 13:01:02 -0600
Message-ID: <20f5b753-1d5f-eb7d-cbb9-6ecaf43294f8@kernel.dk>
References: <20171016173447.27253-1-mlyle@lyle.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-bcache-owner@vger.kernel.org>
Received: from mail-it0-f49.google.com ([209.85.214.49]:56708 "EHLO
        mail-it0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753146AbdJPTBE (ORCPT
        <rfc822;linux-bcache@vger.kernel.org>);
        Mon, 16 Oct 2017 15:01:04 -0400
Received: by mail-it0-f49.google.com with SMTP id r127so2351872itb.5
        for <linux-bcache@vger.kernel.org>; Mon, 16 Oct 2017 12:01:04 -0700 (PDT)
In-Reply-To: <20171016173447.27253-1-mlyle@lyle.org>
Content-Language: en-US
Sender: linux-bcache-owner@vger.kernel.org
List-Id: linux-bcache@vger.kernel.org
To: Michael Lyle <mlyle@lyle.org>, linux-bcache@vger.kernel.org, linux-block@vger.kernel.org

On 10/16/2017 11:34 AM, Michael Lyle wrote:
> Sorry this got through to linux-block, was detected by the kbuilds test
> robot.  NSEC_PER_SEC is a long constant; 2.5 * 10^9 doesn't fit in a
> signed long constant.

Applied, but you should remember to add Fixes lines when a patch
explicitly fixes a problem introduced by a previous patch. Ala:

Fixes: e41166c5c44e ("bcache: writeback rate shouldn't artifically clamp")

so that backports have an easier time finding dependent fixes.

-- 
Jens Axboe
