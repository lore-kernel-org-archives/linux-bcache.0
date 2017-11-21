From: Kent Overstreet <kent.overstreet@gmail.com>
Subject: Re: [PATCH] bcache: add a separate open bucket list for flash devices
Date: Tue, 21 Nov 2017 17:16:04 -0500
Message-ID: <20171121221604.ozk4va5tfqlsyu7u@moria.home.lan>
References: <1511261432-8578-1-git-send-email-tang.junhui@zte.com.cn>
 <20171121105752.yy7krolo4dx75bte@moria.home.lan>
 <3179102c-26c9-0519-854c-b0bec6cb9241@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-block-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <3179102c-26c9-0519-854c-b0bec6cb9241@suse.de>
Sender: linux-block-owner@vger.kernel.org
To: Coly Li <colyli@suse.de>
Cc: tang.junhui@zte.com.cn, mlyle@lyle.org, linux-bcache@vger.kernel.org, linux-block@vger.kernel.org
List-Id: linux-bcache@vger.kernel.org

On Tue, Nov 21, 2017 at 10:48:27PM +0800, Coly Li wrote:
> On 21/11/2017 6:57 PM, Kent Overstreet wrote:
> > On Tue, Nov 21, 2017 at 06:50:32PM +0800, tang.junhui@zte.com.cn wrote:
> >> From: Tang Junhui <tang.junhui@zte.com.cn>
> >>
> >> Currently in pick_data_bucket(), though we keep multiple buckets open
> >> for writes, and try to segregate different write streams for better
> >> cache utilization: first we look for a bucket where the last write to
> >> it was sequential with the current write, and failing that we look
> >> for a bucket that was last usedby the same task.
> >>
> >> But actually, in such scenario that there are some flash devices
> >> , and some backend bcache devices, when many tasks request these
> >> flash devices and backend bcache devices, the write IOs may still
> >> fall to the same bucket as bellow bucket:
> >> | bcache data | flash data | bcache data | bcache data| flash data|
> >> then after writeback of these backend bcache devices, the bucket would
> >> be like bellow bucket:
> >> | free | flash data | free | free | flash data |
> > 
> > This patch doesn't make any sense - open_buckets are only for allocations and
> > writes to the SSD.
> > 
> 
> Hi Kent,
> 
> I feel the purpose for this patch is to make flash only volume occupy as
> less buckets as possible. Because dirty sectors of flash only volume is
> not reclaimable, if their dirty sectors mixed with dirty sectors of
> cached device, such buckets will be marked as dirty and won't be reclaimed.

If that's the goal the way to do it would be to segregate the write points, not
the open buckets.
