Return-Path: <linux-bcache-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-17.3 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 37D4DC433ED
	for <linux-bcache@archiver.kernel.org>; Wed, 21 Apr 2021 14:17:52 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E6B716144D
	for <linux-bcache@archiver.kernel.org>; Wed, 21 Apr 2021 14:17:51 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242377AbhDUOSX (ORCPT <rfc822;linux-bcache@archiver.kernel.org>);
        Wed, 21 Apr 2021 10:18:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55180 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238683AbhDUOSW (ORCPT
        <rfc822;linux-bcache@vger.kernel.org>);
        Wed, 21 Apr 2021 10:18:22 -0400
Received: from desiato.infradead.org (desiato.infradead.org [IPv6:2001:8b0:10b:1:d65d:64ff:fe57:4e05])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 97644C06174A;
        Wed, 21 Apr 2021 07:17:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=desiato.20200630; h=Content-Transfer-Encoding:Content-Type
        :In-Reply-To:MIME-Version:Date:Message-ID:From:References:Cc:To:Subject:
        Sender:Reply-To:Content-ID:Content-Description;
        bh=1V074saVJum22Sdu0O1Nvhp0lC8JmfADLwoclM0Jc2Q=; b=fwxp3IWovc71fxS7cpQfwXEMgC
        bPqlkUfG9vBToRhRFloVREUyo6QlPItZhLMoZZ4T0lsGelqVAiiuyS0uvHcQZ6kfIJ/p9+mLSK4xj
        oQPnpygsNhaUCO6hEWFTHbFdCyEWG/baPGltqHvdUjOBbb1zToMJAtDHzcGbzUeh0BKnJBvp0HJBp
        UZVoR8zLQECkqU/HZZGT6pMCV+1cC/jOuLvdze//wlEyQVD4NwYbIHNMIhL7GS33uJd6pG7scbl6l
        fnhM0Z1P6WUyHYLM59Pa10y2hFREi5K5VLXt9dIYmnJ82l+mJ3jIOzcwVccu+RghuuJ6tZeYb+7q+
        dYNJXVOg==;
Received: from [2601:1c0:6280:3f0::df68]
        by desiato.infradead.org with esmtpsa (Exim 4.94 #2 (Red Hat Linux))
        id 1lZDff-00EYZv-2D; Wed, 21 Apr 2021 14:17:39 +0000
Subject: Re: [PATCH] bcache: add BLK_DEV dependency for BCACHE_NVM_PAGES
To:     Arnd Bergmann <arnd@kernel.org>, Coly Li <colyli@suse.de>,
        Kent Overstreet <kent.overstreet@gmail.com>,
        Jens Axboe <axboe@kernel.dk>,
        Jianpeng Ma <jianpeng.ma@intel.com>
Cc:     Arnd Bergmann <arnd@arndb.de>, Jean Delvare <jdelvare@suse.de>,
        linux-bcache@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20210421135021.3360382-1-arnd@kernel.org>
From:   Randy Dunlap <rdunlap@infradead.org>
Message-ID: <aa96ed83-47f4-39a7-4b6e-fb17cb4e9f84@infradead.org>
Date:   Wed, 21 Apr 2021 07:17:33 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.8.0
MIME-Version: 1.0
In-Reply-To: <20210421135021.3360382-1-arnd@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-bcache.vger.kernel.org>
X-Mailing-List: linux-bcache@vger.kernel.org

On 4/21/21 6:50 AM, Arnd Bergmann wrote:
> From: Arnd Bergmann <arnd@arndb.de>
> 
> Selecting this without CONFIG_BLK_DEV causes a Kconfig warning:
> 
> WARNING: unmet direct dependencies detected for LIBNVDIMM
>   Depends on [n]: PHYS_ADDR_T_64BIT [=y] && HAS_IOMEM [=y] && BLK_DEV [=n]
>   Selected by [y]:
>   - BCACHE_NVM_PAGES [=y] && MD [=y] && BCACHE [=y] && PHYS_ADDR_T_64BIT [=y]
> 
> Add it as another dependency.
> 
> Fixes: 688330711e9a ("bcache: initialize the nvm pages allocator")
> Signed-off-by: Arnd Bergmann <arnd@arndb.de>
> ---
>  drivers/md/bcache/Kconfig | 1 +
>  1 file changed, 1 insertion(+)
> 
> diff --git a/drivers/md/bcache/Kconfig b/drivers/md/bcache/Kconfig
> index 0996e366ad0b..9cb3d8c39fc1 100644
> --- a/drivers/md/bcache/Kconfig
> +++ b/drivers/md/bcache/Kconfig
> @@ -40,6 +40,7 @@ config BCACHE_NVM_PAGES
>  	bool "NVDIMM support for bcache (EXPERIMENTAL)"
>  	depends on BCACHE
>  	depends on PHYS_ADDR_T_64BIT
> +	depends on BLKDEV

	           BLK_DEV

>  	select LIBNVDIMM
>  	select DAX
>  	help
> 

tested?

-- 
~Randy

