Return-Path: <linux-bcache-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.2 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 020B7C63697
	for <linux-bcache@archiver.kernel.org>; Thu, 26 Nov 2020 18:02:32 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id CC0F2207BC
	for <linux-bcache@archiver.kernel.org>; Thu, 26 Nov 2020 18:02:31 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2404600AbgKZSCb (ORCPT
        <rfc822;linux-bcache@archiver.kernel.org>);
        Thu, 26 Nov 2020 13:02:31 -0500
Received: from verein.lst.de ([213.95.11.211]:35325 "EHLO verein.lst.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2404596AbgKZSCb (ORCPT <rfc822;linux-bcache@vger.kernel.org>);
        Thu, 26 Nov 2020 13:02:31 -0500
Received: by verein.lst.de (Postfix, from userid 2407)
        id E1E5A68B05; Thu, 26 Nov 2020 19:02:28 +0100 (CET)
Date:   Thu, 26 Nov 2020 19:02:28 +0100
From:   Christoph Hellwig <hch@lst.de>
To:     Jan Kara <jack@suse.cz>
Cc:     Christoph Hellwig <hch@lst.de>, Jens Axboe <axboe@kernel.dk>,
        Tejun Heo <tj@kernel.org>, Josef Bacik <josef@toxicpanda.com>,
        Coly Li <colyli@suse.de>, Mike Snitzer <snitzer@redhat.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Johannes Thumshirn <johannes.thumshirn@wdc.com>,
        dm-devel@redhat.com, Jan Kara <jack@suse.com>,
        linux-block@vger.kernel.org, linux-bcache@vger.kernel.org,
        linux-mtd@lists.infradead.org, linux-fsdevel@vger.kernel.org,
        linux-mm@kvack.org
Subject: Re: [PATCH 31/44] block: move the start_sect field to struct
 block_device
Message-ID: <20201126180228.GB25921@lst.de>
References: <20201126130422.92945-1-hch@lst.de> <20201126130422.92945-32-hch@lst.de> <20201126165641.GQ422@quack2.suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201126165641.GQ422@quack2.suse.cz>
User-Agent: Mutt/1.5.17 (2007-11-01)
Precedence: bulk
List-ID: <linux-bcache.vger.kernel.org>
X-Mailing-List: linux-bcache@vger.kernel.org

On Thu, Nov 26, 2020 at 05:56:41PM +0100, Jan Kara wrote:
> The long long conversion is pointless here, right?

Yes.
