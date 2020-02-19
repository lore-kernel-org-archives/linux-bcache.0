From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 2/3] bcache: make bch_btree_check() to be multiple threads
Date: Wed, 19 Feb 2020 08:30:15 -0800
Message-ID: <20200219163015.GE10644@infradead.org>
References: <20200215082858.128025-1-colyli@suse.de>
 <20200215082858.128025-3-colyli@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-bcache-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.133]:33394 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726652AbgBSQaQ (ORCPT
        <rfc822;linux-bcache@vger.kernel.org>);
        Wed, 19 Feb 2020 11:30:16 -0500
Content-Disposition: inline
In-Reply-To: <20200215082858.128025-3-colyli@suse.de>
Sender: linux-bcache-owner@vger.kernel.org
List-Id: linux-bcache@vger.kernel.org
To: Coly Li <colyli@suse.de>
Cc: linux-bcache@vger.kernel.org, linux-block@vger.kernel.org

maybe s/be multiple threads/multithreaded/ in the subject?
