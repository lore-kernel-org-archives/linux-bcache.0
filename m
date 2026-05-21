Received: from mail-pf1-f201.google.com (mail-pf1-f201.google.com [209.85.210.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3F77F37DADE
	for <linux-bcache@vger.kernel.org>; Thu, 21 May 2026 16:39:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779381571; cv=none; b=hZBTz7CpOe4xLrTJLtShYZwe9WpcDM2q93VTBocqsGy4O8XezKmsaTWeKRsAJnzqLs/aNOVKd9BTurHcVwdiSKfYrF+cDTu7GEUrXPYVgNzz7SRzFM8BRhTkFdeLSeAv5YjtGeJQ6YSSbGm/M0X5cArSxm4tjJbFesSFAvZZoRs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779381571; c=relaxed/simple;
	bh=HGxpQrZgHeZ5XdWo8XrXJ61+T9wEQlIAhOCfy1noM/g=;
	h=Date:Mime-Version:Message-ID:Subject:From:To:Cc:Content-Type; b=gzZcOCRm7hCinEep98GFZQ/RKuFphPHlu+2+nguazyfBUh4fyisSAwvvcW21DXQu7zEU564IPm7W7CdS/j63P31JSPabZ5aT4NNDdgCnzGx4XwwQQ0QqF63ughxWCPjiMCUO5dVLam+Mgn3BHj3hjeowtNKAfNk5ehSz7BhlffY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--ankitkap.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=uNlltK1g; arc=none smtp.client-ip=209.85.210.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--ankitkap.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="uNlltK1g"
Received: by mail-pf1-f201.google.com with SMTP id d2e1a72fcca58-8353fbc7ad5so3208290b3a.3
        for <linux-bcache@vger.kernel.org>; Thu, 21 May 2026 09:39:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1779381570; x=1779986370; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:mime-version:date:from:to:cc:subject
         :date:message-id:reply-to;
        bh=LJIt57Y7zAQuOXmjePQBHdZGtC9uhpS/FVTvnHMcie8=;
        b=uNlltK1g0KMF+z3FEgzUEiftX0kUvTGc1NEyjmG7htrwtf5sws2AZlJgbliGrwKAkr
         dLVBSoy4OSeDeq9AV+Rcp7MaA2x0r6mCMHDsbFaU8kLnvM8KxcRDivCGHou0Sz6KbB9P
         F3eADleXtF3b0A9EPhVdh4ckwsIuALofqPqtZztPnk9gQnrTO/fU6K5aRfZwDR5hfQa4
         TWg/QYhUvXKbCQAYUWqy8F/Ogm+F8E3ThUPZjiNPwrYPa2txe348XvHpTzhRP6nzSYtR
         PnthioSx9X0K1ZoVJMny4hzDhoRkeSnvFRQRutgOnH8hD/2sE/p5Jdl9rcABgeSgiwy1
         /lDw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1779381570; x=1779986370;
        h=cc:to:from:subject:message-id:mime-version:date:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=LJIt57Y7zAQuOXmjePQBHdZGtC9uhpS/FVTvnHMcie8=;
        b=ne+Qsyyqju2Vh4HmWURxAc40xKXZMLygoz24trWpjhPbQrlipSZZL3YJafmDsejmyc
         sEp9ZjqJ3/7SqaHqfif6WqENZRAMS5NccXHMFPBcETyG4UxFVVut0lbMUWt00zjAHYnQ
         ly4aBvsY+6pnsRWf/VS+kK//VxKSMt8/oKY1oS4vWZfjSnxf5tELCzfpZCUSE9Yh14pc
         Av9ET+x5AUQmcdbpSAxrlfFidgRR3j524O1VW4XgdRr6cdFpkxKrc9Z2wdksO9F7V/hK
         K1kUoQtADe0Noy12D1aNPQYqJSYnrfb7ZMXk73KbKfJr/G4D/muqpnwtDcH54IgHUupY
         fEug==
X-Gm-Message-State: AOJu0YxpasG3PTqOiMDa4WX5Rdr4FYdcSpjuACYJAYcIlPsB8sHPXaxs
	wNaeyT8c2jjBloL5JOHoyJ7iiEC1LydNpCGO1cXzhNa4297mLHovXogaSO9rcuHK0mqIzeBPE7x
	ziJ+qpmDUikM8cQ==
X-Received: from pfiy2.prod.google.com ([2002:a05:6a00:1902:b0:82f:71fd:3094])
 (user=ankitkap job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:6a00:438b:b0:82c:9f7e:518c with SMTP id d2e1a72fcca58-8415f32e17amr55159b3a.25.1779381569336;
 Thu, 21 May 2026 09:39:29 -0700 (PDT)
Date: Thu, 21 May 2026 16:39:24 +0000
Precedence: bulk
X-Mailing-List: linux-bcache@vger.kernel.org
List-Id: <linux-bcache.vger.kernel.org>
List-Subscribe: <mailto:linux-bcache+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcache+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
X-Mailer: git-send-email 2.54.0.669.g59709faab0-goog
Message-ID: <20260521163925.178264-1-ankitkap@google.com>
Subject: [PATCH 0/1] bcache: fix stale data race between read cache miss and
 bypass write
From: Ankit Kapoor <ankitkap@google.com>
To: Coly Li <colyli@fnnas.com>, Kent Overstreet <kent.overstreet@linux.dev>
Cc: linux-bcache@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Ankit Kapoor <ankitkap@google.com>
Content-Type: text/plain; charset="UTF-8"

Overview
--------
This series addresses a cache inconsistency issue with stale data in bcache
that arises from a race condition between a read cache miss and a bypass 
write due to congestion or sequential cutoff. The fix involves sequencing 
the btree invalidation of the bypass write to occur strictly after the 
backing device write.

Race Analysis
-------------
The following sequence illustrates how stale data is cached after a read
cache miss when btree invalidation of a bypass write happens in parallel
with a delayed write to the backing device:

Write IO Path (Parallel)            Read IO Path
------------------------            ------------
           |
 [Btree Invalidation]
           |
           |                      [Cache Miss]
           |                           |
           |                     [Btree Placeholder Key Insertion]
           |                           |
 (Delay in writing                     |
 to the backing device)                |
           |                     [Cache data from the backing device]
           |                           |
           +-------------------------->|  <-- No key collision detected!
           |                      [Btree Placeholder Key Replacement]
           |                           |
    [Write to the                      |
    backing device]                -------------
                                 CRITICAL BUG:
                             Stale data gets cached

Reproduction Steps
------------------
The bug can be reliably reproduced by injecting a 5-second delay into
the backing device write path via dm-delay. Cache mode is set to
writearound to simulate bypass write.

1. Data Preparation:
  # printf -- '%.0s\0' {1..4096} > /tmp/0.txt
  # printf -- '%.0s\1' {1..4096} > /tmp/1.txt
  # echo writearound > /sys/block/bcache0/bcache/cache_mode
  # dd if=/tmp/0.txt of=/media/bcache/data.txt oflag=direct \
    bs=4096 count=1 conv=notrunc

2. Race Execution:
  # dd if=/tmp/1.txt of=/media/bcache/data.txt oflag=direct \
    bs=4096 count=1 conv=notrunc &
  # sleep 1
  # dd if=/media/bcache/data.txt iflag=direct bs=4096 count=1 \
    status=none | hexdump > ./concurrent-read-result
  # sleep 10
  # dd if=/media/bcache/data.txt iflag=direct bs=4096 count=1 \
    status=none | hexdump > ./second-read-result

3. Results (Without Patch):
  # cat second-read-result
  0000000 0000 0000 0000 0000 0000 0000 0000 0000  # <--- STALE READ

Proposed Fix
------------
The fix enforces strict total (sequential) order of btree invalidation
after write to the backing device in a bypass write:

OLD FLOW                                          NEW FLOW
-------------------------------       --------------------------------
        [ Write Start ]                       [ Write Start ]
               |                                     |
       +-------+-------+                             |
       |               |                             v
       v               v                    [     Write to   ]
 [    Btree     ] [   Write to    ]         [ backing-device ]
 [ Invalidation ] [ backing-device]                  |
       |               |                             v
       +-------+-------+                    [      Btree     ]
               |                            [  Invalidation  ]
               v                                     |
         [ Write End ]                               v
                                               [ Write End ]

Enforcing this sequential execution ensures that either:
1. A stale read is followed and invalidated by the deferred write
   invalidation flow.
2. The write invalidation executes first, forcing the subsequent read
   path's key replacement sequence to properly catch the collision.

Failure Handling
----------------
This patch keeps existing error-handling behavior intact. Although
execution is now sequential, btree invalidation is still triggered
regardless of whether the write to the backing device succeeds
or fails.

Verification and Performance
----------------------------
Manual Results (With Patch):
  # cat second-read-result
  0000000 0101 0101 0101 0101 0101 0101 0101 0101  # <--- CORRECT DATA

Stress Verification:
FIO was executed under a write-only workload (128 KB Write, libaio,
iodepth=64, direct=1). Without the patch, FIO reported CRC errors
due to stale read corruptions; with the patch, zero CRC errors or
corruptions were reported.

Write-Only Workload (FIO Averages CSV):
Metric,With Fix,Without Fix,Delta

Write IOPS,1630,1630,0.00%
Write Bandwidth (MiB/s),204,204,0.00%
Write Avg Latency (micro second),39219.95,39219.58,0.00%

Test Environment
----------------
- CPU: 1 vCPU, Intel Haswell x86_64 (n1-standard-1 instance)
- Memory: 3.75 GB RAM
- OS: Linux 6.12.68 (Google COS)
- Storage: Google Cloud SSD PD + Local SSD

Ankit Kapoor (1):
  bcache: fix stale data race between read cache miss and bypass write

 drivers/md/bcache/request.c | 13 +++++++++++++
 1 file changed, 13 insertions(+)

-- 
2.54.0.669.g59709faab0-goog

