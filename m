Return-Path: <linux-bcache-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.0 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 92AF9C19F37
	for <linux-bcache@archiver.kernel.org>; Fri, 27 Aug 2021 19:19:52 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 7C52260FD9
	for <linux-bcache@archiver.kernel.org>; Fri, 27 Aug 2021 19:19:52 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231565AbhH0TUk (ORCPT <rfc822;linux-bcache@archiver.kernel.org>);
        Fri, 27 Aug 2021 15:20:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59874 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231557AbhH0TUc (ORCPT
        <rfc822;linux-bcache@vger.kernel.org>);
        Fri, 27 Aug 2021 15:20:32 -0400
Received: from bombadil.infradead.org (unknown [IPv6:2607:7c80:54:e::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AE185C061796;
        Fri, 27 Aug 2021 12:19:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20210309; h=Sender:In-Reply-To:Content-Type:
        MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=8+JTx2QtJKu1nzu/fi4s9YgHPPdIhi0U0aDc5hOafyE=; b=DmLUkoPiySq9BrvK1jaaJXWx0d
        4oEOxLjKBZFeObZMhOh8sXY1k9im/R0uUMkC798SPMVqTN8z7b346uM78ptLFFh7ODfY2ePOWraOr
        4EONWQeoBcZMd6EX5GAGMU3xHzWM3D7svkZsMOHZ8OzOXcIrul5xc+JcgzFeUWPXxSMiT4v30J2mV
        2VMfemsc0kth5aUdZPQrJPpoqW9sacn9jiLcOpS6HC7RQjlCVUH91Xx18A8JwNcV21q1iTlzeLfgX
        t4+CykU+NT2SpiQkmzwM6uOiWwKyIrce5Pnz+akrSNGRf4y8IYvb9KAKu1zKykq3QUfwrSIOlBPS+
        IdaBQL9w==;
Received: from mcgrof by bombadil.infradead.org with local (Exim 4.94.2 #2 (Red Hat Linux))
        id 1mJhNr-00D5om-W1; Fri, 27 Aug 2021 19:19:24 +0000
Date:   Fri, 27 Aug 2021 12:19:23 -0700
From:   Luis Chamberlain <mcgrof@kernel.org>
To:     axboe@kernel.dk, colyli@suse.de, kent.overstreet@gmail.com,
        kbusch@kernel.org, sagi@grimberg.me, vishal.l.verma@intel.com,
        dan.j.williams@intel.com, dave.jiang@intel.com,
        ira.weiny@intel.com, konrad.wilk@oracle.com, roger.pau@citrix.com,
        boris.ostrovsky@oracle.com, jgross@suse.com,
        sstabellini@kernel.org, minchan@kernel.org, ngupta@vflare.org,
        senozhatsky@chromium.org
Cc:     xen-devel@lists.xenproject.org, nvdimm@lists.linux.dev,
        linux-nvme@lists.infradead.org, linux-bcache@vger.kernel.org,
        linux-block@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 00/10] block: first batch of add_disk() error handling
 conversions
Message-ID: <YSk6uyyuhDvFiqLJ@bombadil.infradead.org>
References: <20210827191809.3118103-1-mcgrof@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210827191809.3118103-1-mcgrof@kernel.org>
Sender: Luis Chamberlain <mcgrof@infradead.org>
Precedence: bulk
List-ID: <linux-bcache.vger.kernel.org>
X-Mailing-List: linux-bcache@vger.kernel.org


Botched the subject. Sorry. this is the *second* batch :)

  Luis
