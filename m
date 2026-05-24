Received: from va-2-36.ptr.blmpb.com (va-2-36.ptr.blmpb.com [209.127.231.36])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1EA6E3A7F66
	for <linux-bcache@vger.kernel.org>; Sun, 24 May 2026 16:13:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.127.231.36
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779639199; cv=none; b=MocgnjR3rJVD0GVtAsMcK++3as6M8fMO+O4VOrH8rxpjM5hsuxlALa1aM19SlbPrDvGuZd4261foHztEfFI+FTLxhJdAsFDGQH1rqVJ4x4ZmwohiEQ8r1G/BssWI7RGmX6g/JCojq2JZskVcgd0eQpw301DVUTeql6x+PY0EPiU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779639199; c=relaxed/simple;
	bh=sjMJVGOWPvVgHOtlj65ii+D+LhAMduYVx4ZiWzf8a8A=;
	h=Mime-Version:From:Content-Disposition:References:To:Date:
	 Message-Id:Content-Type:Cc:Subject:In-Reply-To; b=O/OipNVEMINJQhpwXfQiE0eKqWkU13PoiTzLkbCa43JgsaM/E6OMVJUq9DTYtbry9l4SzS1HtJS56U2dXTXASQZF91TtSLckDFLEljrfctdnURoUDoSoG1HCgIiEpRt55eu8VPJuuYtKr/2ypSxvlVysKFngF0G3lubqY3FGBz0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=fnnas.com; spf=none smtp.mailfrom=fnnas.com; dkim=pass (2048-bit key) header.d=fnnas-com.20200927.dkim.feishu.cn header.i=@fnnas-com.20200927.dkim.feishu.cn header.b=w0dRuKeG; arc=none smtp.client-ip=209.127.231.36
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=fnnas.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=fnnas.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=fnnas-com.20200927.dkim.feishu.cn header.i=@fnnas-com.20200927.dkim.feishu.cn header.b="w0dRuKeG"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
 s=s1; d=fnnas-com.20200927.dkim.feishu.cn; t=1779639177;
  h=from:subject:mime-version:from:date:message-id:subject:to:cc:
 reply-to:content-type:mime-version:in-reply-to:message-id;
 bh=1rLzvHSzdH/mUg79/n60/P1xpTLbc2cGco0IQzakcCs=;
 b=w0dRuKeGSVE++qhE+pR2HWV+HgrZUk2Uz58F2VAmR4w1ci/swQ8ICqeOEdrFk6BbwQy00W
 d4OVNF5/eiXHX3Ku092qgwTuhnQeMctrYyCEdEVU+yyWdmREFCBynMGv+qKFYQDAU0hzZl
 VfzDZu313FpRDZWOFAIA/ymr4SK5Njb6zKQlA3BSRn1wxk2aiH80BnE00+sGEFDJRL/qwf
 MYzFY0Zxx+80YPgcxGDhd/DgoVuOPpfKSvOl4rZ9hGVLK5RXbajqrs1QP5HYwinqP2Zyve
 buIMUe1hVx1CgpoO9y3ToCQfqcM9OpghJTt5LaAW4wvWTim8umm2YTcqkNv07A==
Precedence: bulk
X-Mailing-List: linux-bcache@vger.kernel.org
List-Id: <linux-bcache.vger.kernel.org>
List-Subscribe: <mailto:linux-bcache+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcache+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
X-Original-From: Coly Li <colyli@fnnas.com>
Content-Transfer-Encoding: 7bit
From: "Coly Li" <colyli@fnnas.com>
X-Lms-Return-Path: <lba+26a132387+a0d56c+vger.kernel.org+colyli@fnnas.com>
Received: from studio.local ([120.245.64.106]) by smtp.feishu.cn with ESMTPS; Mon, 25 May 2026 00:12:54 +0800
Content-Disposition: inline
References: <20260521163925.178264-1-ankitkap@google.com>
To: "Ankit Kapoor" <ankitkap@google.com>
Date: Mon, 25 May 2026 00:12:53 +0800
Message-Id: <ahMi6qmGtJsf1X03@studio.local>
Content-Type: text/plain; charset=UTF-8
Cc: "Kent Overstreet" <kent.overstreet@linux.dev>, 
	<linux-bcache@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 0/1] bcache: fix stale data race between read cache miss and bypass write
In-Reply-To: <20260521163925.178264-1-ankitkap@google.com>

On Thu, May 21, 2026 at 04:39:24PM +0800, Ankit Kapoor wrote:

Hi Ankit,

From your description and analysis, I feel this is a real issue.
Let me understand this deeper and response you later.

Thanks.

Coly Li

