From: Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH 04/10] bcache: clean up hacks around bio_split_pool
Date: Tue, 28 Apr 2015 14:14:38 +0200
Message-ID: <20150428121438.GB10479@lst.de>
References: <1430203717-13307-1-git-send-email-mlin@kernel.org> <1430203717-13307-5-git-send-email-mlin@kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-bcache-owner@vger.kernel.org>
Received: from verein.lst.de ([213.95.11.211]:40691 "EHLO newverein.lst.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965417AbbD1MOk (ORCPT <rfc822;linux-bcache@vger.kernel.org>);
	Tue, 28 Apr 2015 08:14:40 -0400
Content-Disposition: inline
In-Reply-To: <1430203717-13307-5-git-send-email-mlin@kernel.org>
Sender: linux-bcache-owner@vger.kernel.org
List-Id: linux-bcache@vger.kernel.org
To: Ming Lin <mlin@kernel.org>
Cc: linux-kernel@vger.kernel.org, Christoph Hellwig <hch@lst.de>, Jens Axboe <axboe@kernel.dk>, Kent Overstreet <kent.overstreet@gmail.com>, Dongsu Park <dongsu.park@profitbricks.com>, linux-bcache@vger.kernel.org

On Mon, Apr 27, 2015 at 11:48:31PM -0700, Ming Lin wrote:
> From: Kent Overstreet <kent.overstreet@gmail.com>
> 
> There has been workarounds only in bcache, for splitting pool as well
> as submitting bios. Since generic_make_request() is able to handle
> arbitrarily sized bios, it's now possible to delete those hacks.

The Subject and description look confusing to me.

From me reading of the code I'd word it as:

Subject: bcache: remove driver private bio splitting code

The bcache driver has always accepted arbitrarily large bios and split
them internally.  Now that every driver must accept arbitrarily large
bios this code isn't nessecary anymore.
