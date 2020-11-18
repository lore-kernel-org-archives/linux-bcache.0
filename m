Return-Path: <linux-bcache-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.2 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AED79C5519F
	for <linux-bcache@archiver.kernel.org>; Wed, 18 Nov 2020 08:58:09 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 5BCB7241A5
	for <linux-bcache@archiver.kernel.org>; Wed, 18 Nov 2020 08:58:09 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726915AbgKRI6I (ORCPT
        <rfc822;linux-bcache@archiver.kernel.org>);
        Wed, 18 Nov 2020 03:58:08 -0500
Received: from verein.lst.de ([213.95.11.211]:34517 "EHLO verein.lst.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726775AbgKRI6I (ORCPT <rfc822;linux-bcache@vger.kernel.org>);
        Wed, 18 Nov 2020 03:58:08 -0500
Received: by verein.lst.de (Postfix, from userid 2407)
        id E406367357; Wed, 18 Nov 2020 09:58:04 +0100 (CET)
Date:   Wed, 18 Nov 2020 09:58:04 +0100
From:   Christoph Hellwig <hch@lst.de>
To:     Jan Beulich <jbeulich@suse.com>
Cc:     Christoph Hellwig <hch@lst.de>, Tejun Heo <tj@kernel.org>,
        Josef Bacik <josef@toxicpanda.com>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Coly Li <colyli@suse.de>, Mike Snitzer <snitzer@redhat.com>,
        dm-devel@redhat.com, Richard Weinberger <richard@nod.at>,
        Jan Kara <jack@suse.com>, linux-block@vger.kernel.org,
        xen-devel@lists.xenproject.org, linux-bcache@vger.kernel.org,
        linux-mtd@lists.infradead.org, linux-fsdevel@vger.kernel.org,
        linux-mm@kvack.org, Jens Axboe <axboe@kernel.dk>
Subject: Re: merge struct block_device and struct hd_struct
Message-ID: <20201118085804.GA20384@lst.de>
References: <20201118084800.2339180-1-hch@lst.de> <22ca5396-0253-f286-9eab-d417b2e0b3ad@suse.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <22ca5396-0253-f286-9eab-d417b2e0b3ad@suse.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
Precedence: bulk
List-ID: <linux-bcache.vger.kernel.org>
X-Mailing-List: linux-bcache@vger.kernel.org

On Wed, Nov 18, 2020 at 09:56:11AM +0100, Jan Beulich wrote:
> since this isn't the first series from you recently spamming
> xen-devel, may I ask that you don't Cc entire series to lists
> which are involved with perhaps just one out of the many patches?
> IMO Cc lists should be compiled on a per-patch basis; the cover
> letter may of course be sent to the union of all of them.

No way.  Individual CCs are completely broken as they don't provide
the reviewer a context.  If you don't want xen-blkfront patches to
go to xen-devel remove it from MAINTAINERS.
