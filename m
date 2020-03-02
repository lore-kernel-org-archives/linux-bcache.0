From: Michal Hocko <mhocko@kernel.org>
Subject: Re: [PATCH 1/2] bcache: ignore pending signals in
 bcache_device_init()
Date: Mon, 2 Mar 2020 14:40:48 +0100
Message-ID: <20200302134048.GK4380@dhcp22.suse.cz>
References: <20200302093450.48016-1-colyli@suse.de>
 <20200302093450.48016-2-colyli@suse.de>
 <20200302122748.GH4380@dhcp22.suse.cz>
 <29a1c9fa-46e2-af5f-9531-c25dbb0a3dca@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-bcache-owner@vger.kernel.org>
Received: from mail-wr1-f65.google.com ([209.85.221.65]:39920 "EHLO
        mail-wr1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727627AbgCBNkw (ORCPT
        <rfc822;linux-bcache@vger.kernel.org>);
        Mon, 2 Mar 2020 08:40:52 -0500
Content-Disposition: inline
In-Reply-To: <29a1c9fa-46e2-af5f-9531-c25dbb0a3dca@suse.de>
Sender: linux-bcache-owner@vger.kernel.org
List-Id: linux-bcache@vger.kernel.org
To: Coly Li <colyli@suse.de>
Cc: axboe@kernel.dk, linux-bcache@vger.kernel.org, linux-block@vger.kernel.org, hare@suse.de, mkoutny@suse.com, Oleg Nesterov <oleg@redhat.com>, Christoph Hellwig <hch@lst.de>

On Mon 02-03-20 21:29:09, Coly Li wrote:
[...]
> > I cannot really comment on the bcache part because I am not familiar
> > with the code. It is quite surprising to see an initialization taking
> > that long though.
> > 
> 
> Back to the time 10 years ago when bcache merged into Linux mainline,
> checking meta data for a 120G SSD was fast. But now an 8TB SSD is quite
> common on server... So the problem appears.

Does all that work has to happen synchronously from the kworker context?
Is it possible some of the initialization to be done more lazily or in
the background?

> > Anyway
> > 
> >> This patch calls flush_signals() in bcache_device_init() if there is
> >> pending signal for current process. It avoids bcache registration
> >> failure in system boot up time due to bcache udev rule timeout.
> > 
> > this sounds like a wrong way to address the issue. Killing the udev
> > worker is a userspace policy and the kernel shouldn't simply ignore it.
> 
> Indeed the bcache registering process cannot be killed, because a mutex
> lock (bch_register_lock) is held during all the registration operation.
> 
> In my testing, kthread_run()/kthread_create() failure by pending signal
> happens after all metadata checking finished, that's 55 minutes later.
> No mater the registration successes or fails, the time length is same.
> 
> Once the udev timeout killing is useless, why not make the registration
> to success ? This is what the patch does.

I cannot really comment for the systemd part but it is quite unexpected
for it to have signals ignored completely.

> > Is there any problem to simply increase the timeout on the system which
> > uses a large bcache?
> > 
> 
> At this moment, this is a workaround. Christoph Hellwig also suggests to
> fix kthread_run()/kthread_create(). Now I am looking for method to
> distinct that the parent process is killed by OOM killer and not by
> other processes in kthread_run()/kthread_create(), but the solution is
> not clear to me yet.

It is really hard to comment on this because I do not have a sufficient
insight but in genereal. The oom victim context can be checked by
tsk_is_oom_victim but kernel threads are subject of the oom killer
because they do not own any address space. I also suspect that none of
the data you allocate for the cache is accounted per any specific
process.

> When meta-data size is around 40GB, registering cache device will take
> around 55 minutes on my machine for current Linux kernel. I have patch
> to reduce the time to around 7~8 minutes but still too long. I may add a
> timeout in bcache udev rule for example 10 munites, but when the cache
> device get large and large, the timeout will be not enough eventually.
> 
> As I mentioned, this is a workaround to fix the problem now. Fixing
> kthread_run()/kthread_create() may take longer time for me. If there is
> hint to make it, please offer me.

My main question is why there is any need to touch the kernel code. You
can still update the systemd/udev timeout AFAIK. This would be the
proper workaround from my (admittedly limited) POV.

-- 
Michal Hocko
SUSE Labs
