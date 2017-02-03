From: "marcin@mejor.pl" <marcin@mejor.pl>
Subject: =?UTF-8?Q?[bcachefs]_./include/asm-generic/bug.h:55:35:_warning:_?=
 =?UTF-8?Q?=e2=80=98l=5fpacked=e2=80=99_may_be_used_uninitialized_in_this_fu?=
 =?UTF-8?Q?nction?=
Date: Fri, 3 Feb 2017 15:14:49 +0100
Message-ID: <eebbd36b-103f-3425-eef5-437b5ce2999b@mejor.pl>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Return-path: <linux-bcache-owner@vger.kernel.org>
Received: from jowisz.mejor.pl ([81.4.120.72]:42118 "EHLO jowisz.mejor.pl"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752169AbdBCOO5 (ORCPT <rfc822;linux-bcache@vger.kernel.org>);
        Fri, 3 Feb 2017 09:14:57 -0500
Sender: linux-bcache-owner@vger.kernel.org
List-Id: linux-bcache@vger.kernel.org
To: linux-bcache@vger.kernel.org

Hi,
could it be a real problem?

>   CC      drivers/md/bcache/btree_io.o
> In file included from ./arch/x86/include/asm/bug.h:35:0,
>                  from ./include/linux/bug.h:4,
>                  from drivers/md/bcache/bcache.h:181,
>                  from drivers/md/bcache/btree_io.c:2:
> drivers/md/bcache/btree_io.c: In function ‘sort_extent_whiteouts’:
> ./include/asm-generic/bug.h:55:35: warning: ‘l_packed’ may be used uninitialized in this function [-Wmaybe-uninitialized]
>  #define BUG_ON(condition) do { if (unlikely(condition)) BUG(); } while (0)
>                                    ^
> drivers/md/bcache/btree_io.c:203:21: note: ‘l_packed’ was declared here
>   bool prev = false, l_packed;
>                      ^
>   CC      drivers/md/bcache/btree_iter.o
