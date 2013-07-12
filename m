From: Kent Overstreet <kmo-PEzghdH756F8UrSeD/g0lQ@public.gmane.org>
Subject: Re: kernel 3.10 + applied bcache patches unable to handle kernel
 NULL pointer dereference
Date: Thu, 11 Jul 2013 18:40:17 -0700
Message-ID: <20130712014017.GE17799@kmo-pixel>
References: <51D542EB.7070404@profihost.ag>
 <51D56066.80106@profihost.ag>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-bcache-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <51D56066.80106-2Lf/h1ldwEHR5kwTpVNS9A@public.gmane.org>
Sender: linux-bcache-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Stefan Priebe - Profihost AG <s.priebe-2Lf/h1ldwEHR5kwTpVNS9A@public.gmane.org>
Cc: linux-bcache-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-bcache@vger.kernel.org

On Thu, Jul 04, 2013 at 01:45:42PM +0200, Stefan Priebe - Profihost AG wrote:
> fix is this one: http://pastebin.com/raw.php?i=LBFJRvEt

Oh I see, the patch that introduced this is an old version of the patch
- the bcache-for-3.11 had this fixed, and I forgot to update that
branch. Thanks, I'll apply it there.

> 
> Am 04.07.2013 11:39, schrieb Stefan Priebe - Profihost AG:
> > Hello list,
> > 
> > after applying the latest patches from the bcache branch on top of
> > kernel 3.10.
> > 
> > I get the following backtrace while booting my system.
> > 
> > 
> >  BUG: unable to handle kernel NULL pointer dereference at 00000000000000a0
> >  IP: [<ffffffffa00fbe07>] bcache_dev_sectors_dirty_add+0x17/0x90 [bcache]
> >  PGD c44e83067 PUD c45480067 PMD 0
> >  SMP
> >  usb 2-1: new high-speed USB device number 2 using ehci-pci
> >  Modules linked in: bcache sd_mod ahci ehci_pci libahci ehci_hcd isci(+)
> > libsas usbcore igb usb_common scsi_transport_
> > sas i2c_algo_bit i2c_core ptp pps_core ixgbe(O+)
> >  CPU: 1 PID: 381 Comm: bcache-register Tainted: G           O 3.10.0+2-ph #1
> >  Hardware name: Supermicro
> > X9SRE/X9SRE-3F/X9SRi/X9SRi-3F/X9SRE/X9SRE-3F/X9SRi/X9SRi-3F, BIOS 2.0a
> > 04/19/2013
> >  task: ffff880c476bcaa0 ti: ffff880c44544000 task.ti: ffff880c44544000
> >  RIP: 0010:[<ffffffffa00fbe07>]  [<ffffffffa00fbe07>]
> > bcache_dev_sectors_dirty_add+0x17/0x90 [bcache]
> >  RSP: 0018:ffff880c44545850  EFLAGS: 00010246
> >  RAX: 00000000fffffff8 RBX: ffff880c437464d0 RCX: ffff880c43ef0000
> >  RDX: 000000001d1c1810 RSI: 0000000000000001 RDI: ffff880c43ee0000
> >  RBP: ffff880c44545858 R08: 0000000000000000 R09: 0000000000000000
> >  R10: 0000000000000001 R11: 0000000000000001 R12: ffff880c44545c70
> >  R13: ffff880c44545c08 R14: ffff880c43aa9000 R15: ffff880c44545968
> >  FS:  00007f545ab31700(0000) GS:ffff880c7fc20000(0000)
> > knlGS:0000000000000000
> >  CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> >  CR2: 00000000000000a0 CR3: 0000000c457bf000 CR4: 00000000000407e0
> >  DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
> >  DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
> >  Stack:
> >   ffff880c437464d0 ffff880c44545948 ffffffffa00f204d 0000000000000013
> >   ffff880c445459c0 0000000000000010 ffff880c44545968 0000000000000008
> >   0000000000000001 0000000000000001 8000000000000001 0000000000000008
> >  Call Trace:
> >   [<ffffffffa00f204d>] fix_overlapping_extents+0x2ed/0x620 [bcache]
> >   [<ffffffffa00f6f47>] ? __bch_bset_search+0xa7/0x260 [bcache]
> >   [<ffffffffa00f7cff>] ? __bch_btree_iter_init+0x7f/0xd0 [bcache]
> >   [<ffffffffa00f2464>] btree_insert_key+0xe4/0x410 [bcache]
> >   [<ffffffffa00f2a37>] bch_btree_insert_keys+0xc7/0xf0 [bcache]
> >   [<ffffffffa00f545f>] bch_btree_insert_recurse+0xbf/0x530 [bcache]
> >   [<ffffffffa00f5a19>] bch_btree_insert+0x149/0x320 [bcache]
> >   [<ffffffffa00fb1fd>] bch_journal_replay+0x15d/0x2a0 [bcache]
> >   [<ffffffffa01057d9>] run_cache_set+0x2e9/0x5e0 [bcache]
> >   [<ffffffffa01061cf>] register_cache_set+0x20f/0x2d0 [bcache]
> >   [<ffffffffa0103a61>] ? cache_alloc+0x4e1/0x500 [bcache]
> >   [<ffffffffa0106377>] register_cache+0xe7/0x190 [bcache]
> >   [<ffffffffa010660e>] register_bcache+0x1ee/0x320 [bcache]
> >   [<ffffffff8129e717>] kobj_attr_store+0x17/0x20
> >   [<ffffffff811af36d>] sysfs_write_file+0xdd/0x160
> >   [<ffffffff8114039f>] vfs_write+0xdf/0x1a0
> >   [<ffffffff811408ea>] SyS_write+0x5a/0xa0
> >   [<ffffffff81525e52>] system_call_fastpath+0x16/0x1b
> >  Code: 00 00 00 00 b8 01 00 00 00 c9 c3 66 0f 1f 84 00 00 00 00 00 55 89
> > c8 89 f6 48 89 e5 53 48 8b 8f c8 0c 00 00 4c
> > 8b 04 f1 4d 85 c0 <41> 8b 88 a0 00 00 00 74 60 85 c0 74 5c bf 01 00 00
> > 00 d3 e7 8d
> >  RIP  [<ffffffffa00fbe07>] bcache_dev_sectors_dirty_add+0x17/0x90 [bcache]
> >   RSP <ffff880c44545850>
> >  CR2: 00000000000000a0
> >  ---[ end trace 052fb8ed913f5457 ]---
> > 
> > Greets,
> > Stefan
> > 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-bcache" in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
