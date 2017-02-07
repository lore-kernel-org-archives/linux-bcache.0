From: "marcin@mejor.pl" <marcin@mejor.pl>
Subject: =?UTF-8?Q?Re:_[bcachefs]_./include/asm-generic/bug.h:55:35:_warning?=
 =?UTF-8?Q?:_=e2=80=98l=5fpacked=e2=80=99_may_be_used_uninitialized_in_this_?=
 =?UTF-8?Q?function?=
Date: Tue, 7 Feb 2017 14:52:25 +0100
Message-ID: <43b46755-17a1-1d0a-d719-36c8df587cb6@mejor.pl>
References: <eebbd36b-103f-3425-eef5-437b5ce2999b@mejor.pl>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Return-path: <linux-bcache-owner@vger.kernel.org>
Received: from jowisz.mejor.pl ([81.4.120.72]:41998 "EHLO jowisz.mejor.pl"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1754088AbdBGNxC (ORCPT <rfc822;linux-bcache@vger.kernel.org>);
        Tue, 7 Feb 2017 08:53:02 -0500
In-Reply-To: <eebbd36b-103f-3425-eef5-437b5ce2999b@mejor.pl>
Sender: linux-bcache-owner@vger.kernel.org
List-Id: linux-bcache@vger.kernel.org
To: linux-bcache@vger.kernel.org

W dniu 03.02.2017 o 15:14, marcin@mejor.pl pisze:
> Hi,
> could it be a real problem?
> 
>>   CC      drivers/md/bcache/btree_io.o
>> In file included from ./arch/x86/include/asm/bug.h:35:0,
>>                  from ./include/linux/bug.h:4,
>>                  from drivers/md/bcache/bcache.h:181,
>>                  from drivers/md/bcache/btree_io.c:2:
>> drivers/md/bcache/btree_io.c: In function ‘sort_extent_whiteouts’:
>> ./include/asm-generic/bug.h:55:35: warning: ‘l_packed’ may be used uninitialized in this function [-Wmaybe-uninitialized]
>>  #define BUG_ON(condition) do { if (unlikely(condition)) BUG(); } while (0)
>>                                    ^
>> drivers/md/bcache/btree_io.c:203:21: note: ‘l_packed’ was declared here
>>   bool prev = false, l_packed;
>>                      ^
>>   CC      drivers/md/bcache/btree_iter.o


Fixed in 44591aeaf65.
