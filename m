Return-Path: <linux-bcache-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D7983C47094
	for <linux-bcache@archiver.kernel.org>; Mon,  7 Jun 2021 11:07:03 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id BB4EC61001
	for <linux-bcache@archiver.kernel.org>; Mon,  7 Jun 2021 11:07:03 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230264AbhFGLIx (ORCPT <rfc822;linux-bcache@archiver.kernel.org>);
        Mon, 7 Jun 2021 07:08:53 -0400
Received: from verein.lst.de ([213.95.11.211]:45696 "EHLO verein.lst.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230131AbhFGLIw (ORCPT <rfc822;linux-bcache@vger.kernel.org>);
        Mon, 7 Jun 2021 07:08:52 -0400
Received: by verein.lst.de (Postfix, from userid 2407)
        id 67A4867373; Mon,  7 Jun 2021 13:06:57 +0200 (CEST)
Date:   Mon, 7 Jun 2021 13:06:57 +0200
From:   Christoph Hellwig <hch@lst.de>
To:     Coly Li <colyli@suse.de>
Cc:     axboe@kernel.dk, linux-bcache@vger.kernel.org,
        linux-block@vger.kernel.org, linux-kernel@vger.kernel.org,
        Alexander Ullrich <ealex1979@gmail.com>,
        Diego Ercolani <diego.ercolani@gmail.com>,
        Jan Szubiak <jan.szubiak@linuxpolska.pl>,
        Marco Rebhan <me@dblsaiko.net>,
        Matthias Ferdinand <bcache@mfedv.net>,
        Victor Westerhuis <victor@westerhu.is>,
        Vojtech Pavlik <vojtech@suse.cz>,
        Rolf Fokkens <rolf@rolffokkens.nl>,
        Thorsten Knabe <linux@thorsten-knabe.de>,
        stable@vger.kernel.org, Christoph Hellwig <hch@lst.de>,
        Kent Overstreet <kent.overstreet@gmail.com>,
        Nix <nix@esperi.org.uk>, Takashi Iwai <tiwai@suse.com>
Subject: Re: [PATCH v5 2/2] bcache: avoid oversized read request in cache
 missing code path
Message-ID: <20210607110657.GB6729@lst.de>
References: <20210607103539.12823-1-colyli@suse.de> <20210607103539.12823-3-colyli@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210607103539.12823-3-colyli@suse.de>
User-Agent: Mutt/1.5.17 (2007-11-01)
Precedence: bulk
List-ID: <linux-bcache.vger.kernel.org>
X-Mailing-List: linux-bcache@vger.kernel.org

On Mon, Jun 07, 2021 at 06:35:39PM +0800, Coly Li wrote:
> +	/* Limitation for valid replace key size and cache_bio bvecs number */
> +	size_limit = min_t(unsigned int, bio_max_segs(UINT_MAX) * PAGE_SECTORS,
> +			   (1 << KEY_SIZE_BITS) - 1);

bio_max_segs kaps the argument to BIO_MAX_VECS, so you might as well
directly write BIO_MAX_VECS.  Can you explain the PAGE_SECTORS here a bit
more? Does this code path use discontiguous per-sector allocations?
Preferably in a comment.

> +	s->insert_bio_sectors = min3(size_limit, sectors, bio_sectors(bio));

Also I don't really understand the units involved here.
s->insert_bio_sectors, sectors, and bio_sectors is in unit of 512 byte
sectors.  

> -	miss = bio_next_split(bio, sectors, GFP_NOIO, &s->d->bio_split);
> +	miss = bio_next_split(bio, s->insert_bio_sectors, GFP_NOIO, &s->d->bio_split);

Overly long line.
