From: Jens Axboe <axboe@kernel.dk>
Subject: Re: [GIT PULL] bcache for 3.14
Date: Thu, 9 Jan 2014 19:34:47 -0700
Message-ID: <20140110023447.GG6780@kernel.dk>
References: <20140108211907.GD7291@kmo-pixel>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-bcache-owner@vger.kernel.org>
Received: from merlin.infradead.org ([205.233.59.134]:49399 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755458AbaAJCet (ORCPT
	<rfc822;linux-bcache@vger.kernel.org>);
	Thu, 9 Jan 2014 21:34:49 -0500
Content-Disposition: inline
In-Reply-To: <20140108211907.GD7291@kmo-pixel>
Sender: linux-bcache-owner@vger.kernel.org
List-Id: linux-bcache@vger.kernel.org
To: Kent Overstreet <kmo@daterainc.com>
Cc: linux-kernel@vger.kernel.org, linux-bcache@vger.kernel.org

On Wed, Jan 08 2014, Kent Overstreet wrote:
> Jens, here's the updated bcache pull, rebased and retested on top of
> your latest for-3.14/drivers branch. Only other change was a one liner
> in the "bcache/md: Use raid stripe size" patch to update
> blk_stack_limits(), as pointed out by Mike Snitzer.

Pulled, thanks!

-- 
Jens Axboe
