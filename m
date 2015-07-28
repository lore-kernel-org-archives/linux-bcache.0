From: Ming Lin <mlin@kernel.org>
Subject: Re: [ANNOUNCE] bcachefs!
Date: Tue, 28 Jul 2015 11:41:52 -0700
Message-ID: <CAF1ivSZhj2WuafP0yFey47OyAhjF7-Sznnb1WBXA+Hm5Rem31Q@mail.gmail.com>
References: <CAF1ivSa4bZaw2w9nu1tQeYx7JBb2_fVDV67Le=ybC2m8OdX3gg@mail.gmail.com>
	<20150717231700.GA4166@kmo-pixel>
	<1437176155.9009.0.camel@ssi>
	<20150717234023.GB4166@kmo-pixel>
	<1437176911.9298.0.camel@ssi>
	<20150717235133.GC4166@kmo-pixel>
	<1437177497.9298.3.camel@ssi>
	<20150718021007.GA3196@kmo-pixel>
	<1437196863.4737.2.camel@hasee>
	<CAF1ivSaqGRWruh8mePvFaKC9CSQB8xW7aAe872dao6J34v6iFg@mail.gmail.com>
	<20150724191557.GA1928@kmo-pixel>
	<1437770866.21988.16.camel@ssi>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-bcache-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.136]:43688 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751998AbbG1Sl7 (ORCPT <rfc822;linux-bcache@vger.kernel.org>);
	Tue, 28 Jul 2015 14:41:59 -0400
Received: from mail.kernel.org (localhost [127.0.0.1])
	by mail.kernel.org (Postfix) with ESMTP id 493D820771
	for <linux-bcache@vger.kernel.org>; Tue, 28 Jul 2015 18:41:55 +0000 (UTC)
Received: from mail-vn0-f50.google.com (mail-vn0-f50.google.com [209.85.216.50])
	(using TLSv1.2 with cipher AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPSA id A992F2076F
	for <linux-bcache@vger.kernel.org>; Tue, 28 Jul 2015 18:41:53 +0000 (UTC)
Received: by vnav141 with SMTP id v141so46337267vna.0
        for <linux-bcache@vger.kernel.org>; Tue, 28 Jul 2015 11:41:52 -0700 (PDT)
In-Reply-To: <1437770866.21988.16.camel@ssi>
Sender: linux-bcache-owner@vger.kernel.org
List-Id: linux-bcache@vger.kernel.org
To: Ming Lin <mlin@kernel.org>
Cc: Kent Overstreet <kent.overstreet@gmail.com>, "linux-bcache@vger.kernel.org" <linux-bcache@vger.kernel.org>

On Fri, Jul 24, 2015 at 1:47 PM, Ming Lin <mlin@kernel.org> wrote:
>
> And I want to learn how the btree node insert/delete/update happens on
> disk. These maybe too detail. I'm going to write a small tool to dump
> the file system. Then I could understand better the on disk btree
> format.

Here is my simple tool to dump parts of the on-disk format.
http://www.minggr.net/cgit/cgit.cgi/bcache-tools/commit/?id=deb258e2

It's not in good shape, but simple enough to learn the on-disk format.
