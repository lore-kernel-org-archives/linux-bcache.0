Received: from mail-pf1-f178.google.com (mail-pf1-f178.google.com [209.85.210.178])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AD640243387
	for <linux-bcache@vger.kernel.org>; Tue, 11 Aug 2026 12:37:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.178
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786451865; cv=none; b=pZ22nUq+wbY5HrrmygrWt7MoQex2CHwKiU0Z8mBrFQnp3euB0LtiQ8JW3xDOC0jagcp8Ij5iIMWpAnR6OEQVUwgDsORGJ4dFkNxo9Fmn+/bRAqlNZ51SOTPr5Q9gLwe9blW/ZEcJb7FfjeHPp7wKELUhQu90d9+NnQDr0ai4pNE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786451865; c=relaxed/simple;
	bh=DzI7kEhHtU5brJg70jdDaBPZVqXDvTQX9YZhXFDxk/Y=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=UjZYUlBkMihLPDXqLGojGeeUt9DLtHpGOi7XniZSSxefrWC5FpmhnZmidmimrABcjkYU9LRB25NqKivzRkU7ba4CfPxIEGZox+OiC1sLefcALMzhPHSXVQWanSm4eYlNbshSuYjR/gmNhneINP18TxdlbgsBaCknNsXjEhGNiyo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=DemN43mx; arc=none smtp.client-ip=209.85.210.178
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="DemN43mx"
Received: by mail-pf1-f178.google.com with SMTP id d2e1a72fcca58-848743155bcso1092166b3a.0
        for <linux-bcache@vger.kernel.org>; Tue, 11 Aug 2026 05:37:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1786451860; x=1787056660; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=28yuNNlegJl/rBWa83KpsQnTVO01eLaLH2nkr58B0ms=;
        b=DemN43mxK6kvxYrUifCDa4o+Q+hvJCXE4ruwx7NM2hk24LoJ1FhyMbXYNH6cz82kHe
         2DGV05eoLrix6KLZ41I5TdTEUeuSK2A6+cvUtItBgwWV/nxWfjFHXDY5ukKdPUpXjS5D
         fj8agnz5TgttSVmTuwgQepR++8MNuksEDF+LdONG/imC5ngrXij8waDpxjOusCdgpQLo
         54PT4ZuishYymC9h04C0ufMQC/Iu4RqK+lql14ZooY0b1wbSg4IC44qEcXE/2p3UWQBC
         ofjco4LoHzsrIcBeOwcRkDAFXZFnWmoO1+kmxU925Y0N978MdOTmtBb32inrSa/L3oTG
         FRGA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1786451860; x=1787056660;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=28yuNNlegJl/rBWa83KpsQnTVO01eLaLH2nkr58B0ms=;
        b=awZdNj19wLaaj7p8RFYecy7yNLNkKEQC/nMvwwihsuJUlAqzT82Q9JRSxS4/A7FZG4
         kB86w5+hm3cIIbdgIBeEeKoiiGfXds3Zgpp2FpQYFhPtwUsVbFLAO6A//aHOLbfIjrgy
         5URuYcZvF93izna4UJCV3bTrX4LY4XPmz6kk2rEuGvKuZAd7O0AJQhlDdcDSP7Zml+4L
         NQSGOIuQzHaVNWZ30jfModAcXPdUJb0/IRGHgXH91HRX0vGpaVkWmpVwARl4PSqAy/gO
         tBqIr+t0xoVAkzSN7MZcljc3IdZ1X+Q5TYaZBiGv5DtPU2cLZ6ml00Ag6G+OdXLtbtrm
         LTnA==
X-Gm-Message-State: AOJu0YzZQcqX921XEi22dRgXoLR/I7YFhSLKk3GH/PV98KQWz8wkJDzb
	dhUsiem7j5bFZaif2ektgwYA15rPV8bVYNC1skoZ2LBQnm9PEDTOeyGo
X-Gm-Gg: AR+sD12n2/wocSTarygkF8ZVvY5CeICOV3y7ax/Nn7YfACGm0UZNv6MDyQG5ZNJzJQu
	ndR1jDrJwDN4hv5furAt64OtRcTkrLSBryksG1dNOAOBBPeFrrULXq2nnE8dZoz2l3jhu14MTrG
	r4yWvI9eBxII1YQpnx4jzyFX7s6vga7IJUu4kKe+K7bbwhllP7DY9Rq9Wb1wDJvTclNaMyaBIvC
	O+mjc10M3r4fYQ62l4xXoqCb60rSI0y1U0FD7Dj9FeGIcJc06qjrybpuP4c6ljlDRG9UZs4pkQO
	6grMdBwA2WjOj2D14P1oBHk4avuhT3Utnvk8vlBLvVIH5XLAbq3F2hqevV0xya1uBmBdiiuDwCF
	qdp8iaO5chyZIowvvuc/P1hkKfxaWP6hrUXOcPTJ37TmiZwLEZtzTGarwq+yf9kQSDtC+cvwZ33
	PkRbI3doyTsmWLFCJ9ElOVz4YQpF9T2ipOunooiF6HmAj2I18g0xeeCU7kGyGU7gUAbqF8QzKjk
	bwVH78=
