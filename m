From: Jens Axboe <axboe@kernel.dk>
Subject: Re: [PATCH 00/15] bcache: series of patches for 4.15
Date: Mon, 16 Oct 2017 09:08:03 -0600
Message-ID: <20171016150802.GA27385@kernel.dk>
References: <20171013233542.20938-1-mlyle@lyle.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-bcache-owner@vger.kernel.org>
Received: from mail-it0-f52.google.com ([209.85.214.52]:53439 "EHLO
        mail-it0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752678AbdJPPIF (ORCPT
        <rfc822;linux-bcache@vger.kernel.org>);
        Mon, 16 Oct 2017 11:08:05 -0400
Received: by mail-it0-f52.google.com with SMTP id n195so1519424itg.2
        for <linux-bcache@vger.kernel.org>; Mon, 16 Oct 2017 08:08:05 -0700 (PDT)
Content-Disposition: inline
In-Reply-To: <20171013233542.20938-1-mlyle@lyle.org>
Sender: linux-bcache-owner@vger.kernel.org
List-Id: linux-bcache@vger.kernel.org
To: Michael Lyle <mlyle@lyle.org>
Cc: linux-bcache@vger.kernel.org, linux-block@vger.kernel.org

On Fri, Oct 13 2017, Michael Lyle wrote:
> Jens, and everyone:
> 
> Here is the current series of work for inclusion in next and for 4.15's
> merge window.  We may get some additional fixes, but this is most of the
> work we expect.  All have been previously sent to these lists except the
> very last one.
> 
> There's a lot of small cleanup patches and fixes for race conditions.
> 
> Also included is my new rate controller which we've been measuring for
> some time, and other related changes to writeback rate management.

Applied for 4.15, thanks.

-- 
Jens Axboe
