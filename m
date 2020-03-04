From: Oleg Nesterov <oleg@redhat.com>
Subject: Re: [PATCH 1/2] bcache: ignore pending signals in
 bcache_device_init()
Date: Wed, 4 Mar 2020 14:02:09 +0100
Message-ID: <20200304130208.GE13170@redhat.com>
References: <20200302134919.GB9769@redhat.com>
 <20200303080544.GW4380@dhcp22.suse.cz>
 <20200303121918.GA27520@redhat.com>
 <20200303160307.GI4380@dhcp22.suse.cz>
 <20200304113613.GA13170@redhat.com>
 <20200304115718.GI16139@dhcp22.suse.cz>
 <20200304121324.GC13170@redhat.com>
 <20200304122226.GJ16139@dhcp22.suse.cz>
 <20200304123342.GD13170@redhat.com>
 <20200304124144.GL16139@dhcp22.suse.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-bcache-owner@vger.kernel.org>
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:36269 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S2388022AbgCDNCR (ORCPT
        <rfc822;linux-bcache@vger.kernel.org>);
        Wed, 4 Mar 2020 08:02:17 -0500
Content-Disposition: inline
In-Reply-To: <20200304124144.GL16139@dhcp22.suse.cz>
Sender: linux-bcache-owner@vger.kernel.org
List-Id: linux-bcache@vger.kernel.org
To: Michal Hocko <mhocko@kernel.org>
Cc: Coly Li <colyli@suse.de>, axboe@kernel.dk, linux-bcache@vger.kernel.org, linux-block@vger.kernel.org, hare@suse.de, mkoutny@suse.com

On 03/04, Michal Hocko wrote:
>
>  /*
> - * Flush all pending signals for this kthread.
> + * Flush all pending signals for this kthread. Please note that this interface
> + * shouldn't be and if there is a need for it then it should be clearly
> + * documented why.
> + *
> + * Existing users should be double checked because most of them are likely
> + * obsolete. Kernel threads are not on the receiving end of signal delivery
> + * unless they explicitly request that by allow_signal() and in that case
> + * flush_signals is almost always a bug
                    ^^^^^^^^^^^^^^^^^^^^^^
I still think this is too strong statement...

Even if it seems that most current users of flush_signals() are wrong.

> because signal should be processed
> + * by kernel_dequeue_signal rather than dropping them on the floor.

Yes, but to remind we need some cleanups to ensure that
s/flush_signals/kernel_dequeue_signal/ is always "safe" even when only a
single signal is allowed,

> The only
> + * exception when flush_signals could be used is a micro-optimization when
> + * only a single signal is allowed when retreiving the specific signal number
> + * is not needed. Please document this usage.
>   */

Agreed.

Oleg.
