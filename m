Received: from va-2-44.ptr.blmpb.com (va-2-44.ptr.blmpb.com [209.127.231.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1A82439A060
	for <linux-bcache@vger.kernel.org>; Fri,  9 Oct 2026 03:42:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.127.231.44
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791517339; cv=none; b=R87B6odPwLcWZFHrxcmgorIt/HDX9DiRT3SXX/SWIaq/wEN7Xu6ntreN1El11H5iK+oy+gW5ZiToxf6eg7smjoM15zoae2uKtwdaBub/ZGKyWjjbeN6cm5IeNSDcJqrzqSAv3gCNV+/wxEWRgzyuR6ejFEiWRPwjnBgNw5bXp5s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791517339; c=relaxed/simple;
	bh=7CZlaYYi20bf4bXAayhLqNmOcyVP5+xPb/OdHQiWcNw=;
	h=To:Message-Id:In-Reply-To:Cc:Subject:Mime-Version:References:
	 Content-Type:Content-Disposition:From:Date; b=VRxANga57pPPkTQm5AKpwnI44X4NDcovhqNBkwPfR0Oj7DMYo1UdIyjn5dAhGETX2rdsm/RDbf8IlPF8viaJU+GxvaYytyu7nkvZ4M1wOhcbxybQulTioJEas2RN8hxzEdAwe5mU/dUjmuG1s1is5f1ZomP7RtW8pvGz53SVSHY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fygo.io; spf=pass smtp.mailfrom=fygo.io; dkim=pass (2048-bit key) header.d=fygo-io.20200929.dkim.larksuite.com header.i=@fygo-io.20200929.dkim.larksuite.com header.b=mwTqWYC6; arc=none smtp.client-ip=209.127.231.44
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fygo.io
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=fygo.io
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=fygo-io.20200929.dkim.larksuite.com header.i=@fygo-io.20200929.dkim.larksuite.com header.b="mwTqWYC6"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
 s=s1; d=fygo-io.20200929.dkim.larksuite.com; t=1791517312;
  h=from:subject:mime-version:from:date:message-id:subject:to:cc:
 reply-to:content-type:mime-version:in-reply-to:message-id;
 bh=6H0xVcBGCyy0DRg50XBdWdXe14dnWjgOXxW73K88Do8=;
 b=mwTqWYC6Fa11Ovp3jkhTlOx5FtfQmkqP+NWCFMJI8dn2ucA9nwaZqEc1YU5WdfbWqsrNRf
 q0ztiSbH7EYtcc+16HT/hs2+kIQ+L4y2tmskI90/RpJwUhD4Fl+xmOcJZFMkcRvUri1oFT
 UlX5L22QOgDigqceGDPsU0oWG9+RJHo8JTuN12x0HXU3I0CtzwPpkoDbjJACaCV+7WppZf
 x4/Z1JJdxjg4EccaDU+bL2mhV23J91SXOhx5ASrQ0iIYnPckMGeJGl8sxkhF0Zd09MqYD6
 4EOHxiO4FOGmm7lFlGMwMxdrOO/8BdwX11UXJC1LsqoMcYiKuG74Gn9nIb4nGw==
Content-Transfer-Encoding: 7bit
To: "Rosen Penev" <rosenp@gmail.com>
Message-Id: <ashiQ98Qmie63mB2@studio.local>
X-Original-From: Coly Li <colyli@fygo.io>
In-Reply-To: <20261004233523.516891-1-rosenp@gmail.com>
Cc: <linux-bcache@vger.kernel.org>, 
	"Kent Overstreet" <kent.overstreet@linux.dev>, 
	"open list" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] bcache: fix kernel-doc warning on CLOSURE_CALLBACK
Precedence: bulk
X-Mailing-List: linux-bcache@vger.kernel.org
List-Id: <linux-bcache.vger.kernel.org>
List-Subscribe: <mailto:linux-bcache+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcache+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20261004233523.516891-1-rosenp@gmail.com>
Content-Type: text/plain; charset=UTF-8
Received: from studio.local ([120.245.64.82]) by smtp.larksuite.com with ESMTPS; Fri, 09 Oct 2026 03:41:51 +0000
Content-Disposition: inline
From: "Coly Li" <colyli@fygo.io>
Date: Fri, 9 Oct 2026 11:41:48 +0800
X-Lms-Return-Path: <lba+26ac86280+99828c+vger.kernel.org+colyli@fygo.io>

Hi Rosen,

On Sun, Oct 04, 2026 at 04:35:23PM +0800, Rosen Penev wrote:
> bch_data_insert() is defined through the CLOSURE_CALLBACK() macro, which
> kernel-doc cannot see through, so the kernel-doc comment above it
> produces:
> 
>   request.c:308 function parameter 'bch_data_insert' not described in 'CLOSURE_CALLBACK'
>   request.c:308 expecting prototype for bch_data_insert(). Prototype was for CLOSURE_CALLBACK() instead
> 
> Turn it into a regular block comment, and drop the @cl line along
> with the kernel-doc markup.
> 
> Assisted-by: LLM

The patch is fine to me. Can you provide the detailed LLM name here?

> Signed-off-by: Rosen Penev <rosenp@gmail.com>

Thanks.

Coly Li

> ---
>  drivers/md/bcache/request.c | 3 +--
>  1 file changed, 1 insertion(+), 2 deletions(-)
> 
> diff --git a/drivers/md/bcache/request.c b/drivers/md/bcache/request.c
> index 3fa3b13a410f..e7f097346d64 100644
> --- a/drivers/md/bcache/request.c
> +++ b/drivers/md/bcache/request.c
> @@ -285,9 +285,8 @@ static CLOSURE_CALLBACK(bch_data_insert_start)
>  	}
>  }
>  
> -/**
> +/*
>   * bch_data_insert - stick some data in the cache
> - * @cl: closure pointer.
>   *
>   * This is the starting point for any data to end up in a cache device; it could
>   * be from a normal write, or a writeback write, or a write to a flash only
> -- 
> 2.56.0
