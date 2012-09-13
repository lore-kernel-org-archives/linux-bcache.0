From: Joseph Glanville <joseph.glanville-2MxvZkOi9dvvnOemgxGiVw@public.gmane.org>
Subject: bcache crash/bugs on HEAD (rebased on 3.6-rc5)
Date: Thu, 13 Sep 2012 17:05:42 +1000
Message-ID: <CAOzFzEhfGi0Z6r0q_3D6M181yC0t5GTs0VG6Y-9LCqU_gJCt+g@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-bcache-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-bcache-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-bcache-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Kent Overstreet <koverstreet-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
List-Id: linux-bcache@vger.kernel.org

Hi Kent, list.

I get the following crash when running fio on an LV ontop of a bcache device.
What is interesting is the rootfs is also on a LV on bcache device too.

The device setup looks like this:

sda
bcache (uses a raid1 of SSDs as cache dev)
lvm (uses bcache0 as backing device)
root/bcache(lvm volumes)

When looking at the traceback I noticed it failed inside the aio interface.
So I reverted the recent commit "66f5a1f Extensible AIO interface"
And I am able to get fio to run.

Things then get interesting though.

Though I was able to get fio to run when I tried do a test with
rw=randwrite with the cache in writeback mode it caused all IO to
hang.
dmesg then contained a hang trace which I have also attached.

