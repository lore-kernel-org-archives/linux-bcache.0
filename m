Return-Path: <linux-bcache-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.2 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7DF7FC28D13
	for <linux-bcache@archiver.kernel.org>; Wed,  3 Mar 2021 00:35:59 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 623A264FB5
	for <linux-bcache@archiver.kernel.org>; Wed,  3 Mar 2021 00:35:59 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236161AbhCCAUZ (ORCPT <rfc822;linux-bcache@archiver.kernel.org>);
        Tue, 2 Mar 2021 19:20:25 -0500
Received: from mx2.suse.de ([195.135.220.15]:41958 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1351183AbhCBNfC (ORCPT <rfc822;linux-bcache@vger.kernel.org>);
        Tue, 2 Mar 2021 08:35:02 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id CE75FACBC;
        Tue,  2 Mar 2021 13:33:41 +0000 (UTC)
Subject: Re: [PATCH] bcache-tools: fix potential memoryleak problem in,
 may_add_item()
To:     Zhiqiang Liu <liuzhiqiang26@huawei.com>
Cc:     linfeilong <linfeilong@huawei.com>,
        lixiaokeng <lixiaokeng@huawei.com>, linux-bcache@vger.kernel.org
References: <c475bf5f-d284-aea9-5898-6ef3581138fb@huawei.com>
From:   Coly Li <colyli@suse.de>
Message-ID: <9e68d3fe-52bc-a496-5cad-ec47c1d295c1@suse.de>
Date:   Tue, 2 Mar 2021 21:33:37 +0800
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.16; rv:78.0)
 Gecko/20100101 Thunderbird/78.8.0
MIME-Version: 1.0
In-Reply-To: <c475bf5f-d284-aea9-5898-6ef3581138fb@huawei.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-bcache.vger.kernel.org>
X-Mailing-List: linux-bcache@vger.kernel.org

On 2/27/21 10:38 AM, Zhiqiang Liu wrote:
> 
> In may_add_item(), it will directly return 1 without freeing
> variable tmp and closing fd, when the return value of detail_base()
> is not equal to 0. In addition, we do not check whether
> allocating memory for tmp is successful.
> 
> Here, we will check whether malloc() returns NULL, and
> will free tmp and close fd when detail_base() fails.
> 
> Signed-off-by: ZhiqiangLiu <lzhq28@mail.ustc.edu.cn>

Applied. BTW, I change your above name string from ZhiqiangLiu to
Zhiqiang Liu, because of the checkpatch.pl warning.


Thanks.

Coly Li


> ---
>  lib.c | 28 +++++++++++++++++-----------
>  1 file changed, 17 insertions(+), 11 deletions(-)
> 
> diff --git a/lib.c b/lib.c
> index 6341c61..745dab6 100644
> --- a/lib.c
> +++ b/lib.c
> @@ -382,7 +382,7 @@ int may_add_item(char *devname, struct list_head *head)
>  	struct cache_sb sb;
>  	char dev[512];
>  	struct dev *tmp;
> -	int ret;
> +	int ret = 0;
> 
>  	if (strcmp(devname, ".") == 0 || strcmp(devname, "..") == 0)
>  		return 0;
> @@ -392,27 +392,33 @@ int may_add_item(char *devname, struct list_head *head)
>  	if (fd == -1)
>  		return 0;
> 
> -	if (pread(fd, &sb_disk, sizeof(sb_disk), SB_START) != sizeof(sb_disk)) {
> -		close(fd);
> -		return 0;
> -	}
> +	if (pread(fd, &sb_disk, sizeof(sb_disk), SB_START) != sizeof(sb_disk))
> +		goto out;
> 
> -	if (memcmp(sb_disk.magic, bcache_magic, 16)) {
> -		close(fd);
> -		return 0;
> -	}
> +	if (memcmp(sb_disk.magic, bcache_magic, 16))
> +		goto out;
> 
>  	to_cache_sb(&sb, &sb_disk);
> 
>  	tmp = (struct dev *) malloc(DEVLEN);
> +	if (tmp == NULL) {
> +		fprintf(stderr, "Error: fail to allocate memory buffer\n");
> +		ret = 1;
> +		goto out;
> +	}
> +
>  	tmp->csum = le64_to_cpu(sb_disk.csum);
>  	ret = detail_base(dev, sb, tmp);
>  	if (ret != 0) {
>  		fprintf(stderr, "Failed to get information for %s\n", dev);
> -		return 1;
> +		free(tmp);
> +		goto out;
>  	}
>  	list_add_tail(&tmp->dev_list, head);
> -	return 0;
> +
> +out:
> +	close(fd);
> +	return ret;
>  }
> 
>  int list_bdevs(struct list_head *head)
> 

