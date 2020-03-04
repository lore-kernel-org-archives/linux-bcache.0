From: Michal Hocko <mhocko@kernel.org>
Subject: Re: [PATCH 1/2] bcache: ignore pending signals in
 bcache_device_init()
Date: Wed, 4 Mar 2020 12:57:18 +0100
Message-ID: <20200304115718.GI16139@dhcp22.suse.cz>
References: <20200302093450.48016-1-colyli@suse.de>
 <20200302093450.48016-2-colyli@suse.de>
 <20200302122748.GH4380@dhcp22.suse.cz>
 <20200302134919.GB9769@redhat.com>
 <20200303080544.GW4380@dhcp22.suse.cz>
 <20200303121918.GA27520@redhat.com>
 <20200303160307.GI4380@dhcp22.suse.cz>
 <20200304113613.GA13170@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-bcache-owner@vger.kernel.org>
Received: from mail-wr1-f68.google.com ([209.85.221.68]:34625 "EHLO
        mail-wr1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726440AbgCDL5W (ORCPT
        <rfc822;linux-bcache@vger.kernel.org>);
        Wed, 4 Mar 2020 06:57:22 -0500
Content-Disposition: inline
In-Reply-To: <20200304113613.GA13170@redhat.com>
Sender: linux-bcache-owner@vger.kernel.org
List-Id: linux-bcache@vger.kernel.org
To: Oleg Nesterov <oleg@redhat.com>
Cc: Coly Li <colyli@suse.de>, axboe@kernel.dk, linux-bcache@vger.kernel.org, linux-block@vger.kernel.org, hare@suse.de, mkoutny@suse.com

On Wed 04-03-20 12:36:13, Oleg Nesterov wrote:
[...]
> IOW, I mostly agree with
> 
> 	- * Flush all pending signals for this kthread.
> 	+ * Flush all pending signals for this kthread. Please note that this interface
> 	+ * shouldn't be used and in fact it is DEPRECATED.
> 	+ * Existing users should be double checked because most of them are likely
> 	+ * obsolete. Kernel threads are not on the receiving end of signal delivery
> 	+ * unless they explicitly request that by allow_signal() and in that case
> 	+ * flush_signals is almost always a bug because signal should be processed
> 	+ * by kernel_dequeue_signal rather than dropping them on the floor.
> 
> you wrote in your previous email, but "DEPRECATED" and "almost always a bug"
> looks a bit too strong to me.

So what would be a legit usecase to drop all signals while explicitly
calling allow_signal? 

-- 
Michal Hocko
SUSE Labs
