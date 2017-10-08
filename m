From: Coly Li <i@coly.li>
Subject: Re: [PATCH v3 2/5] bcache: implement PI controller for writeback rate
Date: Sun, 8 Oct 2017 12:22:43 +0800
Message-ID: <6d3709a2-96a7-100e-a966-eeefc11dfd39@coly.li>
References: <20170927174122.30341-1-mlyle@lyle.org>
 <20170927174122.30341-3-mlyle@lyle.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Return-path: <linux-block-owner@vger.kernel.org>
In-Reply-To: <20170927174122.30341-3-mlyle@lyle.org>
Content-Language: en-US
Sender: linux-block-owner@vger.kernel.org
To: Michael Lyle <mlyle@lyle.org>
Cc: linux-bcache@vger.kernel.org, "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>
List-Id: linux-bcache@vger.kernel.org

On 2017/9/28 上午1:41, Michael Lyle wrote:
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
> 
> There is a slight difference from earlier versions of the patch in
> integral handling to prevent excessive negative integral windup.
> 
> Signed-off-by: Michael Lyle <mlyle@lyle.org>
> Reviewed-by: Coly Li <colyli@suse.de>


Hi Mike,

I am testing all the 5 patches these days for the writeback performance.
I just find when dirty number is much smaller then dirty target,
writeback rate is still maximum as 488.2M/sec.

Here is part of the output:

rate:		488.2M/sec
dirty:		91.7G
target:		152.3G
proportional:	-1.5G
integral:	10.9G
change:		0.0k/sec
next io:	0ms



rate:		488.2M/sec
dirty:		85.3G
target:		152.3G
proportional:	-1.6G
integral:	10.6G
change:		0.0k/sec
next io:	-7ms



rate:		488.2M/sec
dirty:		79.3G
target:		152.3G
proportional:	-1.8G
integral:	10.1G
change:		0.0k/sec
next io:	-26ms



rate:		488.2M/sec
dirty:		73.1G
target:		152.3G
proportional:	-1.9G
integral:	9.7G
change:		0.0k/sec
next io:	-1ms



rate:		488.2M/sec
dirty:		66.9G
target:		152.3G
proportional:	-2.1G
integral:	9.2G
change:		0.0k/sec
next io:	-66ms



rate:		488.2M/sec
dirty:		61.1G
target:		152.3G
proportional:	-2.2G
integral:	8.7G
change:		0.0k/sec
next io:	-6ms



rate:		488.2M/sec
dirty:		55.6G
target:		152.3G
proportional:	-2.4G
integral:	8.1G
change:		0.0k/sec
next io:	-5ms



rate:		488.2M/sec
dirty:		49.4G
target:		152.3G
proportional:	-2.5G
integral:	7.5G
change:		0.0k/sec
next io:	0ms



rate:		488.2M/sec
dirty:		43.1G
target:		152.3G
proportional:	-2.7G
integral:	7.0G
change:		0.0k/sec
next io:	-1ms



rate:		488.2M/sec
dirty:		37.3G
target:		152.3G
proportional:	-2.8G
integral:	6.3G
change:		0.0k/sec
next io:	-2ms



rate:		488.2M/sec
dirty:		31.7G
target:		152.3G
proportional:	-3.0G
integral:	5.6G
change:		0.0k/sec
next io:	-17ms

The backing cached device size is 7.2TB, cache device is 1.4TB, block
size is 8kB only. I write 700G (50% of cache device size) dirty data
onto the cache device, and start writeback by echo 1 to
writeback_running file.

In my test, writeback spent 89 minutes to decrease dirty number from
700G to 147G (dirty target number is 152G). At this moment writeback
rate was still displayed as 488.2M/sec. And after 22 minutes writeback
rate jumped to 4.0k/sec. During the 22 minutes, (147-15.8=) 131.2G dirty
data written out.

Is it as expected ?

Thanks.

-- 
Coly Li
