From: Coly Li <colyli@suse.de>
Subject: Re: [PATCH] add label interface for cache device in sysfs
Date: Fri, 14 Sep 2018 18:00:37 +0800
Message-ID: <eb59aaba-809b-579e-23c0-da802bd66e84@suse.de>
References: <20180914095120.2699-1-cdbdyx@163.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20180914095120.2699-1-cdbdyx@163.com>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
To: Dongbo Cao <cdbdyx@163.com>
Cc: kent.overstreet@gmail.com, linux-bcache@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-bcache@vger.kernel.org


On 9/14/18 5:51 PM, Dongbo Cao wrote:
> label interface will be called by bcache tools in user space.
>
> Signed-off-by: Dongbo Cao <cdbdyx@163.com>

Hi Dongbo,


In your change I see you set superblock label to cache set. What is the 
use case for doing this ?

Thanks.


Coly Li


> ---
>   drivers/md/bcache/sysfs.c | 19 +++++++++++++++++++
>   1 file changed, 19 insertions(+)
>
> diff --git a/drivers/md/bcache/sysfs.c b/drivers/md/bcache/sysfs.c
> index 225b15aa..e64c718f 100644
> --- a/drivers/md/bcache/sysfs.c
> +++ b/drivers/md/bcache/sysfs.c
> @@ -950,6 +950,13 @@ SHOW(__bch_cache)
>   		return ret;
>   	}
>   
> +	if (attr == &sysfs_label) {
> +		memcpy(buf, ca->sb.label, SB_LABEL_SIZE);
> +		buf[SB_LABEL_SIZE + 1] = '\0';
> +		strcat(buf, "\n");
> +		return strlen(buf);
> +	}
> +
>   	return 0;
>   }
>   SHOW_LOCKED(bch_cache)
> @@ -993,6 +1000,17 @@ STORE(__bch_cache)
>   		atomic_set(&ca->io_errors, 0);
>   	}
>   
> +	if (attr == &sysfs_label) {
> +		if (size > SB_LABEL_SIZE)
> +			return -EINVAL;
> +		memcpy(ca->sb.label, buf, size);
> +		if (size < SB_LABEL_SIZE)
> +			ca->sb.label[size] = '\0';
> +		if (size && ca->sb.label[size - 1] == '\n')
> +			ca->sb.label[size - 1] = '\0';
> +		bcache_write_super(ca->set);
> +	}
> +
>   	return size;
>   }
>   STORE_LOCKED(bch_cache)
> @@ -1009,6 +1027,7 @@ static struct attribute *bch_cache_files[] = {
>   	&sysfs_io_errors,
>   	&sysfs_clear_stats,
>   	&sysfs_cache_replacement_policy,
> +	&sysfs_label,
>   	NULL
>   };
>   KTYPE(bch_cache);
