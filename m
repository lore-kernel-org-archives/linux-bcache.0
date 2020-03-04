From: Oleg Nesterov <oleg@redhat.com>
Subject: Re: [PATCH 1/2] bcache: ignore pending signals in
 bcache_device_init()
Date: Wed, 4 Mar 2020 12:53:31 +0100
Message-ID: <20200304115330.GB13170@redhat.com>
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
Return-path: <linux-block-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20200304113613.GA13170@redhat.com>
Sender: linux-block-owner@vger.kernel.org
To: Michal Hocko <mhocko@kernel.org>
Cc: Coly Li <colyli@suse.de>, axboe@kernel.dk, linux-bcache@vger.kernel.org, linux-block@vger.kernel.org, hare@suse.de, mkoutny@suse.com
List-Id: linux-bcache@vger.kernel.org

On 03/04, Oleg Nesterov wrote:
>
> arch/arm/common/bL_switcher.c:bL_switcher_thread(). Why does it do
> flush_signals() ? signal_pending() must not be possible. It seems that
> people think that wait_event_interruptible() or even schedule() in
> TASK_INTERRUPTIBLE state can lead to a pending signal but this is not
> true. Of course, I could miss allow_signal() in bL_switch_to() paths...

Jens, could you explain flush_signals() in io_sq_thread() ?

Oleg.
