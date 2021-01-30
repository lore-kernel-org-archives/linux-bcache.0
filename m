Return-Path: <linux-bcache-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E35B7C433E6
	for <linux-bcache@archiver.kernel.org>; Sat, 30 Jan 2021 19:06:58 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B387160234
	for <linux-bcache@archiver.kernel.org>; Sat, 30 Jan 2021 19:06:58 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232210AbhA3TGo (ORCPT <rfc822;linux-bcache@archiver.kernel.org>);
        Sat, 30 Jan 2021 14:06:44 -0500
Received: from smtprelay0077.hostedemail.com ([216.40.44.77]:42408 "EHLO
        smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S229990AbhA3TGn (ORCPT
        <rfc822;linux-bcache@vger.kernel.org>);
        Sat, 30 Jan 2021 14:06:43 -0500
X-Greylist: delayed 388 seconds by postgrey-1.27 at vger.kernel.org; Sat, 30 Jan 2021 14:06:43 EST
Received: from smtprelay.hostedemail.com (10.5.19.251.rfc1918.com [10.5.19.251])
        by smtpgrave08.hostedemail.com (Postfix) with ESMTP id 89594182D4575
        for <linux-bcache@vger.kernel.org>; Sat, 30 Jan 2021 19:00:15 +0000 (UTC)
Received: from filter.hostedemail.com (clb03-v110.bra.tucows.net [216.40.38.60])
        by smtprelay02.hostedemail.com (Postfix) with ESMTP id 86FC9173085F;
        Sat, 30 Jan 2021 18:59:33 +0000 (UTC)
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-HE-Tag: hook93_0608dc9275b3
X-Filterd-Recvd-Size: 2897
Received: from [192.168.1.159] (unknown [47.151.137.21])
        (Authenticated sender: joe@perches.com)
        by omf03.hostedemail.com (Postfix) with ESMTPA;
        Sat, 30 Jan 2021 18:59:32 +0000 (UTC)
Message-ID: <14e1e776ceac5d4e84675bc70532aa30530eb8ec.camel@perches.com>
Subject: Re: [PATCH 13/29] bcache: Avoid comma separated statements
From:   Joe Perches <joe@perches.com>
To:     Jiri Kosina <trivial@kernel.org>, Coly Li <colyli@suse.de>,
        Kent Overstreet <kent.overstreet@gmail.com>
Cc:     linux-bcache@vger.kernel.org, linux-kernel@vger.kernel.org
Date:   Sat, 30 Jan 2021 10:59:31 -0800
In-Reply-To: <99ba798329f7d957e75a22c8551e8bd22f70c626.1598331149.git.joe@perches.com>
References: <cover.1598331148.git.joe@perches.com>
         <99ba798329f7d957e75a22c8551e8bd22f70c626.1598331149.git.joe@perches.com>
Content-Type: text/plain; charset="ISO-8859-1"
User-Agent: Evolution 3.38.1-1 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-bcache.vger.kernel.org>
X-Mailing-List: linux-bcache@vger.kernel.org

On Mon, 2020-08-24 at 21:56 -0700, Joe Perches wrote:
> Use semicolons and braces.

ping?

> Signed-off-by: Joe Perches <joe@perches.com>
> ---
>  drivers/md/bcache/bset.c  | 12 ++++++++----
>  drivers/md/bcache/sysfs.c |  6 ++++--
>  2 files changed, 12 insertions(+), 6 deletions(-)
> 
> diff --git a/drivers/md/bcache/bset.c b/drivers/md/bcache/bset.c
> index 67a2c47f4201..94d38e8a59b3 100644
> --- a/drivers/md/bcache/bset.c
> +++ b/drivers/md/bcache/bset.c
> @@ -712,8 +712,10 @@ void bch_bset_build_written_tree(struct btree_keys *b)
>  	for (j = inorder_next(0, t->size);
>  	     j;
>  	     j = inorder_next(j, t->size)) {
> -		while (bkey_to_cacheline(t, k) < cacheline)
> -			prev = k, k = bkey_next(k);
> +		while (bkey_to_cacheline(t, k) < cacheline) {
> +			prev = k;
> +			k = bkey_next(k);
> +		}
>  
> 
>  		t->prev[j] = bkey_u64s(prev);
>  		t->tree[j].m = bkey_to_cacheline_offset(t, cacheline++, k);
> @@ -901,8 +903,10 @@ unsigned int bch_btree_insert_key(struct btree_keys *b, struct bkey *k,
>  	status = BTREE_INSERT_STATUS_INSERT;
>  
> 
>  	while (m != bset_bkey_last(i) &&
> -	       bkey_cmp(k, b->ops->is_extents ? &START_KEY(m) : m) > 0)
> -		prev = m, m = bkey_next(m);
> +	       bkey_cmp(k, b->ops->is_extents ? &START_KEY(m) : m) > 0) {
> +		prev = m;
> +		m = bkey_next(m);
> +	}
>  
> 
>  	/* prev is in the tree, if we merge we're done */
>  	status = BTREE_INSERT_STATUS_BACK_MERGE;
> diff --git a/drivers/md/bcache/sysfs.c b/drivers/md/bcache/sysfs.c
> index ac06c0bc3c0a..1878c5ee53b6 100644
> --- a/drivers/md/bcache/sysfs.c
> +++ b/drivers/md/bcache/sysfs.c
> @@ -1071,8 +1071,10 @@ SHOW(__bch_cache)
>  			--n;
>  
> 
>  		while (cached < p + n &&
> -		       *cached == BTREE_PRIO)
> -			cached++, n--;
> +		       *cached == BTREE_PRIO) {
> +			cached++;
> +			n--;
> +		}
>  
> 
>  		for (i = 0; i < n; i++)
>  			sum += INITIAL_PRIO - cached[i];


