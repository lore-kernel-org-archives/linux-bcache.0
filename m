From: Ming Lin <mlin@kernel.org>
Subject: Re: [ANNOUNCE] bcachefs!
Date: Wed, 15 Jul 2015 00:39:36 -0700
Message-ID: <CAF1ivSa4bZaw2w9nu1tQeYx7JBb2_fVDV67Le=ybC2m8OdX3gg@mail.gmail.com>
References: <20150714005825.GA24027@kmo-pixel>
	<1436940689.6520.1.camel@hasee>
	<CAC7rs0sbg2ci6=niQ0X11AONZbr2AOYhRbxfDH_w4N4A7dyPLw@mail.gmail.com>
	<1436944556.6520.5.camel@hasee>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-bcache-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.136]:35901 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751702AbbGOHjj (ORCPT <rfc822;linux-bcache@vger.kernel.org>);
	Wed, 15 Jul 2015 03:39:39 -0400
Received: from mail.kernel.org (localhost [127.0.0.1])
	by mail.kernel.org (Postfix) with ESMTP id 9CE242057F
	for <linux-bcache@vger.kernel.org>; Wed, 15 Jul 2015 07:39:38 +0000 (UTC)
Received: from mail-ob0-f174.google.com (mail-ob0-f174.google.com [209.85.214.174])
	(using TLSv1.2 with cipher AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPSA id 6771820585
	for <linux-bcache@vger.kernel.org>; Wed, 15 Jul 2015 07:39:37 +0000 (UTC)
Received: by obbgp5 with SMTP id gp5so21353078obb.0
        for <linux-bcache@vger.kernel.org>; Wed, 15 Jul 2015 00:39:36 -0700 (PDT)
In-Reply-To: <1436944556.6520.5.camel@hasee>
Sender: linux-bcache-owner@vger.kernel.org
List-Id: linux-bcache@vger.kernel.org
To: Ming Lin <mlin@kernel.org>
Cc: Kent Overstreet <kent.overstreet@gmail.com>, "linux-bcache@vger.kernel.org" <linux-bcache@vger.kernel.org>

On Wed, Jul 15, 2015 at 12:15 AM, Ming Lin <mlin@kernel.org> wrote:
> On Tue, 2015-07-14 at 23:58 -0700, Kent Overstreet wrote:
>> Can you strace it?
>
> Strange. Now error message changed.

I mean sometimes it showed:

mount: /dev/sdt already mounted or /mnt/ busy

>
> root@afa03:~# mount /dev/sdt /mnt/
> mount: mount(2) failed: No such file or directory
