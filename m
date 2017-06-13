From: Coly Li <i@coly.li>
Subject: Re: [PATCH] bcache: Correct return value for sysfs attach errors
Date: Tue, 13 Jun 2017 13:47:07 +0800
Message-ID: <7141227c-6fbe-2815-aa15-ec0a7c5f47e4@coly.li>
References: <1497302306-17398-1-git-send-email-tasleson@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Return-path: <linux-bcache-owner@vger.kernel.org>
Received: from server.coly.li ([162.144.45.48]:60336 "EHLO server.coly.li"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751955AbdFMFrP (ORCPT <rfc822;linux-bcache@vger.kernel.org>);
        Tue, 13 Jun 2017 01:47:15 -0400
In-Reply-To: <1497302306-17398-1-git-send-email-tasleson@redhat.com>
Content-Language: en-US
Sender: linux-bcache-owner@vger.kernel.org
List-Id: linux-bcache@vger.kernel.org
To: Tony Asleson <tasleson@redhat.com>, linux-bcache@vger.kernel.org

On 2017/6/13 上午5:18, Tony Asleson wrote:
> If you encounter any errors in bch_cached_dev_attach it will return a negative
> error code.  The variable 'v' which stores the result is unsigned, thus user
> space sees a very large value returned for bytes written which can cause
> incorrect user space behavior.  Utilize 1 signed variable to use throughout
> the function to preserve error return capability.
> 
> Signed-off-by: Tony Asleson <tasleson@redhat.com>

Acked-by: Coly Li <colyli@suse.de>

Nice catch, thanks.

Coly

> ---
>  drivers/md/bcache/sysfs.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/md/bcache/sysfs.c b/drivers/md/bcache/sysfs.c
> index f90f136..ab2f8ce 100644
> --- a/drivers/md/bcache/sysfs.c
> +++ b/drivers/md/bcache/sysfs.c
> @@ -192,7 +192,7 @@
>  {
>  	struct cached_dev *dc = container_of(kobj, struct cached_dev,
>  					     disk.kobj);
> -	unsigned v = size;
> +	ssize_t v = size;
>  	struct cache_set *c;
>  	struct kobj_uevent_env *env;
>  
> @@ -227,7 +227,7 @@
>  		bch_cached_dev_run(dc);
>  
>  	if (attr == &sysfs_cache_mode) {
> -		ssize_t v = bch_read_string_list(buf, bch_cache_modes + 1);
> +		v = bch_read_string_list(buf, bch_cache_modes + 1);
>  
>  		if (v < 0)
>  			return v;
> 
