Return-Path: <SRS0=DFY1=66=vger.kernel.org=linux-bcache-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.5 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 47820C433E0
	for <linux-bcache@archiver.kernel.org>; Sat, 16 May 2020 15:35:32 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 2C31120756
	for <linux-bcache@archiver.kernel.org>; Sat, 16 May 2020 15:35:32 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726998AbgEPPfb (ORCPT
        <rfc822;linux-bcache@archiver.kernel.org>);
        Sat, 16 May 2020 11:35:31 -0400
Received: from verein.lst.de ([213.95.11.211]:60837 "EHLO verein.lst.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726663AbgEPPfa (ORCPT <rfc822;linux-bcache@vger.kernel.org>);
        Sat, 16 May 2020 11:35:30 -0400
Received: by verein.lst.de (Postfix, from userid 2407)
        id C8FAB68B05; Sat, 16 May 2020 17:35:25 +0200 (CEST)
Date:   Sat, 16 May 2020 17:35:25 +0200
From:   Christoph Hellwig <hch@lst.de>
To:     Coly Li <colyli@suse.de>
Cc:     Christoph Hellwig <hch@lst.de>, linux-block@vger.kernel.org,
        damien.lemoal@wdc.com, hare@suse.com, axboe@kernel.dk,
        linux-bcache@vger.kernel.org, kbusch@kernel.org
Subject: Re: [RFC PATCH v2 3/4] block: remove queue_is_mq restriction from
 blk_revalidate_disk_zones()
Message-ID: <20200516153525.GA16693@lst.de>
References: <20200516035434.82809-1-colyli@suse.de> <20200516035434.82809-4-colyli@suse.de> <20200516124020.GC13448@lst.de> <d3fe49f1-d37b-689e-ae0e-078b1254d7e7@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <d3fe49f1-d37b-689e-ae0e-078b1254d7e7@suse.de>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-bcache-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-bcache.vger.kernel.org>
X-Mailing-List: linux-bcache@vger.kernel.org
Message-ID: <20200516153525.ATWhIZNkFXEfOyEeAPnb5EhqhMR8fzD4IqCajZEsMIE@z>

On Sat, May 16, 2020 at 09:13:50PM +0800, Coly Li wrote:
> It is OK for me to set the zone_nr and zone size without calling
> blk_revalidate_disk_zones().

Yes.  And without having seen your code I'm pretty sure it should
get simpler by not using blk_revalidate_disk_zones.
