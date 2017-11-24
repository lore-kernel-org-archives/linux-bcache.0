From: Michael Lyle <mlyle@lyle.org>
Subject: Re: [PATCH v2] bcache: check return value of register_shrinker
Date: Fri, 24 Nov 2017 14:24:42 -0800
Message-ID: <a1831d01-b327-1e0b-b802-38892931e56e@lyle.org>
References: <20171124201814.26173-1-mlyle@lyle.org>
 <20171124220250.400-1-mlyle@lyle.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-bcache-owner@vger.kernel.org>
Received: from mail-pl0-f65.google.com ([209.85.160.65]:36020 "EHLO
        mail-pl0-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753730AbdKXWYo (ORCPT
        <rfc822;linux-bcache@vger.kernel.org>);
        Fri, 24 Nov 2017 17:24:44 -0500
Received: by mail-pl0-f65.google.com with SMTP id b12so5062859plm.3
        for <linux-bcache@vger.kernel.org>; Fri, 24 Nov 2017 14:24:44 -0800 (PST)
Received: from ?IPv6:2001:470:4a39::d66? ([2001:470:4a39::d66])
        by smtp.gmail.com with ESMTPSA id y1sm35151347pge.27.2017.11.24.14.24.43
        for <linux-bcache@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 24 Nov 2017 14:24:43 -0800 (PST)
In-Reply-To: <20171124220250.400-1-mlyle@lyle.org>
Content-Language: en-US
Sender: linux-bcache-owner@vger.kernel.org
List-Id: linux-bcache@vger.kernel.org
To: linux-bcache@vger.kernel.org

Just a note to everyone-- a quick Reviewed-by: would be appreciated from
someone here on the bcache list because I'm hoping to get this sent off
with a couple other things to Jens soon.  -mpl

On 11/24/2017 02:02 PM, Michael Lyle wrote:
> register_shrinker is now __must_check, so check it to kill a warning.
> Caller of bch_btree_cache_alloc in super.c appropriately checks return
> value so this is fully plumbed through.
> 
> This V2 fixes checkpatch warnings and improves the commit description,
> as I was too hasty getting the previous version out.
> 
> Signed-off-by: Michael Lyle <mlyle@lyle.org>
> ---
>  drivers/md/bcache/btree.c | 5 ++++-
>  1 file changed, 4 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/md/bcache/btree.c b/drivers/md/bcache/btree.c
> index 11c5503d31dc..81e8dc3dbe5e 100644
> --- a/drivers/md/bcache/btree.c
> +++ b/drivers/md/bcache/btree.c
> @@ -807,7 +807,10 @@ int bch_btree_cache_alloc(struct cache_set *c)
>  	c->shrink.scan_objects = bch_mca_scan;
>  	c->shrink.seeks = 4;
>  	c->shrink.batch = c->btree_pages * 2;
> -	register_shrinker(&c->shrink);
> +
> +	if (register_shrinker(&c->shrink))
> +		pr_warn("bcache: %s: could not register shrinker",
> +				__func__);
>  
>  	return 0;
>  }
> 
