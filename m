Return-Path: <linux-bcache-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 66CD3C433EF
	for <linux-bcache@archiver.kernel.org>; Tue,  1 Mar 2022 12:19:37 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232613AbiCAMUQ (ORCPT <rfc822;linux-bcache@archiver.kernel.org>);
        Tue, 1 Mar 2022 07:20:16 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49794 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234695AbiCAMUM (ORCPT
        <rfc822;linux-bcache@vger.kernel.org>);
        Tue, 1 Mar 2022 07:20:12 -0500
Received: from verein.lst.de (verein.lst.de [213.95.11.211])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4C99E73077;
        Tue,  1 Mar 2022 04:19:31 -0800 (PST)
Received: by verein.lst.de (Postfix, from userid 2407)
        id CD72668AFE; Tue,  1 Mar 2022 13:19:26 +0100 (CET)
Date:   Tue, 1 Mar 2022 13:19:26 +0100
From:   Christoph Hellwig <hch@lst.de>
To:     Ira Weiny <ira.weiny@intel.com>
Cc:     Christoph Hellwig <hch@lst.de>, Jens Axboe <axboe@kernel.dk>,
        Chris Zankel <chris@zankel.net>,
        Max Filippov <jcmvbkbc@gmail.com>,
        Justin Sanders <justin@coraid.com>,
        Philipp Reisner <philipp.reisner@linbit.com>,
        Lars Ellenberg <lars.ellenberg@linbit.com>,
        Denis Efremov <efremov@linux.com>,
        Minchan Kim <minchan@kernel.org>,
        Nitin Gupta <ngupta@vflare.org>, Coly Li <colyli@suse.de>,
        Dan Williams <dan.j.williams@intel.com>,
        Vishal Verma <vishal.l.verma@intel.com>,
        linux-xtensa@linux-xtensa.org, linux-block@vger.kernel.org,
        drbd-dev@lists.linbit.com, linux-bcache@vger.kernel.org,
        nvdimm@lists.linux.dev
Subject: Re: [PATCH 03/10] zram: use memcpy_to_bvec in zram_bvec_read
Message-ID: <20220301121926.GA3405@lst.de>
References: <20220222155156.597597-1-hch@lst.de> <20220222155156.597597-4-hch@lst.de> <Yh1ycd3S/FKAtnuD@iweiny-desk3>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Yh1ycd3S/FKAtnuD@iweiny-desk3>
User-Agent: Mutt/1.5.17 (2007-11-01)
Precedence: bulk
List-ID: <linux-bcache.vger.kernel.org>
X-Mailing-List: linux-bcache@vger.kernel.org

On Mon, Feb 28, 2022 at 05:10:09PM -0800, Ira Weiny wrote:
> On Tue, Feb 22, 2022 at 04:51:49PM +0100, Christoph Hellwig wrote:
> > Use the proper helper instead of open coding the copy.
> > 
> > Signed-off-by: Christoph Hellwig <hch@lst.de>
> 
> Looks fine but I don't see a reason to keep the other operation atomic.  Could
> the src map also use kmap_local_page()?

That switch obviously makes sense, but in this series I've focussed on
the bio_vec maps so far.
