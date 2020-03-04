From: Michal Hocko <mhocko@kernel.org>
Subject: Re: [PATCH 1/2] bcache: ignore pending signals in
 bcache_device_init()
Date: Wed, 4 Mar 2020 13:22:26 +0100
Message-ID: <20200304122226.GJ16139@dhcp22.suse.cz>
References: <20200302093450.48016-1-colyli@suse.de>
 <20200302093450.48016-2-colyli@suse.de>
 <20200302122748.GH4380@dhcp22.suse.cz>
 <20200302134919.GB9769@redhat.com>
 <20200303080544.GW4380@dhcp22.suse.cz>
 <20200303121918.GA27520@redhat.com>
 <20200303160307.GI4380@dhcp22.suse.cz>
 <20200304113613.GA13170@redhat.com>
 <20200304115718.GI16139@dhcp22.suse.cz>
 <20200304121324.GC13170@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-bcache-owner@vger.kernel.org>
Received: from mail-wm1-f66.google.com ([209.85.128.66]:36125 "EHLO
        mail-wm1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729175AbgCDMWb (ORCPT
        <rfc822;linux-bcache@vger.kernel.org>);
        Wed, 4 Mar 2020 07:22:31 -0500
Content-Disposition: inline
In-Reply-To: <20200304121324.GC13170@redhat.com>
Sender: linux-bcache-owner@vger.kernel.org
List-Id: linux-bcache@vger.kernel.org
To: Oleg Nesterov <oleg@redhat.com>
Cc: Coly Li <colyli@suse.de>, axboe@kernel.dk, linux-bcache@vger.kernel.org, linux-block@vger.kernel.org, hare@suse.de, mkoutny@suse.com

On Wed 04-03-20 13:13:25, Oleg Nesterov wrote:
> On 03/04, Michal Hocko wrote:
> >
> > So what would be a legit usecase to drop all signals while explicitly
> > calling allow_signal?
> 
> Not sure I understand...

flush_signals will simply drop all pending signals on the floor so there
is no way to handle them, right? I am asking when is still really a
desirable thing to do when you allow_signal for the kthread. The only
one I can imagine is that the kthread allows a single signal so it is
quite clear which signal is flushed.

kernel_dequeue_signal on the other hand will give you a signal and so
the code can actually handle it in some way.

-- 
Michal Hocko
SUSE Labs
