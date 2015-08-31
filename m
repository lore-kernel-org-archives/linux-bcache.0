From: Vojtech Pavlik <vojtech@suse.cz>
Subject: Re: Bcache stuck at writeback of a key, consuming 100% CPU, not
 possible to detach
Date: Mon, 31 Aug 2015 16:49:49 +0200
Message-ID: <20150831144949.GA3276@suse.com>
References: <20150830085442.GA31722@suse.com>
 <20150831163937.00ca3f7a@harpe.intellique.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-bcache-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:58302 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752698AbbHaOtu (ORCPT <rfc822;linux-bcache@vger.kernel.org>);
	Mon, 31 Aug 2015 10:49:50 -0400
Content-Disposition: inline
In-Reply-To: <20150831163937.00ca3f7a@harpe.intellique.com>
Sender: linux-bcache-owner@vger.kernel.org
List-Id: linux-bcache@vger.kernel.org
To: Emmanuel Florac <eflorac@intellique.com>
Cc: kmo@daterainc.com, linux-bcache@vger.kernel.org

On Mon, Aug 31, 2015 at 04:39:37PM +0200, Emmanuel Florac wrote:

> > Then I noticed that during those situations where the system was
> > slow, and processes stuck in D, bcache_writeback CPU usage was
> > soaring all the way to saturating a core,
> 
> In my experience, bcache_writeback stays in Wait state, therefore
> always saturate a core: any machine I'm running bcache on has a
> constant load of 1.00 even when completely idle.

In this situation, I see it in an "R" state.

> > showing this backtrace,
> > spending time in refill_keybuf_fn():
>  <snip>
> > Changing the configuration to writeback_percent=40 helped. For some
> > time at least.
> > 
> > When the issue returned, without any further changes to the system, I
> > started investigating deeper. Since writeback_percent was large, also
> > the amount of dirty data was large.
> 
> In my case, when dirty data reaches the upper limit (i.e. when the
> amount of dirty data equals the writeback_percent * backing device
> size ), and it occurs regularly, the system just freezes...

That may be a similar symptom.

> > Before poking deeper, I decided I
> > want to clear the dirty data entierly. So I set the system to
> > cache_mode=writethrough and watched the dirty data trickle to the
> > backing device.
> > 
> > But then it stopped at 2.8G and didn't progress any further. The
> > bcache_writeback thread was at 100% CPU usage again and system was
> > near unusable. Reverting to writeback made the system responsive
> > again.
> 
> The bcache_writeback stays at 100% _even_ when in writethrough mode,
> alas. So this looks normal. However dirty_data definitely should drop
> to zero...

This most certainly isn't normal. The ftrace shows it's looping in a
loop doing nothing useful.

>  <snip> 
> > I consider this a rather serious bug, even though it is most likely
> > caused by the cache device being corrupted. Any hints?
> 
> Did you check what "smartctl -a" has to say about your backing device,
> and maybe your spinning drives too? Just in case...

Yes, they're fine. The backing device is a RAID5.

-- 
Vojtech Pavlik
Director SuSE Labs
