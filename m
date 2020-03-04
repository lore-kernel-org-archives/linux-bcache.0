From: Oleg Nesterov <oleg@redhat.com>
Subject: Re: [PATCH 1/2] bcache: ignore pending signals in
 bcache_device_init()
Date: Wed, 4 Mar 2020 12:36:13 +0100
Message-ID: <20200304113613.GA13170@redhat.com>
References: <20200302093450.48016-1-colyli@suse.de>
 <20200302093450.48016-2-colyli@suse.de>
 <20200302122748.GH4380@dhcp22.suse.cz>
 <20200302134919.GB9769@redhat.com>
 <20200303080544.GW4380@dhcp22.suse.cz>
 <20200303121918.GA27520@redhat.com>
 <20200303160307.GI4380@dhcp22.suse.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-block-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20200303160307.GI4380@dhcp22.suse.cz>
Sender: linux-block-owner@vger.kernel.org
To: Michal Hocko <mhocko@kernel.org>
Cc: Coly Li <colyli@suse.de>, axboe@kernel.dk, linux-bcache@vger.kernel.org, linux-block@vger.kernel.org, hare@suse.de, mkoutny@suse.com
List-Id: linux-bcache@vger.kernel.org

On 03/03, Michal Hocko wrote:
>
> On Tue 03-03-20 13:19:18, Oleg Nesterov wrote:
> [...]
> > but I am not sure this optmization makes sense.
>
> I would much rather start with a clarification on what should be use
> what shouldn't. Because as of now, people tend to copy patterns which
> are broken or simply do not make any sense at all.

Yes, it has a lot of buggy users.

It should only be used by kthtreads which do allow_signal(), and imo
even in this case kernel_dequeue_signal() makes more sense.

I am looking at 2 first users reported by git-grep.

arch/arm/common/bL_switcher.c:bL_switcher_thread(). Why does it do
flush_signals() ? signal_pending() must not be possible. It seems that
people think that wait_event_interruptible() or even schedule() in
TASK_INTERRUPTIBLE state can lead to a pending signal but this is not
true. Of course, I could miss allow_signal() in bL_switch_to() paths...

drivers/block/drbd/. I know nothing about this code, but it seems that
flush_signals() can be called by the userspace process. This should be
forbidden.

IOW, I mostly agree with

	- * Flush all pending signals for this kthread.
	+ * Flush all pending signals for this kthread. Please note that this interface
	+ * shouldn't be used and in fact it is DEPRECATED.
	+ * Existing users should be double checked because most of them are likely
	+ * obsolete. Kernel threads are not on the receiving end of signal delivery
	+ * unless they explicitly request that by allow_signal() and in that case
	+ * flush_signals is almost always a bug because signal should be processed
	+ * by kernel_dequeue_signal rather than dropping them on the floor.

you wrote in your previous email, but "DEPRECATED" and "almost always a bug"
looks a bit too strong to me.

I would like to add WARN_ON(!PF_KTHREAD) into flush_signals() and let people
fix their code ;)

Oleg.
