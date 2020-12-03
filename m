Return-Path: <linux-bcache-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1DADCC64E7B
	for <linux-bcache@archiver.kernel.org>; Thu,  3 Dec 2020 06:57:32 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id BB3FB20758
	for <linux-bcache@archiver.kernel.org>; Thu,  3 Dec 2020 06:57:31 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729817AbgLCG5b (ORCPT
        <rfc822;linux-bcache@archiver.kernel.org>);
        Thu, 3 Dec 2020 01:57:31 -0500
Received: from mx2.suse.de ([195.135.220.15]:52118 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725912AbgLCG5b (ORCPT <rfc822;linux-bcache@vger.kernel.org>);
        Thu, 3 Dec 2020 01:57:31 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id 6A023ABE9;
        Thu,  3 Dec 2020 06:56:49 +0000 (UTC)
To:     Yi Li <yilikernel@gmail.com>
Cc:     Yi Li <yili@winhong.com>, kent.overstreet@gmail.com,
        linux-bcache@vger.kernel.org, linux-kernel@vger.kernel.org,
        Guo Chao <guochao@winhong.com>
References: <20201130112137.587437-1-yili@winhong.com>
 <CAJfdMYDnDJXFVfEECtQ9-E4F9kfsF035PH+x3kaVn6PPSYCydA@mail.gmail.com>
 <b838b790-e1e3-d644-2b1c-5de02a10669f@suse.de>
 <CAJfdMYCbkAZtWpJ6sgsrRnV4i+5sRahaq-ktMjqcG1JXoazmGQ@mail.gmail.com>
From:   Coly Li <colyli@suse.de>
Subject: Re: [PATCH] bcache: fix panic due to cache_set is null
Message-ID: <79fde596-254a-510c-547a-b1525985de9d@suse.de>
Date:   Thu, 3 Dec 2020 14:56:45 +0800
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.16; rv:78.0)
 Gecko/20100101 Thunderbird/78.5.0
MIME-Version: 1.0
In-Reply-To: <CAJfdMYCbkAZtWpJ6sgsrRnV4i+5sRahaq-ktMjqcG1JXoazmGQ@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-bcache.vger.kernel.org>
X-Mailing-List: linux-bcache@vger.kernel.org

On 12/3/20 2:25 PM, Yi Li wrote:
>> On 12/1/20 12:35 PM, Yi Li wrote:
>>> sorry, This patch will cause deadlock, i will check and redo it.
>>
>> Can you try latest upstream kernel firstly ? Before spending more time
>> on the fix.
>>
> 
> This issue just happened three times （xenserver7.5 dom0 kernel） on the
> same machine and cannot reproduce it now. and have not reproduce it
> using the lastest uptream kernel.
> 

Hmm, this is something very probably that I am not able to help. It
seems the kernel is a third-part maintained Linux v4.4 based kernel +
bcache backport, which is out of my view.

If similar problem happens on latest upstream kernel, or at least v5.8+
kernel, I can help to take a look.


>> If I remember correctly, when cancel_writeback_rate_update_dwork() is
>> not timed out, the cache set memory won't be freed before the
>> writeback_rate_update worker terminates. It is possible that I miss
>> something in the code, but I suggest to test with a kernel after v5.3,
>> and better a v5.8+ kernel.
>>
>> Coly Li
>>
> Thanks.
> 
> it is  confused that why writeback_rate_update worker run  again after
> cancel_delayed_work_sync( kernel log telled).
> 

[snipped]

Coly Li
