From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 2/4] bcache: Fix building error on MIPS
Date: Tue, 28 Nov 2017 05:42:21 -0800
Message-ID: <20171128134221.GA16064@infradead.org>
References: <20171124231427.9563-1-mlyle@lyle.org>
 <20171124231427.9563-3-mlyle@lyle.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <stable-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20171124231427.9563-3-mlyle@lyle.org>
Sender: stable-owner@vger.kernel.org
To: Michael Lyle <mlyle@lyle.org>
Cc: linux-bcache@vger.kernel.org, linux-block@vger.kernel.org, axboe@kernel.dk, Huacai Chen <chenhc@lemote.com>, stable@vger.kernel.org
List-Id: linux-bcache@vger.kernel.org

> diff --git a/include/uapi/linux/bcache.h b/include/uapi/linux/bcache.h
> index 90fc490f973f..821f71a2e48f 100644
> --- a/include/uapi/linux/bcache.h
> +++ b/include/uapi/linux/bcache.h
> @@ -91,7 +91,7 @@ PTR_FIELD(PTR_GEN,			0,  8)
>  
>  #define PTR_CHECK_DEV			((1 << PTR_DEV_BITS) - 1)
>  
> -#define PTR(gen, offset, dev)						\
> +#define MAKE_PTR(gen, offset, dev)					\
>  	((((__u64) dev) << 51) | ((__u64) offset) << 8 | gen)

This really should have a BCACHE_ prefix, and probably a lower case
name.  And last but not least it really shouldn't be in a uapi header.

Similar things apply to various other things around it.
