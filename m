From: Slava Pestov <sp@datera.io>
Subject: Re: How to invalidate all cache
Date: Sun, 12 Oct 2014 20:16:31 -0700
Message-ID: <CACHGV4Jn3ML=2PO9FtoT4OXZCtpt56bOb=TmnVanv7Tm2MJyDg@mail.gmail.com>
References: <20141013030351.GA12742@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-bcache-owner@vger.kernel.org>
Received: from mail-lb0-f170.google.com ([209.85.217.170]:56127 "EHLO
	mail-lb0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752626AbaJMDQe (ORCPT
	<rfc822;linux-bcache@vger.kernel.org>);
	Sun, 12 Oct 2014 23:16:34 -0400
Received: by mail-lb0-f170.google.com with SMTP id u10so5766624lbd.29
        for <linux-bcache@vger.kernel.org>; Sun, 12 Oct 2014 20:16:32 -0700 (PDT)
In-Reply-To: <20141013030351.GA12742@gmail.com>
Sender: linux-bcache-owner@vger.kernel.org
List-Id: linux-bcache@vger.kernel.org
To: Zheng Liu <gnehzuil.liu@gmail.com>
Cc: linux-bcache@vger.kernel.org, Zheng Liu <wenqing.lz@taobao.com>

You can try to detach the backing device, which will cause all dirty
data to be written back, and attach it again.

On Sun, Oct 12, 2014 at 8:03 PM, Zheng Liu <gnehzuil.liu@gmail.com> wrote:
> Hi all,
>
> I am trying to do some benchmarks against bcache, espeically in cache
> miss scenario, but I don't find a user interface to invalidate all
> cache.  Anyone can tell me how to do that.
>
> Thanks in advance,
>                                                 - Zheng
> --
> To unsubscribe from this list: send the line "unsubscribe linux-bcache" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
