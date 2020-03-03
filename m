From: Michal Hocko <mhocko@kernel.org>
Subject: Re: [PATCH 1/2] bcache: ignore pending signals in
 bcache_device_init()
Date: Tue, 3 Mar 2020 09:05:44 +0100
Message-ID: <20200303080544.GW4380@dhcp22.suse.cz>
References: <20200302093450.48016-1-colyli@suse.de>
 <20200302093450.48016-2-colyli@suse.de>
 <20200302122748.GH4380@dhcp22.suse.cz>
 <20200302134919.GB9769@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-bcache-owner@vger.kernel.org>
Received: from mail-wm1-f66.google.com ([209.85.128.66]:39317 "EHLO
        mail-wm1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727659AbgCCIFr (ORCPT
        <rfc822;linux-bcache@vger.kernel.org>);
        Tue, 3 Mar 2020 03:05:47 -0500
Content-Disposition: inline
In-Reply-To: <20200302134919.GB9769@redhat.com>
Sender: linux-bcache-owner@vger.kernel.org
List-Id: linux-bcache@vger.kernel.org
To: Oleg Nesterov <oleg@redhat.com>
Cc: Coly Li <colyli@suse.de>, axboe@kernel.dk, linux-bcache@vger.kernel.org, linux-block@vger.kernel.org, hare@suse.de, mkoutny@suse.com

On Mon 02-03-20 14:49:19, Oleg Nesterov wrote:
> On 03/02, Michal Hocko wrote:
> >
> > I cannot really comment on the bcache part because I am not familiar
> > with the code.
> 
> same here...
> 
> > > This patch calls flush_signals() in bcache_device_init() if there is
> > > pending signal for current process. It avoids bcache registration
> > > failure in system boot up time due to bcache udev rule timeout.
> >
> > this sounds like a wrong way to address the issue. Killing the udev
> > worker is a userspace policy and the kernel shouldn't simply ignore it.
> 
> Agreed. If nothing else, if a userspace process has pending SIKILL then
> flush_signals() is very wrong.
> 
> > Btw. Oleg, I have noticed quite a lot of flush_signals usage in the
> > drivers land and I have really hard time to understand their purpose.
> 
> Heh. I bet most if not all users of flush_signals() are simply wrong.
> 
> > What is the actual valid usage of this function?
> 
> I thinks it should die...

Can we simply deprecate it and add a big fat comment explaning why this
is wrong interface to use?

So what about this?
diff --git a/kernel/signal.c b/kernel/signal.c
index 9ad8dea93dbb..8a895e565e84 100644
--- a/kernel/signal.c
+++ b/kernel/signal.c
@@ -465,7 +465,13 @@ void flush_sigqueue(struct sigpending *queue)
 }
 
 /*
- * Flush all pending signals for this kthread.
+ * Flush all pending signals for this kthread. Please note that this interface
+ * shouldn't be used and in fact it is DEPRECATED.
+ * Existing users should be double checked because most of them are likely
+ * obsolete. Kernel threads are not on the receiving end of signal delivery
+ * unless they explicitly request that by allow_signal() and in that case
+ * flush_signals is almost always a bug because signal should be processed
+ * by kernel_dequeue_signal rather than dropping them on the floor.
  */
 void flush_signals(struct task_struct *t)
 {
-- 
Michal Hocko
SUSE Labs
