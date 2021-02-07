Return-Path: <linux-bcache-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CEE46C433DB
	for <linux-bcache@archiver.kernel.org>; Sun,  7 Feb 2021 15:30:52 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 9933764E3B
	for <linux-bcache@archiver.kernel.org>; Sun,  7 Feb 2021 15:30:52 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229813AbhBGPat (ORCPT <rfc822;linux-bcache@archiver.kernel.org>);
        Sun, 7 Feb 2021 10:30:49 -0500
Received: from mx2.suse.de ([195.135.220.15]:37412 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229753AbhBGPaT (ORCPT <rfc822;linux-bcache@vger.kernel.org>);
        Sun, 7 Feb 2021 10:30:19 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id B9C93ACB7;
        Sun,  7 Feb 2021 15:29:37 +0000 (UTC)
Subject: Re: bch_cached_dev_attach() The obsoleted large bucket layout is
 unsupported, set the bcache device into read-only
To:     Rolf Fokkens <rolf@rolffokkens.nl>, linux-bcache@vger.kernel.org
References: <96e89237-8abe-adf7-8cf0-7065cde81dc3@rolffokkens.nl>
From:   Coly Li <colyli@suse.de>
Message-ID: <7049b813-df93-45ee-dfc3-93ab68065f18@suse.de>
Date:   Sun, 7 Feb 2021 23:29:34 +0800
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.16; rv:78.0)
 Gecko/20100101 Thunderbird/78.7.0
MIME-Version: 1.0
In-Reply-To: <96e89237-8abe-adf7-8cf0-7065cde81dc3@rolffokkens.nl>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-bcache.vger.kernel.org>
X-Mailing-List: linux-bcache@vger.kernel.org

On 2/6/21 7:49 PM, Rolf Fokkens wrote:
> Hi all,
> 
> Apparently some bcache users are hit by the message in the subject, see
> https://bugzilla.redhat.com/show_bug.cgi?id=1922485
> 
> I personally cannot reproduce this, but if the provided info is correct,
> a certain kernel upgrade will break existing bcache setups. Is this
> really true?
> 
> If so, this is a breaking change, which is very harmful.
> 
> I hope some of you have suggestions for the people who apparently are
> impacted by this.

This is a regression and fixed in 5.11-rc6 by commit 0df28cad06eb
("bcache: only check feature sets when sb->version >=
BCACHE_SB_VERSION_CDEV_WITH_FEATURES").

Also the fix has been in stable kernels already last week. The fix
should go into distribution very soon IMHO.

Thanks.

Coly Li
