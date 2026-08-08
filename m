Received: from mail-pl1-f200.google.com (mail-pl1-f200.google.com [209.85.214.200])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3D69A1EE7C6
	for <linux-bcache@vger.kernel.org>; Sat,  8 Aug 2026 04:06:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.200
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786161970; cv=none; b=QBbWI4pWEjqHtREmgjkQQTnPOx3FRR+C4JKVLmBJBgju68ox/iFOw2udMuFc5zoSMLTN9Fmayj8mQcXvaNG1T+Zmusc4Lk7wRhjcMyZsOQ2/4w4NfH1sm8kxC0ylsjurGGbBhoJD1nXPfW6oViBp5HAt3nY5BfgLfUZZ60i+2Kw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786161970; c=relaxed/simple;
	bh=CM9eATT97Ldk3iC2huT05hh5qkvflunWlUqXFDIpJNs=;
	h=Date:Mime-Version:Message-ID:Subject:From:To:Cc:Content-Type; b=rwzygLjcPyKeI1u1OPj4x559oLSlNXUJKfwvDzDy1bXbPGvE9BJpl4zmj3xcaCApKHdKwirlcQRX8Ms7LtWP1M0tc8qOLNdJd8y0h6+g5fKpAsY5Oebr0Uep4BCyzU1GTbCoVuMDuA+07DLdB5M+qMQZHkMzKw4VwwDjvlQoQ1o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--ankitkap.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=X75l5hXy; arc=none smtp.client-ip=209.85.214.200
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--ankitkap.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="X75l5hXy"
Received: by mail-pl1-f200.google.com with SMTP id d9443c01a7336-2cee1ec30f2so3100285ad.3
        for <linux-bcache@vger.kernel.org>; Fri, 07 Aug 2026 21:06:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1786161968; x=1786766768; darn=vger.kernel.org;
        h=content-type:cc:to:from:subject:message-id:mime-version:date:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=wd9Rr7aX5D5KJrDnty+QbnhM2Ku0xbmgni13VvdyC9M=;
        b=X75l5hXyw9wHPOItFUsbvmJzNxnSDDXSQ7rmK81ULsF6cIACZAOEanVLsXkivZqmdg
         24X/O81GvS4WeNOAwZMop2VoToC5ks5ckZ8MdJPtAcIR5DnA1GGz2Xr+TAgQbFfZf5pR
         GyR8piGgjBydVf8MmNfXXu67cV/7HnyyeXR8tm80uksU2mUpSKG6CmudiyBXcKiPfyYi
         MYJjhT9eAt8G62xKEZB8qRQyr5qvBggOBb3sU6iP9jwP2QcCDOixyW9pMn4+PQ9vVl5l
         oIfUfbFSi9kYSg7H0nAEupZivOe8i4Mmwdg1v2oqGzlZSm9ENtC8+6w/1fPvYfv1s1J6
         S6nQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1786161968; x=1786766768;
        h=content-type:cc:to:from:subject:message-id:mime-version:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=wd9Rr7aX5D5KJrDnty+QbnhM2Ku0xbmgni13VvdyC9M=;
        b=MglX6yzHST7VEtXGhBP1HFF3AVWebu15kJEpalJwfaE1l+YRto4zxjMaOgth3ToEDC
         zQD4fG/psKlSx/PkU+0AtMS4fONGPwkBUH2OKjJS3J1DrA87g5VO4rkgBFmjXHbCpmxz
         ExHHmu0tmzluQHLgaFsGIbmpTvstxhdJZ+QqoTALFP67OCS//q4Gxx20UJ5btBrwQnjJ
         ziXn0igR4fa2QdO0erbAbTTAadAf91nQP3dcrW++8B05D9KxFltEK32M6/q+zQ1Jk8FF
         CkqzozYewWwrUIh3ov3vynTpd0wkhoKV0wdFU9s9lJHL84QaK9AlAHPXTC/dSDrMFog+
         Td6A==
X-Forwarded-Encrypted: i=1; AHgh+Ror/wYdaU55HuYGiTLAPBAvCFeuTb2m69AUSWC1xBl6eC6MQLnI9iANQy4yrBTw1PBCFj3QaT8Z0r5fqts=@vger.kernel.org
X-Gm-Message-State: AOJu0YxYDiqg8xaOb91A2xc2d7R119BZTQZPLQQ6JNJEcGnGI6TxFyCQ
	oaluHOupe2oS0ej32QDhxldDa1D9JhDK+CHIDgmQC4ltryTEONnvoPWHcD8z6PNgZ05yGSCR7Xh
	B00BNDx3bxkREPw==
