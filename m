From: Keith Busch <kbusch@kernel.org>
Subject: Re: [RFC PATCH 2/4] block: block: change REQ_OP_ZONE_RESET from 8 to
 15
Date: Sat, 16 May 2020 02:22:35 +0900
Message-ID: <20200515172235.GA21682@redsun51.ssa.fujisawa.hgst.com>
References: <20200515163157.72796-1-colyli@suse.de>
 <20200515163157.72796-3-colyli@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-bcache-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:48932 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726170AbgEORWo (ORCPT <rfc822;linux-bcache@vger.kernel.org>);
        Fri, 15 May 2020 13:22:44 -0400
Content-Disposition: inline
In-Reply-To: <20200515163157.72796-3-colyli@suse.de>
Sender: linux-bcache-owner@vger.kernel.org
List-Id: linux-bcache@vger.kernel.org
To: Coly Li <colyli@suse.de>
Cc: linux-block@vger.kernel.org, damien.lemoal@wdc.com, hare@suse.com, hch@lst.de, axboe@kernel.dk, linux-bcache@vger.kernel.org, Chaitanya Kulkarni <chaitanya.kulkarni@wdc.com>, Johannes Thumshirn <johannes.thumshirn@wdc.com>

The subject title for this patch should mention "REQ_OP_ZONE_RESET_ALL"
instead of "REQ_OP_ZONE_RESET".
