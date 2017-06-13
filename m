From: David Kleuker <post@davidak.de>
Subject: Bugreport: direct I/O (O_DIRECT) leads to uninterruptible sleep of process
Date: Tue, 13 Jun 2017 12:11:01 +0200
Message-ID: <A5C4D59E-E122-480E-8571-DB58B76DC4BA@davidak.de>
Mime-Version: 1.0 (Mac OS X Mail 8.2 \(2104\))
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
Return-path: <linux-bcache-owner@vger.kernel.org>
Received: from mx2.mailbox.org ([80.241.60.215]:45802 "EHLO mx2.mailbox.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751888AbdFMKLI (ORCPT <rfc822;linux-bcache@vger.kernel.org>);
        Tue, 13 Jun 2017 06:11:08 -0400
Received: from smtp1.mailbox.org (smtp1.mailbox.org [80.241.60.240])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mx2.mailbox.org (Postfix) with ESMTPS id 9FB604BECC
        for <linux-bcache@vger.kernel.org>; Tue, 13 Jun 2017 12:11:06 +0200 (CEST)
Received: from smtp1.mailbox.org ([80.241.60.240])
        by spamfilter03.heinlein-hosting.de (spamfilter03.heinlein-hosting.de [80.241.56.117]) (amavisd-new, port 10030)
        with ESMTP id biIB6vpSnwmv for <linux-bcache@vger.kernel.org>;
        Tue, 13 Jun 2017 12:11:04 +0200 (CEST)
Sender: linux-bcache-owner@vger.kernel.org
List-Id: linux-bcache@vger.kernel.org
To: linux-bcache@vger.kernel.org

Hello,

i encountered a bug!

Steps to reproduce:

1. create GPT scheme and 1 partition on each drive

2. bcachefs format -L tank --data_replicas=2 --metadata_replicas=2 /dev/sdb1 /dev/sdc1
External UUID:			7e811c51-4281-424c-8682-cab29f6b683f
Internal UUID:			cef378e2-a2d6-497d-ae82-99e5fe4b699e
Label:				tank
Version:			7
Block_size:			4.0K
Btree node size:		256.0K
Error action:			remount-ro
Clean:				0
Metadata replicas:		have 0, want 2
Data replicas:			have 0, want 2
Metadata checksum type:		crc32c
Data checksum type:		crc32c
Compression type:		none
String hash type:		siphash
32 bit inodes:			0
GC reserve percentage:		8%
Root reserve percentage:	0%
Devices:			2

Device 0:
  UUID:				9231a3aa-8047-4072-aa2a-001ea6a2403f
  Size:				7.3T
  Bucket size:			256.0K
  First bucket:			0
  Buckets:			30523537
  Last mount:			(never)
  State:			readwrite
  Tier:				0
  Has metadata:			0
  Has data:			0
  Replacement policy:		lru
  Discard:			0

Device 1:
  UUID:				c13809ec-1a69-4ba5-97cf-e2379d0d25f2
  Size:				7.3T
  Bucket size:			256.0K
  First bucket:			0
  Buckets:			30523537
  Last mount:			(never)
  State:			readwrite
  Tier:				0
  Has metadata:			0
  Has data:			0
  Replacement policy:		lru
  Discard:			0

3. mount -t bcachefs /dev/sdb1:/dev/sdc1 /data

4. cd /data
[root@nixos:/data]# dd if=/dev/zero of=testfile bs=1G count=1 oflag=direct

The process is in status D (Uninterruptible sleep)

https://en.wikipedia.org/wiki/Sleep_(system_call)#Uninterruptible_sleep

dmesg:

[Tue Jun 13 08:21:10 2017] bcachefs (7e811c51-4281-424c-8682-cab29f6b683f): initializing new filesystem
[Tue Jun 13 08:24:13 2017] ------------[ cut here ]------------
[Tue Jun 13 08:24:13 2017] kernel BUG at /tmp/nix-build-linux-4.11-git.drv-0/bcachefs-43e3159/fs/bcachefs/buckets.c:236!
[Tue Jun 13 08:24:13 2017] invalid opcode: 0000 [#1] SMP
[Tue Jun 13 08:24:13 2017] Modules linked in: af_packet cfg80211 rfkill msr ipmi_ssif iTCO_wdt sb_edac edac_core x86_pkg_temp_thermal intel_powerclamp ast snd_hda_codec_realtek coretemp crct10dif_pclmul crc32_pclmul ghash_clmulni_intel snd_hda_codec_generic ttm pcbc drm_kms_helper ext4 aesni_intel drm aes_x86_64 crypto_simd glue_helper cryptd igb intel_cstate isci intel_uncore agpgart snd_hda_intel ptp fb_sys_fops firewire_ohci syscopyarea pps_core sysfillrect i2c_algo_bit sysimgblt crc16 firewire_core intel_rapl_perf snd_hda_codec libsas jbd2 crc_itu_t i2c_core evdev joydev ipmi_si mousedev input_leds led_class fscrypto mei_me ioatdma scsi_transport_sas mbcache snd_hda_core mac_hid mei lpc_ich shpchp snd_hwdep dca hed wmi ipmi_devintf ipmi_msghandler tpm_tis tpm_tis_core tpm button snd_pc
 m_oss snd_mixer_oss snd_pcm
[Tue Jun 13 08:24:13 2017]  snd_timer snd soundcore atkbd libps2 loop cpufreq_ondemand kvm_intel kvm irqbypass ip_tables x_tables ipv6 crc_ccitt autofs4 hid_generic usbhid hid bcachefs libcrc32c crc32c_generic sd_mod ahci libahci xhci_pci libata xhci_hcd ehci_pci ehci_hcd scsi_mod usbcore crc32c_intel usb_common rtc_cmos serio dm_mod
[Tue Jun 13 08:24:13 2017] CPU: 0 PID: 14370 Comm: kworker/0:0H Not tainted 4.11.0 #1-NixOS
[Tue Jun 13 08:24:13 2017] Hardware name: To Be Filled By O.E.M. To Be Filled By O.E.M./EPC602D8A, BIOS P1.30 10/30/2014
[Tue Jun 13 08:24:13 2017] Workqueue: bcachefs bch2_write_index [bcachefs]
[Tue Jun 13 08:24:13 2017] task: ffff89f42fe04100 task.stack: ffff99f28edb4000
[Tue Jun 13 08:24:13 2017] RIP: 0010:bch2_fs_usage_apply+0x196/0x1d0 [bcachefs]
[Tue Jun 13 08:24:13 2017] RSP: 0000:ffff99f28edb7788 EFLAGS: 00010287
[Tue Jun 13 08:24:13 2017] RAX: 0000000000000100 RBX: ffff99f28edb7a80 RCX: 0000000000000000
[Tue Jun 13 08:24:13 2017] RDX: ffff89fa4d4181d8 RSI: ffff99f28edb7888 RDI: ffff89f76f6e0000
[Tue Jun 13 08:24:13 2017] RBP: ffff99f28edb7930 R08: 0000000000000000 R09: 0000000000000000
[Tue Jun 13 08:24:13 2017] R10: ffff89f434301010 R11: ffff89f434300000 R12: 0000000000001002
[Tue Jun 13 08:24:13 2017] R13: ffff89fa52597e00 R14: 0000000000001002 R15: ffff89fa52597e00
[Tue Jun 13 08:24:13 2017] FS:  0000000000000000(0000) GS:ffff89fa5f200000(0000) knlGS:0000000000000000
[Tue Jun 13 08:24:13 2017] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[Tue Jun 13 08:24:13 2017] CR2: ffffffffff600000 CR3: 0000000859560000 CR4: 00000000000406f0
[Tue Jun 13 08:24:13 2017] Call Trace:
[Tue Jun 13 08:24:13 2017]  ? bch2_insert_fixup_extent+0x1cb/0x760 [bcachefs]
[Tue Jun 13 08:24:13 2017]  __bch2_btree_insert_at+0x47c/0xcd0 [bcachefs]
[Tue Jun 13 08:24:13 2017]  ? bch2_inode_unpack+0x199/0x3f0 [bcachefs]
[Tue Jun 13 08:24:13 2017]  bchfs_write_index_update+0x322/0x530 [bcachefs]
[Tue Jun 13 08:24:13 2017]  ? kmem_cache_alloc+0xd7/0x1b0
[Tue Jun 13 08:24:13 2017]  ? kernfs_path_from_node_locked+0x24e/0x350
[Tue Jun 13 08:24:13 2017]  ? sg_init_table+0x1a/0x40
[Tue Jun 13 08:24:13 2017]  ? blk_rq_map_sg+0x1ca/0x520
[Tue Jun 13 08:24:13 2017]  ? scsi_init_sgtable+0x48/0x90 [scsi_mod]
[Tue Jun 13 08:24:13 2017]  ? bch2_readpages_end_io+0x70/0x70 [bcachefs]
[Tue Jun 13 08:24:13 2017]  ? dequeue_task_fair+0x566/0x1580
[Tue Jun 13 08:24:13 2017]  ? pick_next_task_fair+0x3f4/0x450
[Tue Jun 13 08:24:13 2017]  ? pick_next_task_fair+0x3f4/0x450
[Tue Jun 13 08:24:13 2017]  ? __switch_to+0x161/0x4c0
[Tue Jun 13 08:24:13 2017]  bch2_write_index+0x55/0x1f0 [bcachefs]
[Tue Jun 13 08:24:13 2017]  process_one_work+0x16b/0x4a0
[Tue Jun 13 08:24:13 2017]  worker_thread+0x4b/0x510
[Tue Jun 13 08:24:13 2017]  kthread+0x109/0x140
[Tue Jun 13 08:24:13 2017]  ? pwq_unbound_release_workfn+0xe0/0xe0
[Tue Jun 13 08:24:13 2017]  ? kthread_create_on_node+0x40/0x40
[Tue Jun 13 08:24:13 2017]  ret_from_fork+0x2c/0x40
[Tue Jun 13 08:24:13 2017] Code: 7d d4 74 42 19 c9 83 c9 01 e9 5e ff ff ff 48 39 ce 74 21 48 39 f1 19 c9 83 c9 01 e9 4c ff ff ff 31 c9 48 39 c1 0f 8d 93 fe ff ff <0f> 0b f3 90 e9 ef fe ff ff 49 39 f8 74 14 4c 39 c7 19 c9 83 c9
[Tue Jun 13 08:24:13 2017] RIP: bch2_fs_usage_apply+0x196/0x1d0 [bcachefs] RSP: ffff99f28edb7788
[Tue Jun 13 08:24:13 2017] ---[ end trace 7b0d2186862d4fe8 ]—

when i execute `mkdir /data/test` after that it is also in this state.

rebooting also fails since it can’t get unmounted.

after hard reboot i could mount the FS again. the file dd should create was not written.

i was able to reproduce the error again.

`dd if=/dev/zero of=/data/testfile3 bs=1G count=1` (without oflag=direct) works.


kind regards
davidak