X-Received: from plca7.prod.google.com ([2002:a17:903:4687:b0:2cc:8e87:df3c])
 (user=ankitkap job=prod-delivery.src-stubby-dispatcher) by
 2002:a17:902:c410:b0:2cf:ca89:499d with SMTP id d9443c01a7336-2d2a88834f2mr62690995ad.7.1786161968348;
 Fri, 07 Aug 2026 21:06:08 -0700 (PDT)
Date: Sat,  8 Aug 2026 04:05:47 +0000
Precedence: bulk
X-Mailing-List: linux-bcache@vger.kernel.org
List-Id: <linux-bcache.vger.kernel.org>
List-Subscribe: <mailto:linux-bcache+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcache+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
X-Mailer: git-send-email 2.55.0.679.g6767b8d81c-goog
Message-ID: <20260808040549.2778125-1-ankitkap@google.com>
Subject: [PATCH v3 0/2] bcache: track active bypass writes to fix read miss race
From: Ankit Kapoor <ankitkap@google.com>
To: Coly Li <colyli@fygo.io>, linux-bcache@vger.kernel.org
Cc: Kent Overstreet <kent.overstreet@linux.dev>, linux-kernel@vger.kernel.org, 
	Ankit Kapoor <ankitkap@google.com>
Content-Type: text/plain; charset="UTF-8"

This is the v3 patch series to fix a race condition between read cache
misses and bypass writes in bcache.

This patch series fixes the race condition through two complementary
mechanisms split across two logical patches:

1. [PATCH v3 1/2]: bcache: track active bypass writes to fix read miss race
   - Dynamically tracks active bypass writes across the backing device
     using 32MB chunks and refcounted pages (a single 4KB page covers
     32GB of disk).
   - On a read cache miss, bcache checks for overlapping active bypass
     writes and forces the read to bypass the cache if a collision is
     detected.
   - Serializes btree key invalidation so it executes in
     cached_dev_write_complete() after the payload reaches the disk,
     preventing early invalidations from opening a race window.
   - Resilient memory management: counter pages are backed by a
     dedicated 16-page mempool to guarantee forward progress under
     severe memory pressure, and the top-level array is allocated via
     kvcalloc() to reliably support very large backing devices.

2. [PATCH v3 2/2]: bcache: inspect active bypass writes lock-free via RCU
   - Optimizes the cache miss read path by inspecting active bypass
     counters lock-free under RCU (rcu_read_lock / rcu_dereference),
     removing spinlock contention from latency-sensitive reads.
   - Writers continue to use localized page-level spinlocks to
     synchronize counter updates and mempool allocations.

Changes since v2:
Link: https://lore.kernel.org/linux-bcache/20260617103356.3287775-1-ankitkap@google.com/

Patch 1 (Core Tracking):
 - Upgraded chunk counters from u16 to u32 to prevent any possibility
   of counter overflow under extreme IO concurrency.
 - Replaced GFP_KERNEL/fallback allocations with a dedicated 16-page
   mempool (mempool_alloc with GFP_NOIO), guaranteeing that bypass
   tracking never fails under memory pressure and eliminating the need
   for untracked fallbacks.
 - Used kvcalloc() for the top-level page array to support massive
   backing devices without requiring large contiguous physical
   allocations.
 - Removed debug sysfs counters and tracepoints to keep the patch
   footprint minimal and focused on the core synchronization. These
   can be added in a follow-up patch.

Patch 2 (RCU Optimization):
 - Introduced this entirely new modular commit to separate the lock-free
   read path optimization from the core race synchronization logic.

Memory Consumption:
Note: An additional 16-page mempool standby reserve is maintained
(4 KB/page for Spinlock, ~4.1 KB/page for RCU).

Idle Memory Consumption (Zero active bypass writes)
Backing Disk Size  | Spinlock         | RCU
1 TB               | 0.5 KB           | 0.5 KB
10 TB              | 5.0 KB           | 5.0 KB
100 TB             | 50.0 KB          | 50.0 KB

