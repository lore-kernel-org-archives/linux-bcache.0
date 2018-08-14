From: Coly Li <colyli@suse.de>
Subject: Re: [PATCH 2/2] bcache: add undef for macro in function
Date: Tue, 14 Aug 2018 20:16:07 +0800
Message-ID: <7fdac573-a324-0c33-d9fd-0ab097b47f3f@suse.de>
References: <20180814081625.12326-1-cdbdyx@163.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20180814081625.12326-1-cdbdyx@163.com>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
To: Dongbo Cao <cdbdyx@163.com>
Cc: kent.overstreet@gmail.com, linux-bcache@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-bcache@vger.kernel.org

On 2018/8/14 4:16 PM, Dongbo Cao wrote:
> add undef for macro d_strtoul,d_strtoul_nonzero and d_strtoi_h
> 
> Signed-off-by: Dongbo Cao <cdbdyx@163.com>
> ---
>  drivers/md/bcache/sysfs.c | 3 +++
>  1 file changed, 3 insertions(+)
> 
> diff --git a/drivers/md/bcache/sysfs.c b/drivers/md/bcache/sysfs.c
> index 225b15aa..ed67a290 100644
> --- a/drivers/md/bcache/sysfs.c
> +++ b/drivers/md/bcache/sysfs.c
> @@ -349,6 +349,9 @@ STORE(__cached_dev)
>  	if (attr == &sysfs_stop)
>  		bcache_device_stop(&dc->disk);
>  
> +#undef d_strtoul
> +#undef d_strtoul_nonzero
> +#undef d_strtoi_h
>  	return size;
>  }
>  
> 

Hi Dongbo,

Could you please to provide the motivation why you make this change ?

Thanks.

Coly Li
