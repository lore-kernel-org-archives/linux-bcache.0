From: Gabriel de Perthuis <g2p.code-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH] bcache: register_quiet should still report errors
Date: Tue, 27 Aug 2013 00:37:18 +0200
Message-ID: <521BD89E.1010703@gmail.com>
References: <521BD3C0.9070209@gmail.com> <1377556306-29938-1-git-send-email-g2p.code@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-bcache-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1377556306-29938-1-git-send-email-g2p.code-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Sender: linux-bcache-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Kent Overstreet <kmo-PEzghdH756F8UrSeD/g0lQ@public.gmane.org>
Cc: linux-bcache-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-bcache@vger.kernel.org

> register_quiet should still report all errors except
> "device already registered".
>
> Before this some potential errors would be silenced.

This can replace my other patch in this thread.
Switching /lib/udev/bcache-register to register_quiet
without this kernel patch will suppress the aforementioned errors,
but they probably aren't too common so we can live with it.
