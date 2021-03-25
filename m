Return-Path: <linux-bcache-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8A365C433DB
	for <linux-bcache@archiver.kernel.org>; Thu, 25 Mar 2021 05:31:08 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 3396461A16
	for <linux-bcache@archiver.kernel.org>; Thu, 25 Mar 2021 05:31:08 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229461AbhCYFa1 (ORCPT <rfc822;linux-bcache@archiver.kernel.org>);
        Thu, 25 Mar 2021 01:30:27 -0400
Received: from mx2.suse.de ([195.135.220.15]:50260 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229448AbhCYFaB (ORCPT <rfc822;linux-bcache@vger.kernel.org>);
        Thu, 25 Mar 2021 01:30:01 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id 52EB7AB8A;
        Thu, 25 Mar 2021 05:30:00 +0000 (UTC)
Subject: Re: Undoing an "Auto-Stop" when Cache device has recovered?
To:     Nikolaus Rath <nikolaus@rath.org>
References: <3030cad3-47e2-43b0-8a82-656c6b774c78@www.fastmail.com>
Cc:     linux-bcache@vger.kernel.org
From:   Coly Li <colyli@suse.de>
Message-ID: <bcfeb53d-b8b0-883a-7a02-90b44b23f4dd@suse.de>
Date:   Thu, 25 Mar 2021 13:29:56 +0800
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.16; rv:78.0)
 Gecko/20100101 Thunderbird/78.8.1
MIME-Version: 1.0
In-Reply-To: <3030cad3-47e2-43b0-8a82-656c6b774c78@www.fastmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-bcache.vger.kernel.org>
X-Mailing-List: linux-bcache@vger.kernel.org

On 3/25/21 4:21 AM, Nikolaus Rath wrote:
> Hello,
> 
> My (writeback enabled) bcache cache device had a temporary failure, but seems to have fully recovered (it may have been overheating or a loose cable).
> 
> From the last kernel messages, it seems that bcache tried to flush the dirty data, but failed, and then stopped the cache device.
> 
> After a reboot, the bcacheX device indeed no longer has an associated cache set..
> 
> I think in my case the cache device is in perfect shape again and still has all the data, so I would really like bcache to attach it again so that the dirty cache data is not lost.
> 
> Is there a way to do that?
> 
> (Yes, I will still replace the device afterwards)
> 
> (I am pretty sure that just re-attaching the cacheset will make bcache forget that there was a previous association and will wipe the corresponding metadata).
> 

Hi Nikolaus,

Do you have the kernel log? It depends on whether the cache set is clean
or not. For a clear cache set, the cache set is detached, and next
reattach will invalidate all existing cached data. If the cache set is
dirty and all existing data is wiped, that will be fishy....

Thanks.

Coly Li
