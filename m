From: Kent Overstreet <kent.overstreet@gmail.com>
Subject: Re: [PATCH] bcache: untagle cache_aolloc
Date: Mon, 18 Jul 2016 02:13:33 -0800
Message-ID: <20160718101333.GA18961@kmo-pixel>
References: <1468836669-1136-1-git-send-email-jthumshirn@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-bcache-owner@vger.kernel.org>
Received: from mail-pa0-f68.google.com ([209.85.220.68]:32794 "EHLO
	mail-pa0-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751499AbcGRKNh (ORCPT
	<rfc822;linux-bcache@vger.kernel.org>);
	Mon, 18 Jul 2016 06:13:37 -0400
Content-Disposition: inline
In-Reply-To: <1468836669-1136-1-git-send-email-jthumshirn@suse.de>
Sender: linux-bcache-owner@vger.kernel.org
List-Id: linux-bcache@vger.kernel.org
To: Johannes Thumshirn <jthumshirn@suse.de>
Cc: Jens Axboe <axboe@fb.com>, Eric Wheeler <git@linux.ewheeler.net>, Coly Li <colyli@suse.de>, linux-bcache@vger.kernel.org, linux-kernel@vger.kernel.org

On Mon, Jul 18, 2016 at 12:11:09PM +0200, Johannes Thumshirn wrote:
> bcache's cache_alloc() function currenty has no way freeing memory if one of
> the allocations fails. Untangle the if + allocation statement so we have
> defined checkpoints to free previous allocations if one fails.

nack. The existing error path handles failure midway through just fine.
