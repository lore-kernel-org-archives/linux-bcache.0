From: Kent Overstreet <kent.overstreet@gmail.com>
Subject: Re: [branch:bcachefs-testing]  BUG: unable to handle kernel paging
 request at ffffc90006c53000
Date: Fri, 10 Feb 2017 16:11:36 -0900
Message-ID: <20170211011136.rsyub7uqacdrn4ha@moria.home.lan>
References: <3051ee002436f948e1cf43b26c4cf1e5@mejor.pl>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-bcache-owner@vger.kernel.org>
Received: from mail-pg0-f67.google.com ([74.125.83.67]:32903 "EHLO
        mail-pg0-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752912AbdBKBLk (ORCPT
        <rfc822;linux-bcache@vger.kernel.org>);
        Fri, 10 Feb 2017 20:11:40 -0500
Received: by mail-pg0-f67.google.com with SMTP id 194so4227695pgd.0
        for <linux-bcache@vger.kernel.org>; Fri, 10 Feb 2017 17:11:40 -0800 (PST)
Content-Disposition: inline
In-Reply-To: <3051ee002436f948e1cf43b26c4cf1e5@mejor.pl>
Sender: linux-bcache-owner@vger.kernel.org
List-Id: linux-bcache@vger.kernel.org
To: Marcin <marcin@mejor.pl>
Cc: linux-bcache@vger.kernel.org

On Thu, Jan 12, 2017 at 09:08:36PM +0100, Marcin wrote:
> Hi,
> all the best in 2017!
> 
> I've got reproducible bug testing bcachefs:
> 
> [ 9807.622253] BUG: unable to handle kernel paging request at
> ffffc90006c53000
> [ 9807.622310] IP: [<ffffffff812bf074>] lz4_compress+0x4e4/0x830
> [ 9807.622345] PGD 9c82e067 PUD 9c82f067 PMD 2d4f6067 PTE 0
> [ 9807.622383] Oops: 0002 [#1] SMP
> [ 9807.622408] Modules linked in: cpufreq_ondemand msr af_packet bridge stp
> llc fuse xfs coretemp hwmon kvm_intel r8188eu(C) kvm hpsa irqbypass snd_pcsp
> cfg8
> 0211 i2c_i801 snd_pcm i2c_smbus sky2 i2c_core scsi_transport_sas snd_timer
> snd rfkill soundcore button pcrypt nf_nat_ftp nf_conntrack_ftp nf_nat
> nf_conntrack
>  ipv6 acpi_cpufreq processor raid1 md_mod pata_jmicron ehci_pci ehci_hcd
> dm_mod
> [ 9807.622648] CPU: 1 PID: 6560 Comm: rsync Tainted: G         C      4.8.0+
> #2
> [ 9807.622680] Hardware name: Gigabyte Technology Co., Ltd.
> 965P-DS3/965P-DS3, BIOS F14 06/25/2009
> [ 9807.622727] task: ffff880069d63600 task.stack: ffff880069d68000
> [ 9807.622756] RIP: 0010:[<ffffffff812bf074>]  [<ffffffff812bf074>]
> lz4_compress+0x4e4/0x830
> [ 9807.622806] RSP: 0018:ffff880069d6b8a0  EFLAGS: 00010296
> [ 9807.622833] RAX: ffffc90006c63ef9 RBX: ffffc90006c54000 RCX:
> ffffc90006c53001
> [ 9807.622864] RDX: ffffc90006c63ecc RSI: ffffc90006c63f00 RDI:
> ffffc90006c52ffa
> [ 9807.622894] RBP: ffff880069d6b8f8 R08: ffffc90006c63ff3 R09:
> ffffc90006c43000
> [ 9807.622924] R10: ffffc90006c53000 R11: 0000000000000000 R12:
> ffffc90006c63ff4
> [ 9807.622955] R13: ffff880031220000 R14: ffffc90006c63ff7 R15:
> ffffc90006c43100
> [ 9807.622985] FS:  00007f60acdcb700(0000) GS:ffff88009fc80000(0000)
> knlGS:0000000000000000
> [ 9807.623032] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> [ 9807.623060] CR2: ffffc90006c53000 CR3: 00000000779a6000 CR4:
> 00000000000006e0
> [ 9807.623090] Stack:
> [ 9807.623111]  ffffc90006c43000 ffffc90006c64000 ffffc90006c63ffa
> ffffc90006c63ff9
> [ 9807.623164]  0000000000010000 ffff880069d6ba90 ffff8800779d0000
> ffff880069d6ba90
> [ 9807.623219]  ffff880069d6ba98 ffff880031220000 ffff880097a7fe20
> ffff880069d6b9d0
> [ 9807.623273] Call Trace:
> [ 9807.629620]  [<ffffffff813f5f43>] __bio_compress+0x2c3/0x3c0
> [ 9807.629650]  [<ffffffff812b7123>] ? crc32c+0x63/0x90
> [ 9807.629677]  [<ffffffff813f639c>] bch_bio_compress+0xac/0xc0
> [ 9807.629706]  [<ffffffff8140a7df>] __bch_write+0x3ff/0x7f0
> [ 9807.629734]  [<ffffffff8140ac55>] bch_write+0x85/0x3d0
> [ 9807.629762]  [<ffffffff81404df7>] bch_writepage_do_io+0x57/0x80
> [ 9807.629792]  [<ffffffff81407bae>] bch_writepages+0x2be/0x530
> [ 9807.629821]  [<ffffffff8110cc26>] ? __find_get_pages+0x136/0x370
> [ 9807.629852]  [<ffffffff812a01e3>] ? radix_tree_lookup_slot+0x13/0x30
> [ 9807.629882]  [<ffffffff811198fc>] do_writepages+0x1c/0x30
> [ 9807.629910]  [<ffffffff8110d5f5>] __filemap_fdatawrite_range+0xa5/0xe0
> [ 9807.629941]  [<ffffffff8110d74c>] filemap_write_and_wait_range+0x3c/0x90
> [ 9807.629971]  [<ffffffff81408a41>] bch_truncate+0x1f1/0x230
> [ 9807.630000]  [<ffffffff81402573>] bch_setattr+0x93/0xa0
> [ 9807.630029]  [<ffffffff81190cc7>] notify_change+0x247/0x400
> [ 9807.630059]  [<ffffffff81172b7a>] do_truncate+0x5a/0x90
> [ 9807.630088]  [<ffffffff81172e43>]
> do_sys_ftruncate.constprop.18+0xe3/0x100
> [ 9807.630119]  [<ffffffff81172e89>] SyS_ftruncate+0x9/0x10
> [ 9807.630148]  [<ffffffff814fcedf>] entry_SYSCALL_64_fastpath+0x17/0x93
> [ 9807.630177] Code: fa 0f 82 66 fe ff ff 41 83 fb 0e 0f 87 35 02 00 00 41
> c1 e3 04 48 01 cf 45 88 19 48 39 cf 76 14 4c 8b 1e 48 83 c1 08 48 83 c6 08
> <4c> 89 59 f8 48 39 cf 77 ec 49 89 c3 48 89 d0 48 8d 77 02 4c 89
> [ 9807.630404] RIP  [<ffffffff812bf074>] lz4_compress+0x4e4/0x830
> [ 9807.630435]  RSP <ffff880069d6b8a0>
> [ 9807.630459] CR2: ffffc90006c53000
> [ 9807.630759] ---[ end trace 6a05632b1eded47f ]---

I think this one should be fixed - can you test the latest bcache-dev?
