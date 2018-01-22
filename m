From: Eric Wheeler <bcache@lists.ewheeler.net>
Subject: [RFC PATCH] BUG at block/blk-ioc.c:146 during bcache search_free
Date: Mon, 22 Jan 2018 23:36:44 +0000 (UTC)
Message-ID: <alpine.LRH.2.11.1801222257140.24301@mail.ewheeler.net>
Mime-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="1641074820-29946172-1516664208=:24301"
Return-path: <linux-bcache-owner@vger.kernel.org>
Received: from mx.ewheeler.net ([66.155.3.69]:45888 "EHLO mail.ewheeler.net"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1751031AbeAVXgu (ORCPT <rfc822;linux-bcache@vger.kernel.org>);
        Mon, 22 Jan 2018 18:36:50 -0500
Sender: linux-bcache-owner@vger.kernel.org
List-Id: linux-bcache@vger.kernel.org
To: linux-bcache@vger.kernel.org
Cc: linux-block@vger.kernel.org, =?ISO-8859-2?Q?=A3ukasz_Magiera?= <lmagiera@protonmail.com>

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

--1641074820-29946172-1516664208=:24301
Content-Type: TEXT/PLAIN; charset=ISO-8859-2
Content-Transfer-Encoding: 8BIT

Hello all,

In 4.14.13 we have hit the bug with the full backtrace noted below. This 
looks like a double free problem somewhere related to 
cached_dev_write_complete calling search_free.

It looks like the compiler inlined cached_dev_bio_complete so the stack 
trace is not complete. This is the call order:

cached_dev_write_complete ->
  cached_dev_bio_complete ->
    search_free ->
      bio_put ->
        bio_free ->
          bio_disassociate_task ->
            put_io_context <<<< BUG

I noticed that put_io_context released the ioc from a work_queue, so 
perhaps bcache is calling search_free on the same bio twice and the ioc 
is being queued to be freed twice. Is this possible?

There is another bug report caused when search_free calls bio_put in 
4.13.12, here: 
  https://www.spinics.net/lists/linux-bcache/msg05434.html

In this earlier report by £ukasz Magiera, BIO_REFFED was not flagged so he 
hit the bio_put BUG for its use counter instead of decending into 
put_io_context like my bug did.

In both cases, I think this might fix the issue---but the cause is still 
not clear to me: Why would the same bio referenced by the same search 
struct be decended by search_free more than once?

If this is the case, then this simple patch might fix it.

Please tell me what you think. If this bug is popping up for more than one 
person, then it would be great if we could pin it down.


[129132.219743] ------------[ cut here ]------------
[129132.220502] kernel BUG at block/blk-ioc.c:146!
[129132.221439] invalid opcode: 0000 [#1] SMP PTI
[129132.222206] Modules linked in: dm_snapshot dm_crypt btrfs xor zstd_decompress zstd_compress xxhash raid6_pq zram ebtable_filter ebtables ip6table_filter ip6_tables drbd lru_cache lz4 lz4_compress netconsole sch_sfq xt_comment iptable_filter bridge 8021q garp mrp stp llc dm_thin_pool dm_persistent_data dm_bio_prison dm_bufio libcrc32c binfmt_misc x86_pkg_temp_thermal intel_powerclamp coretemp kvm_intel iTCO_wdt iTCO_vendor_support bcache kvm cdc_acm irqbypass sg lpc_ich crct10dif_pclmul crc32_pclmul video ghash_clmulni_intel i2c_i801 mfd_core shpchp ipmi_si ipmi_devintf ipmi_msghandler pcspkr nfsd auth_rpcgss nfs_acl lockd grace sunrpc ip_tables ext4 mbcache jbd2 ixgbevf mgag200 i2c_algo_bit drm_kms_helper syscopyarea sysfillrect sysimgblt fb_sys_fops ttm drm ahci crc32c_intel libahci i
 xgbe e1000e
[129132.227745]  i2c_core libata mdio arcmsr dca ptp pps_core dm_mirror dm_region_hash dm_log dm_mod dax [last unloaded: zram]
[129132.228595] CPU: 4 PID: 11515 Comm: kworker/4:256 Tainted: G        W       4.14.13 #66
[129132.229418] Hardware name: Supermicro X9SCL/X9SCM/X9SCL/X9SCM, BIOS 2.10 01/09/2014
[129132.230255] Workqueue: bcache bch_data_insert_keys [bcache]
[129132.231067] task: ffff8a24d178da00 task.stack: ffff9fe927fac000
[129132.231891] RIP: 0010:put_io_context+0x7e/0x80
[129132.232689] RSP: 0018:ffff9fe927fafe10 EFLAGS: 00010286
[129132.233476] RAX: f889480000441f0f RBX: ffffffff9828a850 RCX: 0000000000000000
[129132.234268] RDX: 000000000005341b RSI: 0000000000000246 RDI: ffffffff9828a850
[129132.235385] RBP: 0000000100010001 R08: 0000000080200808 R09: ffff8a28adc2ad00
[129132.236174] R10: 0000000000000282 R11: 0000000000000000 R12: ffff8a28bfd21d00
[129132.236945] R13: ffffbfe8ffd1b000 R14: 0000000000000000 R15: ffff8a24e4ae8138
[129132.237684] FS:  0000000000000000(0000) GS:ffff8a28bfd00000(0000) knlGS:0000000000000000
[129132.238430] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[129132.239176] CR2: 000056426ce73060 CR3: 00000001f600a006 CR4: 00000000001626e0
[129132.239909] Call Trace:
[129132.240621]  bio_disassociate_task+0x17/0x60
[129132.241344]  bio_free+0x16/0x60
[129132.242061]  search_free+0x1f/0x40 [bcache]
[129132.242760]  cached_dev_write_complete+0x2c/0x60 [bcache]
[129132.243469]  process_one_work+0x141/0x340
[129132.244173]  worker_thread+0x47/0x3e0
[129132.244863]  kthread+0xfc/0x130
[129132.245530]  ? rescuer_thread+0x380/0x380
[129132.246203]  ? kthread_park+0x60/0x60
[129132.246864]  ? do_syscall_64+0x61/0x1a0
[129132.247503]  ? SyS_exit_group+0x10/0x10
[129132.248140]  ret_from_fork+0x1f/0x30
[129132.248761] Code: 89 ef 4c 89 e6 5d 41 5c e9 a0 63 40 00 48 89 ef 48 89 c6 e8 95 63 40 00 48 89 de 48 8b 3d 33 76 69 01 5b 5d 41 5c e9 e2 8f ec ff <0f> 0b 0f 1f 44 00 00 41 57 4c 8d 7f b8 41 56 41 55 4c 8d 6f c8 
[129132.250075] RIP: put_io_context+0x7e/0x80 RSP: ffff9fe927fafe10
[129132.250805] ---[ end trace c1c4db73f9196ceb ]---

--
Eric Wheeler


==========================================================
diff --git a/drivers/md/bcache/request.c b/drivers/md/bcache/request.c
index e9fbf2b..3dcc4c1 100644
--- a/drivers/md/bcache/request.c
+++ b/drivers/md/bcache/request.c
@@ -631,8 +631,10 @@ static void search_free(struct closure *cl)
 	struct search *s = container_of(cl, struct search, cl);
 	bio_complete(s);
 
-	if (s->iop.bio)
+	if (s->iop.bio) {
 		bio_put(s->iop.bio);
+		s->iop.bio = NULL;
+	}
 
 	closure_debug_destroy(cl);
 	mempool_free(s, s->d->c->search);
--1641074820-29946172-1516664208=:24301--
