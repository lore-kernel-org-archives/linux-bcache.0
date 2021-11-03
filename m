Return-Path: <linux-bcache-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AF888C433F5
	for <linux-bcache@archiver.kernel.org>; Wed,  3 Nov 2021 07:21:26 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 8315D6115B
	for <linux-bcache@archiver.kernel.org>; Wed,  3 Nov 2021 07:21:26 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231981AbhKCHX7 (ORCPT <rfc822;linux-bcache@archiver.kernel.org>);
        Wed, 3 Nov 2021 03:23:59 -0400
Received: from verein.lst.de ([213.95.11.211]:58520 "EHLO verein.lst.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230152AbhKCHX4 (ORCPT <rfc822;linux-bcache@vger.kernel.org>);
        Wed, 3 Nov 2021 03:23:56 -0400
Received: by verein.lst.de (Postfix, from userid 2407)
        id C7DBF68AA6; Wed,  3 Nov 2021 08:21:17 +0100 (CET)
Date:   Wed, 3 Nov 2021 08:21:17 +0100
From:   Christoph Hellwig <hch@lst.de>
To:     Coly Li <colyli@suse.de>
Cc:     linux-bcache@vger.kernel.org, linux-block@vger.kernel.org,
        Christoph Hellwig <hch@lst.de>, Hannes Reinecke <hare@suse.de>,
        Ulf Hansson <ulf.hansson@linaro.org>, stable@vger.kernel.org
Subject: Re: [PATCH] bcache: fix use-after-free problem in
 bcache_device_free()
Message-ID: <20211103072117.GA31003@lst.de>
References: <20211103064917.67383-1-colyli@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211103064917.67383-1-colyli@suse.de>
User-Agent: Mutt/1.5.17 (2007-11-01)
Precedence: bulk
List-ID: <linux-bcache.vger.kernel.org>
X-Mailing-List: linux-bcache@vger.kernel.org

Looks good,

Reviewed-by: Christoph Hellwig <hch@lst.de>
