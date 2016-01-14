From: Ming Lin <mlin@kernel.org>
Subject: Re: writeback: Stability issue (BUG) on 4.4 with writeback_percent
Date: Thu, 14 Jan 2016 09:51:25 -0800
Message-ID: <CAF1ivSY9urc58Ff6axkNrQX8hYxCZNRhAMcH6cEPyyeiBO+=MA@mail.gmail.com>
References: <loom.20160114T081429-882@post.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-bcache-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.136]:46329 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755961AbcANRv2 (ORCPT <rfc822;linux-bcache@vger.kernel.org>);
	Thu, 14 Jan 2016 12:51:28 -0500
Received: from mail.kernel.org (localhost [127.0.0.1])
	by mail.kernel.org (Postfix) with ESMTP id B96DA2049C
	for <linux-bcache@vger.kernel.org>; Thu, 14 Jan 2016 17:51:27 +0000 (UTC)
Received: from mail-vk0-f47.google.com (mail-vk0-f47.google.com [209.85.213.47])
	(using TLSv1.2 with cipher AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPSA id D263E2045A
	for <linux-bcache@vger.kernel.org>; Thu, 14 Jan 2016 17:51:26 +0000 (UTC)
Received: by mail-vk0-f47.google.com with SMTP id n1so130330300vkb.3
        for <linux-bcache@vger.kernel.org>; Thu, 14 Jan 2016 09:51:26 -0800 (PST)
In-Reply-To: <loom.20160114T081429-882@post.gmane.org>
Sender: linux-bcache-owner@vger.kernel.org
List-Id: linux-bcache@vger.kernel.org
To: Miu Vlad-Cosmin <miuvlad@gmail.com>
Cc: linux-bcache@vger.kernel.org, Ming Lei <ming.lei@canonical.com>

On Wed, Jan 13, 2016 at 11:22 PM, Miu Vlad-Cosmin <miuvlad@gmail.com> wrote:
> Hello,
>
> In a rather basic bcache setup (one cache + mdraid backing),
> I encounter a kernel problem related to bcache with 4.4.0.
>
> In order to trigger this bug, fill the cache with some dirty data.
> When there is some dirty data, wait for the bcache_writeback to
> start writing it to the backing device (0-3 minutes)
> and the BUG triggers.
>
> Please find more info here: https://bugzilla.kernel.org/show_bug.cgi?id=110771
>
> [<ffffffff815822af>] make_request+0x47f/0xca0
> [<ffffffff815a5d3d>] md_make_request+0xdd/0x220
> [<ffffffff810c53ce>] ? pick_next_task_fair+0x12e/0x450
> [<ffffffff81311d2e>] generic_make_request+0xce/0x1b0
> [<ffffffff815a1b70>] write_dirty+0x60/0xb0
> [<ffffffff810aafa7>] process_one_work+0x147/0x3d0
> [<ffffffff810ab546>] worker_thread+0x46/0x440
> [<ffffffff810ab500>] ? rescuer_thread+0x2d0/0x2d0
> [<ffffffff810ab500>] ? rescuer_thread+0x2d0/0x2d0
> [<ffffffff810afeb4>] kthread+0xc4/0xe0
> [<ffffffff810afdf0>] ? kthread_park+0x50/0x50
> [<ffffffff8170c85f>] ret_from_fork+0x3f/0x70
>
> A bisect shows "[578270bfbd2803dc7b0b03fbc2ac119efbc73195]
> block: fix segment split" as the problem.

CC Ming Lei.

>
> Anyone can confirm this ?
>
> Thanks,
> Vlad
