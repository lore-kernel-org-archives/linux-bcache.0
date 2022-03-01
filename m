Return-Path: <linux-bcache-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2D65BC433EF
	for <linux-bcache@archiver.kernel.org>; Tue,  1 Mar 2022 02:13:01 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232073AbiCACNi (ORCPT <rfc822;linux-bcache@archiver.kernel.org>);
        Mon, 28 Feb 2022 21:13:38 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42316 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231996AbiCACNi (ORCPT
        <rfc822;linux-bcache@vger.kernel.org>);
        Mon, 28 Feb 2022 21:13:38 -0500
Received: from mga05.intel.com (mga05.intel.com [192.55.52.43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C8C162DE1;
        Mon, 28 Feb 2022 18:12:57 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1646100777; x=1677636777;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=FHnCsOMAMVBswmIQalbSrppghnzz3akbTDtT8A36Yxg=;
  b=gky3VH8HpuBTmSWQthfd7i1UxfeExdzkLT0NchEMzjtmf58xDS78LmOz
   R1kme0ofczXP8FZddko4VKHz1piELJCgM0Yzgih8Hp8WDzUZ0uZTvh65k
   6i4dPfnNtogPA7hN+NU/RJP/uuWmzxhEisYYtVW5Iheu8zyOowQnQmhzA
   CuHkYRVO3nWD6AxNa/GV0lkb87kc5ChRFp1vyAx/PEFK+sqscrMJRz+Wz
   YEX+NHZW4aBCVlZgeTl4h2RcVTmf/nOS3bLRLi3goO6BP5ktZbkMkUC2C
   oK+Xkk+5yDHN6dtjdEqDe/nypY94/z+z0w3Tfa2jS4CyQduw5HBXTEgC8
   g==;
X-IronPort-AV: E=McAfee;i="6200,9189,10272"; a="339469568"
X-IronPort-AV: E=Sophos;i="5.90,144,1643702400"; 
   d="scan'208";a="339469568"
Received: from fmsmga003.fm.intel.com ([10.253.24.29])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Feb 2022 18:12:46 -0800
X-IronPort-AV: E=Sophos;i="5.90,144,1643702400"; 
   d="scan'208";a="629855449"
Received: from chunhanz-mobl.amr.corp.intel.com (HELO localhost) ([10.212.29.175])
  by fmsmga003-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Feb 2022 18:12:45 -0800
Date:   Mon, 28 Feb 2022 18:12:45 -0800
From:   Ira Weiny <ira.weiny@intel.com>
To:     Christoph Hellwig <hch@lst.de>
Cc:     Jens Axboe <axboe@kernel.dk>, Chris Zankel <chris@zankel.net>,
        Max Filippov <jcmvbkbc@gmail.com>,
        Justin Sanders <justin@coraid.com>,
        Philipp Reisner <philipp.reisner@linbit.com>,
        Lars Ellenberg <lars.ellenberg@linbit.com>,
        Denis Efremov <efremov@linux.com>,
        Minchan Kim <minchan@kernel.org>,
        Nitin Gupta <ngupta@vflare.org>, Coly Li <colyli@suse.de>,
        Dan Williams <dan.j.williams@intel.com>,
        Vishal Verma <vishal.l.verma@intel.com>,
        linux-xtensa@linux-xtensa.org, linux-block@vger.kernel.org,
        drbd-dev@lists.linbit.com, linux-bcache@vger.kernel.org,
        nvdimm@lists.linux.dev
Subject: Re: [PATCH 04/10] zram: use memcpy_from_bvec in zram_bvec_write
Message-ID: <Yh2BHT4xXBJac987@iweiny-desk3>
References: <20220222155156.597597-1-hch@lst.de>
 <20220222155156.597597-5-hch@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220222155156.597597-5-hch@lst.de>
Precedence: bulk
List-ID: <linux-bcache.vger.kernel.org>
X-Mailing-List: linux-bcache@vger.kernel.org

On Tue, Feb 22, 2022 at 04:51:50PM +0100, Christoph Hellwig wrote:
> Use memcpy_from_bvec instead of open coding the logic.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>

Same comment regarding the dst map.  Does it need to be atomic?

Regardless,
Reviewed-by: Ira Weiny <ira.weiny@intel.com>

> ---
>  drivers/block/zram/zram_drv.c | 5 +----
>  1 file changed, 1 insertion(+), 4 deletions(-)
> 
> diff --git a/drivers/block/zram/zram_drv.c b/drivers/block/zram/zram_drv.c
> index 14becdf2815df..e9474b02012de 100644
> --- a/drivers/block/zram/zram_drv.c
> +++ b/drivers/block/zram/zram_drv.c
> @@ -1465,7 +1465,6 @@ static int zram_bvec_write(struct zram *zram, struct bio_vec *bvec,
>  {
>  	int ret;
>  	struct page *page = NULL;
> -	void *src;
>  	struct bio_vec vec;
>  
>  	vec = *bvec;
> @@ -1483,11 +1482,9 @@ static int zram_bvec_write(struct zram *zram, struct bio_vec *bvec,
>  		if (ret)
>  			goto out;
>  
> -		src = kmap_atomic(bvec->bv_page);
>  		dst = kmap_atomic(page);
> -		memcpy(dst + offset, src + bvec->bv_offset, bvec->bv_len);
> +		memcpy_from_bvec(dst + offset, bvec);
>  		kunmap_atomic(dst);
> -		kunmap_atomic(src);
>  
>  		vec.bv_page = page;
>  		vec.bv_len = PAGE_SIZE;
> -- 
> 2.30.2
> 
> 
