From: Igor Gnatenko <i.gnatenko.brain-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: [BUG] unable to handle kernel NULL pointer dereference at
 000000000000006c (bch_insert_data)
Date: Mon, 14 Oct 2013 01:24:21 +0400
Message-ID: <1381699461.2306.6.camel@ThinkPad-X230.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-bcache-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-bcache-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-bcache-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-bcache@vger.kernel.org

On testday we found: https://bugzilla.redhat.com/show_bug.cgi?id=1018615
which have dmesg after sysrq-t (also have some lines down).
We setted cache_mode to writeback, mounted to foldear and started copy
files to mounted bcache folder. It was copied some % and stayed.
We running 3.11.4 kernel, which have fix for flushing data.

[ 1550.135293] BUG: unable to handle kernel NULL pointer dereference at
000000000000006c
[ 1550.135335] IP: [<ffffffffa04cc659>] bch_insert_data+0x19/0x30
[bcache]
[ 1550.135378] PGD 1eb80f067 PUD 1dd330067 PMD 0 
[ 1550.135401] Oops: 0002 [#1] SMP 
[ 1550.135417] Modules linked in: nf_conntrack_netbios_ns
nf_conntrack_broadcast ipt_MASQUERADE joydev ip6table_mangle
ip6table_security ip6table_raw ip6t_REJECT iptable_nat nf_nat_ipv4
iptable_mangle iptable_security iptable_raw bnep nf_conntrack_ipv4
nf_defrag_ipv4 xt_conntrack bluetooth rfkill ebtable_filter ebtables
ip6table_filter ip6table_nat nf_conntrack_ipv6 nf_defrag_ipv6
nf_nat_ipv6 nf_nat nf_conntrack ip6_tables binfmt_misc
snd_hda_codec_hdmi bcache uvcvideo videobuf2_vmalloc videobuf2_memops
videobuf2_core videodev snd_usb_audio snd_usbmidi_lib media snd_rawmidi
kvm_amd kvm microcode serio_raw k10temp snd_hda_codec_realtek edac_core
edac_mce_amd snd_hda_intel snd_hda_codec snd_seq sp5100_tco snd_hwdep
i2c_piix4 snd_seq_device snd_pcm r8169 mii snd_page_alloc snd_timer snd
soundcore shpchp
[ 1550.135731]  acpi_cpufreq mperf nfsd auth_rpcgss nfs_acl lockd sunrpc
nouveau video mxm_wmi i2c_algo_bit ata_generic pata_acpi drm_kms_helper
firewire_ohci ttm firewire_core pata_jmicron drm pata_atiixp crc_itu_t
i2c_core wmi
[ 1550.135838] CPU: 0 PID: 680 Comm: jbd2/bcache0-8 Not tainted
3.11.4-301.fc20.x86_64 #1
[ 1550.135857] Hardware name: Gigabyte Technology Co., Ltd.
GA-890GPA-UD3H/GA-890GPA-UD3H, BIOS F4 03/08/2010
[ 1550.135878] task: ffff880221d68f40 ti: ffff880217474000 task.ti:
ffff880217474000
[ 1550.135894] RIP: 0010:[<ffffffffa04cc659>]  [<ffffffffa04cc659>]
bch_insert_data+0x19/0x30 [bcache]
[ 1550.135934] RSP: 0018:ffff880217475af0  EFLAGS: 00010246
[ 1550.135948] RAX: 0000000000000000 RBX: ffff880217739e30 RCX:
0000000000000000
[ 1550.135963] RDX: ffff880217739f30 RSI: 0000000000000000 RDI:
ffff880217739f30
[ 1550.135978] RBP: ffff880217475af0 R08: 0000000000016f60 R09:
0000000000000000
[ 1550.135993] R10: 0000000000000000 R11: 0000000000000000 R12:
ffff88021a960000
[ 1550.136009] R13: ffff8802212a19c0 R14: ffff880217739e90 R15:
ffff880217739e30
[ 1550.136026] FS:  00007fafab1a9700(0000) GS:ffff88022fc00000(0000)
knlGS:00000000f5fffb40
[ 1550.136043] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
[ 1550.136056] CR2: 000000000000006c CR3: 00000001eb80d000 CR4:
00000000000007f0
[ 1550.136076] Stack:
[ 1550.136085]  ffff880217475b00 ffffffffa04d92c3 ffff880217475b60
ffffffffa04ccf35
[ 1550.136114]  ffff88021a960010 8000000000000000 0000000000440128
8000000000000000
[ 1550.136142]  0000000000440130 ffff88021a960010 ffff8802212a19c0
0000000000000000
[ 1550.136169] Call Trace:
[ 1550.136201]  [<ffffffffa04d92c3>] closure_queue+0x43/0x50 [bcache]
[ 1550.136233]  [<ffffffffa04ccf35>] request_write+0x1c5/0x480 [bcache]
[ 1550.136265]  [<ffffffffa04cd362>] cached_dev_make_request+0x172/0x400
[bcache]
[ 1550.136286]  [<ffffffff812d41d2>] generic_make_request+0xc2/0x110
[ 1550.136303]  [<ffffffff812d4291>] submit_bio+0x71/0x150
[ 1550.136322]  [<ffffffff811dc5f6>] ? bio_alloc_bioset+0x196/0x2a0
[ 1550.136340]  [<ffffffff811d7733>] _submit_bh+0x143/0x220
[ 1550.136357]  [<ffffffff811d7820>] submit_bh+0x10/0x20
[ 1550.136375]  [<ffffffff812708d5>]
journal_submit_commit_record.isra.11+0x1b5/0x1e0
[ 1550.136395]  [<ffffffff81271c00>] jbd2_journal_commit_transaction
+0x12b0/0x1a90
[ 1550.136417]  [<ffffffff8127630d>] kjournald2+0xbd/0x250
[ 1550.136437]  [<ffffffff81089400>] ? wake_up_atomic_t+0x30/0x30
[ 1550.136454]  [<ffffffff81276250>] ? commit_timeout+0x10/0x10
[ 1550.136474]  [<ffffffff81088640>] kthread+0xc0/0xd0
[ 1550.136490]  [<ffffffff81088580>] ? insert_kthread_work+0x40/0x40
[ 1550.136509]  [<ffffffff8165726c>] ret_from_fork+0x7c/0xb0
[ 1550.136525]  [<ffffffff81088580>] ? insert_kthread_work+0x40/0x40
[ 1550.136539] Code: 00 00 0f 0b 66 66 66 66 66 2e 0f 1f 84 00 00 00 00
00 66 66 66 66 90 48 8d 47 68 55 48 89 47 60 48 89 e5 48 89 47 58 48 8b
47 40 <f0> ff 40 6c e8 3e fb ff ff 5d c3 66 66 66 2e 0f 1f 84 00 00 00 
[ 1550.136772] RIP  [<ffffffffa04cc659>] bch_insert_data+0x19/0x30
[bcache]
[ 1550.136806]  RSP <ffff880217475af0>
[ 1550.136816] CR2: 000000000000006c
[ 1550.142486] ---[ end trace 2360439c2bcfc286 ]---


-- 
Igor Gnatenko
Fedora release 20 (Heisenbug)
Linux 3.11.4-301.fc20.x86_64
