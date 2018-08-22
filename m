From: Coly Li <colyli@suse.de>
Subject: Re: [PATCH v2] bcache: release dc->writeback_lock properly in
 bch_writeback_thread()
Date: Thu, 23 Aug 2018 02:07:55 +0800
Message-ID: <e44eebe7-a42c-f4f9-0f2f-e7d9135f8bff@suse.de>
References: <20180822180256.15600-1-colyli@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <stable-owner@vger.kernel.org>
In-Reply-To: <20180822180256.15600-1-colyli@suse.de>
Content-Language: en-US
Sender: stable-owner@vger.kernel.org
To: axboe@kernel.dk
Cc: linux-bcache@vger.kernel.org, linux-block@vger.kernel.org, Shan Hai <shan.hai@oracle.com>, stable@vger.kernel.org
List-Id: linux-bcache@vger.kernel.org

On 2018/8/23 2:02 AM, Coly Li wrote:
> From: Shan Hai <shan.hai@oracle.com>
> 
> The writeback thread would exit with a lock held when the cache device is
> detached via sysfs interface, fix it by releasing the held lock before exiting
> the while-loop.
> 
> Fixes: fadd94e05c02 (bcache: quit dc->writeback_thread when BCACHE_DEV_DETACHING is set)
> Signed-off-by: Shan Hai <shan.hai@oracle.com>
> Signed-off-by: Coly Li <colyli@suse.de>
> Tested-by: Shenghui Wang <shhuiw@foxmail.com>
> Cc: stable@vger.kernel.org #4.17+
> ---
> Changelog:
> v2: add Fixes tag by Coly Li.
> v1: initial patch from Shan Hai.

Hi Jens,

Please pick this patch for your next pull request. The change from Shan
Hai fixes a real issue which is reported and lately verified by Shenghui
Wang.

Thanks in advance.

Coly Li

> 
>  drivers/md/bcache/writeback.c | 4 +++-
>  1 file changed, 3 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/md/bcache/writeback.c b/drivers/md/bcache/writeback.c
> index 6be05bd7ca67..08c3a9f9676c 100644
> --- a/drivers/md/bcache/writeback.c
> +++ b/drivers/md/bcache/writeback.c
> @@ -685,8 +685,10 @@ static int bch_writeback_thread(void *arg)
>  			 * data on cache. BCACHE_DEV_DETACHING flag is set in
>  			 * bch_cached_dev_detach().
>  			 */
> -			if (test_bit(BCACHE_DEV_DETACHING, &dc->disk.flags))
> +			if (test_bit(BCACHE_DEV_DETACHING, &dc->disk.flags)) {
> +				up_write(&dc->writeback_lock);
>  				break;
> +			}
>  		}
>  
>  		up_write(&dc->writeback_lock);
> 
