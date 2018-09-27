From: Coly Li <colyli@suse.de>
Subject: Re: [PATCH] use STORE_LOCKED instead of STORE macro
Date: Thu, 27 Sep 2018 23:44:16 +0800
Message-ID: <4e1bb3e5-82f2-51ff-c95b-fa76da4081da@suse.de>
References: <20180927053142.4529-1-cdbdyx@163.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20180927053142.4529-1-cdbdyx@163.com>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
To: Dongbo Cao <cdbdyx@163.com>
Cc: kent.overstreet@gmail.com, linux-bcache@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-bcache@vger.kernel.org


On 9/27/18 1:31 PM, Dongbo Cao wrote:
> merge sysfs_writeback_running attr and sysfs_writeback_percent attr together with other attrs of cached_dev.
>
> Signed-off-by: Dongbo Cao <cdbdyx@163.com>

Could you please to explain more what you want to do, and why you make 
this change?

Thanks.


Coly Li

> ---
>   drivers/md/bcache/sysfs.c | 15 ++-------------
>   1 file changed, 2 insertions(+), 13 deletions(-)
>
> diff --git a/drivers/md/bcache/sysfs.c b/drivers/md/bcache/sysfs.c
> index 26f035a0..14fc9104 100644
> --- a/drivers/md/bcache/sysfs.c
> +++ b/drivers/md/bcache/sysfs.c
> @@ -245,7 +245,7 @@ SHOW(__bch_cached_dev)
>   }
>   SHOW_LOCKED(bch_cached_dev)
>   
> -STORE(__cached_dev)
> +STORE(__bch_cached_dev)
>   {
>   	struct cached_dev *dc = container_of(kobj, struct cached_dev,
>   					     disk.kobj);
> @@ -373,17 +373,6 @@ STORE(__cached_dev)
>   	if (attr == &sysfs_stop)
>   		bcache_device_stop(&dc->disk);
>   
> -	return size;
> -}
> -
> -STORE(bch_cached_dev)
> -{
> -	struct cached_dev *dc = container_of(kobj, struct cached_dev,
> -					     disk.kobj);
> -
> -	mutex_lock(&bch_register_lock);
> -	size = __cached_dev_store(kobj, attr, buf, size);
> -
>   	if (attr == &sysfs_writeback_running)
>   		bch_writeback_queue(dc);
>   
> @@ -392,9 +381,9 @@ STORE(bch_cached_dev)
>   			schedule_delayed_work(&dc->writeback_rate_update,
>   				      dc->writeback_rate_update_seconds * HZ);
>   
> -	mutex_unlock(&bch_register_lock);
>   	return size;
>   }
> +STORE_LOCKED(bch_cached_dev)
>   
>   static struct attribute *bch_cached_dev_files[] = {
>   	&sysfs_attach,
