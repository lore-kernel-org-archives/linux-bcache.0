From: Christoph Hellwig <hch@lst.de>
Subject: Re: [RFC PATCH v2 4/4] block: set bi_size to REQ_OP_ZONE_RESET bio
Date: Sat, 16 May 2020 14:53:07 +0200
Message-ID: <20200516125307.GB13759@lst.de>
References: <20200516035434.82809-1-colyli@suse.de> <20200516035434.82809-5-colyli@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-bcache-owner@vger.kernel.org>
Received: from verein.lst.de ([213.95.11.211]:60489 "EHLO verein.lst.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726237AbgEPMxK (ORCPT <rfc822;linux-bcache@vger.kernel.org>);
        Sat, 16 May 2020 08:53:10 -0400
Content-Disposition: inline
In-Reply-To: <20200516035434.82809-5-colyli@suse.de>
Sender: linux-bcache-owner@vger.kernel.org
List-Id: linux-bcache@vger.kernel.org
To: Coly Li <colyli@suse.de>
Cc: linux-block@vger.kernel.org, damien.lemoal@wdc.com, hare@suse.com, hch@lst.de, axboe@kernel.dk, linux-bcache@vger.kernel.org, kbusch@kernel.org, Ajay Joshi <ajay.joshi@wdc.com>, Chaitanya Kulkarni <chaitanya.kulkarni@wdc.com>, Hannes Reinecke <hare@suse.de>, Johannes Thumshirn <johannes.thumshirn@wdc.com>

This looks ok, but I want to hear Damiens opinion.