X-Received: by 2002:a05:6a00:430c:b0:84e:831:9a1a with SMTP id d2e1a72fcca58-84fa8874d85mr3008148b3a.21.1786451860206;
        Tue, 11 Aug 2026 05:37:40 -0700 (PDT)
Received: from localhost.localdomain ([113.98.201.214])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-84fa9195371sm715118b3a.11.2026.08.11.05.37.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 11 Aug 2026 05:37:38 -0700 (PDT)
From: Wale Zhang <wale.zhang.ftd@gmail.com>
To: colyli@fygo.io,
	kent.overstreet@linux.dev
Cc: linux-bcache@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Wale Zhang <wale.zhang.ftd@gmail.com>
Subject: [PATCH] bcache: reserve a bucket generation for btree node freeing
Date: Tue, 11 Aug 2026 08:35:41 -0400
Message-ID: <20260811123541.624750-1-wale.zhang.ftd@gmail.com>
X-Mailer: git-send-email 2.47.3
Precedence: bulk
X-Mailing-List: linux-bcache@vger.kernel.org
List-Id: <linux-bcache.vger.kernel.org>
List-Subscribe: <mailto:linux-bcache+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcache+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

The allocator allows a bucket generation to advance until its distance
from last_gc reaches BUCKET_GC_GEN_MAX.  A bucket allocated for a btree
node can then be advanced once more by make_btree_freeing_key() when that
node is replaced.  That path does not go through can_inc_bucket_gen().

This can make the generation distance exceed BUCKET_GC_GEN_MAX.  It was
observed during journal replay when a btree split advanced the distance
from 96 to 97.  bch_inc_gen() warned and the subsequent btree scan
reported:

  key too stale: 97, need_gc 97

The cache set was then disabled.

Stop normal bucket invalidation one generation earlier.  The reserved
generation allows make_btree_freeing_key() to invalidate a btree node
without exceeding BUCKET_GC_GEN_MAX.  A bucket cannot need another such
increment before being reused, and reuse has to pass this check again.

