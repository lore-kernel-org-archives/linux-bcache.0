Return-Path: <linux-bcache-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.2 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7B20AC43470
	for <linux-bcache@archiver.kernel.org>; Mon, 12 Apr 2021 09:08:19 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 51312613B3
	for <linux-bcache@archiver.kernel.org>; Mon, 12 Apr 2021 09:08:19 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238730AbhDLJIf (ORCPT <rfc822;linux-bcache@archiver.kernel.org>);
        Mon, 12 Apr 2021 05:08:35 -0400
Received: from verein.lst.de ([213.95.11.211]:47859 "EHLO verein.lst.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S238774AbhDLJGV (ORCPT <rfc822;linux-bcache@vger.kernel.org>);
        Mon, 12 Apr 2021 05:06:21 -0400
Received: by verein.lst.de (Postfix, from userid 2407)
        id EC6B668C65; Mon, 12 Apr 2021 11:06:00 +0200 (CEST)
Date:   Mon, 12 Apr 2021 11:06:00 +0200
From:   Christoph Hellwig <hch@lst.de>
To:     Coly Li <colyli@suse.de>
Cc:     axboe@kernel.dk, linux-bcache@vger.kernel.org,
        linux-block@vger.kernel.org, Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH 7/7] bcache: fix a regression of code compiling failure
 in debug.c
Message-ID: <20210412090600.GA8026@lst.de>
References: <20210411134316.80274-1-colyli@suse.de> <20210411134316.80274-8-colyli@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210411134316.80274-8-colyli@suse.de>
User-Agent: Mutt/1.5.17 (2007-11-01)
Precedence: bulk
List-ID: <linux-bcache.vger.kernel.org>
X-Mailing-List: linux-bcache@vger.kernel.org

On Sun, Apr 11, 2021 at 09:43:16PM +0800, Coly Li wrote:
> The patch "bcache: remove PTR_CACHE" introduces a compiling failure in
> debug.c with following error message,
>   In file included from drivers/md/bcache/bcache.h:182:0,
>                    from drivers/md/bcache/debug.c:9:
>   drivers/md/bcache/debug.c: In function 'bch_btree_verify':
>   drivers/md/bcache/debug.c:53:19: error: 'c' undeclared (first use in
>   this function)
>     bio_set_dev(bio, c->cache->bdev);
>                      ^
> This patch fixes the regression by replacing c->cache->bdev by b->c->
> cache->bdev.

Why not fold this into the offending patch?
