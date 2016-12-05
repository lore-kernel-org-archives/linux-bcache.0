From: "marcin@mejor.pl" <marcin@mejor.pl>
Subject: =?UTF-8?Q?[branch:_bcachefs-performance]_./include/trace/trace=5fev?=
 =?UTF-8?Q?ents.h:327:27:_error:_expected_expression_before_=e2=80=98=29?=
 =?UTF-8?B?4oCZIHRva2Vu?=
Date: Mon, 5 Dec 2016 10:55:24 +0100
Message-ID: <ea208bad-525d-949d-2b01-337ec46f53ce@mejor.pl>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Return-path: <linux-bcache-owner@vger.kernel.org>
Received: from jowisz.mejor.pl ([81.4.120.72]:58834 "EHLO jowisz.mejor.pl"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752366AbcLEKCi (ORCPT <rfc822;linux-bcache@vger.kernel.org>);
        Mon, 5 Dec 2016 05:02:38 -0500
Sender: linux-bcache-owner@vger.kernel.org
List-Id: linux-bcache@vger.kernel.org
To: linux-bcache@vger.kernel.org

Hi!
I'm getting compilation error:
commit 1aae41c06651f0bffedba1a29a59afac3717d315


> In file included from ./include/trace/define_trace.h:95:0,
>                  from ./include/trace/events/bcache.h:1196,
>                  from drivers/md/bcache/trace.c:11:
> ./include/trace/events/bcache.h: In function ‘trace_raw_output_bcache_btree_bounce_block’:
> ./include/trace/trace_events.h:327:27: error: expected expression before ‘)’ token
>   trace_seq_printf(s, print);     \
>                            ^
> ./include/trace/trace_events.h:60:2: note: in expansion of macro ‘DECLARE_EVENT_CLASS’
>   DECLARE_EVENT_CLASS(name,          \
>   ^
> ./include/trace/events/bcache.h:494:1: note: in expansion of macro ‘TRACE_EVENT’
>  TRACE_EVENT(bcache_btree_bounce_block,
>  ^
> In file included from ./include/trace/define_trace.h:95:0,
>                  from ./include/trace/events/bcache.h:1196,
>                  from drivers/md/bcache/trace.c:11:
> ./include/trace/events/bcache.h: In function ‘trace_event_define_fields_bcache_btree_bounce_block’:
> ./include/trace/trace_events.h:418:32: warning: unused variable ‘field’ [-Wunused-variable]
>   struct trace_event_raw_##call field;    \
>                                 ^
> ./include/trace/trace_events.h:60:2: note: in expansion of macro ‘DECLARE_EVENT_CLASS’
>   DECLARE_EVENT_CLASS(name,          \
>   ^
> ./include/trace/events/bcache.h:494:1: note: in expansion of macro ‘TRACE_EVENT’
>  TRACE_EVENT(bcache_btree_bounce_block,
>  ^
> make[3]: *** [scripts/Makefile.build:290: drivers/md/bcache/trace.o] Błąd 1
> make[2]: *** [scripts/Makefile.build:440: drivers/md/bcache] Błąd 2
> make[1]: *** [scripts/Makefile.build:440: drivers/md] Błąd 2
> make: *** [Makefile:968: drivers] Błąd 2



gcc-5.4.0

Marcin
