From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 01/19] bcache: Fix leak of bdev reference
Date: Wed, 5 Jul 2017 11:24:47 -0700
Message-ID: <20170705182447.GA10673@infradead.org>
References: <20170629134510.GA32385@infradead.org>
 <1498855388-16990-1-git-send-email-bcache@lists.ewheeler.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-block-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1498855388-16990-1-git-send-email-bcache@lists.ewheeler.net>
Sender: linux-block-owner@vger.kernel.org
To: bcache@lists.ewheeler.net
Cc: linux-block@vger.kernel.org, linux-bcache@vger.kernel.org, hch@infradead.org, axboe@kernel.dk, Jan Kara <jack@suse.cz>, stable@vger.kernel.org
List-Id: linux-bcache@vger.kernel.org

On Fri, Jun 30, 2017 at 01:42:50PM -0700, bcache@lists.ewheeler.net wrote:
> From: Jan Kara <jack@suse.cz>
> 
> If blkdev_get_by_path() in register_bcache() fails, we try to lookup the
> block device using lookup_bdev() to detect which situation we are in to
> properly report error. However we never drop the reference returned to
> us from lookup_bdev(). Fix that.

This look ok, but I think that whole chunk of code should just go
away - adding a lookup_bdev and resulting mess just for a slightly
different error message is just insane.
