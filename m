From: Coly Li <i@coly.li>
Subject: Re: [PATCH] bcache: PI controller for writeback rate V2
Date: Tue, 26 Sep 2017 12:46:31 +0800
Message-ID: <cd6a80f0-263f-7262-2e3c-f2466e0e2aea@coly.li>
References: <20170908031719.23988-1-mlyle@lyle.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Return-path: <linux-bcache-owner@vger.kernel.org>
Received: from server.coly.li ([162.144.45.48]:54110 "EHLO server.coly.li"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752167AbdIZEqg (ORCPT <rfc822;linux-bcache@vger.kernel.org>);
        Tue, 26 Sep 2017 00:46:36 -0400
In-Reply-To: <20170908031719.23988-1-mlyle@lyle.org>
Content-Language: en-US
Sender: linux-bcache-owner@vger.kernel.org
List-Id: linux-bcache@vger.kernel.org
To: Michael Lyle <mlyle@lyle.org>, linux-bcache@vger.kernel.org
Cc: colyli@suse.de, kent.overstreet@gmail.com

On 2017/9/8 上午11:17, Michael Lyle wrote:
> bcache uses a control system to attempt to keep the amount of dirty data
> in cache at a user-configured level, while not responding excessively to
> transients and variations in write rate.  Previously, the system was a
> PD controller; but the output from it was integrated, turning the
> Proportional term into an Integral term, and turning the Derivative term
> into a crude Proportional term.  Performance of the controller has been
> uneven in production, and it has tended to respond slowly, oscillate,
> and overshoot.
> 
> This patch set replaces the current control system with an explicit PI
> controller and tuning that should be correct for most hardware.  By
> default, it attempts to write at a rate that would retire 1/40th of the
> current excess blocks per second.  An integral term in turn works to
> remove steady state errors.
> 
> IMO, this yields benefits in simplicity (removing weighted average
> filtering, etc) and system performance.
> 
> Another small change is a tunable parameter is introduced to allow the
> user to specify a minimum rate at which dirty blocks are retired.
> Ideally one would set this writeback_rate_minimum to a small percentage
> of disk bandwidth, allowing the dirty data to be slowly cleaned out when
> the system is inactive.  The old behavior would try and retire 1
> sector/second, and the new default is 5 sectors/second.
> 
> Signed-off-by: Michael Lyle <mlyle@lyle.org>
> ---
>  drivers/md/bcache/bcache.h    |  9 +++--
>  drivers/md/bcache/sysfs.c     | 20 ++++++-----
>  drivers/md/bcache/writeback.c | 84 +++++++++++++++++++++++--------------------
>  3 files changed, 61 insertions(+), 52 deletions(-)
> 

[snip]
> @@ -492,8 +499,6 @@ void bch_sectors_dirty_init(struct cached_dev *dc)
>  
>  	bch_btree_map_keys(&op.op, dc->disk.c, &KEY(op.inode, 0, 0),
>  			   sectors_dirty_init_fn, 0);
> -
> -	dc->disk.sectors_dirty_last = bcache_dev_sectors_dirty(&dc->disk);
>  }
>  

Hi Mike,

I have no question for most part of this patch, it is clear to me. I
start to run this PI controller in my test kernel, so far it works fine.


>  void bch_cached_dev_writeback_init(struct cached_dev *dc)
> @@ -507,10 +512,11 @@ void bch_cached_dev_writeback_init(struct cached_dev *dc)
>  	dc->writeback_percent		= 10;
>  	dc->writeback_delay		= 30;
>  	dc->writeback_rate.rate		= 1024;
> +	dc->writeback_rate_minimum	= 5;
>

Here you set dc->writeback_rate_minimum to 5, and in your next patch it
is set to 8. I know 1 is an inaccurate value, could you please set it to
8 here ?


>  	dc->writeback_rate_update_seconds = 5;
> -	dc->writeback_rate_d_term	= 30;
> -	dc->writeback_rate_p_term_inverse = 6000;
> +	dc->writeback_rate_p_term_inverse = 40;
> +	dc->writeback_rate_i_term_inverse = 10000;
>  
>  	INIT_DELAYED_WORK(&dc->writeback_rate_update, update_writeback_rate);
>  }

We discussed why you set dc->writeback_rate_p_term_inverse to 40, could
you please to copy (maybe modify a bit) the discussion into patch commit
log, to explain why the parameters are decided.

I have no more comments. Looking for ward to your next version patch.

Thanks for your effort.

-- 
Coly Li
