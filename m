From: Coly Li <colyli@suse.de>
Subject: Re: [PATCH] bcache: remove set but not used variable 'i'
Date: Mon, 6 Apr 2020 12:43:08 +0800
Message-ID: <dee5c875-4b4e-c425-ec8d-35e7599c4f5f@suse.de>
References: <1586259407-23673-1-git-send-email-wanghai38@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1586259407-23673-1-git-send-email-wanghai38@huawei.com>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
To: Wang Hai <wanghai38@huawei.com>, kent.overstreet@gmail.com
Cc: linux-bcache@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-bcache@vger.kernel.org

On 2020/4/7 7:36 下午, Wang Hai wrote:
> Fixes gcc '-Wunused-but-set-variable' warning:
> 
> drivers/md/bcache/btree.c: In function bch_btree_check_thread:
> drivers/md/bcache/btree.c:1910:6: warning:
>  variable ‘i’ set but not used [-Wunused-but-set-variable]
> 
> It's not used since commit 8e7102273f59 ("bcache: make bch_btree_check()
> to be multithreaded"), so remove it.
> 
> Reported-by: Hulk Robot <hulkci@huawei.com>
> Signed-off-by: Wang Hai <wanghai38@huawei.com>

Hi Hai,

Colin King already submitted a similar patch on Apr 2 to fix it.

Thanks.

Coly Li


> ---
>  drivers/md/bcache/btree.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/md/bcache/btree.c b/drivers/md/bcache/btree.c
> index 72856e5..b962313 100644
> --- a/drivers/md/bcache/btree.c
> +++ b/drivers/md/bcache/btree.c
> @@ -1907,10 +1907,10 @@ static int bch_btree_check_thread(void *arg)
>  	struct btree_iter iter;
>  	struct bkey *k, *p;
>  	int cur_idx, prev_idx, skip_nr;
> -	int i, n;
> +	int n;
>  
>  	k = p = NULL;
> -	i = n = 0;
> +	n = 0;
>  	cur_idx = prev_idx = 0;
>  	ret = 0;
>  
> 
