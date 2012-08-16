From: Kent Overstreet <koverstreet-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Subject: Re: Kernel panic with current bcache-3.2 branch.
Date: Thu, 16 Aug 2012 16:34:57 -0700
Message-ID: <20120816233457.GA26564@google.com>
References: <CAOzFzEiS3MWe39C+XinBP3fN-Kw8Hs6n3oyqixrMVZpsuMhLcw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-bcache-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <CAOzFzEiS3MWe39C+XinBP3fN-Kw8Hs6n3oyqixrMVZpsuMhLcw-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-bcache-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Joseph Glanville <joseph.glanville-2MxvZkOi9dvvnOemgxGiVw@public.gmane.org>
Cc: linux-bcache-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-bcache@vger.kernel.org

On Thu, Aug 16, 2012 at 06:51:15PM +1000, Joseph Glanville wrote:
> Hi list, Kent,
> 
> I caused a crash with the current 3.2 branch under Xen dom0.
> By the look of it the swap LV caused the crash?

Argh. Strange bug.

I wonder if this is related to a bug someone on lkml noticed the other
day in my change to the dm code... I see you've got dm_multipath linked
in. That would cause memory corruption (underruning allocated memory),
which might cause this.

I'm going to try and reproduce it too, it might be something simpler.
How are things configured? I see raid1 in the call stack, but there must
be something else too because raid1 doesn't call bio_pair_split().

