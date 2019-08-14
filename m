From: Heitor Alves de Siqueira <halves@canonical.com>
Subject: Re: [PATCH] bcache: add cond_resched() in __bch_cache_cmp()
Date: Wed, 14 Aug 2019 11:23:01 -0300
Message-ID: <20190814142301.32556-1-halves@canonical.com>
References: <c13b1d2a-a8e6-f20c-604e-a375c018bf66@suse.de>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <c13b1d2a-a8e6-f20c-604e-a375c018bf66@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
To: colyli@suse.de
Cc: kent.overstreet@gmail.com, linux-bcache@vger.kernel.org, linux-kernel@vger.kernel.org, shile.zhang@linux.alibaba.com, vojtech@suse.com
List-Id: linux-bcache@vger.kernel.org

Hi Coly,

We've had users impacted by system stalls and were able to trace it back to the
bcache priority_stats query. After investigating a bit further, it seems that
the sorting step in the quantiles calculation can cause heavy CPU
contention. This has a severe performance impact on any task that is running in
the same CPU as the sysfs query, and caused issues even for non-bcache
workloads.

We did some test runs with fio to get a better picture of the impact on
read/write workloads while a priority_stats query is running, and came up with
some interesting results. The bucket locking doesn't seem to have that
much performance impact even in full-write workloads, but the 'sort' can affect
bcache device throughput and latency pretty heavily (and any other tasks that
are "unlucky" to be scheduled together with it). In some of our tests, there was
a performance reduction of almost 90% in random read IOPS to the bcache device
(refer to the comparison graph at [0]). There's a few more details on the
Launchpad bug [1] we've created to track this, together with the complete fio
results + comparison graphs.

The cond_resched() patch suggested by Shile Zhang actually improved performance
a lot, and eliminated the stalls we've observed during the priority_stats
query. Even though it may cause the sysfs query to take a bit longer, it seems
like a decent tradeoff for general performance when running that query on a
system under heavy load. It's also a cheap short-term solution until we can look
into a more complex re-write of the priority_stats calculation (perhaps one that
doesn't require the locking?). Could we revisit Shile's patch, and consider
merging it?

Thanks!
Heitor

[0] https://people.canonical.com/~halves/priority_stats/read/4k-iops-2Dsmooth.png
[1] https://bugs.launchpad.net/bugs/1840043
