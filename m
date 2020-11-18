Return-Path: <linux-bcache-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.3 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9E317C56202
	for <linux-bcache@archiver.kernel.org>; Wed, 18 Nov 2020 09:04:11 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 42EEE20756
	for <linux-bcache@archiver.kernel.org>; Wed, 18 Nov 2020 09:04:11 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b="bmXyeILM"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726935AbgKRJEI (ORCPT
        <rfc822;linux-bcache@archiver.kernel.org>);
        Wed, 18 Nov 2020 04:04:08 -0500
Received: from mx2.suse.de ([195.135.220.15]:33044 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725767AbgKRJEH (ORCPT <rfc822;linux-bcache@vger.kernel.org>);
        Wed, 18 Nov 2020 04:04:07 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
        t=1605690246; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=LkhYOLJvmFdpwfgmCORfd6M3DajwjiKhI3bCgvrsEjU=;
        b=bmXyeILM/jFC2y7/cL8bo+i+qT42pSFQTqiJfE9lrw1eXqLr2D6ZDxQVQXD+H6sZYclscK
        41e7ZVfbBmnYeTwtVfb+7Gjw2bitCfE/o1RVw9BIO+YSUBtHEGFI6Iz3TDO51XM38Wl3km
        oroI4x9/8G6WspbnyxouqPKxYU34Y7M=
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id 19B49B138;
        Wed, 18 Nov 2020 09:04:05 +0000 (UTC)
Subject: Re: merge struct block_device and struct hd_struct
To:     Christoph Hellwig <hch@lst.de>
Cc:     Tejun Heo <tj@kernel.org>, Josef Bacik <josef@toxicpanda.com>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Coly Li <colyli@suse.de>, Mike Snitzer <snitzer@redhat.com>,
        dm-devel@redhat.com, Richard Weinberger <richard@nod.at>,
        Jan Kara <jack@suse.com>, linux-block@vger.kernel.org,
        xen-devel@lists.xenproject.org, linux-bcache@vger.kernel.org,
        linux-mtd@lists.infradead.org, linux-fsdevel@vger.kernel.org,
        linux-mm@kvack.org, Jens Axboe <axboe@kernel.dk>
References: <20201118084800.2339180-1-hch@lst.de>
 <22ca5396-0253-f286-9eab-d417b2e0b3ad@suse.com>
 <20201118085804.GA20384@lst.de>
From:   Jan Beulich <jbeulich@suse.com>
Message-ID: <1ded2079-f1be-6d5d-01df-65754447df78@suse.com>
Date:   Wed, 18 Nov 2020 10:04:04 +0100
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.4.3
MIME-Version: 1.0
In-Reply-To: <20201118085804.GA20384@lst.de>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-bcache.vger.kernel.org>
X-Mailing-List: linux-bcache@vger.kernel.org

On 18.11.2020 09:58, Christoph Hellwig wrote:
> On Wed, Nov 18, 2020 at 09:56:11AM +0100, Jan Beulich wrote:
>> since this isn't the first series from you recently spamming
>> xen-devel, may I ask that you don't Cc entire series to lists
>> which are involved with perhaps just one out of the many patches?
>> IMO Cc lists should be compiled on a per-patch basis; the cover
>> letter may of course be sent to the union of all of them.
> 
> No way.  Individual CCs are completely broken as they don't provide
> the reviewer a context.

That's the view of some people, but not all. Context can be easily
established by those who care going to one of the many archives on
which the entire series lands. Getting spammed, however, can't be
avoided by the dozens or hundreds of list subscribers.

>  If you don't want xen-blkfront patches to
> go to xen-devel remove it from MAINTAINERS.

Patches to Xen drivers very much ought to go to xen-devel imo, so
no - removal is not an option.

Jan
