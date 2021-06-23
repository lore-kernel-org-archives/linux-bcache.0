Return-Path: <linux-bcache-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2BD54C4743C
	for <linux-bcache@archiver.kernel.org>; Wed, 23 Jun 2021 05:51:24 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 0F1DD610F7
	for <linux-bcache@archiver.kernel.org>; Wed, 23 Jun 2021 05:51:24 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229906AbhFWFxj (ORCPT <rfc822;linux-bcache@archiver.kernel.org>);
        Wed, 23 Jun 2021 01:53:39 -0400
Received: from vostok.pvgoran.name ([71.19.149.48]:35763 "EHLO
        vostok.pvgoran.name" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229833AbhFWFxi (ORCPT
        <rfc822;linux-bcache@vger.kernel.org>);
        Wed, 23 Jun 2021 01:53:38 -0400
X-Greylist: delayed 310 seconds by postgrey-1.27 at vger.kernel.org; Wed, 23 Jun 2021 01:53:37 EDT
Received: from [10.0.10.127] (l37-193-246-51.novotelecom.ru [::ffff:37.193.246.51])
  (AUTH: CRAM-MD5 main-collector@pvgoran.name, )
  by vostok.pvgoran.name with ESMTPSA
  id 00000000000D3321.0000000060D2CA9F.0000298B; Wed, 23 Jun 2021 05:46:06 +0000
Date:   Wed, 23 Jun 2021 12:46:04 +0700
From:   Pavel Goran <via-bcache@pvgoran.name>
X-Mailer: The Bat! (v3.85.03) Professional
Reply-To: Pavel Goran <via-bcache@pvgoran.name>
X-Priority: 3 (Normal)
Message-ID: <133698796.20210623124604@pvgoran.name>
To:     Coly Li <colyli@suse.de>
CC:     Hannes Reinecke <hare@suse.de>, linux-bcache@vger.kernel.org,
        linux-block@vger.kernel.org, Jianpeng Ma <jianpeng.ma@intel.com>,
        kernel test robot <lkp@intel.com>,
        Dan Carpenter <dan.carpenter@oracle.com>, axboe@kernel.dk,
        Qiaowei Ren <qiaowei.ren@intel.com>
Subject: Re[2]: [PATCH 05/14] bcache: initialization of the buddy
In-Reply-To: <e66262c1-7ce1-cd67-b48b-982b6d1ea1d1@suse.de>
References: <20210615054921.101421-1-colyli@suse.de> <20210615054921.101421-6-colyli@suse.de> <bfa10634-b144-e180-c66a-5bf839c5ce71@suse.de> <e66262c1-7ce1-cd67-b48b-982b6d1ea1d1@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-bcache.vger.kernel.org>
X-Mailing-List: linux-bcache@vger.kernel.org

Hello Coly,

Wednesday, June 23, 2021, 12:35:21 PM, you wrote:

> ... (skipped a lot)
>>> +                            /* recs array can has hole */
>> can have holes ?

> It means the valid record is not always continuously stored in recs[]
> from struct bch_nvm_pgalloc_recs. Because currently only 8 bytes write
> to a 8 bytes aligned address on NVDIMM is stomic for power failure.

> ...

The issue is with the wording of this comment, not with the code or the
meaning of the comment.

The comment should read "recs array can have hole".

> Coly Li

Pavel Goran
  

