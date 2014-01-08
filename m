From: Kent Overstreet <kmo@daterainc.com>
Subject: Re: [PATCH 2/3] bcache: Avoid hung task happen.
Date: Wed, 8 Jan 2014 13:34:02 -0800
Message-ID: <20140108213402.GG7291@kmo-pixel>
References: <201401081939218365334@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-bcache-owner@vger.kernel.org>
Received: from mail-pa0-f47.google.com ([209.85.220.47]:53937 "EHLO
	mail-pa0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757647AbaAHVcp (ORCPT
	<rfc822;linux-bcache@vger.kernel.org>);
	Wed, 8 Jan 2014 16:32:45 -0500
Received: by mail-pa0-f47.google.com with SMTP id kq14so2373382pab.6
        for <linux-bcache@vger.kernel.org>; Wed, 08 Jan 2014 13:32:45 -0800 (PST)
Content-Disposition: inline
In-Reply-To: <201401081939218365334@gmail.com>
Sender: linux-bcache-owner@vger.kernel.org
List-Id: linux-bcache@vger.kernel.org
To: majianpeng <majianpeng@gmail.com>
Cc: linux-bcache <linux-bcache@vger.kernel.org>

On Wed, Jan 08, 2014 at 07:39:26PM +0800, majianpeng wrote:
> Because after kthread_create, the state of kthread is TASK_UNINTERRUPTIBLE.
> If we don't wake up dc->writeback_thread, the thread will be hung-task.
> For those reasons, we don't wake up writeback_thread:
> A:only create backed device
> B:create backed device and cache device, but don't write at once
> C:write without writeback poliy
> 
> So like the way of create gc_thread, after creating writeback_thread, i
> set the state is TASK_INTERRUPTIBLE.

I've seen this issue, but this isn't even where the sleep happens,
there's no way this could be fixing it..
