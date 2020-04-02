From: Coly Li <colyli@suse.de>
Subject: Re: [PATCH] bcache: remove redundant variables i and n
Date: Thu, 2 Apr 2020 19:34:09 +0800
Message-ID: <de88ae08-1200-285b-cd1b-cfd723d2da56@suse.de>
References: <20200402111903.514146-1-colin.king@canonical.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20200402111903.514146-1-colin.king@canonical.com>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
To: Colin King <colin.king@canonical.com>
Cc: Kent Overstreet <kent.overstreet@gmail.com>, linux-bcache@vger.kernel.org, kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-bcache@vger.kernel.org

On 2020/4/2 7:19 下午, Colin King wrote:
> From: Colin Ian King <colin.king@canonical.com>
> 
> Variables i and n are being assigned but are never used. They are
> redundant and can be removed.
> 

Hi Colin,

> Addresses-Coverity: ("Unused value")
> Signed-off-by: Colin Ian King <colin.king@canonical.com>

Thanks, I will submit this patch in Linux 5.7-rc series.

> ---
>  drivers/md/bcache/btree.c | 2 --
>  1 file changed, 2 deletions(-)
> 
> diff --git a/drivers/md/bcache/btree.c b/drivers/md/bcache/btree.c
> index 72856e5f23a3..114d0d73d909 100644
> --- a/drivers/md/bcache/btree.c
> +++ b/drivers/md/bcache/btree.c
> @@ -1907,10 +1907,8 @@ static int bch_btree_check_thread(void *arg)
>  	struct btree_iter iter;
>  	struct bkey *k, *p;
>  	int cur_idx, prev_idx, skip_nr;
> -	int i, n;
>  
>  	k = p = NULL;
> -	i = n = 0;
>  	cur_idx = prev_idx = 0;
>  	ret = 0;
>  
> 


-- 

Coly Li
