From: Coly Li <i@coly.li>
Subject: Re: [PATCH v2 1/4] Leave choosing level of optimalization and linker
 flags to package maintainer.
Date: Tue, 13 Sep 2016 23:33:56 +0800
Message-ID: <2e44ce83-ec49-5bf0-5751-32d73755457e@coly.li>
References: <1473764144-18993-1-git-send-email-marcin@mejor.pl>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Return-path: <linux-bcache-owner@vger.kernel.org>
Received: from server.coly.li ([162.144.45.48]:59578 "EHLO server.coly.li"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1755177AbcIMPeH (ORCPT <rfc822;linux-bcache@vger.kernel.org>);
        Tue, 13 Sep 2016 11:34:07 -0400
In-Reply-To: <1473764144-18993-1-git-send-email-marcin@mejor.pl>
Sender: linux-bcache-owner@vger.kernel.org
List-Id: linux-bcache@vger.kernel.org
To: =?UTF-8?Q?Marcin_Miros=c5=82aw?= <marcin@mejor.pl>, linux-bcache@vger.kernel.org

在 16/9/13 下午6:55, Marcin Mirosław 写道:
> Currently is adding "-static" to linker flags. This needs compiling a couple of dependent libraries to get static
> version of it. It is a little problematic, at least on Gentoo. Also static binary isn't needed for typical usage, if
> somebody need it then it's easy to add "-static" to env variable LDFLAGS and get static binary.
> Similar to CFLAGS, it's easier to add "-g" to CFLAGS than negating it by using "-g0".
>

Hi Marcin,

Do you mean bcache-tools/Makefile ? I can see '-g', but for '-static' I
don't see it.

I clone the code from https://github.com/g2p/bcache-tools.git, or should
I look at other code ?


Coly

> Signed-off-by: Marcin Mirosław <marcin@mejor.pl>
> ---
>  Makefile | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/Makefile b/Makefile
> index 9f2773e..e9ca92d 100644
> --- a/Makefile
> +++ b/Makefile
> @@ -1,8 +1,8 @@
>  
>  PREFIX=/usr
>  INSTALL=install
> -CFLAGS+=-std=gnu99 -O2 -Wall -g -D_FILE_OFFSET_BITS=64 -I.
> -LDFLAGS+=-static
> +CFLAGS:=-std=gnu99 -O2 -Wall -D_FILE_OFFSET_BITS=64 -I. $(CFLAGS)
> +LDFLAGS+=
>  
>  PKGCONFIG_LIBS="blkid uuid libnih"
>  CFLAGS+=`pkg-config --cflags	${PKGCONFIG_LIBS}`
> 


-- 
Coly Li
