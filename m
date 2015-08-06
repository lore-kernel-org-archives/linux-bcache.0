From: Ming Lin <mlin@kernel.org>
Subject: Re: [ANNOUNCE] bcachefs!
Date: Thu, 6 Aug 2015 16:27:51 -0700
Message-ID: <CAF1ivSa3RCaydtMWPGyuVo=+wR+siF_5x1sPUsCL6DiDS+7yhA@mail.gmail.com>
References: <20150717234023.GB4166@kmo-pixel>
	<1437176911.9298.0.camel@ssi>
	<20150717235133.GC4166@kmo-pixel>
	<1437177497.9298.3.camel@ssi>
	<20150718021007.GA3196@kmo-pixel>
	<1437196863.4737.2.camel@hasee>
	<CAF1ivSaqGRWruh8mePvFaKC9CSQB8xW7aAe872dao6J34v6iFg@mail.gmail.com>
	<20150724191557.GA1928@kmo-pixel>
	<1437770866.21988.16.camel@ssi>
	<CAF1ivSZhj2WuafP0yFey47OyAhjF7-Sznnb1WBXA+Hm5Rem31Q@mail.gmail.com>
	<20150806225834.GA2459@kmo-pixel>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-bcache-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.136]:42762 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751902AbbHFX1y (ORCPT <rfc822;linux-bcache@vger.kernel.org>);
	Thu, 6 Aug 2015 19:27:54 -0400
Received: from mail.kernel.org (localhost [127.0.0.1])
	by mail.kernel.org (Postfix) with ESMTP id 43AEE206A6
	for <linux-bcache@vger.kernel.org>; Thu,  6 Aug 2015 23:27:53 +0000 (UTC)
Received: from mail-vk0-f53.google.com (mail-vk0-f53.google.com [209.85.213.53])
	(using TLSv1.2 with cipher AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPSA id 3EF47206A0
	for <linux-bcache@vger.kernel.org>; Thu,  6 Aug 2015 23:27:52 +0000 (UTC)
Received: by vkfx1 with SMTP id x1so4261125vkf.0
        for <linux-bcache@vger.kernel.org>; Thu, 06 Aug 2015 16:27:51 -0700 (PDT)
In-Reply-To: <20150806225834.GA2459@kmo-pixel>
Sender: linux-bcache-owner@vger.kernel.org
List-Id: linux-bcache@vger.kernel.org
To: Kent Overstreet <kent.overstreet@gmail.com>
Cc: "linux-bcache@vger.kernel.org" <linux-bcache@vger.kernel.org>

On Thu, Aug 6, 2015 at 3:58 PM, Kent Overstreet
<kent.overstreet@gmail.com> wrote:
> On Tue, Jul 28, 2015 at 11:41:52AM -0700, Ming Lin wrote:
>> On Fri, Jul 24, 2015 at 1:47 PM, Ming Lin <mlin@kernel.org> wrote:
>> >
>> > And I want to learn how the btree node insert/delete/update happens on
>> > disk. These maybe too detail. I'm going to write a small tool to dump
>> > the file system. Then I could understand better the on disk btree
>> > format.
>>
>> Here is my simple tool to dump parts of the on-disk format.
>> http://www.minggr.net/cgit/cgit.cgi/bcache-tools/commit/?id=deb258e2
>>
>> It's not in good shape, but simple enough to learn the on-disk format.
>
> Hey! Sorry for taking so long to respond, just got my computer set up back in
> Alaska.
>
> If you want to keep going with your tool, this might be a starting point for a
> debugfs tool - which bcache definitely needs at some point.

Yes, that's my goal.
I'll improve it once I get more familiar with bcachefs on-disk format.
