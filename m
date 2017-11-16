From: Coly Li <colyli@suse.de>
Subject: Re: [PATCH] bcache: Fix building error on MIPS
Date: Thu, 16 Nov 2017 12:25:37 +0800
Message-ID: <b28f4962-f418-d6bf-ad7b-7c1a8089bbe8@suse.de>
References: <1510801573-17878-1-git-send-email-chenhc@lemote.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Return-path: <linux-bcache-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:53221 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1758264AbdKPEZo (ORCPT <rfc822;linux-bcache@vger.kernel.org>);
        Wed, 15 Nov 2017 23:25:44 -0500
In-Reply-To: <1510801573-17878-1-git-send-email-chenhc@lemote.com>
Content-Language: en-US
Sender: linux-bcache-owner@vger.kernel.org
List-Id: linux-bcache@vger.kernel.org
To: Huacai Chen <chenhc@lemote.com>
Cc: Michael Lyle <mlyle@lyle.org>, Kent Overstreet <kent.overstreet@gmail.com>, linux-bcache@vger.kernel.org, stable@vger.kernel.org

On 2017/11/16 上午11:06, Huacai Chen wrote:
> This patch try to fix the building error on MIPS. The reason is MIPS
> has already defined the PTR macro, which conflicts with the PTR macro
> in include/uapi/linux/bcache.h.
> 

Hi Huacai,

Did you try to add a #undef PTR in user/include/linux/bcache.h ?

Thanks.

Coly


> Cc: stable@vger.kernel.org
> Signed-off-by: Huacai Chen <chenhc@lemote.com>
> ---
>  drivers/md/bcache/alloc.c   | 2 +-
>  drivers/md/bcache/extents.c | 2 +-
>  drivers/md/bcache/journal.c | 2 +-
>  include/uapi/linux/bcache.h | 2 +-
>  4 files changed, 4 insertions(+), 4 deletions(-)
> 
> diff --git a/drivers/md/bcache/alloc.c b/drivers/md/bcache/alloc.c
> index a27d852..a0cc1bc 100644
> --- a/drivers/md/bcache/alloc.c
> +++ b/drivers/md/bcache/alloc.c
> @@ -490,7 +490,7 @@ int __bch_bucket_alloc_set(struct cache_set *c, unsigned reserve,
>  		if (b == -1)
>  			goto err;
>  
> -		k->ptr[i] = PTR(ca->buckets[b].gen,
> +		k->ptr[i] = MAKE_PTR(ca->buckets[b].gen,
>  				bucket_to_sector(c, b),
>  				ca->sb.nr_this_dev);
[snip]

> diff --git a/include/uapi/linux/bcache.h b/include/uapi/linux/bcache.h
> index 90fc490..5cc599c 100644
> --- a/include/uapi/linux/bcache.h
> +++ b/include/uapi/linux/bcache.h
> @@ -91,7 +91,7 @@ PTR_FIELD(PTR_GEN,			0,  8)
>  
>  #define PTR_CHECK_DEV			((1 << PTR_DEV_BITS) - 1)
>  
> -#define PTR(gen, offset, dev)						\
> +#define MAKE_PTR(gen, offset, dev)						\
>  	((((__u64) dev) << 51) | ((__u64) offset) << 8 | gen)
>  
>  /* Bkey utility code */
> 
