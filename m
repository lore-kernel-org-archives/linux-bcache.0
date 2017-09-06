From: Jens Axboe <axboe@kernel.dk>
Subject: Re: [PATCH 00/13] bcache: fixes and update for 4.14
Date: Wed, 6 Sep 2017 08:20:04 -0600
Message-ID: <20170906142002.GA19380@kernel.dk>
References: <20170906062602.50497-1-colyli@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-bcache-owner@vger.kernel.org>
Received: from mail-io0-f170.google.com ([209.85.223.170]:33610 "EHLO
        mail-io0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932286AbdIFOUG (ORCPT
        <rfc822;linux-bcache@vger.kernel.org>);
        Wed, 6 Sep 2017 10:20:06 -0400
Received: by mail-io0-f170.google.com with SMTP id y123so24065461iod.0
        for <linux-bcache@vger.kernel.org>; Wed, 06 Sep 2017 07:20:06 -0700 (PDT)
Content-Disposition: inline
In-Reply-To: <20170906062602.50497-1-colyli@suse.de>
Sender: linux-bcache-owner@vger.kernel.org
List-Id: linux-bcache@vger.kernel.org
To: Coly Li <colyli@suse.de>
Cc: linux-bcache@vger.kernel.org, linux-block@vger.kernel.org, bcache@lists.ewheeler.net

On Wed, Sep 06 2017, Coly Li wrote:
> Hi Jens,
> 
> Here are 12 patchs for bcache fixes and updates, most of them were posted
> by Eric Wheeler in 4.13 merge window, but delayed due to lack of code
> review.

Next time, please send this _before_ the merge window opens. Not a huge
problem for this series, since it has been posted numerous times in the
past and already has good review coverage, but it really should have
been in linux-next for a week or two before heading upstream.

> There are some other patches which does not pass my test currently,
> once they are fixed and reviewed by peer developers I will send them
> to you for 4.14 merge window.

If they are not passing tests etc before the merge window opens, they
are not for this cycle.

-- 
Jens Axboe
