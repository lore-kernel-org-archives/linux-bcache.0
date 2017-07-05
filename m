From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 03/19] bcache: do not subtract sectors_to_gc for bypassed
 IO
Date: Wed, 5 Jul 2017 11:25:32 -0700
Message-ID: <20170705182532.GC10673@infradead.org>
References: <20170629134510.GA32385@infradead.org>
 <1498855388-16990-1-git-send-email-bcache@lists.ewheeler.net>
 <1498855388-16990-3-git-send-email-bcache@lists.ewheeler.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-bcache-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([65.50.211.133]:53577 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751680AbdGESZc (ORCPT
        <rfc822;linux-bcache@vger.kernel.org>);
        Wed, 5 Jul 2017 14:25:32 -0400
Content-Disposition: inline
In-Reply-To: <1498855388-16990-3-git-send-email-bcache@lists.ewheeler.net>
Sender: linux-bcache-owner@vger.kernel.org
List-Id: linux-bcache@vger.kernel.org
To: bcache@lists.ewheeler.net
Cc: linux-block@vger.kernel.org, linux-bcache@vger.kernel.org, hch@infradead.org, axboe@kernel.dk, Tang Junhui <tang.junhui@zte.com.cn>, stable@vger.kernel.org

Looks good,

Reviewed-by: Christoph Hellwig <hch@lst.de>
