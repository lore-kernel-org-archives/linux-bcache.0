Received: from va-2-19.ptr.blmpb.com (va-2-19.ptr.blmpb.com [209.127.231.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4D5BD4A9D4F
	for <linux-bcache@vger.kernel.org>; Fri,  4 Sep 2026 15:39:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.127.231.19
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788536345; cv=none; b=jtbKmpj6+GZtmqWSAb/uKpCLg89QOOzQ5ofUGadwLImus6+yuITIGj5RSGISlK31hWE9jRZjjV+029Ui8omuB0zEbi0r8qtRNGOS7BpY+s6B/7VM3w/KLq7RYf5YmFtMfAIoJAt9aPWHEoHL/be92svWwbLnUwBVyrKg6pjc2PM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788536345; c=relaxed/simple;
	bh=sYlptdn28B8vikbZVIYEdGWgAaPQhB/vChPJohyZycM=;
	h=Subject:Date:References:Content-Type:In-Reply-To:Cc:Mime-Version:
	 From:To:Message-Id; b=LiToEh/t6Fu8r/N+NoPuFYgMMxxFluJcbE1+h69Dc3bYGzAH39kgxUwcnqEVcn0hxsw3n2GVsD56269z8Ocl+c72GEu+++EMHBGYnEFysee5EN4cp91aseC/cidkq/vA/i4EmDVke2n6AMEu302GUio3M7njjMonv/RAGl/imuY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fygo.io; spf=pass smtp.mailfrom=fygo.io; dkim=pass (2048-bit key) header.d=fygo-io.20200929.dkim.larksuite.com header.i=@fygo-io.20200929.dkim.larksuite.com header.b=hoDFv4lX; arc=none smtp.client-ip=209.127.231.19
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fygo.io
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=fygo.io
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=fygo-io.20200929.dkim.larksuite.com header.i=@fygo-io.20200929.dkim.larksuite.com header.b="hoDFv4lX"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
 s=s1; d=fygo-io.20200929.dkim.larksuite.com; t=1788536213;
  h=from:subject:mime-version:from:date:message-id:subject:to:cc:
 reply-to:content-type:mime-version:in-reply-to:message-id;
 bh=u+uT2szPCR5zFKobro3MB2pr7EcmWK4K3xsMMji49yQ=;
 b=hoDFv4lX2PMC50Ct0n9Wa2qjNI+9MyxNK2HoeCqLNayef+jXl87glL3STBY0OedvBzfpgs
 ue/9IYbNzwM5LT4ywy2DtoEoEE9DmFmZJWpWkvB872lXqDfVuJqUUjlzE8775gaDDzLpIq
 4Q1vyxRQ0Sx2EYAt9d4ArotfhvRaJHGtIoYxrda+0UQApwYfamwVuC7Rtxv3+9HLjQv1v4
 gWB7VS2zStNKPt1Ic8nfjIRsS1nBuZOBZwMwMValO0Ik84q8fAgGumIpKNe2dx9McnE/F0
 9f7UdHvObNHfqru93ztkmVp5sOcKpqQ4bBmaKc00dvJeipEQkKNWpOhNa/RXbQ==
Subject: Re: [PATCH] bcache: reserve a bucket generation for btree node freeing
Date: Fri, 4 Sep 2026 23:36:39 +0800
Received: from smtpclient.apple ([120.245.64.136]) by smtp.larksuite.com with ESMTPS; Fri, 04 Sep 2026 15:36:51 +0000
References: <20260811123541.624750-1-wale.zhang.ftd@gmail.com>
Content-Type: text/plain; charset=UTF-8
In-Reply-To: <20260811123541.624750-1-wale.zhang.ftd@gmail.com>
Cc: <kent.overstreet@linux.dev>, <linux-bcache@vger.kernel.org>, 
	<linux-kernel@vger.kernel.org>
X-Original-From: Coly Li <colyli@fygo.io>
Content-Transfer-Encoding: quoted-printable
X-Lms-Return-Path: <lba+26a9ae594+7ee168+vger.kernel.org+colyli@fygo.io>
Precedence: bulk
X-Mailing-List: linux-bcache@vger.kernel.org
List-Id: <linux-bcache.vger.kernel.org>
List-Subscribe: <mailto:linux-bcache+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcache+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
From: "Coly Li" <colyli@fygo.io>
X-Mailer: Apple Mail (2.3864.700.51.1.1)
To: "Wale Zhang" <wale.zhang.ftd@gmail.com>
Message-Id: <DEA8D41E-DA59-49B2-8E12-FC16DAB1EA5A@fygo.io>

> 2026=E5=B9=B48=E6=9C=8811=E6=97=A5 20:35=EF=BC=8CWale Zhang <wale.zhang.f=
td@gmail.com> =E5=86=99=E9=81=93=EF=BC=9A
>=20
> The allocator allows a bucket generation to advance until its distance
> from last_gc reaches BUCKET_GC_GEN_MAX.  A bucket allocated for a btree
> node can then be advanced once more by make_btree_freeing_key() when that
> node is replaced.  That path does not go through can_inc_bucket_gen().
>=20
> This can make the generation distance exceed BUCKET_GC_GEN_MAX.  It was
> observed during journal replay when a btree split advanced the distance
> from 96 to 97.  bch_inc_gen() warned and the subsequent btree scan
> reported:
>=20
>  key too stale: 97, need_gc 97
>=20
> The cache set was then disabled.
>=20
> Stop normal bucket invalidation one generation earlier.  The reserved
> generation allows make_btree_freeing_key() to invalidate a btree node
> without exceeding BUCKET_GC_GEN_MAX.  A bucket cannot need another such
> increment before being reused, and reuse has to pass this check again.
>=20
> The kernel log is as follow:
> [   46.769015] ------------[ cut here ]------------
> [   46.769023] WARNING: CPU: 14 PID: 3891 at drivers/md/bcache/alloc.c:81=
 bch_inc_gen+0x3f/0x50 [bcache]
> [   46.769145] Modules linked in: bcache(E) dm_mod(E) ext4(E) crc16(E) jb=
d2(E) crc32c_cryptoapi(E) watchdog(E) squashfs(E) vfat(E) fat(E) overlay(E)=
 raid10(E) raid456(E) async_raid6_recov(E) async_memcpy(E) async_pq(E) asyn=
c_xor(E) xor(E) async_tx(E) raid6_pq(E) raid1(E) raid0(E) md_mod(E) quota_v=
2(E) quota_v1(E) quota_tree(E) loop(E) sd_mod(E) xhci_pci(E) nvme(E) ahci(E=
) xhci_hcd(E) nvme_core(E) libahci(E) libata(E) atlantic(E) nvme_keyring(E)=
 nvme_auth(E) usbcore(E) scsi_mod(E)
> [   46.769216] CPU: 14 UID: 0 PID: 3891 Comm: bcache Tainted: G S   U    =
  E       6.18.15 #1 PREEMPT(lazy)
> [   46.769222] Tainted: [S]=3DCPU_OUT_OF_SPEC, [U]=3DUSER, [E]=3DUNSIGNED=
_MODULE
> [   46.769223] Hardware name: MINI Pro/Default string, BIOS MINI Pro V1.1=
 20250806 08/06/2025
> [   46.769225] RIP: 0010:bch_inc_gen+0x3f/0x50 [bcache]
> [   46.769240] Code: 0f 89 c2 2a 56 07 0f b6 b1 22 06 00 00 40 38 f2 0f 4=
2 d6 88 91 22 06 00 00 48 8b 17 80 ba 22 06 00 00 60 77 05 c3 cc cc cc cc <=
0f> 0b c3 cc cc cc cc 66 2e 0f 1f 84 00 00 00 00 00 90 90 90 90 90
> [   46.769243] RSP: 0018:ffffcadc8ffdf590 EFLAGS: 00010202
> [   46.769245] RAX: 0000000000000063 RBX: 000007ffffffffff RCX: ffff89da5=
8600000
> [   46.769247] RDX: ffff89da58600000 RSI: 0000000000000060 RDI: ffff89d8c=
14c8000
> [   46.769249] RBP: 0000000000000002 R08: 0000000ae3a62aea R09: 000000000=
0000000
> [   46.769250] R10: 0000000000000001 R11: 0000000000000000 R12: 000000000=
0000001
> [   46.769252] R13: ffffcadc8ffdf658 R14: ffff89da820bb800 R15: ffffcadc8=
ffdf600
> [   46.769254] FS:  00007f7222e26bc0(0000) GS:ffff89e854219000(0000) knlG=
S:0000000000000000
> [   46.769256] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> [   46.769258] CR2: 00007f37b77fcde8 CR3: 0000000305c51006 CR4: 000000000=
0f72ef0
> [   46.769260] PKRU: 55555554
> [   46.769261] Call Trace:
> [   46.769265]  <TASK>
> [   46.769267]  make_btree_freeing_key+0xe3/0x120 [bcache]
> [   46.769287]  btree_split+0x4b3/0x6c0 [bcache]
> [   46.769304]  ? __pfx_closure_sync_fn+0x10/0x10
> [   46.769312]  ? update_load_avg+0x7f/0x790
> [   46.769319]  bch_btree_insert_node+0x2f6/0x3d0 [bcache]
> [   46.769335]  ? __pfx_btree_insert_fn+0x10/0x10 [bcache]
> [   46.769349]  btree_insert_fn+0x24/0x50 [bcache]
> [   46.769364]  bch_btree_map_nodes_recurse+0x103/0x190 [bcache]
> [   46.769379]  __bch_btree_map_nodes+0x1b7/0x1f0 [bcache]
> [   46.769393]  ? __pfx_btree_insert_fn+0x10/0x10 [bcache]
> [   46.769407]  bch_btree_insert+0xe3/0x160 [bcache]
> [   46.769420]  ? __pfx_autoremove_wake_function+0x10/0x10
> [   46.769425]  bch_journal_replay+0x131/0x290 [bcache]
> [   46.769442]  ? ttwu_queue_wakelist+0xe0/0x100
> [   46.769447]  ? try_to_wake_up+0x309/0x6e0
> [   46.769451]  register_bcache+0x18b2/0x2000 [bcache]
> [   46.769473]  kernfs_fop_write_iter+0x130/0x210
> [   46.769480]  vfs_write+0x258/0x420
> [   46.769486]  ksys_write+0x65/0xe0
> [   46.769490]  do_syscall_64+0x84/0x810
> [   46.769495]  ? next_uptodate_folio+0x85/0x2a0
> [   46.769501]  ? percpu_counter_add_batch+0x4c/0x90
> [   46.769504]  ? filemap_map_pages+0x64f/0x760
> [   46.769509]  ? do_fault+0x2a2/0x5a0
> [   46.769513]  ? __handle_mm_fault+0x943/0xfb0
> [   46.769518]  ? count_memcg_events+0xb6/0x170
> [   46.769523]  ? handle_mm_fault+0xb2/0x2b0
> [   46.769526]  ? do_user_addr_fault+0x212/0x6a0
> [   46.769531]  entry_SYSCALL_64_after_hwframe+0x76/0x7e
> [   46.769535] RIP: 0033:0x7f7222f20350
> [   46.769538] Code: 40 00 48 8b 15 b1 aa 0d 00 f7 d8 64 89 02 48 c7 c0 f=
f ff ff ff eb b7 0f 1f 00 80 3d 91 32 0e 00 00 74 17 b8 01 00 00 00 0f 05 <=
48> 3d 00 f0 ff ff 77 58 c3 0f 1f 80 00 00 00 00 48 83 ec 28 48 89
> [   46.769540] RSP: 002b:00007ffec1502588 EFLAGS: 00000202 ORIG_RAX: 0000=
000000000001
> [   46.769542] RAX: ffffffffffffffda RBX: 000000000000000a RCX: 00007f722=
2f20350
> [   46.769543] RDX: 000000000000000a RSI: 000055b8694a3c00 RDI: 000000000=
0000003
> [   46.769544] RBP: 000055b8694a3c00 R08: 00007f7222ffc2e0 R09: 000000000=
0000073
> [   46.769546] R10: 0000000000000000 R11: 0000000000000202 R12: 000000000=
000000a
> [   46.769547] R13: 00007ffec1502610 R14: 000000000000000a R15: 00007f722=
2ff79e0
> [   46.769549]  </TASK>
> [   46.769550] ---[ end trace 0000000000000000 ]---
> [   46.777982] bcache: bch_journal_replay() journal replay done, 4 keys i=
n 3 entries, seq 75283
> [   46.809306] bcache: register_cache() registered cache device dm-1
> [   46.820987] bcache: register_bdev() registered backing device dm-3
> [   46.850260] bcache: bch_cache_set_error() error on b2f0a7d0-0c65-44e6-=
8ea7-c2b2d66324ad: key too stale: 97, need_gc 97, disabling caching
> [   46.850268] CPU: 4 UID: 0 PID: 4171 Comm: bch_dirtcnt[3] Tainted: G S =
  U  W   E       6.18.15 #1 PREEMPT(lazy)
> [   46.850270] Tainted: [S]=3DCPU_OUT_OF_SPEC, [U]=3DUSER, [W]=3DWARN, [E=
]=3DUNSIGNED_MODULE
> [   46.850271] Hardware name: MINI Pro/Default string, BIOS MINI Pro V1.1=
 20250806 08/06/2025
> [   46.850272] Call Trace:
> [   46.850274]  <TASK>
> [   46.850277]  dump_stack_lvl+0x64/0x80
> [   46.850286]  bch_extent_bad+0x11e/0x170 [bcache]
> [   46.850299]  ? __pfx_bch_ptr_bad+0x10/0x10 [bcache]
> [   46.850305]  bch_btree_iter_next_filter+0x1b0/0x2e0 [bcache]
> [   46.850311]  bch_btree_map_keys_recurse+0x7d/0x190 [bcache]
> [   46.850317]  ? __pfx_sectors_dirty_init_fn+0x10/0x10 [bcache]
> [   46.850324]  ? sched_balance_update_blocked_averages+0x5f8/0x710
> [   46.850328]  ? bch_btree_node_get.part.0+0x1f6/0x2e0 [bcache]
> [   46.850333]  ? __pfx_up_read+0x10/0x10
> [   46.850335]  bch_root_node_dirty_init+0xdc/0x170 [bcache]
> [   46.850342]  ? __pfx_autoremove_wake_function+0x10/0x10
> [   46.850343]  bch_dirty_init_thread+0x11a/0x150 [bcache]
> [   46.850349]  ? __pfx_bch_dirty_init_thread+0x10/0x10 [bcache]
> [   46.850354]  kthread+0xfe/0x240
> [   46.850356]  ? __pfx_kthread+0x10/0x10
> [   46.850357]  ? __pfx_kthread+0x10/0x10
> [   46.850357]  ret_from_fork+0x1cc/0x200
> [   46.850360]  ? __pfx_kthread+0x10/0x10
> [   46.850360]  ret_from_fork_asm+0x1a/0x30
> [   46.850363]  </TASK>
> [   46.851013] Buffer I/O error on dev bcache0, logical block 0, async pa=
ge read
> [   46.851027] ldm_validate_partition_table(): Disk read failed.
> [   46.851032] Buffer I/O error on dev bcache0, logical block 0, async pa=
ge read
> [   46.851033] Dev bcache0: unable to read RDB block 0
> [   46.851037] Buffer I/O error on dev bcache0, logical block 3, async pa=
ge read
> [   46.851039]  bcache0: unable to read partition table
> [   46.851155] bcache: bch_cached_dev_attach() Caching dm-3 as bcache0 on=
 set b2f0a7d0-0c65-44e6-8ea7-c2b2d66324ad
> [   46.851296] bcache: conditional_stop_bcache_device() stop_when_cache_s=
et_failed of bcache0 is "auto" and cache is dirty, stop it to avoid potenti=
al data corruption.
> [   46.856117] bcache: cached_dev_detach_finish() Caching disabled for dm=
-3
> [   46.881268] bcache: bcache_device_free() bcache0 stopped
> [   47.089287] bcache: cache_set_free() Cache set b2f0a7d0-0c65-44e6-8ea7=
-c2b2d66324ad unregistered
>=20
> Signed-off-by: Wale Zhang <wale.zhang.ftd@gmail.com>

Hi Wale,

Yes, this is a valid problem and efficient fix. Thanks.

I  take it for my for-next.

Coly Li


> ---
> drivers/md/bcache/alloc.c | 7 ++++++-
> 1 file changed, 6 insertions(+), 1 deletion(-)
>=20
> diff --git a/drivers/md/bcache/alloc.c b/drivers/md/bcache/alloc.c
> index 3ec240ec685d..460a6eed59ff 100644
> --- a/drivers/md/bcache/alloc.c
> +++ b/drivers/md/bcache/alloc.c
> @@ -120,7 +120,12 @@ void bch_rescale_priorities(struct cache_set *c, int=
 sectors)
>=20
> static inline bool can_inc_bucket_gen(struct bucket *b)
> {
> - return bucket_gc_gen(b) < BUCKET_GC_GEN_MAX;
> + /*
> + * A bucket may be allocated for a btree node. When the node is freed,
> + * make_btree_freeing_key() increments the bucket generation once more
> + * without going through this check. Leave room for that increment.
> + */
> + return bucket_gc_gen(b) < BUCKET_GC_GEN_MAX - 1;
> }
>=20
> bool bch_can_invalidate_bucket(struct cache *ca, struct bucket *b)
> --=20
> 2.47.3
>=20
>
