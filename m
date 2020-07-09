From: Coly Li <colyli@suse.de>
Subject: Re: [PATCH] bcache: writeback: Remove unneeded variable i
Date: Thu, 9 Jul 2020 14:04:52 +0800
Message-ID: <b4a983cd-a392-c1c9-85b3-3116d9a4fb73@suse.de>
References: <20200709055358.30237-1-vulab@iscas.ac.cn>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-bcache-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:54484 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726196AbgGIGFB (ORCPT <rfc822;linux-bcache@vger.kernel.org>);
        Thu, 9 Jul 2020 02:05:01 -0400
In-Reply-To: <20200709055358.30237-1-vulab@iscas.ac.cn>
Content-Language: en-US
Sender: linux-bcache-owner@vger.kernel.org
List-Id: linux-bcache@vger.kernel.org
To: Xu Wang <vulab@iscas.ac.cn>
Cc: kent.overstreet@gmail.com, linux-bcache@vger.kernel.org, linux-kernel@vger.kernel.org

On 2020/7/9 13:53, Xu Wang wrote:
> Remove unneeded variable i in bch_dirty_init_thread().
> 
> Signed-off-by: Xu Wang <vulab@iscas.ac.cn>

Add it into my testing queue. Thanks.

Coly Li

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