Peak Memory Consumption (All tracking pages allocated)
Backing Disk Size  | Spinlock         | RCU
1 TB               | 128.5 KB         | ~140.0 KB
10 TB              | 1.28 MB          | ~1.4 MB
100 TB             | 12.5 MB          | ~14.0 MB

Setup:
 - CPU: 32 vCPU, Intel Cascade Lake x86_64 (n2-standard-32 GCP VM)
 - Memory: 128 GB RAM
 - OS: Linux 6.12.94 (Google COS)
 - Storage: Google Cloud Extreme PD (1000 GB) + Local SSD (375 GB)

Performance Results

FIO config:
rw=randrw, bs=(R) 4096B-4096B, (W) 128KiB-128KiB, (T) 128KiB-128KiB,
ioengine=libaio, iodepth=32

NVMe SSD - 10 GB Working Set with 16 FIO jobs (1 active tracking page)
Metric                 | Baseline | Patch 1 (Spinlock) | Patch 2 (RCU)
Read IOPS              | 20,945   | 20,832             | 20,839
Write IOPS             | 8,978    | 8,936              | 8,935
Total IOPS             | 29,923   | 29,769             | 29,775
Avg Read Lat (ns)      | 33,292   | 33,858             | 33,871
Avg Write Lat (ns)     | 36,478   | 35,752             | 35,693
Agg Kernel CPU (sys %)*| 48.62%   | 50.80%             | 48.46%
NVMe Utilization       | 70.38%   | 44.29%             | 44.44%
*Note: Kernel CPU reported as aggregate across cores (~3% per core).

NVMe SSD - 320 GB Working Set with 16 FIO jobs (10 tracking pages)
Metric                 | Baseline | Patch 1 (Spinlock) | Patch 2 (RCU)
Read IOPS              | 20,968   | 20,955             | 20,959
Write IOPS             | 8,983    | 8,982              | 8,983
Total IOPS             | 29,951   | 29,937             | 29,942
Avg Read Lat (ns)      | 33,484   | 33,509             | 33,524
Avg Write Lat (ns)     | 35,932   | 35,926             | 35,884
Agg Kernel CPU (sys %)*| 52.54%   | 50.84%             | 52.15%
NVMe Utilization       | 68.11%   | 67.26%             | 69.00%
*Note: Kernel CPU reported as aggregate across cores (~3% per core).

Analysis
Active bypass write tracking shows no measurable performance
degradation on real NVMe storage hardware. While a minor NVMe
utilization dip is observed on small working sets (10 GB), device
utilization remains completely normal on larger, realistic workloads
(320 GB).

Comparing RCU and Spinlock

Because physical NVMe hardware latency masks microsecond-level software
differences, we also benchmarked against a zero-latency null block
device (null_blk) at 64 jobs to remove the hardware bottleneck and
isolate true block-layer locking overhead.

Null Device (null_blk) - 10 GB Working Set with 64 FIO jobs
Metric                 | Baseline | Patch 1 (Spinlock) | Patch 2 (RCU)
Read IOPS              | 64,296   | 58,394             | 58,962
Write IOPS             | 27,551   | 25,012             | 25,267
Total IOPS             | 91,847   | 83,406             | 84,229
Avg Read Lat (ns)      | 45,463   | 50,104             | 49,678
Avg Write Lat (ns)     | 45,362   | 50,451             | 50,025
Agg Kernel CPU (sys %)*| 2119.08% | 2830.73%           | 2838.42%
NVMe Utilization       | 0.00%    | 0.00%              | 0.00%
*Note: Kernel CPU reported as aggregate across 64 threads (~44%/core).

Why Patch 2 (RCU Read-Path Optimization)?
While the absolute throughput improvement on our 32-core test system
is modest (~1.0% / +823 IOPS and ~426 ns lower latency in a 64-job
null_blk stress test), the primary motivation for Patch 2 is to maintain
a lock-free read path and improve scalability on higher-core-count
servers.

Thanks,
Ankit

Ankit Kapoor (2):
  bcache: track active bypass writes to fix read miss race
  bcache: inspect active bypass writes lock-free via RCU

 drivers/md/bcache/bcache.h  |  43 ++++++++++
 drivers/md/bcache/request.c | 151 +++++++++++++++++++++++++++++++++++-
 drivers/md/bcache/super.c   |  42 ++++++++++
 3 files changed, 233 insertions(+), 3 deletions(-)

-- 
2.55.0.679.g6767b8d81c-goog

