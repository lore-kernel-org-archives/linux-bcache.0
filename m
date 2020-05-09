Return-Path: <SRS0=E67d=6X=vger.kernel.org=linux-bcache-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.5 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 913A3C47257
	for <linux-bcache@archiver.kernel.org>; Sat,  9 May 2020 08:24:05 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 7178D24957
	for <linux-bcache@archiver.kernel.org>; Sat,  9 May 2020 08:24:05 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727812AbgEIIX7 (ORCPT
        <rfc822;linux-bcache@archiver.kernel.org>);
        Sat, 9 May 2020 04:23:59 -0400
Received: from verein.lst.de ([213.95.11.211]:56114 "EHLO verein.lst.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727839AbgEIIX6 (ORCPT <rfc822;linux-bcache@vger.kernel.org>);
        Sat, 9 May 2020 04:23:58 -0400
Received: by verein.lst.de (Postfix, from userid 2407)
        id DB7F368C7B; Sat,  9 May 2020 10:23:52 +0200 (CEST)
Date:   Sat, 9 May 2020 10:23:52 +0200
From:   Christoph Hellwig <hch@lst.de>
To:     Dan Williams <dan.j.williams@intel.com>
Cc:     Christoph Hellwig <hch@lst.de>, Jens Axboe <axboe@kernel.dk>,
        Jim Paris <jim@jtan.com>, Geoff Levand <geoff@infradead.org>,
        Joshua Morris <josh.h.morris@us.ibm.com>,
        Philip Kelleher <pjk1939@linux.ibm.com>,
        Minchan Kim <minchan@kernel.org>,
        Nitin Gupta <ngupta@vflare.org>,
        Sergey Senozhatsky <sergey.senozhatsky.work@gmail.com>,
        linux-m68k@lists.linux-m68k.org,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        linux-xtensa@linux-xtensa.org, drbd-dev@lists.linbit.com,
        linux-block@vger.kernel.org,
        linuxppc-dev <linuxppc-dev@lists.ozlabs.org>,
        linux-bcache@vger.kernel.org,
        linux-raid <linux-raid@vger.kernel.org>,
        linux-nvdimm <linux-nvdimm@lists.01.org>
Subject: Re: remove a few uses of ->queuedata
Message-ID: <20200509082352.GB21834@lst.de>
References: <20200508161517.252308-1-hch@lst.de> <CAPcyv4j3gVqrZWCCc2Q-6JizGAQXW0b+R1BcvWCZOvzaukGLQg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAPcyv4j3gVqrZWCCc2Q-6JizGAQXW0b+R1BcvWCZOvzaukGLQg@mail.gmail.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-bcache-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-bcache.vger.kernel.org>
X-Mailing-List: linux-bcache@vger.kernel.org
Message-ID: <20200509082352.FPyVtiiEA_pUoLBIYBkXut5zj1C6lssrLBKVt_c9CbU@z>

On Fri, May 08, 2020 at 11:04:45AM -0700, Dan Williams wrote:
> On Fri, May 8, 2020 at 9:16 AM Christoph Hellwig <hch@lst.de> wrote:
> >
> > Hi all,
> >
> > various bio based drivers use queue->queuedata despite already having
> > set up disk->private_data, which can be used just as easily.  This
> > series cleans them up to only use a single private data pointer.
> 
> ...but isn't the queue pretty much guaranteed to be cache hot and the
> gendisk cache cold? I'm not immediately seeing what else needs the
> gendisk in the I/O path. Is there another motivation I'm missing?

->private_data is right next to the ->queue pointer, pat0 and part_tbl
which are all used in the I/O submission path (generic_make_request /
generic_make_request_checks).  This is mostly a prep cleanup patch to
also remove the pointless queue argument from ->make_request - then
->queue is an extra dereference and extra churn.
