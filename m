Return-Path: <linux-bcache-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EEFFCC56201
	for <linux-bcache@archiver.kernel.org>; Wed, 25 Nov 2020 16:22:56 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id ACD3E20789
	for <linux-bcache@archiver.kernel.org>; Wed, 25 Nov 2020 16:22:56 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730560AbgKYQW4 (ORCPT
        <rfc822;linux-bcache@archiver.kernel.org>);
        Wed, 25 Nov 2020 11:22:56 -0500
Received: from verein.lst.de ([213.95.11.211]:59598 "EHLO verein.lst.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729755AbgKYQW4 (ORCPT <rfc822;linux-bcache@vger.kernel.org>);
        Wed, 25 Nov 2020 11:22:56 -0500
Received: by verein.lst.de (Postfix, from userid 2407)
        id 4507168B02; Wed, 25 Nov 2020 17:22:50 +0100 (CET)
Date:   Wed, 25 Nov 2020 17:22:50 +0100
From:   Christoph Hellwig <hch@lst.de>
To:     Jan Kara <jack@suse.cz>
Cc:     Christoph Hellwig <hch@lst.de>, Jens Axboe <axboe@kernel.dk>,
        Tejun Heo <tj@kernel.org>, Josef Bacik <josef@toxicpanda.com>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Coly Li <colyli@suse.de>, Mike Snitzer <snitzer@redhat.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Johannes Thumshirn <johannes.thumshirn@wdc.com>,
        dm-devel@redhat.com, Richard Weinberger <richard@nod.at>,
        Jan Kara <jack@suse.com>, linux-block@vger.kernel.org,
        xen-devel@lists.xenproject.org, linux-bcache@vger.kernel.org,
        linux-mtd@lists.infradead.org, linux-fsdevel@vger.kernel.org,
        linux-mm@kvack.org
Subject: Re: [PATCH 04/45] fs: simplify freeze_bdev/thaw_bdev
Message-ID: <20201125162250.GA795@lst.de>
References: <20201124132751.3747337-1-hch@lst.de> <20201124132751.3747337-5-hch@lst.de> <20201125122953.GH16944@quack2.suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201125122953.GH16944@quack2.suse.cz>
User-Agent: Mutt/1.5.17 (2007-11-01)
Precedence: bulk
List-ID: <linux-bcache.vger.kernel.org>
X-Mailing-List: linux-bcache@vger.kernel.org

On Wed, Nov 25, 2020 at 01:29:53PM +0100, Jan Kara wrote:
> >  	mutex_unlock(&bdev->bd_fsfreeze_mutex);
> > -	return sb;	/* thaw_bdev releases s->s_umount */
> > +	return error;	/* thaw_bdev releases s->s_umount */
> 
> The comment about thaw_bdev() seems to be stale? At least I don't see what
> it's speaking about...

Yes, this comment seems long stale.  I think in the very early days
we held s_umount on frozen file system, which caused all kinds of
problems.

> >  	mutex_unlock(&bdev->bd_fsfreeze_mutex);
> > -	return error;
> > +	return 0;
> 
> But we now won't return -EINVAL if this gets called e.g. with
> bd_fsfreeze_count == 0, right?

Yes.  I had tried to drop the return value as all the freeze_bdev
calls ignored it.  But I had missed the unpaired emergency thaw and put
it back and messed this up..
