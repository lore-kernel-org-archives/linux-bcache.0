From: Kent Overstreet <kent.overstreet@gmail.com>
Subject: Re: [bcachefs][tier] INFO: task bch_tier_read:21414 blocked for more
 than 120 seconds.
Date: Fri, 14 Oct 2016 22:17:20 -0800
Message-ID: <20161015061720.dtdh7gobrkkpbk3i@kmo-pixel>
References: <ebd2b9da9ab215488fd59797d8d1d67d@mejor.pl>
 <20161012012600.s2cq5ac37hwwrp3e@kmo-pixel>
 <b96021dc-9eaa-ea03-291f-1612d73f49c4@mejor.pl>
 <20161012121105.ym3sed4tgc2vx3dh@kmo-pixel>
 <8312944b83a28b36f054c7a44d0fcbd8@mejor.pl>
 <CAC7rs0vU1KTsf1KmbCJg3GWLrsKd4aA=j=vCezyBPTuVFxOHQg@mail.gmail.com>
 <856aa94d33dfbd22dbb377b5de22b0cc@mejor.pl>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Return-path: <linux-bcache-owner@vger.kernel.org>
Received: from mail-pa0-f53.google.com ([209.85.220.53]:35055 "EHLO
        mail-pa0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750899AbcJOGRZ (ORCPT
        <rfc822;linux-bcache@vger.kernel.org>);
        Sat, 15 Oct 2016 02:17:25 -0400
Received: by mail-pa0-f53.google.com with SMTP id qn10so51785360pac.2
        for <linux-bcache@vger.kernel.org>; Fri, 14 Oct 2016 23:17:24 -0700 (PDT)
Content-Disposition: inline
In-Reply-To: <856aa94d33dfbd22dbb377b5de22b0cc@mejor.pl>
Sender: linux-bcache-owner@vger.kernel.org
List-Id: linux-bcache@vger.kernel.org
To: Marcin <marcin@mejor.pl>
Cc: linux-bcache@vger.kernel.org

On Wed, Oct 12, 2016 at 09:51:17PM +0200, Marcin wrote:
> W dniu 2016-10-12 21:19, Kent Overstreet napisał(a):
> > It needs to return true, not false.
> 
> It's not a bash, ok:)
> 
> With:
> --- a/drivers/md/bcache/journal.h
> +++ b/drivers/md/bcache/journal.h
> @@ -184,7 +184,8 @@ static inline unsigned jset_u64s(unsigned u64s)
> 
>  static inline bool journal_flushes_device(struct cache *ca)
>  {
> -       return ca->mi.tier == 0;
> +       /** return ca->mi.tier == 0; **/
> +       return true;
>  }
> 
>  void bch_journal_start(struct cache_set *);
> 
> I'm getting:
> [   89.029997] WARNING: CPU: 0 PID: 2356 at mm/page_alloc.c:3421
> __alloc_pages_nodemask+0x9d4/0xdb0
> 
> while mounting. WHile copying I'm getting:
> [  489.430063] INFO: task bch_tier_read:2383 blocked for more than 120
> seconds.
> [  489.430066]       Tainted: G        W       4.8.0+ #1
> [  489.430067] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables
> this message.
> [  489.430069] bch_tier_read   D ffff88002e447848     0  2383      2
> 0x00000000
> [  489.430075]  ffff88002e447848 ffffffff8180b4c0 ffff88002ebf9a80
> ffffffff81353740
> [  489.430079]  ffff88002e448000 ffff88003fc16d80 7fffffffffffffff
> ffff880037649728
> [  489.430083]  ffff8800376496f8 ffff88002e447860 ffffffff81473730
> 0000000000000000
> [  489.430087] Call Trace:
> [  489.430095]  [<ffffffff81353740>] ? scsi_init_io+0x40/0x1d0
> [  489.430099]  [<ffffffff81473730>] schedule+0x30/0x80
> [  489.430103]  [<ffffffff814767bd>] schedule_timeout+0x24d/0x300
> [  489.430105]  [<ffffffff8134c7df>] ? scsi_host_alloc_command+0x3f/0xb0
> [  489.430109]  [<ffffffff810aba77>] ? ktime_get+0x37/0xa0
> [  489.430111]  [<ffffffff81472f6f>] io_schedule_timeout+0x9f/0x110
> [  489.430115]  [<ffffffff81264bcd>] get_request+0x40d/0x840
> [  489.430119]  [<ffffffff810864c0>] ? wake_atomic_t_function+0x60/0x60
> [  489.430122]  [<ffffffff81268597>] blk_queue_bio+0x117/0x3c0
> [  489.430125]  [<ffffffff812669eb>] generic_make_request+0xcb/0x1a0
> [  489.430161]  [<ffffffffa02fde96>] bch_submit_bbio+0x66/0xf0 [bcache]
> [  489.430182]  [<ffffffffa02fe018>] bch_submit_bbio_replicas+0xf8/0x190
> [bcache]
> [  489.430204]  [<ffffffffa02fe3a6>] __bch_write+0x2f6/0x710 [bcache]
> [  489.430225]  [<ffffffffa02fe845>] bch_write+0x85/0x3b0 [bcache]
> [  489.430246]  [<ffffffffa0305d17>] do_pending_writes+0xa7/0x150 [bcache]
> [  489.430275]  [<ffffffffa0306748>] bch_move_ctxt_wait+0x38/0xb0 [bcache]
> [  489.430278]  [<ffffffff810864c0>] ? wake_atomic_t_function+0x60/0x60
> [  489.430297]  [<ffffffffa0314b53>] read_tiering+0x143/0x4c0 [bcache]
> [  489.430300]  [<ffffffff814732ad>] ? __schedule+0x2cd/0x720
> [  489.430316]  [<ffffffffa02e859a>] ?
> bch_bucket_stats_read_cache+0xda/0x150 [bcache]
> [  489.430335]  [<ffffffffa0315117>] bch_tiering_thread+0x247/0x250 [bcache]
> [  489.430354]  [<ffffffffa0314ed0>] ? read_tiering+0x4c0/0x4c0 [bcache]
> [  489.430357]  [<ffffffff81069f84>] kthread+0xc4/0xe0
> [  489.430360]  [<ffffffff814779ff>] ret_from_fork+0x1f/0x40
> [  489.430362]  [<ffffffff81069ec0>] ? kthread_worker_fn+0x160/0x160
> [  612.310040] INFO: task kworker/0:1:31 blocked for more than 120 seconds.
> [  612.310043]       Tainted: G        W       4.8.0+ #1
> [  612.310044] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables
> this message.
> [  612.310046] kworker/0:1     D ffff88003e34fcc8     0    31      2
> 0x00000000
> [  612.310085] Workqueue: events_freezable btree_node_write_work [bcache]
> [  612.310088]  ffff88003e34fcc8 ffffffff8180b4c0 ffff88003e261a80
> 0000000200000000
> [  612.310092]  ffff88003e350000 ffff880009de7618 ffff88003e261a80
> 0000000000000000
> [  612.310096]  ffff880009de7630 ffff88003e34fce0 ffffffff81473730
> 7fffffffffffffff
> [  612.310100] Call Trace:
> [  612.310106]  [<ffffffff81473730>] schedule+0x30/0x80
> [  612.310110]  [<ffffffff814767bd>] schedule_timeout+0x24d/0x300
> [  612.310132]  [<ffffffffa0309fe0>] ? six_lock_type+0x60/0x340 [bcache]
> [  612.310135]  [<ffffffff814752df>] __down+0x5f/0xa0
> [  612.310138]  [<ffffffff8108bd9c>] down+0x3c/0x50
> [  612.310157]  [<ffffffffa02e0fb5>] __bch_btree_node_write+0x25/0xa0
> [bcache]
> [  612.310175]  [<ffffffffa02e1066>] bch_btree_node_write_dirty+0x36/0x50
> [bcache]
> [  612.310193]  [<ffffffffa02e1142>] btree_node_write_work+0x12/0x20
> [bcache]
> [  612.310196]  [<ffffffff81064c7b>] process_one_work+0x15b/0x470
> [  612.310199]  [<ffffffff81064fd6>] worker_thread+0x46/0x4e0
> [  612.310201]  [<ffffffff81064f90>] ? process_one_work+0x470/0x470
> [  612.310203]  [<ffffffff81064f90>] ? process_one_work+0x470/0x470
> [  612.310206]  [<ffffffff81069f84>] kthread+0xc4/0xe0
> [  612.310210]  [<ffffffff814779ff>] ret_from_fork+0x1f/0x40
> [  612.310213]  [<ffffffff81069ec0>] ? kthread_worker_fn+0x160/0x160
> [  612.310218] INFO: task kworker/u8:5:71 blocked for more than 120 seconds.
> [  612.310219]       Tainted: G        W       4.8.0+ #1
> [  612.310220] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables
> this message.
> [  612.310221] kworker/u8:5    D ffff880037513798     0    71      2
> 0x00000000
> [  612.310228] Workqueue: writeback wb_workfn (flush-bcache-1)
> [  612.310231]  ffff880037513798 ffff88003e144f80 ffff88003cfab500
> ffff88003a3fc860
> [  612.310235]  ffff880037514000 ffff8800375137e0 0000000000000004
> 0000000000000004
> [  612.310238]  ffff8800376cd850 ffff8800375137b0 ffffffff81473730
> 0000000000000002
> [  612.310242] Call Trace:
> [  612.310245]  [<ffffffff81473730>] schedule+0x30/0x80
> [  612.310274]  [<ffffffffa030a1b2>] six_lock_type+0x232/0x340 [bcache]
> [  612.310290]  [<ffffffffa02e17de>] btree_node_lock_write+0x8e/0xc0
> [bcache]
> [  612.310306]  [<ffffffffa02e3ec1>] btree_node_lock_for_insert+0x51/0x90
> [bcache]
> [  612.310322]  [<ffffffffa02e68e0>] __bch_btree_insert_at+0x230/0x990
> [bcache]
> [  612.310338]  [<ffffffffa02e307a>] ?
> bch_btree_iter_peek_with_holes+0x8a/0x290 [bcache]
> [  612.310356]  [<ffffffffa02f609c>] __bch_write_inode+0x22c/0x2b0 [bcache]
> [  612.310360]  [<ffffffff8107f468>] ? find_busiest_group+0x118/0x930
> [  612.310377]  [<ffffffffa02f63ec>] bch_vfs_write_inode+0x3c/0x90 [bcache]
> [  612.310380]  [<ffffffff8118994f>] __writeback_single_inode+0x24f/0x320
> [  612.310382]  [<ffffffff81189e95>] writeback_sb_inodes+0x1d5/0x490
> [  612.310385]  [<ffffffff8118a1dd>] __writeback_inodes_wb+0x8d/0xc0
> [  612.310387]  [<ffffffff8118a4ca>] wb_writeback+0x22a/0x2e0
> [  612.310390]  [<ffffffff8118c508>] wb_workfn+0x2e8/0x3b0
> [  612.310392]  [<ffffffff81064c7b>] process_one_work+0x15b/0x470
> [  612.310394]  [<ffffffff81064fd6>] worker_thread+0x46/0x4e0
> [  612.310396]  [<ffffffff81064f90>] ? process_one_work+0x470/0x470
> [  612.310398]  [<ffffffff81069f84>] kthread+0xc4/0xe0
> [  612.310401]  [<ffffffff814779ff>] ret_from_fork+0x1f/0x40
> [  612.310403]  [<ffffffff81069ec0>] ? kthread_worker_fn+0x160/0x160
> [  612.310425] INFO: task bch_tier_read:2383 blocked for more than 120
> seconds.
> [  612.310427]       Tainted: G        W       4.8.0+ #1
> [  612.310427] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables
> this message.
> [  612.310428] bch_tier_read   D ffff88002e447848     0  2383      2
> 0x00000000
> [  612.310432]  ffff88002e447848 ffffffff8180b4c0 ffff88002ebf9a80
> ffffffff81353740
> [  612.310435]  ffff88002e448000 ffff88003fc16d80 7fffffffffffffff
> ffff880037649728
> [  612.310438]  ffff8800376496f8 ffff88002e447860 ffffffff81473730
> 0000000000000000
> [  612.310441] Call Trace:
> [  612.310444]  [<ffffffff81353740>] ? scsi_init_io+0x40/0x1d0
> [  612.310446]  [<ffffffff81473730>] schedule+0x30/0x80
> [  612.310449]  [<ffffffff814767bd>] schedule_timeout+0x24d/0x300
> [  612.310451]  [<ffffffff8134c7df>] ? scsi_host_alloc_command+0x3f/0xb0
> [  612.310454]  [<ffffffff810aba77>] ? ktime_get+0x37/0xa0
> [  612.310456]  [<ffffffff81472f6f>] io_schedule_timeout+0x9f/0x110
> [  612.310459]  [<ffffffff81264bcd>] get_request+0x40d/0x840
> [  612.310462]  [<ffffffff810864c0>] ? wake_atomic_t_function+0x60/0x60
> [  612.310465]  [<ffffffff81268597>] blk_queue_bio+0x117/0x3c0
> [  612.310467]  [<ffffffff812669eb>] generic_make_request+0xcb/0x1a0
> [  612.310485]  [<ffffffffa02fde96>] bch_submit_bbio+0x66/0xf0 [bcache]
> [  612.310503]  [<ffffffffa02fe018>] bch_submit_bbio_replicas+0xf8/0x190
> [bcache]
> [  612.310521]  [<ffffffffa02fe3a6>] __bch_write+0x2f6/0x710 [bcache]
> [  612.310539]  [<ffffffffa02fe845>] bch_write+0x85/0x3b0 [bcache]
> [  612.310558]  [<ffffffffa0305d17>] do_pending_writes+0xa7/0x150 [bcache]
> [  612.310576]  [<ffffffffa0306748>] bch_move_ctxt_wait+0x38/0xb0 [bcache]
> [  612.310578]  [<ffffffff810864c0>] ? wake_atomic_t_function+0x60/0x60
> [  612.310597]  [<ffffffffa0314b53>] read_tiering+0x143/0x4c0 [bcache]
> [  612.310600]  [<ffffffff814732ad>] ? __schedule+0x2cd/0x720
> [  612.310616]  [<ffffffffa02e859a>] ?
> bch_bucket_stats_read_cache+0xda/0x150 [bcache]
> [  612.310635]  [<ffffffffa0315117>] bch_tiering_thread+0x247/0x250 [bcache]
> [  612.310654]  [<ffffffffa0314ed0>] ? read_tiering+0x4c0/0x4c0 [bcache]
> [  612.310656]  [<ffffffff81069f84>] kthread+0xc4/0xe0
> [  612.310659]  [<ffffffff814779ff>] ret_from_fork+0x1f/0x40
> [  612.310661]  [<ffffffff81069ec0>] ? kthread_worker_fn+0x160/0x160
> 
> [...]

hmm...

I still haven't figured out the FUA bug, and this does still look like IO
getting stuck. We do still issue FUA writes for metadata writes with the change
I told you to make, so maybe you're still hitting that bug.

I'll let you know when I figure out the FUA bug.
