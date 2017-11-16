From: Kai Krakow <hurikhan77@gmail.com>
Subject: Re: [PATCH] bcache: Fix building error on MIPS
Date: Thu, 16 Nov 2017 17:58:16 +0100
Message-ID: <20171116175816.461480be@jupiter.sol.kaishome.de>
References: <1510801573-17878-1-git-send-email-chenhc@lemote.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-bcache-owner@vger.kernel.org>
Received: from [195.159.176.226] ([195.159.176.226]:33022 "EHLO
        blaine.gmane.org" rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org
        with ESMTP id S1760170AbdKPQ62 (ORCPT
        <rfc822;linux-bcache@vger.kernel.org>);
        Thu, 16 Nov 2017 11:58:28 -0500
Received: from list by blaine.gmane.org with local (Exim 4.84_2)
        (envelope-from <glbd-linux-bcache@m.gmane.org>)
        id 1eFNUY-0006GV-Qw
        for linux-bcache@vger.kernel.org; Thu, 16 Nov 2017 17:58:18 +0100
Sender: linux-bcache-owner@vger.kernel.org
List-Id: linux-bcache@vger.kernel.org
To: linux-bcache@vger.kernel.org
Cc: stable@vger.kernel.org

Am Thu, 16 Nov 2017 11:06:13 +0800
schrieb Huacai Chen <chenhc@lemote.com>:

> diff --git a/include/uapi/linux/bcache.h b/include/uapi/linux/bcache.h
> index 90fc490..5cc599c 100644
> --- a/include/uapi/linux/bcache.h
> +++ b/include/uapi/linux/bcache.h
> @@ -91,7 +91,7 @@ PTR_FIELD(PTR_GEN,			0,  8)
>  
>  #define PTR_CHECK_DEV			((1 << PTR_DEV_BITS) -
> 1) 
> -#define PTR(gen, offset,
> dev)						\ +#define
> MAKE_PTR(gen, offset,
> dev)						\ ((((__u64) dev)
> << 51) | ((__u64) offset) << 8 | gen) /* Bkey utility code */

I don't think you make it any better by calling it MAKE_PTR then. How's
the next guy stumbling across such a conflict calling his definition
then? CREATE_PTR?

Why not call it BCH_PTR or similar?

-- 
Regards,
Kai

Replies to list-only preferred.
