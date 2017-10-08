From: Coly Li <i@coly.li>
Subject: Re: [PATCH] bcache: writeback rate shouldn't artifically clamp
Date: Sun, 8 Oct 2017 14:09:20 +0800
Message-ID: <fe817f47-89d6-8543-ded6-7ffa46fd52d0@coly.li>
References: <20171008052520.17068-1-mlyle@lyle.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Return-path: <linux-bcache-owner@vger.kernel.org>
Received: from server.coly.li ([162.144.45.48]:47676 "EHLO server.coly.li"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750771AbdJHGJY (ORCPT <rfc822;linux-bcache@vger.kernel.org>);
        Sun, 8 Oct 2017 02:09:24 -0400
In-Reply-To: <20171008052520.17068-1-mlyle@lyle.org>
Content-Language: en-US
Sender: linux-bcache-owner@vger.kernel.org
List-Id: linux-bcache@vger.kernel.org
To: Michael Lyle <mlyle@lyle.org>, linux-bcache@vger.kernel.org, linux-block@vger.kernel.org
Cc: colyli@suse.de

On 2017/10/8 下午1:25, Michael Lyle wrote:
> The previous code artificially limited writeback rate to 1000000
> blocks/second (NSEC_PER_MSEC), which is a rate that can be met on fast
> hardware.  The rate limiting code works fine (though with decreased
> precision) up to 3 orders of magnitude faster, so use NSEC_PER_SEC.
> 
> Additionally, ensure that uint32_t is used as a type for rate throughout
> the rate management so that type checking/clamp_t can work properly.
> 
> bch_next_delay should be rewritten for increased precision and better
> handling of high rates and long sleep periods, but this is adequate for
> now.
> 
> Signed-off-by: Michael Lyle <mlyle@lyle.org>
> Reported-by: Coly Li <colyli@suse.de>

Added to for-test, I will update test result after the writeback
performance test done (hopefully in 2 days).

Thanks for fast fix.

Coly Li


[snip]
