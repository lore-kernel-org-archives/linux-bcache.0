From: Oleg Nesterov <oleg@redhat.com>
Subject: Re: [PATCH 1/2] bcache: ignore pending signals in
 bcache_device_init()
Date: Mon, 2 Mar 2020 14:49:19 +0100
Message-ID: <20200302134919.GB9769@redhat.com>
References: <20200302093450.48016-1-colyli@suse.de>
 <20200302093450.48016-2-colyli@suse.de>
 <20200302122748.GH4380@dhcp22.suse.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-bcache-owner@vger.kernel.org>
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:24795 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726300AbgCBNt0 (ORCPT
        <rfc822;linux-bcache@vger.kernel.org>);
        Mon, 2 Mar 2020 08:49:26 -0500
Content-Disposition: inline
In-Reply-To: <20200302122748.GH4380@dhcp22.suse.cz>
Sender: linux-bcache-owner@vger.kernel.org
List-Id: linux-bcache@vger.kernel.org
To: Michal Hocko <mhocko@kernel.org>
Cc: Coly Li <colyli@suse.de>, axboe@kernel.dk, linux-bcache@vger.kernel.org, linux-block@vger.kernel.org, hare@suse.de, mkoutny@suse.com

On 03/02, Michal Hocko wrote:
>
> I cannot really comment on the bcache part because I am not familiar
> with the code.

same here...

> > This patch calls flush_signals() in bcache_device_init() if there is
> > pending signal for current process. It avoids bcache registration
> > failure in system boot up time due to bcache udev rule timeout.
>
> this sounds like a wrong way to address the issue. Killing the udev
> worker is a userspace policy and the kernel shouldn't simply ignore it.

Agreed. If nothing else, if a userspace process has pending SIKILL then
flush_signals() is very wrong.

> Btw. Oleg, I have noticed quite a lot of flush_signals usage in the
> drivers land and I have really hard time to understand their purpose.

Heh. I bet most if not all users of flush_signals() are simply wrong.

> What is the actual valid usage of this function?

I thinks it should die... It was used by kthreads, but today
signal_pending() == T is only possible if kthread does allow_signal(),
and in this case it should probably use kernel_dequeue_signal().


Say, io_sq_thread(). Why does it do

		if (signal_pending(current))
			flush_signals(current);

afaics this kthread doesn't use allow_signal/allow_kernel_signal, this
means that signal_pending() must be impossible even if this kthread sleeps
in TASK_INTERRUPTIBLE state. Add Jens.

Oleg.
