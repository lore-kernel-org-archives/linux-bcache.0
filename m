From: Ming Lin <mlin@kernel.org>
Subject: Re: bcache deadlock
Date: Sun, 2 Aug 2015 23:21:17 -0700
Message-ID: <CAF1ivSY=+SDonyQdWntkyYWYhEgVrgzNLxdd7x1PVmKcyH2fGA@mail.gmail.com>
References: <55BC6268.3060407@profihost.ag>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-bcache-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.136]:48660 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750801AbbHCGVU (ORCPT <rfc822;linux-bcache@vger.kernel.org>);
	Mon, 3 Aug 2015 02:21:20 -0400
Received: from mail.kernel.org (localhost [127.0.0.1])
	by mail.kernel.org (Postfix) with ESMTP id 7F16220504
	for <linux-bcache@vger.kernel.org>; Mon,  3 Aug 2015 06:21:19 +0000 (UTC)
Received: from mail-vk0-f49.google.com (mail-vk0-f49.google.com [209.85.213.49])
	(using TLSv1.2 with cipher AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPSA id 814EB20374
	for <linux-bcache@vger.kernel.org>; Mon,  3 Aug 2015 06:21:18 +0000 (UTC)
Received: by vkhg129 with SMTP id g129so39037636vkh.2
        for <linux-bcache@vger.kernel.org>; Sun, 02 Aug 2015 23:21:17 -0700 (PDT)
In-Reply-To: <55BC6268.3060407@profihost.ag>
Sender: linux-bcache-owner@vger.kernel.org
List-Id: linux-bcache@vger.kernel.org
To: Stefan Priebe <s.priebe@profihost.ag>
Cc: "linux-bcache@vger.kernel.org" <linux-bcache@vger.kernel.org>

On Fri, Jul 31, 2015 at 11:08 PM, Stefan Priebe <s.priebe@profihost.ag> wrote:
> Hi,
>
> any ideas about this deadlock:
> 2015-08-01 00:05:05     "echo 0 > /proc/sys/kernel/hung_task_timeout_secs"
> disables this message.
> 2015-08-01 00:05:05     Tainted: G O 3.18.19+47-ph #1
> 2015-08-01 00:05:05     INFO: task xfsaild/bcache5:2437 blocked for more
> than 120 seconds.

No backtrace?
