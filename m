From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 09/11] bcache: use kmalloc to allocate bio in
 bch_data_verify()
Date: Fri, 21 Apr 2017 04:31:40 -0700
Message-ID: <20170421113140.GH12523@infradead.org>
References: <149266645258.27388.14083229348123176454.stgit@noble>
 <149266673005.27388.9415706764616504556.stgit@noble>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-bcache-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([65.50.211.133]:40563 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1038702AbdDULbl (ORCPT
        <rfc822;linux-bcache@vger.kernel.org>);
        Fri, 21 Apr 2017 07:31:41 -0400
Content-Disposition: inline
In-Reply-To: <149266673005.27388.9415706764616504556.stgit@noble>
Sender: linux-bcache-owner@vger.kernel.org
List-Id: linux-bcache@vger.kernel.org
To: NeilBrown <neilb@suse.com>
Cc: Jens Axboe <axboe@kernel.dk>, linux-block@vger.kernel.org, linux-kernel@vger.kernel.org, Kent Overstreet <kent.overstreet@gmail.com>, linux-bcache@vger.kernel.org

Looks fine,

Reviewed-by: Christoph Hellwig <hch@lst.de>
