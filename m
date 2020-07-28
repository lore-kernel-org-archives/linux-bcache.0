Return-Path: <SRS0=y0oE=BH=vger.kernel.org=linux-bcache-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DA2F5C433E0
	for <linux-bcache@archiver.kernel.org>; Tue, 28 Jul 2020 12:14:11 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B402E206D8
	for <linux-bcache@archiver.kernel.org>; Tue, 28 Jul 2020 12:14:11 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="TLyCjW2O"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728435AbgG1MOL (ORCPT
        <rfc822;linux-bcache@archiver.kernel.org>);
        Tue, 28 Jul 2020 08:14:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42972 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728300AbgG1MOK (ORCPT
        <rfc822;linux-bcache@vger.kernel.org>);
        Tue, 28 Jul 2020 08:14:10 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7CD05C061794;
        Tue, 28 Jul 2020 05:14:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=8CHby33wg6Y/gNBPzkJnNVv+vQ6NjUqFlboKV3+EU8U=; b=TLyCjW2OE/xvR81tiuaQz5Xbfl
        mtkyaGJbYGBtowkciL5g2ES+G/b3ZAJk9Mt3LsWP8q1yYYDfMeDhcxxf7Z5cRf6XOxuMOBVGXi+cV
        pPFKYHEue9/HZ1KFlMqKnyE8syNHCvrA+eS+z0PvB3AOhmT7RBhjXs6wZuEjVU/eEliNNTlb3HcZJ
        jvHwZZT6SdAM9NCKvz7EmzKrC9lErlOXXpwkp2xfNpwe0CkOvLkfXD3cAp6GBdz7X9EKAX5AuDvDM
        1IRIexPGZbXI1+s/Qy5Vb0U6A5HamZz+7hFu6uE1uSsfDqUfN0IEF+UHUQlWunyJideFlfOSl4f3d
        iw7ChoTA==;
Received: from hch by casper.infradead.org with local (Exim 4.92.3 #3 (Red Hat Linux))
        id 1k0OUh-0001BT-U0; Tue, 28 Jul 2020 12:14:07 +0000
Date:   Tue, 28 Jul 2020 13:14:07 +0100
From:   Christoph Hellwig <hch@infradead.org>
To:     Jens Axboe <axboe@kernel.dk>
Cc:     Coly Li <colyli@suse.de>, linux-block@vger.kernel.org,
        linux-bcache@vger.kernel.org
Subject: Re: [PATCH 00/25] bcache patches for Linux v5.9
Message-ID: <20200728121407.GA4403@infradead.org>
References: <20200725120039.91071-1-colyli@suse.de>
 <bbc97069-6d8f-d8c5-35b1-d85ccb2566df@kernel.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <bbc97069-6d8f-d8c5-35b1-d85ccb2566df@kernel.dk>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by casper.infradead.org. See http://www.infradead.org/rpr.html
Sender: linux-bcache-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-bcache.vger.kernel.org>
X-Mailing-List: linux-bcache@vger.kernel.org

On Sat, Jul 25, 2020 at 07:39:00AM -0600, Jens Axboe wrote:
> > Please take them for your Linux v5.9 block drivers branch.
> 
> Thanks, applied.

Can you please revert "cache: fix bio_{start,end}_io_acct with proper
device" again?  It really is a gross hack making things worse rather
than better.
