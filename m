From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 01/19] bcache: Fix leak of bdev reference
Date: Mon, 4 Sep 2017 23:43:48 -0700
Message-ID: <20170905064348.GA23716@infradead.org>
References: <20170629134510.GA32385@infradead.org>
 <1498855388-16990-1-git-send-email-bcache@lists.ewheeler.net>
 <20170705182447.GA10673@infradead.org>
 <e9019647-62b5-1c14-8b2f-66528b972b5c@coly.li>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-bcache-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([65.50.211.133]:51840 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750718AbdIEGnv (ORCPT
        <rfc822;linux-bcache@vger.kernel.org>);
        Tue, 5 Sep 2017 02:43:51 -0400
Content-Disposition: inline
In-Reply-To: <e9019647-62b5-1c14-8b2f-66528b972b5c@coly.li>
Sender: linux-bcache-owner@vger.kernel.org
List-Id: linux-bcache@vger.kernel.org
To: Coly Li <i@coly.li>
Cc: Christoph Hellwig <hch@infradead.org>, bcache@lists.ewheeler.net, linux-block@vger.kernel.org, linux-bcache@vger.kernel.org, axboe@kernel.dk, Jan Kara <jack@suse.cz>

On Tue, Sep 05, 2017 at 01:30:04AM +0800, Coly Li wrote:
> 
> When you mentioned "whole chunk of code", do you mean the following
> block of code ?
> 
> 
> 1960         if (IS_ERR(bdev)) {
> ========= start of whole chunk of code ============
> 1961                 if (bdev == ERR_PTR(-EBUSY)) {
> 1962                         bdev = lookup_bdev(strim(path));
> 1963                         mutex_lock(&bch_register_lock);
> 1964                         if (!IS_ERR(bdev) && bch_is_open(bdev))
> 1965                                 err = "device already registered";
> 1966                         else
> 1967                                 err = "device busy";
> 1968                         mutex_unlock(&bch_register_lock);
> 1969                         if (!IS_ERR(bdev))
> 1970                                 bdput(bdev);
> 1971                         if (attr == &ksysfs_register_quiet)
> 1972                                 goto out;
> 1973                 }
> ========= end of whole chunk of code ============
> 1974                 goto err;
> 1975         }
> 
> I don't mind to remove it, just double check I don't misunderstand what
> you meant.

Yes, that's the problematic block.