> Overview
> --------
> This series addresses a cache inconsistency issue with stale data in bcache
> that arises from a race condition between a read cache miss and a bypass 
> write due to congestion or sequential cutoff. The fix involves sequencing 
> the btree invalidation of the bypass write to occur strictly after the 
> backing device write.
> 
> Race Analysis
> -------------
> The following sequence illustrates how stale data is cached after a read
> cache miss when btree invalidation of a bypass write happens in parallel
> with a delayed write to the backing device:
> 
> Write IO Path (Parallel)            Read IO Path
> ------------------------            ------------
>            |
>  [Btree Invalidation]
>            |
>            |                      [Cache Miss]
>            |                           |
>            |                     [Btree Placeholder Key Insertion]
>            |                           |
>  (Delay in writing                     |
>  to the backing device)                |
>            |                     [Cache data from the backing device]
>            |                           |
>            +-------------------------->|  <-- No key collision detected!
>            |                      [Btree Placeholder Key Replacement]
>            |                           |
>     [Write to the                      |
>     backing device]                -------------
>                                  CRITICAL BUG:
>                              Stale data gets cached
> 
> Reproduction Steps
> ------------------
> The bug can be reliably reproduced by injecting a 5-second delay into
> the backing device write path via dm-delay. Cache mode is set to
> writearound to simulate bypass write.
> 
> 1. Data Preparation:
>   # printf -- '%.0s\0' {1..4096} > /tmp/0.txt
>   # printf -- '%.0s\1' {1..4096} > /tmp/1.txt
>   # echo writearound > /sys/block/bcache0/bcache/cache_mode
>   # dd if=/tmp/0.txt of=/media/bcache/data.txt oflag=direct \
>     bs=4096 count=1 conv=notrunc
> 
> 2. Race Execution:
>   # dd if=/tmp/1.txt of=/media/bcache/data.txt oflag=direct \
>     bs=4096 count=1 conv=notrunc &
>   # sleep 1
>   # dd if=/media/bcache/data.txt iflag=direct bs=4096 count=1 \
>     status=none | hexdump > ./concurrent-read-result
>   # sleep 10
>   # dd if=/media/bcache/data.txt iflag=direct bs=4096 count=1 \
>     status=none | hexdump > ./second-read-result
> 
> 3. Results (Without Patch):
>   # cat second-read-result
>   0000000 0000 0000 0000 0000 0000 0000 0000 0000  # <--- STALE READ
> 
> Proposed Fix
> ------------
> The fix enforces strict total (sequential) order of btree invalidation
> after write to the backing device in a bypass write:
> 
> OLD FLOW                                          NEW FLOW
> -------------------------------       --------------------------------
>         [ Write Start ]                       [ Write Start ]
>                |                                     |
>        +-------+-------+                             |
>        |               |                             v
>        v               v                    [     Write to   ]
>  [    Btree     ] [   Write to    ]         [ backing-device ]
>  [ Invalidation ] [ backing-device]                  |
>        |               |                             v
>        +-------+-------+                    [      Btree     ]
>                |                            [  Invalidation  ]
>                v                                     |
>          [ Write End ]                               v
>                                                [ Write End ]
> 
> Enforcing this sequential execution ensures that either:
> 1. A stale read is followed and invalidated by the deferred write
>    invalidation flow.
> 2. The write invalidation executes first, forcing the subsequent read
>    path's key replacement sequence to properly catch the collision.
> 
> Failure Handling
> ----------------
> This patch keeps existing error-handling behavior intact. Although
> execution is now sequential, btree invalidation is still triggered
> regardless of whether the write to the backing device succeeds
> or fails.
> 
> Verification and Performance
> ----------------------------
> Manual Results (With Patch):
>   # cat second-read-result
>   0000000 0101 0101 0101 0101 0101 0101 0101 0101  # <--- CORRECT DATA
> 
> Stress Verification:
> FIO was executed under a write-only workload (128 KB Write, libaio,
> iodepth=64, direct=1). Without the patch, FIO reported CRC errors
> due to stale read corruptions; with the patch, zero CRC errors or
> corruptions were reported.
> 
> Write-Only Workload (FIO Averages CSV):
> Metric,With Fix,Without Fix,Delta
> 
> Write IOPS,1630,1630,0.00%
> Write Bandwidth (MiB/s),204,204,0.00%
> Write Avg Latency (micro second),39219.95,39219.58,0.00%
> 
> Test Environment
> ----------------
> - CPU: 1 vCPU, Intel Haswell x86_64 (n1-standard-1 instance)
> - Memory: 3.75 GB RAM
> - OS: Linux 6.12.68 (Google COS)
> - Storage: Google Cloud SSD PD + Local SSD
> 
> Ankit Kapoor (1):
>   bcache: fix stale data race between read cache miss and bypass write
> 
>  drivers/md/bcache/request.c | 13 +++++++++++++
>  1 file changed, 13 insertions(+)
> 
> -- 
> 2.54.0.669.g59709faab0-goog
