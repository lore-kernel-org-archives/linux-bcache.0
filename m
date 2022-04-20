Return-Path: <linux-bcache-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C250BC433EF
	for <linux-bcache@archiver.kernel.org>; Wed, 20 Apr 2022 04:39:32 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238756AbiDTEmP (ORCPT <rfc822;linux-bcache@archiver.kernel.org>);
        Wed, 20 Apr 2022 00:42:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48210 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1354192AbiDTEmP (ORCPT
        <rfc822;linux-bcache@vger.kernel.org>);
        Wed, 20 Apr 2022 00:42:15 -0400
Received: from verein.lst.de (verein.lst.de [213.95.11.211])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DBEDE1ADB5;
        Tue, 19 Apr 2022 21:39:30 -0700 (PDT)
Received: by verein.lst.de (Postfix, from userid 2407)
        id 684B667373; Wed, 20 Apr 2022 06:39:27 +0200 (CEST)
Date:   Wed, 20 Apr 2022 06:39:27 +0200
From:   Christoph Hellwig <hch@lst.de>
To:     Coly Li <colyli@suse.de>
Cc:     axboe@kernel.dk, hch@lst.de, kch@nvidia.com, snitzer@redhat.com,
        linux-bcache@vger.kernel.org, linux-block@vger.kernel.org
Subject: Re: [PATCH 0/2] bcache fixes for Linux v5.18-rc3
Message-ID: <20220420043927.GA1363@lst.de>
References: <20220419160425.4148-1-colyli@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220419160425.4148-1-colyli@suse.de>
User-Agent: Mutt/1.5.17 (2007-11-01)
Precedence: bulk
List-ID: <linux-bcache.vger.kernel.org>
X-Mailing-List: linux-bcache@vger.kernel.org

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>
