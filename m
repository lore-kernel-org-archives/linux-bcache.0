From: Michal Hocko <mhocko@kernel.org>
Subject: Re: [PATCH 1/2] bcache: ignore pending signals in
 bcache_device_init()
Date: Wed, 4 Mar 2020 13:41:44 +0100
Message-ID: <20200304124144.GL16139@dhcp22.suse.cz>
References: <20200302122748.GH4380@dhcp22.suse.cz>
 <20200302134919.GB9769@redhat.com>
 <20200303080544.GW4380@dhcp22.suse.cz>
 <20200303121918.GA27520@redhat.com>
 <20200303160307.GI4380@dhcp22.suse.cz>
 <20200304113613.GA13170@redhat.com>
 <20200304115718.GI16139@dhcp22.suse.cz>
 <20200304121324.GC13170@redhat.com>
 <20200304122226.GJ16139@dhcp22.suse.cz>
 <20200304123342.GD13170@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-block-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20200304123342.GD13170@redhat.com>
Sender: linux-block-owner@vger.kernel.org
To: Oleg Nesterov <oleg@redhat.com>
Cc: Coly Li <colyli@suse.de>, axboe@kernel.dk, linux-bcache@vger.kernel.org, linux-block@vger.kernel.org, hare@suse.de, mkoutny@suse.com
List-Id: linux-bcache@vger.kernel.org

On Wed 04-03-20 13:33:42, Oleg Nesterov wrote:
> On 03/04, Michal Hocko wrote:
> >
> > On Wed 04-03-20 13:13:25, Oleg Nesterov wrote:
> > > On 03/04, Michal Hocko wrote:
> > > >
> > > > So what would be a legit usecase to drop all signals while explicitly
> > > > calling allow_signal?
> > >
> > > Not sure I understand...
> >
> > flush_signals will simply drop all pending signals on the floor so there
> > is no way to handle them, right? I am asking when is still really a
> > desirable thing to do when you allow_signal for the kthread. The only
> > one I can imagine is that the kthread allows a single signal so it is
> > quite clear which signal is flushed.
> 
> Yes. This is what I meant when I said "they should do the same if kthread
> allows a single signal".

OK, good that we are at the same page. I have clearly misread your
earlier email.
 
> > kernel_dequeue_signal on the other hand will give you a signal and so
> > the code can actually handle it in some way.
> 
> Yes.

diff --git a/kernel/signal.c b/kernel/signal.c
index 9ad8dea93dbb..959adc2a5a3d 100644
--- a/kernel/signal.c
+++ b/kernel/signal.c
@@ -465,7 +465,18 @@ void flush_sigqueue(struct sigpending *queue)
 }
 
 /*
- * Flush all pending signals for this kthread.
+ * Flush all pending signals for this kthread. Please note that this interface
+ * shouldn't be and if there is a need for it then it should be clearly
+ * documented why.
+ *
+ * Existing users should be double checked because most of them are likely
+ * obsolete. Kernel threads are not on the receiving end of signal delivery
+ * unless they explicitly request that by allow_signal() and in that case
+ * flush_signals is almost always a bug because signal should be processed
+ * by kernel_dequeue_signal rather than dropping them on the floor. The only
+ * exception when flush_signals could be used is a micro-optimization when
+ * only a single signal is allowed when retreiving the specific signal number
+ * is not needed. Please document this usage.
  */
 void flush_signals(struct task_struct *t)
 {

-- 
Michal Hocko
SUSE Labs
