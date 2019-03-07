From: Vojtech Pavlik <vojtech@suse.com>
Subject: Re: [PATCH] bcache: add cond_resched() in __bch_cache_cmp()
Date: Thu, 7 Mar 2019 16:44:21 +0100
Message-ID: <20190307154421.GA8829@suse.cz>
References: <1551935728-243664-1-git-send-email-shile.zhang@linux.alibaba.com>
 <24916a71-39ff-7324-ad12-9d79cc68d0da@suse.de>
 <3640cd7f-f32a-1509-dbef-6000b6e14e75@linux.alibaba.com>
 <c421d715-6d14-a6f0-907b-644318120c8e@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <c421d715-6d14-a6f0-907b-644318120c8e@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
To: Coly Li <colyli@suse.de>
Cc: Shile Zhang <shile.zhang@linux.alibaba.com>, Kent Overstreet <kent.overstreet@gmail.com>, linux-bcache@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-bcache@vger.kernel.org

On Thu, Mar 07, 2019 at 11:36:18PM +0800, Coly Li wrote:
> On 2019/3/7 11:06 下午, Shile Zhang wrote:
> > 
> > On 2019/3/7 18:34, Coly Li wrote:
> >> On 2019/3/7 1:15 下午, shile.zhang@linux.alibaba.com wrote:
> >>> From: Shile Zhang <shile.zhang@linux.alibaba.com>
> >>>
> >>> Read /sys/fs/bcache/<uuid>/cacheN/priority_stats can take very long
> >>> time with huge cache after long run.
> >>>
> >>> Signed-off-by: Shile Zhang <shile.zhang@linux.alibaba.com>
> >> Hi Shile,
> >>
> >> Do you test your change ? It will be helpful with more performance data
> >> (what problem that you improved).
> > 
> > In case of 960GB SSD cache device, once read of the 'priority_stats'
> > costs about 600ms in our test environment.
> > 
> 
> After the fix, how much time it takes ?
> 
> 
> > The perf tool shown that near 50% CPU time consumed by 'sort()', this
> > means once sort will hold the CPU near 300ms.
> > 
> > In our case, the statistics collector reads the 'priority_stats'
> > periodically, it will trigger the schedule latency jitters of the
> > 
> > task which shared same CPU core.
> > 
> 
> Hmm, it seems you just make the sort slower, and nothing more changes.
> Am I right ?

Well, it has to make the sort slower, but it'll also avoid hogging the
CPU (on a non-preemptible kernel), avoiding a potential soft lockup
warning and allowing other tasks to run.

-- 
Vojtech Pavlik
VP SUSE Labs
