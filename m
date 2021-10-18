Return-Path: <linux-bcache-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 10697C433FE
	for <linux-bcache@archiver.kernel.org>; Mon, 18 Oct 2021 15:21:34 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id EA25A60720
	for <linux-bcache@archiver.kernel.org>; Mon, 18 Oct 2021 15:21:33 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233084AbhJRPXo (ORCPT <rfc822;linux-bcache@archiver.kernel.org>);
        Mon, 18 Oct 2021 11:23:44 -0400
Received: from verein.lst.de ([213.95.11.211]:34781 "EHLO verein.lst.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232363AbhJRPXm (ORCPT <rfc822;linux-bcache@vger.kernel.org>);
        Mon, 18 Oct 2021 11:23:42 -0400
Received: by verein.lst.de (Postfix, from userid 2407)
        id D768168C4E; Mon, 18 Oct 2021 17:21:28 +0200 (CEST)
Date:   Mon, 18 Oct 2021 17:21:27 +0200
From:   Christoph Hellwig <hch@lst.de>
To:     Coly Li <colyli@suse.de>
Cc:     Christoph Hellwig <hch@lst.de>, linux-bcache@vger.kernel.org
Subject: Re: [PATCH 1/4] bcache: remove the cache_dev_name field from
 struct cache
Message-ID: <20211018152127.GA31195@lst.de>
References: <20211018060934.1816088-1-hch@lst.de> <20211018060934.1816088-2-hch@lst.de> <dc8601a6-21a5-3680-7489-1430d14788db@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <dc8601a6-21a5-3680-7489-1430d14788db@suse.de>
User-Agent: Mutt/1.5.17 (2007-11-01)
Precedence: bulk
List-ID: <linux-bcache.vger.kernel.org>
X-Mailing-List: linux-bcache@vger.kernel.org

On Mon, Oct 18, 2021 at 10:26:18PM +0800, Coly Li wrote:
> On 10/18/21 2:09 PM, Christoph Hellwig wrote:
>> Just use the %pg format specifier to print the name directly.
>
> Hi  Christoph,
>
> NACK for this patch.  The buffer cache_dev_name is added on purpose, in 
> case ca->bdev cannot be referenced correctly for some special condition 
> when underlying device fails.

Where exactly?  ->bdev is never cleared and only dropped after we
waited for the I/O to complete.
