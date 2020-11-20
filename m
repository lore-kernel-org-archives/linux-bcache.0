Return-Path: <linux-bcache-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0E757C63798
	for <linux-bcache@archiver.kernel.org>; Fri, 20 Nov 2020 08:56:34 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B24E92242A
	for <linux-bcache@archiver.kernel.org>; Fri, 20 Nov 2020 08:56:33 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727384AbgKTI4d (ORCPT
        <rfc822;linux-bcache@archiver.kernel.org>);
        Fri, 20 Nov 2020 03:56:33 -0500
Received: from verein.lst.de ([213.95.11.211]:41998 "EHLO verein.lst.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727208AbgKTI4d (ORCPT <rfc822;linux-bcache@vger.kernel.org>);
        Fri, 20 Nov 2020 03:56:33 -0500
Received: by verein.lst.de (Postfix, from userid 2407)
        id 134F468B05; Fri, 20 Nov 2020 09:56:27 +0100 (CET)
Date:   Fri, 20 Nov 2020 09:56:26 +0100
From:   Christoph Hellwig <hch@lst.de>
To:     Jan Kara <jack@suse.cz>
Cc:     Christoph Hellwig <hch@lst.de>, Jens Axboe <axboe@kernel.dk>,
        Tejun Heo <tj@kernel.org>, Josef Bacik <josef@toxicpanda.com>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Coly Li <colyli@suse.de>, Mike Snitzer <snitzer@redhat.com>,
        dm-devel@redhat.com, Richard Weinberger <richard@nod.at>,
        Jan Kara <jack@suse.com>, linux-block@vger.kernel.org,
        xen-devel@lists.xenproject.org, linux-bcache@vger.kernel.org,
        linux-mtd@lists.infradead.org, linux-fsdevel@vger.kernel.org,
        linux-mm@kvack.org
Subject: Re: [PATCH 11/20] block: reference struct block_device from struct
 hd_struct
Message-ID: <20201120085626.GB21715@lst.de>
References: <20201118084800.2339180-1-hch@lst.de> <20201118084800.2339180-12-hch@lst.de> <20201119094157.GT1981@quack2.suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201119094157.GT1981@quack2.suse.cz>
User-Agent: Mutt/1.5.17 (2007-11-01)
Precedence: bulk
List-ID: <linux-bcache.vger.kernel.org>
X-Mailing-List: linux-bcache@vger.kernel.org

On Thu, Nov 19, 2020 at 10:41:57AM +0100, Jan Kara wrote:
> >  	rcu_assign_pointer(ptbl->part[0], &disk->part0);
> > @@ -1772,8 +1626,10 @@ struct gendisk *__alloc_disk_node(int minors, int node_id)
> >  	 * converted to make use of bd_mutex and sequence counters.
> >  	 */
> >  	hd_sects_seq_init(&disk->part0);
> > -	if (hd_ref_init(&disk->part0))
> > -		goto out_free_part0;
> > +	if (hd_ref_init(&disk->part0)) {
> > +		hd_free_part(&disk->part0);
> 
> Aren't you missing kfree(disk) here?

This should actually jump to out_free_bdstats, I've fixed it up.
