Return-Path: <linux-bcache-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-17.1 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AD6A4C433DB
	for <linux-bcache@archiver.kernel.org>; Thu, 24 Dec 2020 06:15:39 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 64A0F22AAA
	for <linux-bcache@archiver.kernel.org>; Thu, 24 Dec 2020 06:15:39 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726583AbgLXGPV (ORCPT
        <rfc822;linux-bcache@archiver.kernel.org>);
        Thu, 24 Dec 2020 01:15:21 -0500
Received: from mx2.suse.de ([195.135.220.15]:48988 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726440AbgLXGPV (ORCPT <rfc822;linux-bcache@vger.kernel.org>);
        Thu, 24 Dec 2020 01:15:21 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id 076D2AE66;
        Thu, 24 Dec 2020 06:14:40 +0000 (UTC)
Subject: Re: [PATCH] bcache: set pdev_set_uuid before scond loop iteration
To:     Yi Li <yili@winhong.com>
Cc:     yilikernel@gmail.com, kent.overstreet@gmail.com,
        linux-bcache@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20201224015355.358211-1-yili@winhong.com>
From:   Coly Li <colyli@suse.de>
Message-ID: <a39ce88d-6955-6f3c-b064-d51cd8bd71e3@suse.de>
Date:   Thu, 24 Dec 2020 14:14:33 +0800
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.16; rv:78.0)
 Gecko/20100101 Thunderbird/78.6.0
MIME-Version: 1.0
In-Reply-To: <20201224015355.358211-1-yili@winhong.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-bcache.vger.kernel.org>
X-Mailing-List: linux-bcache@vger.kernel.org

On 12/24/20 9:53 AM, Yi Li wrote:
> There is no need to reassign pdev_set_uuid in the second loop iteration,
> so move it to the place before second loop.
> 
> Signed-off-by: Yi Li <yili@winhong.com>

Added into my for-next directory. Thanks.

Coly Li

> ---
>  drivers/md/bcache/super.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/md/bcache/super.c b/drivers/md/bcache/super.c
> index a4752ac410dc..6aa23a6fb394 100644
> --- a/drivers/md/bcache/super.c
> +++ b/drivers/md/bcache/super.c
> @@ -2644,8 +2644,8 @@ static ssize_t bch_pending_bdevs_cleanup(struct kobject *k,
>  	}
>  
>  	list_for_each_entry_safe(pdev, tpdev, &pending_devs, list) {
> +		char *pdev_set_uuid = pdev->dc->sb.set_uuid;
>  		list_for_each_entry_safe(c, tc, &bch_cache_sets, list) {
> -			char *pdev_set_uuid = pdev->dc->sb.set_uuid;
>  			char *set_uuid = c->set_uuid;
>  
>  			if (!memcmp(pdev_set_uuid, set_uuid, 16)) {
> 

