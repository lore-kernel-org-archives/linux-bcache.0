From: Coly Li <colyli@suse.de>
Subject: Re: [PATCH][next] bcache: movinggc: Use struct_size() helper in
 kzalloc()
Date: Sat, 20 Jun 2020 22:17:20 +0800
Message-ID: <de0eb477-35a5-9849-55c5-1b782fc3cec3@suse.de>
References: <20200617223331.GA25794@embeddedor>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20200617223331.GA25794@embeddedor>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
To: "Gustavo A. R. Silva" <gustavoars@kernel.org>
Cc: Kent Overstreet <kent.overstreet@gmail.com>, linux-bcache@vger.kernel.org, linux-kernel@vger.kernel.org, "Gustavo A. R. Silva" <gustavo@embeddedor.com>
List-Id: linux-bcache@vger.kernel.org

On 2020/6/18 06:33, Gustavo A. R. Silva wrote:
> Make use of the struct_size() helper instead of an open-coded version
> in order to avoid any potential type mistakes.
> 
> This code was detected with the help of Coccinelle and, audited and
> fixed manually.
> 
> Signed-off-by: Gustavo A. R. Silva <gustavoars@kernel.org>

The patch looks good to me, and I assume you already test and verify the
change. I will add them in my for-test directory.

Thanks.

Coly Li

> ---
>  drivers/md/bcache/movinggc.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/md/bcache/movinggc.c b/drivers/md/bcache/movinggc.c
> index 7891fb512736..b7dd2d75f58c 100644
> --- a/drivers/md/bcache/movinggc.c
> +++ b/drivers/md/bcache/movinggc.c
> @@ -145,8 +145,8 @@ static void read_moving(struct cache_set *c)
>  			continue;
>  		}
>  
> -		io = kzalloc(sizeof(struct moving_io) + sizeof(struct bio_vec)
> -			     * DIV_ROUND_UP(KEY_SIZE(&w->key), PAGE_SECTORS),
> +		io = kzalloc(struct_size(io, bio.bio.bi_inline_vecs,
> +					 DIV_ROUND_UP(KEY_SIZE(&w->key), PAGE_SECTORS)),
>  			     GFP_KERNEL);
>  		if (!io)
>  			goto err;
> 
