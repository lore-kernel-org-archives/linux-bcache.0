From: Ming Lin <mlin@kernel.org>
Subject: Re: Testing bcachefs - beginners questions
Date: Thu, 17 Mar 2016 23:55:36 -0700
Message-ID: <CAF1ivSb+_KXe0OLMibZYnZbfk_wS8bR4JUxxYV0zw-J9PTn-QA@mail.gmail.com>
References: <alpine.LRH.2.11.1603161917400.19675@mail.ewheeler.net>
	<20160318041551.GA7889@kmo-pixel>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-bcache-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.136]:56958 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751932AbcCRGzj (ORCPT <rfc822;linux-bcache@vger.kernel.org>);
	Fri, 18 Mar 2016 02:55:39 -0400
Received: from mail.kernel.org (localhost [127.0.0.1])
	by mail.kernel.org (Postfix) with ESMTP id 741362038A
	for <linux-bcache@vger.kernel.org>; Fri, 18 Mar 2016 06:55:38 +0000 (UTC)
Received: from mail-oi0-f51.google.com (mail-oi0-f51.google.com [209.85.218.51])
	(using TLSv1.2 with cipher AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPSA id 49F842037F
	for <linux-bcache@vger.kernel.org>; Fri, 18 Mar 2016 06:55:37 +0000 (UTC)
Received: by mail-oi0-f51.google.com with SMTP id r187so81532284oih.3
        for <linux-bcache@vger.kernel.org>; Thu, 17 Mar 2016 23:55:37 -0700 (PDT)
In-Reply-To: <20160318041551.GA7889@kmo-pixel>
Sender: linux-bcache-owner@vger.kernel.org
List-Id: linux-bcache@vger.kernel.org
To: Kent Overstreet <kent.overstreet@gmail.com>
Cc: Eric Wheeler <bcache@lists.ewheeler.net>, =?UTF-8?Q?Marcin_Miros=C5=82aw?= <marcin@mejor.pl>, linux-bcache@vger.kernel.org

On Thu, Mar 17, 2016 at 9:15 PM, Kent Overstreet
<kent.overstreet@gmail.com> wrote:

>
> Benchmark wise, here's a dio append benchmark I ran the other day:
>
> Summary:
> bcachefs:       1749.1 MB/s
> ext4:           513.6 MB/s
> xfs:            515.7 MB/s
> btrfs:          531.2 MB/s

This is so cool!
