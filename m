From: Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH] bio: ensure __bio_clone_fast copies bi_partno
Date: Fri, 17 Nov 2017 16:08:42 +0100
Message-ID: <20171117150842.GB24694@lst.de>
References: <20171117074725.22536-1-mlyle@lyle.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-bcache-owner@vger.kernel.org>
Received: from verein.lst.de ([213.95.11.211]:49130 "EHLO newverein.lst.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S964890AbdKQPIo (ORCPT <rfc822;linux-bcache@vger.kernel.org>);
        Fri, 17 Nov 2017 10:08:44 -0500
Content-Disposition: inline
In-Reply-To: <20171117074725.22536-1-mlyle@lyle.org>
Sender: linux-bcache-owner@vger.kernel.org
List-Id: linux-bcache@vger.kernel.org
To: Michael Lyle <mlyle@lyle.org>
Cc: linux-block@vger.kernel.org, linux-bcache@vger.kernel.org, Christoph Hellwig <hch@lst.de>, Jens Axboe <axboe@kernel.dk>, stable@vger.kernel.org

Looks good,

Reviewed-by: Christoph Hellwig <hch@lst.de>