All of the fio threads ended up in infinite io_wait and are
unkillable. My poor htop ended up looking like this:

  Hostname: thespian02                    Tasks: 47, 4 thr, 815 kthr; 2 running
  Mem[||||#*********      515/3935MB]     Load average: 32.89 29.96 18.35
  Swp[                     0/51199MB]     Uptime: 00:19:51
  1  [%%%%%%%%%%%%%%%%%%%%%%%%%%0.0%]     2  [%%%%%%%%%%%%%%%%%%%%%%%%%%0.0%]
  3  [************************100.0%]     4  [%%%%%%%%%%%%%%%%%%%%%%%%%%0.0%]
  5  [%%%%%%%%%%%%%%%%%%%%%%%%%%0.0%]     6  [                          0.0%]
  7  [%%%%%%%%%%%%%%%%%%%%%%%%%%0.0%]     8  [                          0.0%]
  9  [                          0.0%]     10 [                          0.0%]
  11 [                          0.0%]     12 [                          0.0%]
  13 [%%%%%%%%%%%%%%%%%%%%%%%%%%0.0%]     14 [&                         0.0%]
  15 [#*                        5.1%]     16 [%%%%%%%%%%%%%%%%%%%%%%%%%%0.0%]
  17 [                          0.0%]     18 [                          0.0%]
  19 [                          0.0%]     20 [                          0.0%]
  21 [%%%%%%%%%%%%%%%%%%%%%%%%%%0.0%]     22 [%%%%%%%%%%%%%%%%%%%%%%%%%%0.0%]
  23 [%%%%%%%%%%%%%%%%%%%%%%%%%%0.0%]     24 [                          0.0%]

:(

To ensure my issues aren't just caused by the rebase etc I will
compile the actual HEAD without my extra commits (fixes for bugs in
SCSI layer mostly) and see if that changes much.

Joseph.

thespian02 ~ # fio bcache.fio
/dev/dsan/bcache: (g=0): rw=read, bs=4K-4K/4K-4K, ioengine=libaio, iodepth=64
...
/dev/dsan/bcache: (g=0): rw=read, bs=4K-4K/4K-4K, ioengine=libaio, iodepth=64
fio 2.0.3
Starting 24 processes
[  489.956938] general protection fault: 0000 [#1] SMP
[  489.957161] Modules linked in: ib_srpt(O) scst_vdisk(O) scst(O)
bonding ib_srp raid1 dm_multipath raid0 md_mod
[  489.957702] CPU 13
[  489.957752] Pid: 4536, comm: fio Tainted: G           O 3.6.0-rc5+
#3 Dell                   PowerEdge C2100       /0P19C9
[  489.958029] RIP: e030:[<ffffffff8113bc96>]  [<ffffffff8113bc96>]
kfree+0x46/0x110
[  489.958233] RSP: e02b:ffff88013bba39b0  EFLAGS: 00010016
[  489.958337] RAX: 02931c72de934700 RBX: a4c6a4b7a4d1cdc8 RCX: 0000000000000001
[  489.958459] RDX: ffff88011ae60048 RSI: dead000000200200 RDI: 02930672de934700
[  489.958569] RBP: ffff88013bba39d0 R08: ffff88011d66a020 R09: 0000000000000001
[  489.958679] R10: ffffea0004759a80 R11: 0000000000000000 R12: ffff88011ae60000
[  489.958789] R13: ffffffff811865f6 R14: ffff88011ae60000 R15: 0000000000001000
[  489.958902] FS:  00007fa21e4de700(0000) GS:ffff88013bba0000(0000)
knlGS:0000000000000000
[  489.959070] CS:  e033 DS: 0000 ES: 0000 CR0: 000000008005003b
[  489.959175] CR2: 00007fa21524b010 CR3: 000000013585c000 CR4: 0000000000002660
[  489.959285] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
[  489.959396] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
[  489.959506] Process fio (pid: 4536, threadinfo ffff88011773a000,
task ffff88013593bb00)
[  489.959672] Stack:
[  489.959767]  ffff88013bba39d0 ffff880122cdb100 ffff88011ae60000
ffff88011ae60040
[  489.960063]  ffff88013bba3a10 ffffffff811865f6 ffff880122cdb100
ffff88011ae60000
[  489.960348]  ffff88011ae60040 0000000000000200 ffff880122cdb100
ffff88011ae60000
[  489.960633] Call Trace:
[  489.960726]  <IRQ>
[  489.960765]  [<ffffffff811865f6>] __aio_put_req+0x106/0x160
[  489.960990]  [<ffffffff811866d0>] aio_complete+0x80/0x1e0
[  489.961095]  [<ffffffff81179bdf>] dio_complete+0xaf/0xe0
[  489.961212]  [<ffffffff81179c77>] dio_bio_end_aio+0x67/0xc0
[  489.961320]  [<ffffffff810f6902>] ? mempool_free_slab+0x12/0x20
[  489.961429]  [<ffffffff81175458>] bio_endio+0x18/0x30
[  489.961536]  [<ffffffff8150aa5d>] dec_pending+0x16d/0x2f0
[  489.961641]  [<ffffffff8150ad93>] clone_endio+0x93/0xd0
[  489.961745]  [<ffffffff81175458>] bio_endio+0x18/0x30
[  489.961849]  [<ffffffff814fd33e>] bio_complete+0x3e/0xa0
[  489.961953]  [<ffffffff814fd3b1>] search_free+0x11/0x60
[  489.962057]  [<ffffffff814fd732>] cached_dev_bio_complete+0x12/0x40
[  489.962165]  [<ffffffff814fd7f9>] cached_dev_read_complete+0x69/0x80
[  489.962276]  [<ffffffff812bab56>] closure_queue+0x36/0x40
[  489.962382]  [<ffffffff814febf7>] request_read_done_bh+0xe7/0x160
[  489.962489]  [<ffffffff812bab56>] closure_queue+0x36/0x40
[  489.962611]  [<ffffffff812baccc>] closure_put+0xcc/0xe0
[  489.962716]  [<ffffffff814f901d>] bch_bbio_endio+0x2d/0x40
[  489.962821]  [<ffffffff814ff39c>] bch_cache_read_endio+0x8c/0xa0
[  489.962928]  [<ffffffff81175458>] bio_endio+0x18/0x30
[  489.963033]  [<ffffffff8128b48b>] req_bio_endio.clone.50+0x8b/0xd0
[  489.963140]  [<ffffffff8128b6b3>] blk_update_request+0x103/0x490
[  489.963249]  [<ffffffff816b7c29>] ? _raw_spin_unlock_irqrestore+0x19/0x20
[  489.963358]  [<ffffffff8128ba6f>] blk_update_bidi_request+0x2f/0x90
[  489.963466]  [<ffffffff8128c0fa>] blk_end_bidi_request+0x2a/0x80
[  489.963573]  [<ffffffff8128c18b>] blk_end_request+0xb/0x10
[  489.963679]  [<ffffffff8140d437>] scsi_io_completion+0x97/0x670
[  489.963785]  [<ffffffff816b7c29>] ? _raw_spin_unlock_irqrestore+0x19/0x20
[  489.963896]  [<ffffffff81404e8e>] scsi_finish_command+0xbe/0xf0
[  489.964011]  [<ffffffff8140d22f>] scsi_softirq_done+0x9f/0x130
[  489.964119]  [<ffffffff8129448d>] blk_done_softirq+0x7d/0x90
[  489.964226]  [<ffffffff81056d31>] __do_softirq+0xc1/0x230
[  489.964331]  [<ffffffff810c6b43>] ? handle_percpu_irq+0x43/0x60
[  489.964438]  [<ffffffff816c0b7c>] call_softirq+0x1c/0x30
[  489.964544]  [<ffffffff81016425>] do_softirq+0x65/0xa0
[  489.964647]  [<ffffffff8105711e>] irq_exit+0x8e/0xb0
[  489.964752]  [<ffffffff8132d37f>] xen_evtchn_do_upcall+0x2f/0x40
[  489.964858]  [<ffffffff816c0bce>] xen_do_hypervisor_callback+0x1e/0x30
[  489.964965]  <EOI>
[  489.965004] Code: c0 0f 85 85 00 00 00 48 83 fb 10 76 74 48 89 df
e8 60 ae f0 ff 48 bf 00 00 00 00 00 ea ff ff 48 c1 e8 0c 48 c1 e0 06
48 8d 3c 38 <48> 8b 07 f6 c4 80 0f 85 b0 00 00 00 48 8b 07 a8 80 0f 84
95 00
[  489.967357] RIP  [<ffffffff8113bc96>] kfree+0x46/0x110
[  489.967491]  RSP <ffff88013bba39b0>
[  489.967591] ---[ end trace 5acaef9eec9f0faa ]---
[  489.967595] BUG: unable to handle kernel paging request at ffffebe000000040
[  489.967599] IP: [<ffffffff8113bc96>] kfree+0x46/0x110
[  489.967600] PGD 0
[  489.967601] Oops: 0000 [#2] SMP
[  489.967605] Modules linked in: ib_srpt(O) scst_vdisk(O) scst(O)
bonding ib_srp raid1 dm_multipath raid0 md_mod
[  489.967608] CPU 0
[  489.967608] Pid: 4547, comm: fio Tainted: G      D    O 3.6.0-rc5+
#3 Dell                   PowerEdge C2100       /0P19C9
[  489.967610] RIP: e030:[<ffffffff8113bc96>]  [<ffffffff8113bc96>]
kfree+0x46/0x110
[  489.967611] RSP: e02b:ffff88013ba039b0  EFLAGS: 00010012
[  489.967611] RAX: 000001e000000040 RBX: 0000000000001000 RCX: 000000000000000b
[  489.967612] RDX: ffff880123112db0 RSI: dead000000200200 RDI: ffffebe000000040
[  489.967613] RBP: ffff88013ba039d0 R08: ffff8801227b6160 R09: 000000000000000b
[  489.967614] R10: ffffea000489ed80 R11: 0000000000000000 R12: ffff88011aeb1f80
[  489.967614] R13: ffffffff811865f6 R14: ffff88011aeb1f80 R15: 0000000000001000
[  489.967618] FS:  00007fa21e4de700(0000) GS:ffff88013ba00000(0000)
knlGS:0000000000000000
[  489.967618] CS:  e033 DS: 0000 ES: 0000 CR0: 000000008005003b
[  489.967619] CR2: ffffebe000000040 CR3: 0000000134bdd000 CR4: 0000000000002660
[  489.967620] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
[  489.967621] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
[  489.967622] Process fio (pid: 4547, threadinfo ffff880122f62000,
task ffff880126c88000)
[  489.967623] Stack:
[  489.967624]  ffff88013ba039d0 ffff880123113400 ffff88011aeb1f80
ffff88011aeb1fc0
[  489.967625]  ffff88013ba03a10 ffffffff811865f6 ffff880123113400
ffff88011aeb1f80
[  489.967627]  ffff88011aeb1fc0 0000000000000200 ffff880123113400
ffff88011aeb1f80
[  489.967627] Call Trace:
[  489.967628]  <IRQ>
[  489.967631]  [<ffffffff811865f6>] __aio_put_req+0x106/0x160
[  489.967633]  [<ffffffff811866d0>] aio_complete+0x80/0x1e0
[  489.967634]  [<ffffffff81179bdf>] dio_complete+0xaf/0xe0
[  489.967636]  [<ffffffff81179c77>] dio_bio_end_aio+0x67/0xc0
[  489.967637]  [<ffffffff810f6902>] ? mempool_free_slab+0x12/0x20
[  489.967639]  [<ffffffff81175458>] bio_endio+0x18/0x30
[  489.967642]  [<ffffffff8150aa5d>] dec_pending+0x16d/0x2f0
[  489.967644]  [<ffffffff8150ad93>] clone_endio+0x93/0xd0
[  489.967645]  [<ffffffff81175458>] bio_endio+0x18/0x30
[  489.967647]  [<ffffffff814fd33e>] bio_complete+0x3e/0xa0
[  489.967648]  [<ffffffff814fd3b1>] search_free+0x11/0x60
[  489.967650]  [<ffffffff814fd732>] cached_dev_bio_complete+0x12/0x40
[  489.967651]  [<ffffffff814fd7f9>] cached_dev_read_complete+0x69/0x80
[  489.967653]  [<ffffffff812bab56>] closure_queue+0x36/0x40
[  489.967655]  [<ffffffff814febf7>] request_read_done_bh+0xe7/0x160
[  489.967657]  [<ffffffff812bab56>] closure_queue+0x36/0x40
[  489.967658]  [<ffffffff812baccc>] closure_put+0xcc/0xe0
[  489.967660]  [<ffffffff814f901d>] bch_bbio_endio+0x2d/0x40
[  489.967661]  [<ffffffff814ff39c>] bch_cache_read_endio+0x8c/0xa0
[  489.967663]  [<ffffffff81175458>] bio_endio+0x18/0x30
[  489.967664]  [<ffffffff8128b48b>] req_bio_endio.clone.50+0x8b/0xd0
[  489.967666]  [<ffffffff8128b6b3>] blk_update_request+0x103/0x490
[  489.967667]  [<ffffffff8128ba6f>] blk_update_bidi_request+0x2f/0x90
[  489.967669]  [<ffffffff8128c0fa>] blk_end_bidi_request+0x2a/0x80
[  489.967670]  [<ffffffff8128c18b>] blk_end_request+0xb/0x10
[  489.967672]  [<ffffffff8140d437>] scsi_io_completion+0x97/0x670
[  489.967674]  [<ffffffff816b7c29>] ? _raw_spin_unlock_irqrestore+0x19/0x20
[  489.967676]  [<ffffffff81404e8e>] scsi_finish_command+0xbe/0xf0
[  489.967677]  [<ffffffff8140d22f>] scsi_softirq_done+0x9f/0x130
[  489.967679]  [<ffffffff8129448d>] blk_done_softirq+0x7d/0x90
[  489.967681]  [<ffffffff81056d31>] __do_softirq+0xc1/0x230
[  489.967683]  [<ffffffff810c6a5e>] ? handle_fasteoi_irq+0x9e/0x140
[  489.967685]  [<ffffffff816c0b7c>] call_softirq+0x1c/0x30
[  489.967687]  [<ffffffff81016425>] do_softirq+0x65/0xa0
[  489.967688]  [<ffffffff8105711e>] irq_exit+0x8e/0xb0
[  489.967690]  [<ffffffff8132d37f>] xen_evtchn_do_upcall+0x2f/0x40
[  489.967692]  [<ffffffff816c0bce>] xen_do_hypervisor_callback+0x1e/0x30
[  489.967694]  <EOI>
[  489.967695]  [<ffffffff8100122a>] ? hypercall_page+0x22a/0x1000
[  489.967697]  [<ffffffff8100122a>] ? hypercall_page+0x22a/0x1000
[  489.967701]  [<ffffffff81009b6d>] ? xen_force_evtchn_callback+0xd/0x10
[  489.967703]  [<ffffffff8100a272>] ? check_events+0x12/0x20
[  489.967705]  [<ffffffff8100a25f>] ? xen_restore_fl_direct_reloc+0x4/0x4
[  489.967707]  [<ffffffff810093dc>] ? xen_alloc_pte+0x1bc/0x320
[  489.967711]  [<ffffffff81118a82>] ? __pte_alloc+0x72/0xf0
[  489.967713]  [<ffffffff8111c5ff>] ? handle_mm_fault+0x1df/0x220
[  489.967716]  [<ffffffff816bb59c>] ? do_page_fault+0x18c/0x4d0
[  489.967718]  [<ffffffff81004be0>] ? xen_mc_flush+0xb0/0x1b0
[  489.967720]  [<ffffffff810047c3>] ? xen_clts+0x93/0x150
[  489.967722]  [<ffffffff816b8125>] ? page_fault+0x25/0x30
[  489.967736] Code: c0 0f 85 85 00 00 00 48 83 fb 10 76 74 48 89 df
e8 60 ae f0 ff 48 bf 00 00 00 00 00 ea ff ff 48 c1 e8 0c 48 c1 e0 06
48 8d 3c 38 <48> 8b 07 f6 c4 80 0f 85 b0 00 00 00 48 8b 07 a8 80 0f 84
95 00
[  489.967738] RIP  [<ffffffff8113bc96>] kfree+0x46/0x110
[  489.967738]  RSP <ffff88013ba039b0>
[  489.967739] CR2: ffffebe000000040
[  489.967742] ---[ end trace 5acaef9eec9f0fab ]---
[  489.967744] Kernel panic - not syncing: Fatal exception in interrupt
[  489.967752] general protection fault: 0000 [#3] SMP
[  489.967762] Modules linked in: ib_srpt(O) scst_vdisk(O) scst(O)
bonding ib_srp raid1 dm_multipath raid0 md_mod
[  489.967768] CPU 12
[  489.967769] Pid: 0, comm: swapper/12 Tainted: G      D    O
3.6.0-rc5+ #3 Dell                   PowerEdge C2100       /0P19C9
[  489.967783] RIP: e030:[<ffffffff8113bc96>]  [<ffffffff8113bc96>]
kfree+0x46/0x110
[  489.967784] RSP: e02b:ffff88013bb839b0  EFLAGS: 00010012
[  489.967785] RAX: 01b5cb9d98b5c180 RBX: 6d726f662d706870 RCX: 0000000000000007
[  489.967786] RDX: ffff8801355f27b0 RSI: dead000000200200 RDI: 01b5b59d98b5c180
[  489.967787] RBP: ffff88013bb839d0 R08: ffff8801222240e0 R09: 0000000000000007
[  489.967788] R10: ffffea0004888900 R11: 0000000000000000 R12: ffff8801356cc180
[  489.967789] R13: ffffffff811865f6 R14: ffff8801356cc180 R15: 0000000000001000
[  489.967793] FS:  00007fa21e4de700(0000) GS:ffff88013bb80000(0000)
knlGS:0000000000000000
[  489.967794] CS:  e033 DS: 002b ES: 002b CR0: 000000008005003b
[  489.967795] CR2: 00007fa21524b010 CR3: 00000001245ae000 CR4: 0000000000002660
[  489.967796] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
[  489.967797] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
[  489.967798] Process swapper/12 (pid: 0, threadinfo
ffff880136ed0000, task ffff880136ec8ec0)
[  489.967799] Stack:
[  489.967800]  ffff88013bb839d0 ffff880134872000 ffff8801356cc180
ffff8801356cc1c0
[  489.967801]  ffff88013bb83a10 ffffffff811865f6 ffff880134872000
ffff8801356cc180
[  489.967803]  ffff8801356cc1c0 0000000000000200 ffff880134872000
ffff8801356cc180
[  489.967803] Call Trace:
[  489.967806]  <IRQ>
[  489.967810]  [<ffffffff811865f6>] __aio_put_req+0x106/0x160
[  489.967812]  [<ffffffff811866d0>] aio_complete+0x80/0x1e0
[  489.967814]  [<ffffffff81179bdf>] dio_complete+0xaf/0xe0
[  489.967815]  [<ffffffff81179c77>] dio_bio_end_aio+0x67/0xc0
[  489.967818]  [<ffffffff810f6902>] ? mempool_free_slab+0x12/0x20
[  489.967820]  [<ffffffff81175458>] bio_endio+0x18/0x30
[  489.967824]  [<ffffffff8150aa5d>] dec_pending+0x16d/0x2f0
[  489.967825]  [<ffffffff8150ad93>] clone_endio+0x93/0xd0
[  489.967827]  [<ffffffff81175458>] bio_endio+0x18/0x30
[  489.967829]  [<ffffffff814fd33e>] bio_complete+0x3e/0xa0
[  489.967830]  [<ffffffff814fd3b1>] search_free+0x11/0x60
[  489.967831]  [<ffffffff814fd732>] cached_dev_bio_complete+0x12/0x40
[  489.967833]  [<ffffffff814fd7f9>] cached_dev_read_complete+0x69/0x80
[  489.967836]  [<ffffffff812bab56>] closure_queue+0x36/0x40
[  489.967837]  [<ffffffff814febf7>] request_read_done_bh+0xe7/0x160
[  489.967839]  [<ffffffff812bab56>] closure_queue+0x36/0x40
[  489.967841]  [<ffffffff812baccc>] closure_put+0xcc/0xe0
[  489.967842]  [<ffffffff814f901d>] bch_bbio_endio+0x2d/0x40
[  489.967844]  [<ffffffff814ff39c>] bch_cache_read_endio+0x8c/0xa0
[  489.967845]  [<ffffffff81175458>] bio_endio+0x18/0x30
[  489.967847]  [<ffffffff8128b48b>] req_bio_endio.clone.50+0x8b/0xd0
[  489.967849]  [<ffffffff8128b6b3>] blk_update_request+0x103/0x490
[  489.967850]  [<ffffffff8128ba6f>] blk_update_bidi_request+0x2f/0x90
[  489.967852]  [<ffffffff8128c0fa>] blk_end_bidi_request+0x2a/0x80
[  489.967853]  [<ffffffff8128c18b>] blk_end_request+0xb/0x10
[  489.967855]  [<ffffffff8140d437>] scsi_io_completion+0x97/0x670
[  489.967858]  [<ffffffff816b7c29>] ? _raw_spin_unlock_irqrestore+0x19/0x20
[  489.967860]  [<ffffffff81404e8e>] scsi_finish_command+0xbe/0xf0
[  489.967862]  [<ffffffff8140d22f>] scsi_softirq_done+0x9f/0x130
[  489.967865]  [<ffffffff8129448d>] blk_done_softirq+0x7d/0x90
[  489.967867]  [<ffffffff81056d31>] __do_softirq+0xc1/0x230
[  489.967870]  [<ffffffff810c6b43>] ? handle_percpu_irq+0x43/0x60
[  489.967872]  [<ffffffff816c0b7c>] call_softirq+0x1c/0x30
[  489.967875]  [<ffffffff81016425>] do_softirq+0x65/0xa0
[  489.967876]  [<ffffffff8105711e>] irq_exit+0x8e/0xb0
[  489.967880]  [<ffffffff8132d37f>] xen_evtchn_do_upcall+0x2f/0x40
[  489.967881]  [<ffffffff816c0bce>] xen_do_hypervisor_callback+0x1e/0x30
[  489.967882]  <EOI>
[  489.967884]  [<ffffffff810013aa>] ? hypercall_page+0x3aa/0x1000
[  489.967885]  [<ffffffff810013aa>] ? hypercall_page+0x3aa/0x1000
[  489.967888]  [<ffffffff81009b10>] ? xen_safe_halt+0x10/0x20
[  489.967891]  [<ffffffff8101c878>] ? default_idle+0x58/0x1b0
[  489.967892]  [<ffffffff8101d49f>] ? cpu_idle+0x8f/0xc0
[  489.967894]  [<ffffffff8100a219>] ? xen_irq_enable_direct_reloc+0x4/0x4
[  489.967896]  [<ffffffff816ac412>] ? cpu_bringup_and_idle+0xe/0x10
[  489.967913] Code: c0 0f 85 85 00 00 00 48 83 fb 10 76 74 48 89 df
e8 60 ae f0 ff 48 bf 00 00 00 00 00 ea ff ff 48 c1 e8 0c 48 c1 e0 06
48 8d 3c 38 <48> 8b 07 f6 c4 80 0f 85 b0 00 00 00 48 8b 07 a8 80 0f 84
95 00

dmesg from second run:

[  461.023400] INFO: rcu_sched self-detected stall on CPU { 2}
(t=60000 jiffies)
[  461.023410] Pid: 1159, comm: kworker/2:1 Tainted: G           O 3.6.0-rc5+ #4
[  461.023412] Call Trace:
[  461.023414]  <IRQ>  [<ffffffff810cb232>] rcu_check_callbacks+0x4d2/0x640
[  461.023429]  [<ffffffff8109bd80>] ? tick_nohz_handler+0xf0/0xf0
[  461.023434]  [<ffffffff8105f303>] update_process_times+0x43/0x80
[  461.023436]  [<ffffffff8109bde7>] tick_sched_timer+0x67/0xd0
[  461.023439]  [<ffffffff810751ff>] __run_hrtimer+0x7f/0x1d0
[  461.023445]  [<ffffffff81009ff9>] ? xen_clocksource_get_cycles+0x9/0x10
[  461.023448]  [<ffffffff810956d7>] ? ktime_get_update_offsets+0x47/0xd0
[  461.023450]  [<ffffffff81075a3e>] hrtimer_interrupt+0xfe/0x250
[  461.023453]  [<ffffffff81009ccd>] xen_timer_interrupt+0x2d/0x1b0
[  461.023457]  [<ffffffff816b7e90>] ? _raw_spin_lock_irq+0x10/0x20
[  461.023459]  [<ffffffff8105e0f9>] ? run_timer_softirq+0x1f9/0x3b0
[  461.023464]  [<ffffffff810c39fd>] handle_irq_event_percpu+0x5d/0x200
[  461.023466]  [<ffffffff810c6b43>] handle_percpu_irq+0x43/0x60
[  461.023472]  [<ffffffff8132b3e6>] __xen_evtchn_do_upcall+0x1a6/0x260
[  461.023475]  [<ffffffff8132d47a>] xen_evtchn_do_upcall+0x2a/0x40
[  461.023479]  [<ffffffff816c0d8e>] xen_do_hypervisor_callback+0x1e/0x30
[  461.023480]  <EOI>  [<ffffffff814ed601>] ? bch_allocator_thread+0x4e1/0xed0
[  461.023490]  [<ffffffff810879c8>] ? idle_balance+0xf8/0x150
[  461.023495]  [<ffffffff81071600>] ? wake_up_bit+0x40/0x40
[  461.023499]  [<ffffffff816b6cc8>] ? __schedule+0x398/0x780
[  461.023502]  [<ffffffff814ed120>] ? bch_bucket_add_unused+0xe0/0xe0
[  461.023504]  [<ffffffff8106a65a>] ? process_one_work+0x13a/0x500
[  461.023506]  [<ffffffff8106bb65>] ? worker_thread+0x1a5/0x510
[  461.023509]  [<ffffffff816b7e09>] ? _raw_spin_unlock_irqrestore+0x19/0x20
[  461.023511]  [<ffffffff8106b9c0>] ? manage_workers+0x330/0x330
[  461.023513]  [<ffffffff81070cd6>] ? kthread+0x96/0xa0
[  461.023515]  [<ffffffff816c0c44>] ? kernel_thread_helper+0x4/0x10
[  461.023518]  [<ffffffff816b8078>] ? retint_restore_args+0x5/0x6
[  461.023520]  [<ffffffff816c0c40>] ? gs_change+0x13/0x13
[  641.026218] INFO: rcu_sched self-detected stall on CPU { 2}
(t=240003 jiffies)
[  641.026227] Pid: 1159, comm: kworker/2:1 Tainted: G           O 3.6.0-rc5+ #4
[  641.026229] Call Trace:
[  641.026231]  <IRQ>  [<ffffffff810cb232>] rcu_check_callbacks+0x4d2/0x640
[  641.026243]  [<ffffffff8109bd80>] ? tick_nohz_handler+0xf0/0xf0
[  641.026246]  [<ffffffff8105f303>] update_process_times+0x43/0x80
[  641.026248]  [<ffffffff8109bde7>] tick_sched_timer+0x67/0xd0
[  641.026251]  [<ffffffff810751ff>] __run_hrtimer+0x7f/0x1d0
[  641.026256]  [<ffffffff81009ff9>] ? xen_clocksource_get_cycles+0x9/0x10
[  641.026259]  [<ffffffff810956d7>] ? ktime_get_update_offsets+0x47/0xd0
[  641.026261]  [<ffffffff81075a3e>] hrtimer_interrupt+0xfe/0x250
[  641.026264]  [<ffffffff816b7e09>] ? _raw_spin_unlock_irqrestore+0x19/0x20
[  641.026267]  [<ffffffff81009ccd>] xen_timer_interrupt+0x2d/0x1b0
[  641.026269]  [<ffffffff816b7e90>] ? _raw_spin_lock_irq+0x10/0x20
[  641.026271]  [<ffffffff8105e0f9>] ? run_timer_softirq+0x1f9/0x3b0
[  641.026275]  [<ffffffff810c39fd>] handle_irq_event_percpu+0x5d/0x200
[  641.026277]  [<ffffffff810c6b43>] handle_percpu_irq+0x43/0x60
[  641.026281]  [<ffffffff8132b3e6>] __xen_evtchn_do_upcall+0x1a6/0x260
[  641.026284]  [<ffffffff8132d47a>] xen_evtchn_do_upcall+0x2a/0x40
[  641.026288]  [<ffffffff816c0d8e>] xen_do_hypervisor_callback+0x1e/0x30
[  641.026289]  <EOI>  [<ffffffff814ed6e5>] ? bch_allocator_thread+0x5c5/0xed0
[  641.026296]  [<ffffffff810879c8>] ? idle_balance+0xf8/0x150
[  641.026300]  [<ffffffff81071600>] ? wake_up_bit+0x40/0x40
[  641.026303]  [<ffffffff816b6cc8>] ? __schedule+0x398/0x780
[  641.026306]  [<ffffffff814ed120>] ? bch_bucket_add_unused+0xe0/0xe0
[  641.026308]  [<ffffffff8106a65a>] ? process_one_work+0x13a/0x500
[  641.026310]  [<ffffffff8106bb65>] ? worker_thread+0x1a5/0x510
[  641.026312]  [<ffffffff816b7e09>] ? _raw_spin_unlock_irqrestore+0x19/0x20
[  641.026314]  [<ffffffff8106b9c0>] ? manage_workers+0x330/0x330
[  641.026317]  [<ffffffff81070cd6>] ? kthread+0x96/0xa0
[  641.026319]  [<ffffffff816c0c44>] ? kernel_thread_helper+0x4/0x10
[  641.026321]  [<ffffffff816b8078>] ? retint_restore_args+0x5/0x6
[  641.026323]  [<ffffffff816c0c40>] ? gs_change+0x13/0x13

-- 
CTO | Orion Virtualisation Solutions | www.orionvm.com.au
Phone: 1300 56 99 52 | Mobile: 0428 754 846