> 
> Joseph.
> 
> [ 1103.762081] kernel BUG at fs/bio.c:420!
> [ 1103.762172] invalid opcode: 0000 [#1] SMP
> [ 1103.762260] CPU 10
> [ 1103.762270] Modules linked in: ib_srpt(O) scst_vdisk(O) scst(O)
> bonding ib_srp raid1 dm_multipath raid0 md_mod
> [ 1103.762512]
> [ 1103.762577] Pid: 0, comm: swapper/10 Tainted: G           O 3.2.0+
> #2 Dell                   PowerEdge C2100       /0P19C9
> [ 1103.762739] RIP: e030:[<ffffffff811648a7>]  [<ffffffff811648a7>]
> bio_put+0x27/0x30
> [ 1103.762893] RSP: e02b:ffff8800bf538b80  EFLAGS: 00010246
> [ 1103.762971] RAX: 0000000000000000 RBX: ffff88007b725418 RCX: ffff8800bf6d3870
> [ 1103.763060] RDX: ffff88008d1ddca0 RSI: ffff8800bf6d0270 RDI: ffff88007b725418
> [ 1103.763145] RBP: ffff8800bf538b80 R08: ffff8800bf547d80 R09: 0000000000000000
> [ 1103.763235] R10: 0000000000000000 R11: 0000000000000000 R12: ffff88007cf03980
> [ 1103.763320] R13: ffff880074027980 R14: 0000000000000400 R15: 0000000000000001
> [ 1103.763407] FS:  00007f610dd14740(0000) GS:ffff8800bf535000(0000)
> knlGS:0000000000000000
> [ 1103.763563] CS:  e033 DS: 002b ES: 002b CR0: 000000008005003b
> [ 1103.763645] CR2: 00000000021d61b8 CR3: 000000009d683000 CR4: 0000000000002660
> [ 1103.763737] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
> [ 1103.763825] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
> [ 1103.763914] Process swapper/10 (pid: 0, threadinfo
> ffff8800b5eac000, task ffff8800b5e7d070)
> [ 1103.764058] Stack:
> [ 1103.764124]  ffff8800bf538ba0 ffffffff8115f7f3 ffff8800bf538ba8
> ffff88007b725400
> [ 1103.764275]  ffff8800bf538bb0 ffffffff81163a98 ffff8800bf538bd0
> ffffffff811648e9
> [ 1103.764423]  ffff88001ae54000 ffff88001a807600 ffff8800bf538be0
> ffffffff8116491a
> [ 1103.764572] Call Trace:
> [ 1103.764639]  <IRQ>
> [ 1103.764712]  [<ffffffff8115f7f3>] end_bio_bh_io_sync+0x33/0x50
> [ 1103.764793]  [<ffffffff81163a98>] bio_endio+0x18/0x30
> [ 1103.764886]  [<ffffffff811648e9>] bio_pair_release+0x39/0x50
> [ 1103.764967]  [<ffffffff8116491a>] bio_pair_end+0x1a/0x20
> [ 1103.765045]  [<ffffffff81163a98>] bio_endio+0x18/0x30
> [ 1103.765130]  [<ffffffffa0024647>] call_bio_endio+0x57/0xb0 [raid1]
> [ 1103.765219]  [<ffffffff8100122a>] ? hypercall_page+0x22a/0x1000
> [ 1103.765301]  [<ffffffffa0024725>] raid_end_bio_io+0x85/0x90 [raid1]
> [ 1103.765384]  [<ffffffffa0025336>] raid1_end_read_request+0x56/0x190 [raid1]
> [ 1103.765470]  [<ffffffff81009f52>] ? check_events+0x12/0x20
> [ 1103.765550]  [<ffffffff81163a98>] bio_endio+0x18/0x30
> [ 1103.765637]  [<ffffffff81274d4b>] req_bio_endio.clone.38+0x8b/0xd0
> [ 1103.765723]  [<ffffffff81275043>] blk_update_request+0x103/0x490
> [ 1103.765805]  [<ffffffff812753ff>] blk_update_bidi_request+0x2f/0x90
> [ 1103.765888]  [<ffffffff8127798a>] blk_end_bidi_request+0x2a/0x80
> [ 1103.765970]  [<ffffffff81277a1b>] blk_end_request+0xb/0x10
> [ 1103.766052]  [<ffffffff813dc7d7>] scsi_io_completion+0x97/0x5f0
> [ 1103.766142]  [<ffffffff8166e629>] ? _raw_spin_unlock_irqrestore+0x19/0x20
> [ 1103.766232]  [<ffffffff813d4352>] scsi_finish_command+0xb2/0xf0
> [ 1103.766317]  [<ffffffff813dc5cd>] scsi_softirq_done+0x9d/0x130
> [ 1103.766400]  [<ffffffff810b6e35>] ? handle_irq_event_percpu+0xb5/0x210
> [ 1103.766484]  [<ffffffff8127d60d>] blk_done_softirq+0x7d/0x90
> [ 1103.766565]  [<ffffffff8105d6c5>] __do_softirq+0xa5/0x1c0
> [ 1103.766646]  [<ffffffff8167836c>] call_softirq+0x1c/0x30
> [ 1103.766727]  [<ffffffff81015275>] do_softirq+0x65/0xa0
> [ 1103.766806]  [<ffffffff8105da4e>] irq_exit+0x8e/0xb0
> [ 1103.766885]  [<ffffffff8130ec6f>] xen_evtchn_do_upcall+0x2f/0x40
> [ 1103.766971]  [<ffffffff816783be>] xen_do_hypervisor_callback+0x1e/0x30
> [ 1103.767056]  <EOI>
> [ 1103.767126]  [<ffffffff810013aa>] ? hypercall_page+0x3aa/0x1000
> [ 1103.767207]  [<ffffffff810013aa>] ? hypercall_page+0x3aa/0x1000
> [ 1103.767289]  [<ffffffff810097f0>] ? xen_safe_halt+0x10/0x20
> [ 1103.767372]  [<ffffffff8101b4f8>] ? default_idle+0x58/0x180
> [ 1103.767458]  [<ffffffff81012216>] ? cpu_idle+0x86/0xc0
> [ 1103.767539]  [<ffffffff81009ef9>] ? xen_irq_enable_direct_reloc+0x4/0x4
> [ 1103.767635]  [<ffffffff81663782>] ? cpu_bringup_and_idle+0xe/0x10
> [ 1103.767716] Code: 00 00 00 00 55 8b 47 40 48 89 e5 85 c0 74 1c f0
> ff 4f 40 0f 94 c0 84 c0 75 0a c9 c3 0f 1f 84 00 00 00 00 00 e8 4b ff
> ff ff c9 c3 <0f> 0b 0f 1f 80 00 00 00 00 55 48 89 e5 53 48 89 fb 48 83
> ec 08
> [ 1103.768213] RIP  [<ffffffff811648a7>] bio_put+0x27/0x30
> [ 1103.768294]  RSP <ffff8800bf538b80>
> [ 1103.768588] ---[ end trace 65811b99fc65acab ]---
> [ 1103.768693] Kernel panic - not syncing: Fatal exception in interrupt
> [ 1103.768803] Pid: 0, comm: swapper/10 Tainted: G      D    O 3.2.0+ #2
> [ 1103.768912] Call Trace:
> [ 1103.769012]  <IRQ>  [<ffffffff8166b889>] panic+0x8c/0x1a0
> [ 1103.769155]  [<ffffffff8166f53a>] oops_end+0xea/0xf0
> [ 1103.769260]  [<ffffffff81016636>] die+0x56/0x90
> [ 1103.769363]  [<ffffffff8166eea4>] do_trap+0xc4/0x170
> [ 1103.769469]  [<ffffffff81013e50>] do_invalid_op+0x90/0xb0
> [ 1103.769583]  [<ffffffff811648a7>] ? bio_put+0x27/0x30
> [ 1103.769691]  [<ffffffff8100984d>] ? xen_force_evtchn_callback+0xd/0x10
> [ 1103.769802]  [<ffffffff81009f52>] ? check_events+0x12/0x20
> [ 1103.769910]  [<ffffffff816780eb>] invalid_op+0x1b/0x20
> [ 1103.770015]  [<ffffffff811648a7>] ? bio_put+0x27/0x30
> [ 1103.770130]  [<ffffffff8115f7f3>] end_bio_bh_io_sync+0x33/0x50
> [ 1103.771157]  [<ffffffff81163a98>] bio_endio+0x18/0x30
> [ 1103.771262]  [<ffffffff811648e9>] bio_pair_release+0x39/0x50
> [ 1103.771369]  [<ffffffff8116491a>] bio_pair_end+0x1a/0x20
> [ 1103.771475]  [<ffffffff81163a98>] bio_endio+0x18/0x30
> [ 1103.771584]  [<ffffffffa0024647>] call_bio_endio+0x57/0xb0 [raid1]
> [ 1103.771702]  [<ffffffff8100122a>] ? hypercall_page+0x22a/0x1000
> [ 1103.771829]  [<ffffffffa0024725>] raid_end_bio_io+0x85/0x90 [raid1]
> [ 1103.771939]  [<ffffffffa0025336>] raid1_end_read_request+0x56/0x190 [raid1]
> [ 1103.772060]  [<ffffffff81009f52>] ? check_events+0x12/0x20
> [ 1103.772173]  [<ffffffff81163a98>] bio_endio+0x18/0x30
> [ 1103.772281]  [<ffffffff81274d4b>] req_bio_endio.clone.38+0x8b/0xd0
> [ 1103.772391]  [<ffffffff81275043>] blk_update_request+0x103/0x490
> [ 1103.772499]  [<ffffffff812753ff>] blk_update_bidi_request+0x2f/0x90
> [ 1103.772609]  [<ffffffff8127798a>] blk_end_bidi_request+0x2a/0x80
> [ 1103.772720]  [<ffffffff81277a1b>] blk_end_request+0xb/0x10
> [ 1103.772828]  [<ffffffff813dc7d7>] scsi_io_completion+0x97/0x5f0
> [ 1103.772938]  [<ffffffff8166e629>] ? _raw_spin_unlock_irqrestore+0x19/0x20
> [ 1103.773059]  [<ffffffff813d4352>] scsi_finish_command+0xb2/0xf0
> [ 1103.773172]  [<ffffffff813dc5cd>] scsi_softirq_done+0x9d/0x130
> [ 1103.773282]  [<ffffffff810b6e35>] ? handle_irq_event_percpu+0xb5/0x210
> [ 1103.773392]  [<ffffffff8127d60d>] blk_done_softirq+0x7d/0x90
> [ 1103.773506]  [<ffffffff8105d6c5>] __do_softirq+0xa5/0x1c0
> [ 1103.773614]  [<ffffffff8167836c>] call_softirq+0x1c/0x30
> [ 1103.773722]  [<ffffffff81015275>] do_softirq+0x65/0xa0
> [ 1103.773828]  [<ffffffff8105da4e>] irq_exit+0x8e/0xb0
> [ 1103.773933]  [<ffffffff8130ec6f>] xen_evtchn_do_upcall+0x2f/0x40
> [ 1103.774042]  [<ffffffff816783be>] xen_do_hypervisor_callback+0x1e/0x30
> [ 1103.774152]  <EOI>  [<ffffffff810013aa>] ? hypercall_page+0x3aa/0x1000
> [ 1103.774300]  [<ffffffff810013aa>] ? hypercall_page+0x3aa/0x1000
> [ 1103.774414]  [<ffffffff810097f0>] ? xen_safe_halt+0x10/0x20
> [ 1103.774523]  [<ffffffff8101b4f8>] ? default_idle+0x58/0x180
> [ 1103.774646]  [<ffffffff81012216>] ? cpu_idle+0x86/0xc0
> [ 1103.774756]  [<ffffffff81009ef9>] ? xen_irq_enable_direct_reloc+0x4/0x4
> [ 1103.774867]  [<ffffffff81663782>] ? cpu_bringup_and_idle+0xe/0x10
> 
> -- 
> CTO | Orion Virtualisation Solutions | www.orionvm.com.au
> Phone: 1300 56 99 52 | Mobile: 0428 754 846
