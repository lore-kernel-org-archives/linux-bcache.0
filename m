Received: from mail-dl1-f73.google.com (mail-dl1-f73.google.com [74.125.82.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B04B23F871E
	for <linux-bcache@vger.kernel.org>; Wed, 17 Jun 2026 10:34:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.82.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781692462; cv=none; b=CSRgUiABiay3nEn7Q7/lCmWubh33AJ6w+Y8i/r9nE7lSdEB86qFNLChFMm5l9iIkQrMzrDmZny0jnvhlXXCek2MQXgEBHQ+GbF8wyEMXmTPKTan7TTc8QAFUJ0ubiUqCaVba2XVKTKxISWJt/R92RG4wWdWDOwzUdyQ2gkKCiuI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781692462; c=relaxed/simple;
	bh=O/BJrQ67R9Vbj5DZXVq/pjvAOoJcwUHZYtgK2g0yuu8=;
	h=Date:Mime-Version:Message-ID:Subject:From:To:Cc:Content-Type; b=Zp7PyM7DryuOUhT9nAScywl3P+z0JiJmGQDyp6kXIS9D2elMuINVmebEEEdvR1DLEoaCQSj+OfdnWRkdPGB0IbFMxmXjYpm2464Eh4iX+wKz2VVMjZS6tJXUjaWFD5J/hRS23FjO+MfkxrV6xXtZmdxSCJc2UvsEpqiJ14ozvKs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--ankitkap.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=isCTD+Ec; arc=none smtp.client-ip=74.125.82.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--ankitkap.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="isCTD+Ec"
Received: by mail-dl1-f73.google.com with SMTP id a92af1059eb24-138acbc0e69so8016149c88.0
        for <linux-bcache@vger.kernel.org>; Wed, 17 Jun 2026 03:34:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1781692460; x=1782297260; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:mime-version:date:from:to:cc:subject
         :date:message-id:reply-to;
        bh=JvA54ztKKAEJWoEFg+ZZGRyvpSIkmqZWAXwaNHlCzxE=;
        b=isCTD+EcUbcuBPyXYDBbCSX42yB3H3y0jPj4nkozOi4ifSrDsaFB6z5x/jRHmnwW6V
         7hN/7K02AP+SOj9cmabuXxbV7TWMeoDExIglYcH/+3EP01xU0dmmQFBVhM66RVeZxgWO
         enaQF3YysNyLvjdpVtfRufRX+rQ2CmNbYKw8d5BJJQZO/aNZhGB3rLK2jAuBtA8s6a03
         pD8KUcnzBKsG5ihJl/S8q/UuFGZB8LN9rXJnZNc60/XUDKTcp8KrUoBUC9PQFtESFgbx
         eJ8OHuogO62p4kuWsmKuaPWapceQDb91Yycr8Bh1ltq2FIq1iiwHNFl+If36ldetrnVN
         /10g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1781692460; x=1782297260;
        h=cc:to:from:subject:message-id:mime-version:date:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=JvA54ztKKAEJWoEFg+ZZGRyvpSIkmqZWAXwaNHlCzxE=;
        b=f9s+j8NCD9dhLh9JBAiO7ay7X+vuZLaJNxPjb2Kpi+hEtF8m7P4xL89IBG+1j9CCvP
         aaCPmCuWoU1Bwj60jw4TTuY9qvdcbHAWQJ1Ax/l4ByT5P9gIn55fgJb97Z2uUrculmQ2
         t40zCwI2bokGQNfjWlVOpdG929WQz3UToRNTnV6XCJJkeLXb6wuVR+itRx6Tvj1SseVi
         1kdcjPYc0XrZjOj88JQh12nslKqmJWwJ92q0FLZ1t58zxzlDq25SzHuVq7xk1vYKFamg
         Cl0W0NSAhdAvRiu4sbiQYA4krJb84HBGRNmR52bvwajEQ+sYEDkVsdNZJ5X0NhUi/ta7
         J/GQ==
X-Gm-Message-State: AOJu0Ywj889Ss2Dr/xpM4o0VZhFfL5WgkvglGmFm/qCIl7yuxZeeaf2r
	/NEJxiSuBvtE6riMKjay6WMBuen6mFxn5RAt96NGqumZ/4OiYJlcy25I5KawPJrrprU2FOrZUou
	NTUt5NFC7Iz8F9r+PYjLpVbUbsaLnO6Qnq39Q9WtcmiH7Yqb6qSBOqxr4PqtQu6LxtDDIJzFqM+
	y23fSlpsFRanPk84M+4nsvZrpPfTgxEcVGBozr3btLPrRbGR7Z0NNajuU=
X-Received: from dldoa11.prod.google.com ([2002:a05:701a:ca8b:b0:137:fdb1:854c])
 (user=ankitkap job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:7022:221e:b0:138:212b:705b with SMTP id a92af1059eb24-1398f6770bcmr1475581c88.12.1781692459305;
 Wed, 17 Jun 2026 03:34:19 -0700 (PDT)
Date: Wed, 17 Jun 2026 10:33:55 +0000
Precedence: bulk
X-Mailing-List: linux-bcache@vger.kernel.org
List-Id: <linux-bcache.vger.kernel.org>
List-Subscribe: <mailto:linux-bcache+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcache+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
X-Mailer: git-send-email 2.54.0.1136.gdb2ca164c4-goog
Message-ID: <20260617103356.3287775-1-ankitkap@google.com>
Subject: [PATCH v2 0/1] bcache: track active bypass writes to prevent stale
 cache reads
From: Ankit Kapoor <ankitkap@google.com>
To: linux-bcache@vger.kernel.org
Cc: colyli@fygo.io, kent.overstreet@linux.dev, linux-kernel@vger.kernel.org, 
	Ankit Kapoor <ankitkap@google.com>
Content-Type: text/plain; charset="UTF-8"

Hi Coly,

This is v2 of the patch to fix a race condition between read cache
misses and bypass writes. 

Changes in v2:
Instead of deferring key invalidation, we now explicitly track active
bypass writes using dynamically allocated pages (modeled closely after
md-bitmap.c as suggested by Coly). We use this tracking information
during cache miss reads to determine if the read must also bypass the
cache.

The active bypass writes are tracked by dividing the backing device
space into 32MB chunks and maintaining concurrent write refcounts. The
memory overhead is minimal; a single 4KB page covers 64 GB of backing
device space in the chosen approach.

Implementation Approaches Evaluated:
When designing this, we evaluated three synchronization approaches:
1. Global Spinlock
2. Page-level Spinlock (Chosen Approach)
3. Atomic Counters (Lockless)

Memory Consumption:

Idle Memory Usage (No active bypass writes)
Backing Disk Size | Global Lk | Page Lk | Atomic Counters
1 TB              | 256 bytes | 256 B   | 1 KB
10 TB             | 2.5 KB    | 2.5 KB  | 10 KB
100 TB            | 25 KB     | 25 KB   | 100 KB

Peak Memory Usage (Tracking pages fully allocated)
Backing Disk Size | Global Lk | Page Lk | Atomic Counters
1 TB              | 64.25 KB  | 64.25 KB| 257 KB
10 TB             | 642.5 KB  | 642.5 KB| 2.51 MB
100 TB            | 6.27 MB   | 6.27 MB | 25.10 MB

Performance Benchmarks (FIO):

Setup:
- CPU: 32 vCPU, Intel Cascade Lake x86_64 (n2-standard-32 GCP VM)
- Memory: 128 GB RAM
- OS: Linux 6.12.68 (Google COS)
- Storage: Google Cloud Extreme PD (1000 GB) + Local SSD (375 GB)

FIO config:
rw=randrw, bs=(R) 4096B-4096B, (W) 128KiB-128KiB, (T) 128KiB-128KiB,
ioengine=libaio, iodepth=32 - 16 jobs

10 GB file workload (1 tracking page active)
Metric       | Unpatch | Global Lk | Page Lk | Atomic  | Analysis
Read IOPS    | 20,977  | 20,897    | 20,900  | 20,886  | Almost flat
Write IOPS   | 8,993   | 8,956     | 8,956   | 8,951   | Almost flat
Total IOPS   | 29,971  | 29,853    | 29,856  | 29,836  | Almost flat
Avg R Lat    | 16.31ms | 16.66 ms  | 16.66 ms| 16.68 ms| Almost flat
Avg W Lat    | 18.94ms | 18.33 ms  | 18.34 ms| 18.34 ms| Almost flat
Kernel CPU % | 63.02   | 77.94     | 72.88   | 75.41   | Overhead
Avg Ker CPU% | 3.94    | 4.87      | 4.56    | 4.71    | Overhead
NVMe Util %  | 66.89   | 0.62      | 0.62    | 0.63    | Offld succs

320 GB file workload (5 tracking pages active)
Metric       | Unpatch | Global Lk | Page Lk | Atomic  | Analysis
Read IOPS    | 20,974  | 20,898    | 20,897  | 20,898  | Almost flat
Write IOPS   | 8,988   | 8,957     | 8,956   | 8,956   | Almost flat
Total IOPS   | 29,963  | 29,855    | 29,853  | 29,854  | Almost flat
Avg R Lat    | 16.54ms | 16.76 ms  | 16.78 ms| 16.76 ms| Almost flat
Avg W Lat    | 18.41ms | 18.11 ms  | 18.07 ms| 18.10 ms| Almost flat
Kernel CPU % | 70.39   | 70.70     | 60.85   | 62.20   | Scaled eff.
Avg Ker CPU% | 4.40    | 4.42      | 3.80    | 3.89    | Scaled eff.
NVMe Util %  | 67.74   | 0.66      | 0.61    | 0.62    | Offld succs

Rationale & Analysis:
1. Tracking Overhead: Implementing tracking inherently adds minor CPU
   overhead for smaller workloads. However, the chosen Page-level Lock
   minimizes this penalty.
2. Cache Device Offloading: The massive drop in NVMe cache utilization
   (67% to 0.6%) occurs because the reads are safely bypassing the
   cache instead of fetching and attempting to populate the cache with
   stale data.
3. Superior Scaling Under Load: For larger files (320GB), the added
   overhead of page tracking is more than compensated for by the saved
   cache update operations during reads.

Questions for Coly:
1. If `kzalloc` fails on the fast path in `bch_bypass_write_start()`,
   we currently skip incrementing the counter (leaving it untracked).
   This opens a tiny edge case (a "stolen increment"): if a concurrent
   bio successfully allocates the tracking page slightly later, the
   initially untracked bio will blindly decrement that counter in
   `bch_bypass_write_end()`. Because of the `> 0` check in
   `bch_bypass_write_end()`, this doesn't cause a true integer
   underflow, but it does prematurely drop the count to 0 (effectively
   stealing the track). `md-bitmap.c` solves similar issues via a
   hijacking fallback. Given that memory corruption is prevented by
   the `> 0` check, do you think a similar fallback mechanism is
   necessary here, or is the rate-limited warning and sysfs tracking
   sufficient given how rare `kzalloc` failures are for 4KB pages?

2. We currently use `u16` for the tracking counters. Since standard
   block layer queue depths rarely exceed a few thousand, a counter
   overflow (65,535 concurrent writes to the exact same 32MB chunk)
   seems practically impossible. However, if you'd prefer to be
   absolutely defensive against overflows without doubling the memory
   footprint to `u32`, I could clamp the counter at `U16_MAX` during
   increments. This would safely prevent wrap-around memory leaks
   while keeping our current memory efficiency. Would you prefer
   leaving it as is, clamping it, or bumping to `u32`?

Looking forward for your feedback on the changes.

Ankit Kapoor (1):
  bcache: track active bypass writes to prevent stale cache reads

 Documentation/admin-guide/bcache.rst |   8 ++
 drivers/md/bcache/bcache.h           |  35 +++++++
 drivers/md/bcache/request.c          | 132 +++++++++++++++++++++++++++
 drivers/md/bcache/stats.c            |  14 +++
 drivers/md/bcache/stats.h            |   4 +
 drivers/md/bcache/super.c            |  30 ++++++
 drivers/md/bcache/sysfs.c            |   5 +
 include/trace/events/bcache.h        |   5 +
 8 files changed, 233 insertions(+)

-- 
2.54.0.1136.gdb2ca164c4-goog

