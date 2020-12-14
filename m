Return-Path: <linux-bcache-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.2 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_SANE_1 autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 94756C4361B
	for <linux-bcache@archiver.kernel.org>; Mon, 14 Dec 2020 06:03:24 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 511DB229C7
	for <linux-bcache@archiver.kernel.org>; Mon, 14 Dec 2020 06:03:24 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2438699AbgLNGCg (ORCPT
        <rfc822;linux-bcache@archiver.kernel.org>);
        Mon, 14 Dec 2020 01:02:36 -0500
Received: from mx2.suse.de ([195.135.220.15]:48906 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2438698AbgLNGCg (ORCPT <rfc822;linux-bcache@vger.kernel.org>);
        Mon, 14 Dec 2020 01:02:36 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id AB231AC10;
        Mon, 14 Dec 2020 06:01:54 +0000 (UTC)
Subject: Re: [PATCH -next] md/bcache: convert comma to semicolon
To:     Zheng Yongjun <zhengyongjun3@huawei.com>,
        kent.overstreet@gmail.com, linux-bcache@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <20201211085222.2762-1-zhengyongjun3@huawei.com>
From:   Coly Li <colyli@suse.de>
Message-ID: <896b0315-2aec-47ce-d281-d231f54de805@suse.de>
Date:   Mon, 14 Dec 2020 14:01:51 +0800
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.16; rv:78.0)
 Gecko/20100101 Thunderbird/78.5.1
MIME-Version: 1.0
In-Reply-To: <20201211085222.2762-1-zhengyongjun3@huawei.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-bcache.vger.kernel.org>
X-Mailing-List: linux-bcache@vger.kernel.org

On 12/11/20 4:52 PM, Zheng Yongjun wrote:
> Replace a comma between expression statements by a semicolon.
> 
> Signed-off-by: Zheng Yongjun <zhengyongjun3@huawei.com>

Thanks for the catch. Added in my 2nd wave series.

Coly Li

> ---
>  drivers/md/bcache/sysfs.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/md/bcache/sysfs.c b/drivers/md/bcache/sysfs.c
> index 554e3afc9b68..00a520c03f41 100644
> --- a/drivers/md/bcache/sysfs.c
> +++ b/drivers/md/bcache/sysfs.c
> @@ -404,7 +404,7 @@ STORE(__cached_dev)
>  		if (!env)
>  			return -ENOMEM;
>  		add_uevent_var(env, "DRIVER=bcache");
> -		add_uevent_var(env, "CACHED_UUID=%pU", dc->sb.uuid),
> +		add_uevent_var(env, "CACHED_UUID=%pU", dc->sb.uuid);
>  		add_uevent_var(env, "CACHED_LABEL=%s", buf);
>  		kobject_uevent_env(&disk_to_dev(dc->disk.disk)->kobj,
>  				   KOBJ_CHANGE,
> 

