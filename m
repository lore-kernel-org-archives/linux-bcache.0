Return-Path: <SRS0=ILQ8=AZ=vger.kernel.org=linux-bcache-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.5 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 88F21C433E0
	for <linux-bcache@archiver.kernel.org>; Tue, 14 Jul 2020 07:19:34 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 6F56E221E8
	for <linux-bcache@archiver.kernel.org>; Tue, 14 Jul 2020 07:19:34 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726850AbgGNHTe (ORCPT
        <rfc822;linux-bcache@archiver.kernel.org>);
        Tue, 14 Jul 2020 03:19:34 -0400
Received: from verein.lst.de ([213.95.11.211]:53076 "EHLO verein.lst.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725306AbgGNHTd (ORCPT <rfc822;linux-bcache@vger.kernel.org>);
        Tue, 14 Jul 2020 03:19:33 -0400
Received: by verein.lst.de (Postfix, from userid 2407)
        id 5658868CFC; Tue, 14 Jul 2020 09:19:30 +0200 (CEST)
Date:   Tue, 14 Jul 2020 09:19:29 +0200
From:   Christoph Hellwig <hch@lst.de>
To:     Coly Li <colyli@suse.de>
Cc:     linux-block@vger.kernel.org, linux-nvme@lists.infradead.org,
        linux-bcache@vger.kernel.org, Christoph Hellwig <hch@lst.de>,
        Chaitanya Kulkarni <chaitanya.kulkarni@wdc.com>,
        Hannes Reinecke <hare@suse.de>, Jan Kara <jack@suse.com>,
        Jens Axboe <axboe@kernel.dk>,
        Mikhail Skorzhinskii <mskorzhinskiy@solarflare.com>,
        Philipp Reisner <philipp.reisner@linbit.com>,
        Sagi Grimberg <sagi@grimberg.me>,
        Vlastimil Babka <vbabka@suse.com>, stable@vger.kernel.org
Subject: Re: [PATCH 1/2] nvme-tpc: don't use sendpage for pages not taking
 reference counter
Message-ID: <20200714071929.GD776@lst.de>
References: <20200710132610.11756-1-colyli@suse.de> <35048818-d28d-a32c-0cb0-5bb3c147dee2@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <35048818-d28d-a32c-0cb0-5bb3c147dee2@suse.de>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-bcache-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-bcache.vger.kernel.org>
X-Mailing-List: linux-bcache@vger.kernel.org

On Mon, Jul 13, 2020 at 08:30:36PM +0800, Coly Li wrote:
> Hi Christoph,
> 
> Could you please take a look at this patch ? I will post a v3 patch soon
> for your review.
> 
> Thanks in advance.

I want Sagi to take a look at this first.
