Return-Path: <SRS0=DFY1=66=vger.kernel.org=linux-bcache-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.5 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 95BEDC433E0
	for <linux-bcache@archiver.kernel.org>; Sat, 16 May 2020 12:50:34 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 7D40E206D8
	for <linux-bcache@archiver.kernel.org>; Sat, 16 May 2020 12:50:34 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726407AbgEPMud (ORCPT
        <rfc822;linux-bcache@archiver.kernel.org>);
        Sat, 16 May 2020 08:50:33 -0400
Received: from verein.lst.de ([213.95.11.211]:60466 "EHLO verein.lst.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726364AbgEPMud (ORCPT <rfc822;linux-bcache@vger.kernel.org>);
        Sat, 16 May 2020 08:50:33 -0400
Received: by verein.lst.de (Postfix, from userid 2407)
        id 239C968CEC; Sat, 16 May 2020 14:50:28 +0200 (CEST)
Date:   Sat, 16 May 2020 14:50:27 +0200
From:   Christoph Hellwig <hch@lst.de>
To:     Coly Li <colyli@suse.de>
Cc:     Christoph Hellwig <hch@lst.de>, linux-block@vger.kernel.org,
        damien.lemoal@wdc.com, hare@suse.com, axboe@kernel.dk,
        linux-bcache@vger.kernel.org, kbusch@kernel.org,
        Hannes Reinecke <hare@suse.de>, Jens Axboe <axboe@fb.com>,
        Johannes Thumshirn <johannes.thumshirn@wdc.com>,
        Shaun Tancheff <shaun.tancheff@seagate.com>
Subject: Re: [RFC PATCH v2 1/4] block: change REQ_OP_ZONE_RESET from 6 to 13
Message-ID: <20200516125027.GA13730@lst.de>
References: <20200516035434.82809-1-colyli@suse.de> <20200516035434.82809-2-colyli@suse.de> <20200516123801.GB13448@lst.de> <fc0fd3c9-ea46-7c62-2a57-abd64e79cd08@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <fc0fd3c9-ea46-7c62-2a57-abd64e79cd08@suse.de>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-bcache-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-bcache.vger.kernel.org>
X-Mailing-List: linux-bcache@vger.kernel.org
Message-ID: <20200516125027.kDa_9hocxLSX_5OYOlKS3PJzur0KUGWzT80xFXXjX-U@z>

On Sat, May 16, 2020 at 08:44:45PM +0800, Coly Li wrote:
> Yes you are right, just like REQ_OP_DISCARD which does not transfer any
> data but changes the data on device. If the request changes the stored
> data, it does transfer data.

REQ_OP_DISCARD is a special case, because most implementation end up
transferring data, it just gets attached in the low-level driver.
