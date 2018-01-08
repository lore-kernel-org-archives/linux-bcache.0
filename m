From: Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH v1 07/10] bcache: set error_limit correctly
Date: Mon, 8 Jan 2018 08:26:52 +0100
Message-ID: <e89b64f2-ff9a-1603-4d0b-6e75283fa993@suse.de>
References: <20180103140325.63175-1-colyli@suse.de>
 <20180103140325.63175-8-colyli@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Return-path: <linux-block-owner@vger.kernel.org>
In-Reply-To: <20180103140325.63175-8-colyli@suse.de>
Content-Language: en-US
Sender: linux-block-owner@vger.kernel.org
To: Coly Li <colyli@suse.de>, linux-bcache@vger.kernel.org
Cc: linux-block@vger.kernel.org, mlyle@lyle.org, tang.junhui@zte.com.cn
List-Id: linux-bcache@vger.kernel.org

On 01/03/2018 03:03 PM, Coly Li wrote:
> Struct cache uses io_errors for two purposes,
> - Error decay: when cache set error_decay is set, io_errors is used to
>   generate a small piece of delay when I/O error happens.
> - I/O errors counter: in order to generate big enough value for error
>   decay, I/O errors counter value is stored by left shifting 20 bits (a.k.a
>   IO_ERROR_SHIFT).
> 
> In function bch_count_io_errors(), if I/O errors counter reaches cache set
> error limit, bch_cache_set_error() will be called to retire the whold cache
> set. But current code is problematic when checking the error limit, see the
> following code piece from bch_count_io_errors(),
> 
>  90   if (error) {
>  91           char buf[BDEVNAME_SIZE];
>  92           unsigned errors = atomic_add_return(1 << IO_ERROR_SHIFT,
>  93                                               &ca->io_errors);
>  94           errors >>= IO_ERROR_SHIFT;
>  95
>  96           if (errors < ca->set->error_limit)
>  97                   pr_err("%s: IO error on %s, recovering",
>  98                          bdevname(ca->bdev, buf), m);
>  99           else
> 100                   bch_cache_set_error(ca->set,
> 101                                       "%s: too many IO errors %s",
> 102                                       bdevname(ca->bdev, buf), m);
> 103   }
> 
> At line 94, errors is right shifting IO_ERROR_SHIFT bits, now it is real
> errors counter to compare at line 96. But ca->set->error_limit is initia-
> lized with an amplified value in bch_cache_set_alloc(),
> 1545   c->error_limit  = 8 << IO_ERROR_SHIFT;
> 
> It means by default, in bch_count_io_errors(), before 8<<20 errors happened
> bch_cache_set_error() won't be called to retire the problematic cache
> device. If the average request size is 64KB, it means bcache won't handle
> failed device until 512GB data is requested. This is too large to be an I/O
> threashold. So I believe the correct error limit should be much less.
> 
> This patch sets default cache set error limit to 8, then in
> bch_count_io_errors() when errors counter reaches 8 (if it is default
> value), function bch_cache_set_error() will be called to retire the whole
> cache set. This patch also removes bits shifting when store or show
> io_error_limit value via sysfs interface.
> 
> Nowadays most of SSDs handle internal flash failure automatically by LBA
> address re-indirect mapping. If an I/O error can be observed by upper layer
> code, it will be a notable error because that SSD can not re-indirect
> map the problematic LBA address to an available flash block. This situation
> indicates the whole SSD will be failed very soon. Therefore setting 8 as
> the default io error limit value makes sense, it is enough for most of
> cache devices.
> 
> Signed-off-by: Coly Li <colyli@suse.de>
> ---
>  drivers/md/bcache/bcache.h | 1 +
>  drivers/md/bcache/super.c  | 2 +-
>  drivers/md/bcache/sysfs.c  | 4 ++--
>  3 files changed, 4 insertions(+), 3 deletions(-)
> 
Reviewed-by: Hannes Reinecke <hare@suse.com>

Cheers,

Hannes
-- 
Dr. Hannes Reinecke		   Teamlead Storage & Networking
hare@suse.de			               +49 911 74053 688
SUSE LINUX GmbH, Maxfeldstr. 5, 90409 Nürnberg
GF: F. Imendörffer, J. Smithard, J. Guild, D. Upmanyu, G. Norton
HRB 21284 (AG Nürnberg)
