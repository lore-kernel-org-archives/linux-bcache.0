From: Michael Lyle <mlyle@lyle.org>
Subject: Re: [for-416 PATCH] bcache: fix writeback target calc on large devices
Date: Tue, 2 Jan 2018 00:12:13 -0800
Message-ID: <CAJ+L6qcbp92KkfzBWkpwZRX9fc6sFkXSs306YP7qcoJsVuybLg@mail.gmail.com>
References: <1514874831-10255-1-git-send-email-tang.junhui@zte.com.cn>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-block-owner@vger.kernel.org>
In-Reply-To: <1514874831-10255-1-git-send-email-tang.junhui@zte.com.cn>
Sender: linux-block-owner@vger.kernel.org
To: Junhui Tang <tang.junhui@zte.com.cn>
Cc: linux-bcache <linux-bcache@vger.kernel.org>, linux-block@vger.kernel.org
List-Id: linux-bcache@vger.kernel.org

Tang Junhui--

Thank you for the feedback.

On Mon, Jan 1, 2018 at 10:33 PM,  <tang.junhui@zte.com.cn> wrote:
> From: Tang Junhui <tang.junhui@zte.com.cn>
>
> This patch is useful for preventing the overflow of the expression
> (cache_dirty_target * bdev_sectors(dc->bdev)), but it also
> lead into a calc error, for example, when there is a 1G and
> 100*164G cached device, it would cause the "target" value to
> be aways zero of the 1G device, which would cause write-back
> threshold losing efficacy.
>
> Maybe at first we can judge if it overflows or not of the expression
> (cache_dirty_target * bdev_sectors(dc->bdev)), if it overflows,
> We can calc the value of target as the patch, otherwise,
> we calc it as old way.

Maybe it'd be preferable just to ensure that share always >=1.  It
seems like a pretty narrow set of cases where the current math works
and the new math doesn't work, though, as I expect that it's
relatively rare to have such a variation in sizes, and even so 16.4TB
uses up 35 bits of the 64 bit quantity.

I don't really like special cases or trying two different ways to do
the math, because then it's very difficult to test.

What do you think?

Mike
