From: Ming Lin <mlin@kernel.org>
Subject: Re: [ANNOUNCE] bcachefs!
Date: Tue, 21 Jul 2015 22:15:38 -0700
Message-ID: <CAF1ivSYAGNRqjPPQdUUj4ESbb_=cYcCxqz0SAmffEzFTbM=K5A@mail.gmail.com>
References: <1436940689.6520.1.camel@hasee>
	<CAC7rs0sbg2ci6=niQ0X11AONZbr2AOYhRbxfDH_w4N4A7dyPLw@mail.gmail.com>
	<1436944556.6520.5.camel@hasee>
	<CAF1ivSa4bZaw2w9nu1tQeYx7JBb2_fVDV67Le=ybC2m8OdX3gg@mail.gmail.com>
	<20150717231700.GA4166@kmo-pixel>
	<1437176155.9009.0.camel@ssi>
	<20150717234023.GB4166@kmo-pixel>
	<1437176911.9298.0.camel@ssi>
	<20150717235133.GC4166@kmo-pixel>
	<1437177497.9298.3.camel@ssi>
	<20150718021007.GA3196@kmo-pixel>
	<1437196863.4737.2.camel@hasee>
	<CAF1ivSaqGRWruh8mePvFaKC9CSQB8xW7aAe872dao6J34v6iFg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-bcache-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.136]:41285 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750934AbbGVFPk (ORCPT <rfc822;linux-bcache@vger.kernel.org>);
	Wed, 22 Jul 2015 01:15:40 -0400
Received: from mail.kernel.org (localhost [127.0.0.1])
	by mail.kernel.org (Postfix) with ESMTP id CA2D2206EA
	for <linux-bcache@vger.kernel.org>; Wed, 22 Jul 2015 05:15:39 +0000 (UTC)
Received: from mail-ob0-f178.google.com (mail-ob0-f178.google.com [209.85.214.178])
	(using TLSv1.2 with cipher AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPSA id DFF0F206E7
	for <linux-bcache@vger.kernel.org>; Wed, 22 Jul 2015 05:15:38 +0000 (UTC)
Received: by obre1 with SMTP id e1so128246173obr.1
        for <linux-bcache@vger.kernel.org>; Tue, 21 Jul 2015 22:15:38 -0700 (PDT)
In-Reply-To: <CAF1ivSaqGRWruh8mePvFaKC9CSQB8xW7aAe872dao6J34v6iFg@mail.gmail.com>
Sender: linux-bcache-owner@vger.kernel.org
List-Id: linux-bcache@vger.kernel.org
To: Kent Overstreet <kent.overstreet@gmail.com>
Cc: "linux-bcache@vger.kernel.org" <linux-bcache@vger.kernel.org>

On Tue, Jul 21, 2015 at 10:11 PM, Ming Lin <mlin@kernel.org> wrote:
> On Fri, Jul 17, 2015 at 10:21 PM, Ming Lin <mlin@kernel.org> wrote:
>> On Fri, 2015-07-17 at 19:10 -0700, Kent Overstreet wrote:
>>> BTW - probably the most valuable thing you could help out with is the
>>> documentation, in particular the guide:
>>> http://bcache.evilpiepirate.org/BcacheGuide/
>>>
>>> Can you read through (at least some of) that, and tell me what's useful and what
>>> needs clarifying? And tell me what you'd like to see added to the guide next -
>>> I'll try and work on documentation over the next two weeks, since I probably
>>> won't be able to do much real coding with my test machines offline.
>>
>> Yes, I'll read through that.
>
> Would you add some example to explain how the extents/inodes/dirents are stored
> in the btree on disk?
>
> I'm reading the debug code in drivers/md/bcache/debug.c.
> It seems helpful to learn about the internal btree structure.

For whom interested:

"cat" these files to dump the btree.

root@bee:/sys/kernel/debug/bcache/07170fb5-b9bd-4f44-a7e3-c657a367a960# ls
dirents  dirents-formats  extents  extents-formats  inodes
inodes-formats  xattrs  xattrs-formats
