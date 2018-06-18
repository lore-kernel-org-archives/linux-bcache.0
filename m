From: Coly Li <colyli@suse.de>
Subject: Re: [PATCH 1/3] bcache: do not assign in if condition
 register_bcache()
Date: Mon, 18 Jun 2018 21:44:00 +0800
Message-ID: <8b109cdf-3bc7-4342-b925-8eea533d73b4@suse.de>
References: <20180618100902.4015-1-flo@geekplace.eu>
 <20180618100902.4015-2-flo@geekplace.eu>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20180618100902.4015-2-flo@geekplace.eu>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
To: Florian Schmaus <flo@geekplace.eu>, Kent Overstreet <kent.overstreet@gmail.com>, linux-bcache@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
List-Id: linux-bcache@vger.kernel.org

On 2018/6/18 6:09 PM, Florian Schmaus wrote:
> Fixes an error condition reported by checkpatch.pl which is caused by
> assigning a variable in an if condition.
> 
> Signed-off-by: Florian Schmaus <flo@geekplace.eu>

Signed-off-by: Coly Li <colyli@suse.de>

Added into for-next patch set.

Thanks.

Coly Li

> ---
>  drivers/md/bcache/super.c | 8 ++++++--
>  1 file changed, 6 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/md/bcache/super.c b/drivers/md/bcache/super.c
> index fa4058e43202..db7177d422e5 100644
> --- a/drivers/md/bcache/super.c
> +++ b/drivers/md/bcache/super.c
> @@ -2163,8 +2163,12 @@ static ssize_t register_bcache(struct kobject *k, struct kobj_attribute *attr,
>  	if (!try_module_get(THIS_MODULE))
>  		return -EBUSY;
>  
> -	if (!(path = kstrndup(buffer, size, GFP_KERNEL)) ||
> -	    !(sb = kmalloc(sizeof(struct cache_sb), GFP_KERNEL)))
> +	path = kstrndup(buffer, size, GFP_KERNEL);
> +	if (!path)
> +		goto err;
> +
> +	sb = kmalloc(sizeof(struct cache_sb), GFP_KERNEL);
> +	if (!sb)
>  		goto err;
>  
>  	err = "failed to open device";
> 