The kernel log is as follow:
[   46.769015] ------------[ cut here ]------------
[   46.769023] WARNING: CPU: 14 PID: 3891 at drivers/md/bcache/alloc.c:81 bch_inc_gen+0x3f/0x50 [bcache]
[   46.769145] Modules linked in: bcache(E) dm_mod(E) ext4(E) crc16(E) jbd2(E) crc32c_cryptoapi(E) watchdog(E) squashfs(E) vfat(E) fat(E) overlay(E) raid10(E) raid456(E) async_raid6_recov(E) async_memcpy(E) async_pq(E) async_xor(E) xor(E) async_tx(E) raid6_pq(E) raid1(E) raid0(E) md_mod(E) quota_v2(E) quota_v1(E) quota_tree(E) loop(E) sd_mod(E) xhci_pci(E) nvme(E) ahci(E) xhci_hcd(E) nvme_core(E) libahci(E) libata(E) atlantic(E) nvme_keyring(E) nvme_auth(E) usbcore(E) scsi_mod(E)
[   46.769216] CPU: 14 UID: 0 PID: 3891 Comm: bcache Tainted: G S   U      E       6.18.15 #1 PREEMPT(lazy)
[   46.769222] Tainted: [S]=CPU_OUT_OF_SPEC, [U]=USER, [E]=UNSIGNED_MODULE
[   46.769223] Hardware name: MINI Pro/Default string, BIOS MINI Pro V1.1 20250806 08/06/2025
[   46.769225] RIP: 0010:bch_inc_gen+0x3f/0x50 [bcache]
[   46.769240] Code: 0f 89 c2 2a 56 07 0f b6 b1 22 06 00 00 40 38 f2 0f 42 d6 88 91 22 06 00 00 48 8b 17 80 ba 22 06 00 00 60 77 05 c3 cc cc cc cc <0f> 0b c3 cc cc cc cc 66 2e 0f 1f 84 00 00 00 00 00 90 90 90 90 90
[   46.769243] RSP: 0018:ffffcadc8ffdf590 EFLAGS: 00010202
[   46.769245] RAX: 0000000000000063 RBX: 000007ffffffffff RCX: ffff89da58600000
[   46.769247] RDX: ffff89da58600000 RSI: 0000000000000060 RDI: ffff89d8c14c8000
[   46.769249] RBP: 0000000000000002 R08: 0000000ae3a62aea R09: 0000000000000000
[   46.769250] R10: 0000000000000001 R11: 0000000000000000 R12: 0000000000000001
[   46.769252] R13: ffffcadc8ffdf658 R14: ffff89da820bb800 R15: ffffcadc8ffdf600
[   46.769254] FS:  00007f7222e26bc0(0000) GS:ffff89e854219000(0000) knlGS:0000000000000000
[   46.769256] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[   46.769258] CR2: 00007f37b77fcde8 CR3: 0000000305c51006 CR4: 0000000000f72ef0
[   46.769260] PKRU: 55555554
[   46.769261] Call Trace:
[   46.769265]  <TASK>
[   46.769267]  make_btree_freeing_key+0xe3/0x120 [bcache]
[   46.769287]  btree_split+0x4b3/0x6c0 [bcache]
[   46.769304]  ? __pfx_closure_sync_fn+0x10/0x10
[   46.769312]  ? update_load_avg+0x7f/0x790
[   46.769319]  bch_btree_insert_node+0x2f6/0x3d0 [bcache]
[   46.769335]  ? __pfx_btree_insert_fn+0x10/0x10 [bcache]
[   46.769349]  btree_insert_fn+0x24/0x50 [bcache]
[   46.769364]  bch_btree_map_nodes_recurse+0x103/0x190 [bcache]
[   46.769379]  __bch_btree_map_nodes+0x1b7/0x1f0 [bcache]
[   46.769393]  ? __pfx_btree_insert_fn+0x10/0x10 [bcache]
[   46.769407]  bch_btree_insert+0xe3/0x160 [bcache]
[   46.769420]  ? __pfx_autoremove_wake_function+0x10/0x10
[   46.769425]  bch_journal_replay+0x131/0x290 [bcache]
[   46.769442]  ? ttwu_queue_wakelist+0xe0/0x100
[   46.769447]  ? try_to_wake_up+0x309/0x6e0
[   46.769451]  register_bcache+0x18b2/0x2000 [bcache]
[   46.769473]  kernfs_fop_write_iter+0x130/0x210
[   46.769480]  vfs_write+0x258/0x420
[   46.769486]  ksys_write+0x65/0xe0
[   46.769490]  do_syscall_64+0x84/0x810
[   46.769495]  ? next_uptodate_folio+0x85/0x2a0
[   46.769501]  ? percpu_counter_add_batch+0x4c/0x90
[   46.769504]  ? filemap_map_pages+0x64f/0x760
[   46.769509]  ? do_fault+0x2a2/0x5a0
[   46.769513]  ? __handle_mm_fault+0x943/0xfb0
[   46.769518]  ? count_memcg_events+0xb6/0x170
[   46.769523]  ? handle_mm_fault+0xb2/0x2b0
[   46.769526]  ? do_user_addr_fault+0x212/0x6a0
[   46.769531]  entry_SYSCALL_64_after_hwframe+0x76/0x7e
[   46.769535] RIP: 0033:0x7f7222f20350
[   46.769538] Code: 40 00 48 8b 15 b1 aa 0d 00 f7 d8 64 89 02 48 c7 c0 ff ff ff ff eb b7 0f 1f 00 80 3d 91 32 0e 00 00 74 17 b8 01 00 00 00 0f 05 <48> 3d 00 f0 ff ff 77 58 c3 0f 1f 80 00 00 00 00 48 83 ec 28 48 89
[   46.769540] RSP: 002b:00007ffec1502588 EFLAGS: 00000202 ORIG_RAX: 0000000000000001
[   46.769542] RAX: ffffffffffffffda RBX: 000000000000000a RCX: 00007f7222f20350
[   46.769543] RDX: 000000000000000a RSI: 000055b8694a3c00 RDI: 0000000000000003
[   46.769544] RBP: 000055b8694a3c00 R08: 00007f7222ffc2e0 R09: 0000000000000073
[   46.769546] R10: 0000000000000000 R11: 0000000000000202 R12: 000000000000000a
[   46.769547] R13: 00007ffec1502610 R14: 000000000000000a R15: 00007f7222ff79e0
[   46.769549]  </TASK>
[   46.769550] ---[ end trace 0000000000000000 ]---
[   46.777982] bcache: bch_journal_replay() journal replay done, 4 keys in 3 entries, seq 75283
[   46.809306] bcache: register_cache() registered cache device dm-1
[   46.820987] bcache: register_bdev() registered backing device dm-3
[   46.850260] bcache: bch_cache_set_error() error on b2f0a7d0-0c65-44e6-8ea7-c2b2d66324ad: key too stale: 97, need_gc 97, disabling caching
[   46.850268] CPU: 4 UID: 0 PID: 4171 Comm: bch_dirtcnt[3] Tainted: G S   U  W   E       6.18.15 #1 PREEMPT(lazy)
[   46.850270] Tainted: [S]=CPU_OUT_OF_SPEC, [U]=USER, [W]=WARN, [E]=UNSIGNED_MODULE
[   46.850271] Hardware name: MINI Pro/Default string, BIOS MINI Pro V1.1 20250806 08/06/2025
[   46.850272] Call Trace:
[   46.850274]  <TASK>
[   46.850277]  dump_stack_lvl+0x64/0x80
[   46.850286]  bch_extent_bad+0x11e/0x170 [bcache]
[   46.850299]  ? __pfx_bch_ptr_bad+0x10/0x10 [bcache]
[   46.850305]  bch_btree_iter_next_filter+0x1b0/0x2e0 [bcache]
[   46.850311]  bch_btree_map_keys_recurse+0x7d/0x190 [bcache]
[   46.850317]  ? __pfx_sectors_dirty_init_fn+0x10/0x10 [bcache]
[   46.850324]  ? sched_balance_update_blocked_averages+0x5f8/0x710
[   46.850328]  ? bch_btree_node_get.part.0+0x1f6/0x2e0 [bcache]
[   46.850333]  ? __pfx_up_read+0x10/0x10
[   46.850335]  bch_root_node_dirty_init+0xdc/0x170 [bcache]
[   46.850342]  ? __pfx_autoremove_wake_function+0x10/0x10
[   46.850343]  bch_dirty_init_thread+0x11a/0x150 [bcache]
[   46.850349]  ? __pfx_bch_dirty_init_thread+0x10/0x10 [bcache]
[   46.850354]  kthread+0xfe/0x240
[   46.850356]  ? __pfx_kthread+0x10/0x10
[   46.850357]  ? __pfx_kthread+0x10/0x10
[   46.850357]  ret_from_fork+0x1cc/0x200
[   46.850360]  ? __pfx_kthread+0x10/0x10
[   46.850360]  ret_from_fork_asm+0x1a/0x30
[   46.850363]  </TASK>
[   46.851013] Buffer I/O error on dev bcache0, logical block 0, async page read
[   46.851027] ldm_validate_partition_table(): Disk read failed.
[   46.851032] Buffer I/O error on dev bcache0, logical block 0, async page read
[   46.851033] Dev bcache0: unable to read RDB block 0
[   46.851037] Buffer I/O error on dev bcache0, logical block 3, async page read
[   46.851039]  bcache0: unable to read partition table
[   46.851155] bcache: bch_cached_dev_attach() Caching dm-3 as bcache0 on set b2f0a7d0-0c65-44e6-8ea7-c2b2d66324ad
[   46.851296] bcache: conditional_stop_bcache_device() stop_when_cache_set_failed of bcache0 is "auto" and cache is dirty, stop it to avoid potential data corruption.
[   46.856117] bcache: cached_dev_detach_finish() Caching disabled for dm-3
[   46.881268] bcache: bcache_device_free() bcache0 stopped
[   47.089287] bcache: cache_set_free() Cache set b2f0a7d0-0c65-44e6-8ea7-c2b2d66324ad unregistered

Signed-off-by: Wale Zhang <wale.zhang.ftd@gmail.com>
---
 drivers/md/bcache/alloc.c | 7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/drivers/md/bcache/alloc.c b/drivers/md/bcache/alloc.c
index 3ec240ec685d..460a6eed59ff 100644
--- a/drivers/md/bcache/alloc.c
+++ b/drivers/md/bcache/alloc.c
@@ -120,7 +120,12 @@ void bch_rescale_priorities(struct cache_set *c, int sectors)
 
 static inline bool can_inc_bucket_gen(struct bucket *b)
 {
-	return bucket_gc_gen(b) < BUCKET_GC_GEN_MAX;
+	/*
+	 * A bucket may be allocated for a btree node. When the node is freed,
+	 * make_btree_freeing_key() increments the bucket generation once more
+	 * without going through this check. Leave room for that increment.
+	 */
+	return bucket_gc_gen(b) < BUCKET_GC_GEN_MAX - 1;
 }
 
 bool bch_can_invalidate_bucket(struct cache *ca, struct bucket *b)
-- 
2.47.3

