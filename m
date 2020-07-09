From: Coly Li <colyli@suse.de>
Subject: Re: [PATCH] bcache: writeback: Remove unneeded variable ret
Date: Thu, 9 Jul 2020 12:07:37 +0800
Message-ID: <e50bf828-997d-38e7-76c4-fd3a70ab6c36@suse.de>
References: <20200709033904.27391-1-vulab@iscas.ac.cn>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-bcache-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:58618 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726064AbgGIEHp (ORCPT <rfc822;linux-bcache@vger.kernel.org>);
        Thu, 9 Jul 2020 00:07:45 -0400
In-Reply-To: <20200709033904.27391-1-vulab@iscas.ac.cn>
Content-Language: en-US
Sender: linux-bcache-owner@vger.kernel.org
List-Id: linux-bcache@vger.kernel.org
To: Xu Wang <vulab@iscas.ac.cn>
Cc: kent.overstreet@gmail.com, linux-bcache@vger.kernel.org, linux-kernel@vger.kernel.org

On 2020/7/9 11:39, Xu Wang wrote:
> Remove unneeded variable ret i.
> 

I see 'i' is removed, where is 'ret' ?

Thanks.


Coly Li


> Signed-off-by: Xu Wang <vulab@iscas.ac.cn>
> ---
>  drivers/md/bcache/writeback.c | 2 --
>  1 file changed, 2 deletions(-)
> 
> diff --git a/drivers/md/bcache/writeback.c b/drivers/md/bcache/writeback.c
> index 1cf1e5016cb9..71801c086b82 100644
> --- a/drivers/md/bcache/writeback.c
> +++ b/drivers/md/bcache/writeback.c
> @@ -825,10 +825,8 @@ static int bch_dirty_init_thread(void *arg)
>  	struct btree_iter iter;
>  	struct bkey *k, *p;
>  	int cur_idx, prev_idx, skip_nr;
> -	int i;
>  
>  	k = p = NULL;
> -	i = 0;
>  	cur_idx = prev_idx = 0;
>  
>  	bch_btree_iter_init(&c->root->keys, &iter, NULL);
> 
