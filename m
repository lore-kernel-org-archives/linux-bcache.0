Received: from sg-3-42.ptr.tlmpb.com (sg-3-42.ptr.tlmpb.com [101.45.255.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7AD99384244
	for <linux-bcache@vger.kernel.org>; Mon, 25 May 2026 13:54:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=101.45.255.42
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779717278; cv=none; b=d73Rmth3iY8C/PZjXV9Fnr6HHxjxUHvCPuyNlPRISsz9H2TEBqf9FIngas05gIooFnUIbeHu4ZFmI1R7pO4o69tptNKtbyEDcjStYfqPNQtoiNvKRipAevm+fR9/PFx5HeRAwfyLsxKMuZqSYRAo8SxfJlRJi5s7oKCCyILeQm4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779717278; c=relaxed/simple;
	bh=nBdsatoQEXUjyQAL+V7TVwCB5cVfGMxySQi7OkB9y8k=;
	h=To:Subject:Date:In-Reply-To:Cc:Message-Id:Content-Type:From:
	 References:Mime-Version:Content-Disposition; b=mbH2K+4iZ42ED506Vr5TBMxg/yZ3D/IYBPa9YneWxMLm8VTR2OR2EDARi2A0ycJJQ7y0884Ayz/702yquEw6mJAY6ys70elXEYxuC9pwZ6bPXQMgs9+HAg0k2YZT+zJdjJmwoG5pBZpecENURih7btVGZ0FCOpHtRuNCMAhrWU0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fygo.io; spf=pass smtp.mailfrom=fygo.io; dkim=pass (2048-bit key) header.d=fygo-io.20200929.dkim.larksuite.com header.i=@fygo-io.20200929.dkim.larksuite.com header.b=e+bptk0x; arc=none smtp.client-ip=101.45.255.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fygo.io
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=fygo.io
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=fygo-io.20200929.dkim.larksuite.com header.i=@fygo-io.20200929.dkim.larksuite.com header.b="e+bptk0x"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
 s=s1; d=fygo-io.20200929.dkim.larksuite.com; t=1779716507;
  h=from:subject:mime-version:from:date:message-id:subject:to:cc:
 reply-to:content-type:mime-version:in-reply-to:message-id;
 bh=d0rhPK4qQ9astzIWbJW8jzOno1xfkj/iyWRJMLfNGCQ=;
 b=e+bptk0xdWMdmYNAxObl268EtQrQ/ZQnSNmKJcybk0KfvGoT+XvrhUmDcZIhLylyAbGDWy
 dENzklhGP7wTtuGsPiJTmxBvtGye1Ih0nGLikCtAA1aPZNFP5PQAJMbqWL62AedtLtGZcO
 QHGbPR/SF946yAiMGoViKS4EuYXDIw5m67y9wBETnnhi+lcgPLYjE9kAaUjTcrQ5yE6U46
 aiLX50CH79WUIbinohOM/sUTdVPL4nAXgM0Li3vDHMm3nFZUdoFJ2wJTJjgNoanqTRxTxw
 U4VWRJE56vHQqLXN4P32YmmKBJnOBR78oH+CCY7aXIJ7yyA1FyZy5xNSeZE/XQ==
To: "Ankit Kapoor" <ankitkap@google.com>
Subject: Re: [PATCH 1/1] bcache: fix stale data race between read cache miss and bypass write
Date: Mon, 25 May 2026 21:41:43 +0800
X-Original-From: Coly Li <colyli@fygo.io>
In-Reply-To: <20260521163925.178264-2-ankitkap@google.com>
Cc: "Kent Overstreet" <kent.overstreet@linux.dev>, 
	<linux-bcache@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Message-Id: <ahRNUlU60mx9ESd1@studio.local>
Content-Type: text/plain; charset=UTF-8
X-Lms-Return-Path: <lba+26a14519a+03031c+vger.kernel.org+colyli@fygo.io>
Content-Transfer-Encoding: 7bit
From: "Coly Li" <colyli@fygo.io>
Received: from studio.local ([120.245.64.106]) by smtp.larksuite.com with ESMTPS; Mon, 25 May 2026 13:41:46 +0000
References: <20260521163925.178264-1-ankitkap@google.com> <20260521163925.178264-2-ankitkap@google.com>
Precedence: bulk
X-Mailing-List: linux-bcache@vger.kernel.org
List-Id: <linux-bcache.vger.kernel.org>
List-Subscribe: <mailto:linux-bcache+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcache+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
Content-Disposition: inline

Hi Ankit,

Yes, I confirm this is an issue that must be solved. Nice catch!

On Thu, May 21, 2026 at 04:39:25PM +0800, Ankit Kapoor wrote:
> A race condition exists between a read cache miss and a bypass write
> due to either congestion or sequential bypass, that causes stale data
> to be cached when the read cache miss runs concurrently with a bypass
> write targeting the same sectors. If the read cache miss fetches data
> from the backing device before the write to the backing device,
> stale data populates the cache.
> 
> The root cause is that bcache currently executes btree key
> invalidation in parallel with (or prior to) writing the actual data
> payload to the backing device. Under this sequence, a concurrent
> read path can register a cache miss and insert a placeholder key.
> If the write's btree key invalidation completes before the read finishes
> fetching old data from the backing device, the read's subsequent
> key replacement will not detect a collision, allowing stale data
> to persist in the cache.
> 
> Fix this by deferring the btree key invalidation until after the
> backing device write completes successfully. Enforcing this
> sequential execution ensures that a stale read is always detected
> and invalidated.
>

This patch fixes the stale data issue in run time, but if power failure
happens inside the race window, after boot up again, the stale data
still exists in cache for following read hits.

And your fix invalidate the key after on-disk bio completed, which makes
such stale data window by power failure longer.
 
To solve all the stale data race both for run time and power failure
condition, could you please consider the following proposal.

Maintain a data structure to hold all invalidate range from by-pass
write, record/insert the invalidation range before bch_data_insert(),
and after cached_dev_write_complete(), clear/remove the invalidation
range.

For a cache-miss read, if there is any invalidation range refcount
exists, check all non-zero refcount ranges, if any range overlaps with
the cache-miss read range, do NOT update the missing bkey back to btree
and only read data from backing device.

Here you need to design a efficient data structure both for performance
and memory consumption. I would sugguest to maintain chunk refcounts
which mapping multiple 32MB ranges on cache device (current max key size
if I remember correctly) range. You may look at how md raid maintains
the legacy bitmap refcount, hope that code can give you any hint.

Finally thank you for report this issue, nick catch!

Coly Li


> Signed-off-by: Ankit Kapoor <ankitkap@google.com>
> ---
>  drivers/md/bcache/request.c | 13 +++++++++++++
>  1 file changed, 13 insertions(+)
> 
> diff --git a/drivers/md/bcache/request.c b/drivers/md/bcache/request.c
> index af345dc6fde1..ef2cf55df3bb 100644
> --- a/drivers/md/bcache/request.c
> +++ b/drivers/md/bcache/request.c
> @@ -978,6 +978,14 @@ static CLOSURE_CALLBACK(cached_dev_write_complete)
>  	cached_dev_bio_complete(&cl->work);
>  }
>  
> +static CLOSURE_CALLBACK(backing_device_bypass_write_complete)
> +{
> +	closure_type(s, struct search, cl);
> +
> +	closure_call(&s->iop.cl, bch_data_insert, NULL, cl);
> +	continue_at(cl, cached_dev_write_complete, NULL);
> +}
> +
>  static void cached_dev_write(struct cached_dev *dc, struct search *s)
>  {
>  	struct closure *cl = &s->cl;
> @@ -1058,6 +1066,11 @@ static void cached_dev_write(struct cached_dev *dc, struct search *s)
>  	}
>  
>  insert_data:
> +	if (s->iop.bypass) {
> +		continue_at(cl, backing_device_bypass_write_complete, NULL);
> +		return;
> +	}
> +
>  	closure_call(&s->iop.cl, bch_data_insert, NULL, cl);
>  	continue_at(cl, cached_dev_write_complete, NULL);
>  }
> -- 
> 2.54.0.669.g59709faab0-goog
