From: Gabriel de Perthuis <g2p.code-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: Can't enable writeback
Date: Sat, 17 Aug 2013 12:56:58 +0000 (UTC)
Message-ID: <kunruq$541$1@ger.gmane.org>
References: <520F65C8.8050301@internode.on.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Return-path: <linux-bcache-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-bcache-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-bcache-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-bcache@vger.kernel.org

> I try to enable writeback:
> 
>    sudo echo writeback > /sys/block/bcache0/cache_mode
> 
> it returns the error
> 
>    bash: /sys/block/bcache0/cache_mode: No such file or directory

You're confusing bcache0 with bcache0/bcache

    echo writeback |sudo tee -a /sys/block/bcache0/bcache/cache_mode

will work.
