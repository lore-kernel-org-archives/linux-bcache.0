From: Eric Wheeler <bcache@lists.ewheeler.net>
Subject: Re: [BUG] bcache_writebac blocked, IO on bcache device hung
Date: Mon, 11 Apr 2016 01:55:05 +0000 (UTC)
Message-ID: <alpine.LRH.2.11.1604110141160.9082@mail.ewheeler.net>
References: <570A99B9.1040504@roesner-online.de>
Mime-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="1641074820-714303321-1460339710=:9082"
Return-path: <linux-bcache-owner@vger.kernel.org>
Received: from mx.ewheeler.net ([71.19.153.34]:39743 "EHLO mail.ewheeler.net"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751010AbcDKBzN (ORCPT <rfc822;linux-bcache@vger.kernel.org>);
	Sun, 10 Apr 2016 21:55:13 -0400
In-Reply-To: <570A99B9.1040504@roesner-online.de>
Sender: linux-bcache-owner@vger.kernel.org
List-Id: linux-bcache@vger.kernel.org
To: Sebastian Roesner <sroesner-kernelorg@roesner-online.de>
Cc: linux-bcache@vger.kernel.org

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

--1641074820-714303321-1460339710=:9082
Content-Type: TEXT/PLAIN; charset=utf-8
Content-Transfer-Encoding: 8BIT

On Sun, 10 Apr 2016, Sebastian Roesner wrote:

> Hello,
> 
> I had an issue with bcache and kernel 4.5.0. I'm not sure that it was purely
> bcache related, but IO on the bcache device didn't work anymore whereas other
> volumes still worked fine.
> 
> After bcache blocked, it showed up the same message for dmcrypt_write. On top
> of the bcache device I run LVM and encrypt its LVs.
> 
> 
> └─sda2                                              8:34    part
>   └─md1                                             9:1     raid1
>     └─bcache0                                     252:0     disk
>       ├─storage-XXXXXXXXXXXXX_crypt               253:0     lvm
>       │ └─XXXXXXXXXXXX                            253:137   crypt
>       ├─storage-XXXXXXXXXXXX_crypt                253:1     lvm
>       │ └─XXXXXXXXXXXX                            253:122   crypt
> [..]
> 
> Bcache was patched with the patches from
> 
> https://bitbucket.org/ewheelerinc/linux v4.5-rc6-bcache-fixes
> https://bitbucket.org/ewheelerinc/linux v4.5-rc7-bcache-fixes
> 
> Trace:
> 
> INFO: task bcache_writebac:10061 blocked for more than 120 seconds.
>       Not tainted 4.5.0-kvmhost #1
> "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
> bcache_writebac D ffff88081fc94440     0 10061      2 0x00000000
>  ffff8807f83d2400 ffff8807fc2ae180 000000020000a07c ffffffff810036a4
>  ffff8800cb444000 ffffffff00000052 ffff8807f83d2400 ffff8807f7df0bc0
>  0000000000000000 ffff8807f7df0000 ffffffff81410370 ffff8807f7df0ad8
> Call Trace:
>  [<ffffffff810036a4>] ? __switch_to+0x1c8/0x36e
>  [<ffffffff81410370>] ? schedule+0x7a/0x87
>  [<ffffffff81411c6c>] ? rwsem_down_write_failed+0x241/0x2b0
>  [<ffffffff81218763>] ? call_rwsem_down_write_failed+0x13/0x20
>  [<ffffffff81411539>] ? down_write+0x24/0x33
>  [<ffffffffa044ccac>] ? bch_writeback_thread+0x48/0x6bc [bcache]
>  [<ffffffffa044cc64>] ? write_dirty_finish+0x1d4/0x1d4 [bcache]
>  [<ffffffff8105efa2>] ? kthread+0x99/0xa1
>  [<ffffffff8105ef09>] ? kthread_parkme+0x16/0x16
>  [<ffffffff814129df>] ? ret_from_fork+0x3f/0x70
>  [<ffffffff8105ef09>] ? kthread_parkme+0x16/0x16

Please recompile with the lockdep debugging options noted here:
  
http://stackoverflow.com/questions/20892822/how-to-use-lockdep-feature-in-linux-kernel-for-deadlock-detection


Also, try this patch from Ming Lei and let us know if that solves it:

Fixes: 54efd50(block: make generic_make_request handle arbitrarily sized bios)
Reported-by: Sebastian Roesner <sroesner-kernelorg@roesner-online.de>
Reported-by: Eric Wheeler <bcache@lists.ewheeler.net>
Cc: stable@vger.kernel.org (4.3+)
Cc: Shaohua Li <shli@fb.com>
Cc: Kent Overstreet <kent.overstreet@gmail.com>
Signed-off-by: Ming Lei <ming.lei@canonical.com>
---
V1:
	- Kent pointed out that using max io size can't cover
	the case of non-full bvecs/pages

The issue can be reproduced by the following approach:
        - create one raid1 over two virtio-blk
        - build bcache device over the above raid1 and another cache device
	and bucket size is set 2Mbytes
        - set cache mode as writeback
        - run random write over ext4 on the bcache device
        - then the crash can be triggered

 block/blk-merge.c | 19 +++++++++++++++++++
 1 file changed, 19 insertions(+)

diff --git a/block/blk-merge.c b/block/blk-merge.c
index 2613531..7b96471 100644
--- a/block/blk-merge.c
+++ b/block/blk-merge.c
@@ -94,8 +94,10 @@ static struct bio *blk_bio_segment_split(struct request_queue *q,
 	bool do_split = true;
 	struct bio *new = NULL;
 	const unsigned max_sectors = get_max_io_size(q, bio);
+	unsigned bvecs = 0;
 
 	bio_for_each_segment(bv, bio, iter) {
+		bvecs++;
 		/*
 		 * If the queue doesn't support SG gaps and adding this
 		 * offset would create a gap, disallow it.
@@ -103,6 +105,23 @@ static struct bio *blk_bio_segment_split(struct request_queue *q,
 		if (bvprvp && bvec_gap_to_prev(q, bvprvp, bv.bv_offset))
 			goto split;
 
+		/*
+		 * With arbitrary bio size, the incoming bio may be very
+		 * big. We have to split the bio into small bios so that
+		 * each holds at most BIO_MAX_PAGES bvecs because
+		 * bio_clone() can fail to allocate big bvecs.
+		 *
+		 * It should have been better to apply the limit per
+		 * request queue in which bio_clone() is involved,
+		 * instead of globally. The biggest blocker is
+		 * bio_clone() in bio bounce.
+		 *
+		 * TODO: deal with bio bounce's bio_clone() gracefully
+		 * and convert the global limit into per-queue limit.
+		 */
+		if (bvecs >= BIO_MAX_PAGES)
+			goto split;
+
 		if (sectors + (bv.bv_len >> 9) > max_sectors) {
 			/*
 			 * Consider this a new segment if we're splitting in
-- 
1.9.1




--
Eric Wheeler


> INFO: task dmcrypt_write:11119 blocked for more than 120 seconds.
>       Not tainted 4.5.0-kvmhost #1
> "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
> dmcrypt_write   D ffff88081fc54440     0 11119      2 0x00000000
>  ffff8807ebe0ce00 ffff8807fc2aee80 ffff8807f929eac0 0000000002011200
>  ffff8800ce50c000 ffff8807ebe0ce00 0000000000000000 ffff8807bcd33020
>  0000000000000001 0000000000000001 ffffffff81410370 ffff8807f7df0ad8
> Call Trace:
>  [<ffffffff81410370>] ? schedule+0x7a/0x87
>  [<ffffffff81411a15>] ? rwsem_down_read_failed+0xc6/0xdc
>  [<ffffffff810e71c8>] ? mempool_alloc+0x61/0x12d
>  [<ffffffff81218734>] ? call_rwsem_down_read_failed+0x14/0x30
>  [<ffffffff81411513>] ? down_read+0x17/0x19
>  [<ffffffffa04441d9>] ? cached_dev_make_request+0x411/0x738 [bcache]
>  [<ffffffff811eb860>] ? generic_make_request+0xb5/0x155
>  [<ffffffffa0314917>] ? dmcrypt_write+0x131/0x160 [dm_crypt]
>  [<ffffffff8106674c>] ? try_to_wake_up+0x1b5/0x1b5
>  [<ffffffffa03147e6>] ? crypt_iv_benbi_gen+0x37/0x37 [dm_crypt]
>  [<ffffffff8105efa2>] ? kthread+0x99/0xa1
>  [<ffffffff8105ef09>] ? kthread_parkme+0x16/0x16
>  [<ffffffff814129df>] ? ret_from_fork+0x3f/0x70
>  [<ffffffff8105ef09>] ? kthread_parkme+0x16/0x16
> INFO: task dmcrypt_write:11609 blocked for more than 120 seconds.
>       Not tainted 4.5.0-kvmhost #1
> "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
> dmcrypt_write   D ffff88081fc54440     0 11609      2 0x00000000
>  ffff8807f04e4e80 ffff8807fc2aee80 ffff8807f929eac0 0000000002011200
>  ffff8807eb2b4000 ffff8807f04e4e80 0000000000000000 ffff8807bab51020
>  0000000000000001 0000000000000001 ffffffff81410370 ffff8807f7df0ad8
> Call Trace:
>  [<ffffffff81410370>] ? schedule+0x7a/0x87
>  [<ffffffff81411a15>] ? rwsem_down_read_failed+0xc6/0xdc
>  [<ffffffff810e71c8>] ? mempool_alloc+0x61/0x12d
>  [<ffffffff81218734>] ? call_rwsem_down_read_failed+0x14/0x30
>  [<ffffffff81411513>] ? down_read+0x17/0x19
>  [<ffffffffa04441d9>] ? cached_dev_make_request+0x411/0x738 [bcache]
>  [<ffffffff811eb860>] ? generic_make_request+0xb5/0x155
>  [<ffffffffa0314917>] ? dmcrypt_write+0x131/0x160 [dm_crypt]
>  [<ffffffff8106674c>] ? try_to_wake_up+0x1b5/0x1b5
>  [<ffffffffa03147e6>] ? crypt_iv_benbi_gen+0x37/0x37 [dm_crypt]
>  [<ffffffff8105efa2>] ? kthread+0x99/0xa1
>  [<ffffffff8105ef09>] ? kthread_parkme+0x16/0x16
>  [<ffffffff814129df>] ? ret_from_fork+0x3f/0x70
>  [<ffffffff8105ef09>] ? kthread_parkme+0x16/0x16
> 
> Sebastian
> --
> To unsubscribe from this list: send the line "unsubscribe linux-bcache" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
--1641074820-714303321-1460339710=:9082--
