Return-Path: <linux-bcache-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.2 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 000ADC5519F
	for <linux-bcache@archiver.kernel.org>; Wed, 18 Nov 2020 16:25:15 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A474724818
	for <linux-bcache@archiver.kernel.org>; Wed, 18 Nov 2020 16:25:15 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726511AbgKRQYx (ORCPT
        <rfc822;linux-bcache@archiver.kernel.org>);
        Wed, 18 Nov 2020 11:24:53 -0500
Received: from verein.lst.de ([213.95.11.211]:35855 "EHLO verein.lst.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726092AbgKRQYx (ORCPT <rfc822;linux-bcache@vger.kernel.org>);
        Wed, 18 Nov 2020 11:24:53 -0500
Received: by verein.lst.de (Postfix, from userid 2407)
        id E61A068B05; Wed, 18 Nov 2020 17:24:48 +0100 (CET)
Date:   Wed, 18 Nov 2020 17:24:47 +0100
From:   Christoph Hellwig <hch@lst.de>
To:     Coly Li <colyli@suse.de>
Cc:     Christoph Hellwig <hch@lst.de>, Jens Axboe <axboe@kernel.dk>,
        Tejun Heo <tj@kernel.org>, Josef Bacik <josef@toxicpanda.com>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Mike Snitzer <snitzer@redhat.com>, dm-devel@redhat.com,
        Richard Weinberger <richard@nod.at>, Jan Kara <jack@suse.com>,
        linux-block@vger.kernel.org, xen-devel@lists.xenproject.org,
        linux-bcache@vger.kernel.org, linux-mtd@lists.infradead.org,
        linux-fsdevel@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [PATCH 19/20] bcache: remove a superflous lookup_bdev all
Message-ID: <20201118162447.GB16753@lst.de>
References: <20201118084800.2339180-1-hch@lst.de> <20201118084800.2339180-20-hch@lst.de> <e7f826fd-cb9c-b4ab-fae8-dad398c14eed@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <e7f826fd-cb9c-b4ab-fae8-dad398c14eed@suse.de>
User-Agent: Mutt/1.5.17 (2007-11-01)
Precedence: bulk
List-ID: <linux-bcache.vger.kernel.org>
X-Mailing-List: linux-bcache@vger.kernel.org

On Wed, Nov 18, 2020 at 04:54:51PM +0800, Coly Li wrote:
> On 11/18/20 4:47 PM, Christoph Hellwig wrote:
> > Don't bother to call lookup_bdev for just a slightly different error
> > message without any functional change.
> > 
> > Signed-off-by: Christoph Hellwig <hch@lst.de>ist
> 
> Hi Christoph,
> 
> NACK. This removing error message is frequently triggered and observed,
> and distinct a busy device and an already registered device is important
> (the first one is critical error and second one is not).
> 
> Remove such error message will be a functional regression.

I can probably keep it, the amount of code to prettiefy an error message
seems excessive, though.
