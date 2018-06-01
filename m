From: Coly Li <colyli@suse.de>
Subject: Re: [PATCH v2 19/21] bcache: use match_string() helper
Date: Fri, 1 Jun 2018 11:45:55 +0800
Message-ID: <f8dea584-a7b1-a894-d4b6-d573fdb4da3d@suse.de>
References: <1527765086-19873-1-git-send-email-xieyisheng1@huawei.com>
 <1527765086-19873-20-git-send-email-xieyisheng1@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1527765086-19873-20-git-send-email-xieyisheng1@huawei.com>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
To: Yisheng Xie <xieyisheng1@huawei.com>, linux-kernel@vger.kernel.org
Cc: andy.shevchenko@gmail.com, Kent Overstreet <kent.overstreet@gmail.com>, linux-bcache@vger.kernel.org
List-Id: linux-bcache@vger.kernel.org

On 2018/5/31 7:11 PM, Yisheng Xie wrote:
> match_string() returns the index of an array for a matching string,
> which can be used instead of open coded variant.
> 
> Cc: Kent Overstreet <kent.overstreet@gmail.com>
> Cc: linux-bcache@vger.kernel.org 
> Signed-off-by: Yisheng Xie <xieyisheng1@huawei.com>

Hi Yishenng,

Andy Shevchenko <andriy.shevchenko@linux.intel.com> submitted a patch to
replace the whole bch_read_string_list() with __sysfs_match_string().
And this patch is applied in Jens' block tree, will go into mainline
kernel in v4.18.

If you search bcache mailing list, you may find a patch named with
"bcache: Replace bch_read_string_list() by __sysfs_match_string()".

That means this patch will conflict with existing changes.

Thanks.

Coly Li

> ---
>  drivers/md/bcache/util.c | 9 ++-------
>  1 file changed, 2 insertions(+), 7 deletions(-)
> 
> diff --git a/drivers/md/bcache/util.c b/drivers/md/bcache/util.c
> index 74febd5..cd1f4fd 100644
> --- a/drivers/md/bcache/util.c
> +++ b/drivers/md/bcache/util.c
> @@ -136,22 +136,17 @@ ssize_t bch_snprint_string_list(char *buf, size_t size, const char * const list[
>  
>  ssize_t bch_read_string_list(const char *buf, const char * const list[])
>  {
> -	size_t i;
> +	ssize_t i;
>  	char *s, *d = kstrndup(buf, PAGE_SIZE - 1, GFP_KERNEL);
>  	if (!d)
>  		return -ENOMEM;
>  
>  	s = strim(d);
>  
> -	for (i = 0; list[i]; i++)
> -		if (!strcmp(list[i], s))
> -			break;
> +	i = match_string(list, -1, s);
>  
>  	kfree(d);
>  
> -	if (!list[i])
> -		return -EINVAL;
> -
>  	return i;
>  }
>  
> 
