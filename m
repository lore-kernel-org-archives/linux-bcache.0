From: Jens Axboe <axboe@kernel.dk>
Subject: Re: Series of patches for bcache targeting 4.15
Date: Mon, 30 Oct 2017 15:58:23 -0600
Message-ID: <20171030215821.GA17465@kernel.dk>
References: <20171030214635.29888-1-mlyle@lyle.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-bcache-owner@vger.kernel.org>
Received: from mail-pg0-f51.google.com ([74.125.83.51]:53713 "EHLO
        mail-pg0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751936AbdJ3V60 (ORCPT
        <rfc822;linux-bcache@vger.kernel.org>);
        Mon, 30 Oct 2017 17:58:26 -0400
Received: by mail-pg0-f51.google.com with SMTP id s2so12812686pge.10
        for <linux-bcache@vger.kernel.org>; Mon, 30 Oct 2017 14:58:26 -0700 (PDT)
Content-Disposition: inline
In-Reply-To: <20171030214635.29888-1-mlyle@lyle.org>
Sender: linux-bcache-owner@vger.kernel.org
List-Id: linux-bcache@vger.kernel.org
To: Michael Lyle <mlyle@lyle.org>
Cc: linux-bcache@vger.kernel.org, linux-block@vger.kernel.org

On Mon, Oct 30 2017, Michael Lyle wrote:
> Hi Jens--
> 
> I have a few last patches for bcache targeting 4.15 if it's
> possible to get them in.  I'm sorry this is a bit late.
> 
> All are reviewed and have received a moderate amount of test
> in my environment (and I'm continuing testing).
> 
> [PATCH 1/5] bcache: only permit to recovery read error when cache
> [PATCH 2/5] bcache: convert cached_dev.count from atomic_t to
> [PATCH 3/5] bcache: update bucket_in_use in real time
> [PATCH 4/5] bcache: fix wrong cache_misses statistics
> [PATCH 5/5] bcache: explicitly destroy mutex while exiting
> 
> Patches 1 and 3 are critical.  The first fixes correctness problems
> if a cache volume fails and is being carried in distro trees.  #3
> prevents a rare issue that can cause extended hanging of end-user
> I/O.  The other three patches are relatively safe cleanup.

Thanks, applied for 4.15.

-- 
Jens Axboe
