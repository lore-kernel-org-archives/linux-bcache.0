From: Kent Overstreet <kmo@daterainc.com>
Subject: Re: [PATCH 3/3] bcache: Fix the bug about cal nr_stripes of backed
 device
Date: Wed, 8 Jan 2014 13:37:00 -0800
Message-ID: <20140108213700.GH7291@kmo-pixel>
References: <201401081939244995495@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-bcache-owner@vger.kernel.org>
Received: from mail-pd0-f182.google.com ([209.85.192.182]:52359 "EHLO
	mail-pd0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757754AbaAHVfn (ORCPT
	<rfc822;linux-bcache@vger.kernel.org>);
	Wed, 8 Jan 2014 16:35:43 -0500
Received: by mail-pd0-f182.google.com with SMTP id v10so2280027pde.41
        for <linux-bcache@vger.kernel.org>; Wed, 08 Jan 2014 13:35:43 -0800 (PST)
Content-Disposition: inline
In-Reply-To: <201401081939244995495@gmail.com>
Sender: linux-bcache-owner@vger.kernel.org
List-Id: linux-bcache@vger.kernel.org
To: majianpeng <majianpeng@gmail.com>
Cc: linux-bcache <linux-bcache@vger.kernel.org>

On Wed, Jan 08, 2014 at 07:39:28PM +0800, majianpeng wrote:
> In func bcache_device_init(),it use this expression to cal nr_stripes:
> "d->nr_stripes = DIV_ROUND_UP_ULL(sectors, d->stripe_size)".
> But the unit of d->stripe_size is byte,the unit os sectors is sector.
> So we should replace sectors with "secotrs << 9".

Nope, d->stripe_size is definitely sectors.
