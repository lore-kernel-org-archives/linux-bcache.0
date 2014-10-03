From: Slava Pestov <sp@datera.io>
Subject: Re: can't attach
Date: Fri, 3 Oct 2014 13:37:15 -0700
Message-ID: <CACHGV4+T0fc3Na=6yrne+NxW+wzd=mxSUqYWGscpuBZwSc9q9g@mail.gmail.com>
References: <542F0547.3060805@hardwarefreak.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-bcache-owner@vger.kernel.org>
Received: from mail-la0-f52.google.com ([209.85.215.52]:38871 "EHLO
	mail-la0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750750AbaJCUhR (ORCPT
	<rfc822;linux-bcache@vger.kernel.org>);
	Fri, 3 Oct 2014 16:37:17 -0400
Received: by mail-la0-f52.google.com with SMTP id hz20so1702027lab.39
        for <linux-bcache@vger.kernel.org>; Fri, 03 Oct 2014 13:37:15 -0700 (PDT)
In-Reply-To: <542F0547.3060805@hardwarefreak.com>
Sender: linux-bcache-owner@vger.kernel.org
List-Id: linux-bcache@vger.kernel.org
To: Stan Hoeppner <stan@hardwarefreak.com>
Cc: linux-bcache@vger.kernel.org

Please include any bcache messages printed in dmesg when this happens.

On Fri, Oct 3, 2014 at 1:21 PM, Stan Hoeppner <stan@hardwarefreak.com> wrote:
> # ls -la /sys/fs/bcache
> total 0
> drwxr-xr-x 3 root root    0 Oct  3 14:39 .
> drwxr-xr-x 6 root root    0 Oct  2 16:32 ..
> drwxr-xr-x 7 root root    0 Oct  3 14:50 8246b830-95d4-420d-aff8-894efc348801
> --w------- 1 root root 4096 Oct  3 14:39 register
> --w------- 1 root root 4096 Oct  3 14:50 register_quiet
>
>
> # echo 8246b830-95d4-420d-aff8-894efc348801 > /sys/block/bcache0/bcache/attach
> bash: echo: write error: Invalid argument
>
>
> What's the problem here?
>
> Thanks,
> Stan
> --
> To unsubscribe from this list: send the line "unsubscribe linux-bcache" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
