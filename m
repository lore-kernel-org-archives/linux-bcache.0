From: Oleg Nesterov <oleg@redhat.com>
Subject: Re: [PATCH 1/2] bcache: ignore pending signals in
 bcache_device_init()
Date: Wed, 4 Mar 2020 13:13:25 +0100
Message-ID: <20200304121324.GC13170@redhat.com>
References: <20200302093450.48016-1-colyli@suse.de>
 <20200302093450.48016-2-colyli@suse.de>
 <20200302122748.GH4380@dhcp22.suse.cz>
 <20200302134919.GB9769@redhat.com>
 <20200303080544.GW4380@dhcp22.suse.cz>
 <20200303121918.GA27520@redhat.com>
 <20200303160307.GI4380@dhcp22.suse.cz>
 <20200304113613.GA13170@redhat.com>
 <20200304115718.GI16139@dhcp22.suse.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-block-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20200304115718.GI16139@dhcp22.suse.cz>
Sender: linux-block-owner@vger.kernel.org
To: Michal Hocko <mhocko@kernel.org>
Cc: Coly Li <colyli@suse.de>, axboe@kernel.dk, linux-bcache@vger.kernel.org, linux-block@vger.kernel.org, hare@suse.de, mkoutny@suse.com
List-Id: linux-bcache@vger.kernel.org

On 03/04, Michal Hocko wrote:
>
> So what would be a legit usecase to drop all signals while explicitly
> calling allow_signal?

Not sure I understand... Did you mean kthread should use kernel_dequeue
rather than flush?

Yes, they should do the same if kthread allows a single signal, iow if
it calls allow_signal() once.

But currently they differ.

1. flush_signal() is faster but we can optimize kernel_dequeue_signal().

2. kernel_dequeue_signal() does not necessarily clears TIF_SIGPENDING
   and I think this needs some fixes. Probably klp_patch_pending() is
   the only problem...

Oleg.
