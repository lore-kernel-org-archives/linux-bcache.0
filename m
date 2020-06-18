From: Coly Li <colyli@suse.de>
Subject: Re: [PATCH][next] bcache: Use struct_size() in kzalloc()
Date: Thu, 18 Jun 2020 13:38:08 +0800
Message-ID: <1c6adee3-bbad-dc88-3dd2-af823f279271@suse.de>
References: <20200617222733.GA24156@embeddedor>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Return-path: <linux-bcache-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:38010 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725837AbgFRFi5 (ORCPT <rfc822;linux-bcache@vger.kernel.org>);
        Thu, 18 Jun 2020 01:38:57 -0400
In-Reply-To: <20200617222733.GA24156@embeddedor>
Content-Language: en-US
Sender: linux-bcache-owner@vger.kernel.org
List-Id: linux-bcache@vger.kernel.org
To: "Gustavo A. R. Silva" <gustavoars@kernel.org>
Cc: Kent Overstreet <kent.overstreet@gmail.com>, linux-bcache@vger.kernel.org, linux-kernel@vger.kernel.org, "Gustavo A. R. Silva" <gustavo@embeddedor.com>

On 2020/6/18 06:27, Gustavo A. R. Silva wrote:
> Make use of the struct_size() helper instead of an open-coded version
> in order to avoid any potential type mistakes.
> 
> This code was detected with the help of Coccinelle and, audited and
> fixed manually.
> 
> Signed-off-by: Gustavo A. R. Silva <gustavoars@kernel.org> ---
>  drivers/md/bcache/writeback.c | 6 ++----
>  1 file changed, 2 insertions(+), 4 deletions(-)
> 
> diff --git a/drivers/md/bcache/writeback.c b/drivers/md/bcache/writeback.c
> index 1cf1e5016cb9..c0db3c860179 100644
> --- a/drivers/md/bcache/writeback.c
> +++ b/drivers/md/bcache/writeback.c
> @@ -459,10 +459,8 @@ static void read_dirty(struct cached_dev *dc)
>  		for (i = 0; i < nk; i++) {
>  			w = keys[i];
>  
> -			io = kzalloc(sizeof(struct dirty_io) +
> -				     sizeof(struct bio_vec) *
> -				     DIV_ROUND_UP(KEY_SIZE(&w->key),
> -						  PAGE_SECTORS),
> +			io = kzalloc(struct_size(io, bio.bi_inline_vecs,
                                                     ^^^^^^^^^^^^^^^^^^
                                                     I like this :-)

> +						DIV_ROUND_UP(KEY_SIZE(&w->key), PAGE_SECTORS)),

The above line seems too long for 80 characters limitation. Does
checkpatch.pl complain for this ?


Thanks.

Coly Li


>  				     GFP_KERNEL);
>  			if (!io)
>  				goto err;
> 
