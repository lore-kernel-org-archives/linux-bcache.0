From: Joseph Glanville <joseph.glanville-2MxvZkOi9dvvnOemgxGiVw@public.gmane.org>
Subject: Re: bcache crash/bugs on HEAD (rebased on 3.6-rc5)
Date: Thu, 13 Sep 2012 17:14:06 +1000
Message-ID: <CAOzFzEi=esX5SD9Fhy2utsR=bq5R9jxPKKez7CfwmwtOTHvNGw@mail.gmail.com>
References: <CAOzFzEhfGi0Z6r0q_3D6M181yC0t5GTs0VG6Y-9LCqU_gJCt+g@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-bcache-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CAOzFzEhfGi0Z6r0q_3D6M181yC0t5GTs0VG6Y-9LCqU_gJCt+g-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-bcache-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-bcache-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Kent Overstreet <koverstreet-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
List-Id: linux-bcache@vger.kernel.org

After leaving it for a while it eventually crashed with the following:

[ 1770.462955] Modules linked in: ib_srpt(O) scst_vdisk(O) scst(O)
bonding ib_srp raid1 dm_multipath raid0 md_mod
[ 1770.463152] CPU 0
[ 1770.463163] Pid: 4573, comm: kworker/0:0 Tainted: G           O
3.6.0-rc5+ #4 Dell                   PowerEdge C2100       /0P19C9
[ 1770.463375] RIP: e030:[<ffffffff8155a0cc>]  [<ffffffff8155a0cc>]
ipoib_cm_tx_handler+0x17c/0x2d0
[ 1770.463525] RSP: e02b:ffff8801265f5c90  EFLAGS: 00010086
[ 1770.463602] RAX: dead000000200200 RBX: ffff880115bb6000 RCX: 0000000000000000
[ 1770.463686] RDX: dead000000100100 RSI: ffff880115580200 RDI: ffff8801275a3200
[ 1770.463770] RBP: ffff8801265f5ce0 R08: 0000000000000040 R09: 0000000000000040
[ 1770.463857] R10: 0000000000007ff0 R11: dead000000200200 R12: ffff880115580200
[ 1770.463941] R13: 0000000000000001 R14: ffff880118818600 R15: 0000000000000000
[ 1770.464027] FS:  00007f41ee938700(0000) GS:ffff88013ba00000(0000)
knlGS:0000000000000000
[ 1770.464167] CS:  e033 DS: 0000 ES: 0000 CR0: 000000008005003b
[ 1770.464245] CR2: ffffffffff600400 CR3: 00000001231dd000 CR4: 0000000000002660
[ 1770.464346] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
[ 1770.464430] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
[ 1770.464514] Process kworker/0:0 (pid: 4573, threadinfo
ffff8801265f4000, task ffff88011aa00760)
[ 1770.464656] Stack:
[ 1770.464720]  0000000000000000 ffff88011558ca00 ffff880115bb62e0
ffff880115bb66c0
[ 1770.464869]  ffffffff8103e912 ffff880135b34e00 ffff880135b36800
ffff880135b36870
[ 1770.465018]  0000000000000001 ffffffff81530020 ffff8801265f5d40
ffffffff8152e352
[ 1770.465165] Call Trace:
[ 1770.465235]  [<ffffffff8103e912>] ? paravirt_end_context_switch+0x12/0x30
[ 1770.465319]  [<ffffffff81530020>] ? cm_req_handler+0xa90/0xa90
[ 1770.465398]  [<ffffffff8152e352>] cm_process_work+0x22/0x140
[ 1770.465479]  [<ffffffff8152b95f>] ? cm_get_id+0x1f/0x50
[ 1770.465556]  [<ffffffff81530020>] ? cm_req_handler+0xa90/0xa90
[ 1770.465636]  [<ffffffff81530241>] cm_work_handler+0x221/0x1090
[ 1770.465735]  [<ffffffff816b6cc8>] ? __schedule+0x398/0x780
[ 1770.465814]  [<ffffffff81530020>] ? cm_req_handler+0xa90/0xa90
[ 1770.465895]  [<ffffffff8106a65a>] process_one_work+0x13a/0x500
[ 1770.465976]  [<ffffffff8106bb65>] worker_thread+0x1a5/0x510
[ 1770.466055]  [<ffffffff816b7e09>] ? _raw_spin_unlock_irqrestore+0x19/0x20
[ 1770.466137]  [<ffffffff8106b9c0>] ? manage_workers+0x330/0x330
[ 1770.466218]  [<ffffffff81070cd6>] kthread+0x96/0xa0
[ 1770.466295]  [<ffffffff816c0c44>] kernel_thread_helper+0x4/0x10
[ 1770.466376]  [<ffffffff816b8078>] ? retint_restore_args+0x5/0x6
[ 1770.466456]  [<ffffffff816c0c40>] ? gs_change+0x13/0x13
[ 1770.466532] Code: e8 1a de 15 00 49 8b 7e 28 49 89 c4 48 85 ff 74
40 48 8b 57 48 48 8b 47 50 48 c7 47 08 00 00 00 00 49 bb 00 02 20 00
00 00 ad de <48> 89 42 08 49 bd 00 01 10 00 00 00 ad de 48 89 10 4c 89
6f 48
[ 1770.466975] RIP  [<ffffffff8155a0cc>] ipoib_cm_tx_handler+0x17c/0x2d0
[ 1770.467059]  RSP <ffff8801265f5c90>
[ 1770.467361] ---[ end trace b2eeb9864136d82b ]---
[ 1770.467463] Kernel panic - not syncing: Fatal exception in interrupt


-- 
CTO | Orion Virtualisation Solutions | www.orionvm.com.au
Phone: 1300 56 99 52 | Mobile: 0428 754 846
