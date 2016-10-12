From: Marcin <marcin@mejor.pl>
Subject: Re: [bcachefs][tier] INFO: task bch_tier_read:21414 blocked for more
 than 120 seconds.
Date: Wed, 12 Oct 2016 21:10:14 +0200
Message-ID: <8312944b83a28b36f054c7a44d0fcbd8@mejor.pl>
References: <ebd2b9da9ab215488fd59797d8d1d67d@mejor.pl>
 <20161012012600.s2cq5ac37hwwrp3e@kmo-pixel>
 <b96021dc-9eaa-ea03-291f-1612d73f49c4@mejor.pl>
 <20161012121105.ym3sed4tgc2vx3dh@kmo-pixel>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8;
 format=flowed
Content-Transfer-Encoding: 8bit
Return-path: <linux-bcache-owner@vger.kernel.org>
Received: from jowisz.mejor.pl ([81.4.120.72]:60846 "EHLO jowisz.mejor.pl"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1755855AbcJLTKj (ORCPT <rfc822;linux-bcache@vger.kernel.org>);
        Wed, 12 Oct 2016 15:10:39 -0400
In-Reply-To: <20161012121105.ym3sed4tgc2vx3dh@kmo-pixel>
Sender: linux-bcache-owner@vger.kernel.org
List-Id: linux-bcache@vger.kernel.org
To: Kent Overstreet <kent.overstreet@gmail.com>
Cc: linux-bcache@vger.kernel.org, linux-bcache-owner@vger.kernel.org

W dniu 2016-10-12 14:11, Kent Overstreet napisał(a):
> On Wed, Oct 12, 2016 at 01:07:46PM +0200, Marcin Mirosław wrote:
>> W dniu 12.10.2016 o 03:26, Kent Overstreet pisze:
>> Hi,
>> [...]
>> > You're not the only one who's seeing this, I've been chasing this bug for the
>> > past several days...
>> >
>> 
>> Is something that can be done on my side to help with it?
>> I can add information that tier0 device is a device with short time of
>> writing requests - it's a HW controller with RAM. Second bling shot is
>> that using btree-node=256k was problematic some time ago:
>> http://www.spinics.net/lists/linux-bcache/msg04178.html , maybe this 
>> is
>> somehow related to the btree-node size?
> 
> It turns out it's not a bcache bug - FUA is buggy...
> 
> If you want, you could confirm by changing journal_flushes_device() to 
> always
> return true - journal.h line 85.
> 
> Gonna try and figure out what the actual FUA bug is tomorrow...


I made such change:
--- a/drivers/md/bcache/journal.h
+++ b/drivers/md/bcache/journal.h
@@ -184,7 +184,8 @@ static inline unsigned jset_u64s(unsigned u64s)

  static inline bool journal_flushes_device(struct cache *ca)
  {
-       return ca->mi.tier == 0;
+       /** return ca->mi.tier == 0; **/
+       return 0;
  }

  void bch_journal_start(struct cache_set *);

(it wasn't line 85, I hope made correct change). Now I'm getting:

[  612.320025] INFO: task kworker/u8:7:77 blocked for more than 120 
seconds.
[  612.320028]       Tainted: G        W       4.8.0+ #1
[  612.320029] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" 
disables this message.
[  612.320031] kworker/u8:7    D ffff88003ca739f0     0    77      2 
0x00000000
[  612.320042] Workqueue: writeback wb_workfn (flush-bcache-1)
[  612.320046]  ffff88003ca739f0 ffff88003d4c4f80 ffff88003c8e9a80 
ffff88003ca739b8
[  612.320050]  ffff88003ca74000 0000000000000100 ffff88003ca73c48 
ffff880036edb4d0
[  612.320054]  ffff880036ed0000 ffff88003ca73a08 ffffffff81473730 
ffff88001bf85468
[  612.320057] Call Trace:
[  612.320064]  [<ffffffff81473730>] schedule+0x30/0x80
[  612.320101]  [<ffffffffa02eca9c>] bch_writepages+0x37c/0x530 [bcache]
[  612.320106]  [<ffffffff810864c0>] ? wake_atomic_t_function+0x60/0x60
[  612.320111]  [<ffffffff811137ec>] do_writepages+0x1c/0x30
[  612.320114]  [<ffffffff81189740>] __writeback_single_inode+0x40/0x320
[  612.320117]  [<ffffffff81189e95>] writeback_sb_inodes+0x1d5/0x490
[  612.320120]  [<ffffffff8118a1dd>] __writeback_inodes_wb+0x8d/0xc0
[  612.320123]  [<ffffffff8118a4ca>] wb_writeback+0x22a/0x2e0
[  612.320126]  [<ffffffff8118c508>] wb_workfn+0x2e8/0x3b0
[  612.320129]  [<ffffffff81064c7b>] process_one_work+0x15b/0x470
[  612.320131]  [<ffffffff81064fd6>] worker_thread+0x46/0x4e0
[  612.320134]  [<ffffffff81064f90>] ? process_one_work+0x470/0x470
[  612.320137]  [<ffffffff81069f84>] kthread+0xc4/0xe0
[  612.320141]  [<ffffffff814779ff>] ret_from_fork+0x1f/0x40
[  612.320143]  [<ffffffff81069ec0>] ? kthread_worker_fn+0x160/0x160
[  612.320149] INFO: task kworker/0:3:329 blocked for more than 120 
seconds.
[  612.320150]       Tainted: G        W       4.8.0+ #1
[  612.320151] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" 
disables this message.
[  612.320152] kworker/0:3     D ffff880037293cc8     0   329      2 
0x00000000
[  612.320174] Workqueue: events_freezable btree_node_write_work 
[bcache]
[  612.320176]  ffff880037293cc8 ffffffff8180b4c0 ffff880037019a80 
0000000200000000
[  612.320180]  ffff880037294000 ffff88000b3f4618 ffff880037019a80 
0000000000000000
[  612.320183]  ffff88000b3f4630 ffff880037293ce0 ffffffff81473730 
7fffffffffffffff
[  612.320187] Call Trace:
[  612.320190]  [<ffffffff81473730>] schedule+0x30/0x80
[  612.320193]  [<ffffffff814767bd>] schedule_timeout+0x24d/0x300
[  612.320214]  [<ffffffffa02fafe0>] ? six_lock_type+0x60/0x340 [bcache]
[  612.320216]  [<ffffffff81077527>] ? sched_clock_local+0x17/0x80
[  612.320219]  [<ffffffff814752df>] __down+0x5f/0xa0
[  612.320222]  [<ffffffff8108bd9c>] down+0x3c/0x50
[  612.320240]  [<ffffffffa02d1fb5>] __bch_btree_node_write+0x25/0xa0 
[bcache]
[  612.320258]  [<ffffffffa02d2066>] 
bch_btree_node_write_dirty+0x36/0x50 [bcache]
[  612.320276]  [<ffffffffa02d2142>] btree_node_write_work+0x12/0x20 
[bcache]
[  612.320279]  [<ffffffff81064c7b>] process_one_work+0x15b/0x470
[  612.320281]  [<ffffffff81064fd6>] worker_thread+0x46/0x4e0
[  612.320283]  [<ffffffff81064f90>] ? process_one_work+0x470/0x470
[  612.320286]  [<ffffffff81064f90>] ? process_one_work+0x470/0x470
[  612.320288]  [<ffffffff81069f84>] kthread+0xc4/0xe0
[  612.320292]  [<ffffffff814779ff>] ret_from_fork+0x1f/0x40
[  612.320294]  [<ffffffff81069ec0>] ? kthread_worker_fn+0x160/0x160
[  612.320313] INFO: task bch_tier_read:2351 blocked for more than 120 
seconds.
[  612.320314]       Tainted: G        W       4.8.0+ #1
[  612.320315] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" 
disables this message.
[  612.320316] bch_tier_read   D ffff8800356ff848     0  2351      2 
0x00000000
[  612.320320]  ffff8800356ff848 ffff88003e144f80 ffff880036d98000 
ffffffff81353740
[  612.320324]  ffff880035700000 ffff88003fc96d80 7fffffffffffffff 
ffff88003cb59728
[  612.320327]  ffff88003cb596f8 ffff8800356ff860 ffffffff81473730 
0000000000000000
[  612.320331] Call Trace:
[  612.320335]  [<ffffffff81353740>] ? scsi_init_io+0x40/0x1d0
[  612.320338]  [<ffffffff81473730>] schedule+0x30/0x80
[  612.320340]  [<ffffffff814767bd>] schedule_timeout+0x24d/0x300
[  612.320342]  [<ffffffff8134c7df>] ? scsi_host_alloc_command+0x3f/0xb0
[  612.320346]  [<ffffffff810aba77>] ? ktime_get+0x37/0xa0
[  612.320348]  [<ffffffff81472f6f>] io_schedule_timeout+0x9f/0x110
[  612.320352]  [<ffffffff81264bcd>] get_request+0x40d/0x840
[  612.320355]  [<ffffffff810864c0>] ? wake_atomic_t_function+0x60/0x60
[  612.320358]  [<ffffffff81268597>] blk_queue_bio+0x117/0x3c0
[  612.320361]  [<ffffffff812669eb>] generic_make_request+0xcb/0x1a0
[  612.320382]  [<ffffffffa02eee96>] bch_submit_bbio+0x66/0xf0 [bcache]
[  612.320403]  [<ffffffffa02ef018>] bch_submit_bbio_replicas+0xf8/0x190 
[bcache]
[  612.320424]  [<ffffffffa02ef3a6>] __bch_write+0x2f6/0x710 [bcache]
[  612.320445]  [<ffffffffa02ef845>] bch_write+0x85/0x3b0 [bcache]
[  612.320467]  [<ffffffffa02f6d17>] do_pending_writes+0xa7/0x150 
[bcache]
[  612.320488]  [<ffffffffa02f7748>] bch_move_ctxt_wait+0x38/0xb0 
[bcache]
[  612.320491]  [<ffffffff810864c0>] ? wake_atomic_t_function+0x60/0x60
[  612.320513]  [<ffffffffa0305b53>] read_tiering+0x143/0x4c0 [bcache]
[  612.320517]  [<ffffffff814732ad>] ? __schedule+0x2cd/0x720
[  612.320536]  [<ffffffffa02d959a>] ? 
bch_bucket_stats_read_cache+0xda/0x150 [bcache]
[  612.320558]  [<ffffffffa0306117>] bch_tiering_thread+0x247/0x250 
[bcache]
[  612.320580]  [<ffffffffa0305ed0>] ? read_tiering+0x4c0/0x4c0 [bcache]
[  612.320582]  [<ffffffff81069f84>] kthread+0xc4/0xe0
[  612.320603]  [<ffffffffa02e5e30>] ? bch_vfs_dirent_create+0x60/0x60 
[bcache]
[  612.320606]  [<ffffffff814779ff>] ret_from_fork+0x1f/0x40
[  612.320609]  [<ffffffff81069ec0>] ? kthread_worker_fn+0x160/0x160
[ ...snip...]
