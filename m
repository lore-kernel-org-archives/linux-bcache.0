From: Marc MERLIN <marc@merlins.org>
Subject: bcache removal: ida_remove called for id=64 which is not allocated.
Date: Sat, 25 Nov 2017 15:11:27 -0800
Message-ID: <20171125231127.7kv7uypcj3pbddqo@merlins.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-bcache-owner@vger.kernel.org>
Received: from magic.merlins.org ([209.81.13.136]:52602 "EHLO
        mail1.merlins.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751642AbdKYXLa (ORCPT
        <rfc822;linux-bcache@vger.kernel.org>);
        Sat, 25 Nov 2017 18:11:30 -0500
Content-Disposition: inline
Sender: linux-bcache-owner@vger.kernel.org
List-Id: linux-bcache@vger.kernel.org
To: linux-bcache@vger.kernel.org

Howdy,

This has been an issue for a while, but it's not fatal.
Nonetheless, I guess I should report it.

I trigger it like this:
echo 1 > /sys/block/md5/bcache/stop
sleep 5
mdadm --stop /dev/md5
(this was backed by bcache64)

bcache: bcache_device_free() bcache64 stopped
ida_remove called for id=64 which is not allocated.
------------[ cut here ]------------
WARNING: CPU: 0 PID: 20900 at lib/idr.c:383 ida_remove+0xe8/0x10d
Modules linked in: veth ip6table_filter ip6_tables ebtable_nat ebtables ppdev lp xt_addrtype br_netfilter bridge stp llc tun autofs4 softdog binfmt_misc ftdi_sio nfsd auth_rpcgss nfs_acl nfs lockd grace fscache sunrpc ipt_REJECT nf_reject_ipv4 xt_conntrack xt_mark xt_nat xt_tcpudp nf_log_ipv4 nf_log_common xt_LOG iptable_mangle iptable_filter lm85 hwmon_vid pl2303 dm_snapshot dm_bufio iptable_nat ip_tables nf_conntrack_ipv4 nf_defrag_ipv4 nf_nat_ipv4 nf_conntrack_ftp ipt_MASQUERADE nf_nat_masquerade_ipv4 nf_nat nf_conntrack x_tables sg st snd_pcm_oss snd_mixer_oss bcache kvm_intel kvm irqbypass snd_cmipci snd_hda_codec_realtek snd_hda_codec_generic snd_mpu401_uart snd_hda_intel snd_opl3_lib snd_hda_codec eeepc_wmi snd_rawmidi asus_wmi snd_hda_core snd_seq_device sparse_keymap asix snd_hwde
 p
 tpm_infineon snd_pcm usbnet tpm_tis snd_timer libphy rc_ati_x10 ati_remote rfkill snd mei_me i915 hwmon rc_core parport_pc wmi_bmof usbserial tpm_tis_core soundcore lpc_ich evdev pcspkr battery input_leds tpm i2c_i801 wmi parport e1000e ptp pps_core fuse raid456 multipath mmc_block mmc_core lrw ablk_helper dm_crypt dm_mod async_raid6_recov async_pq async_xor async_memcpy async_tx crc32c_intel blowfish_x86_64 blowfish_common pcbc aesni_intel aes_x86_64 crypto_simd glue_helper cryptd xhci_pci ehci_pci r8169 xhci_hcd ehci_hcd usbcore aacraid sata_sil24 mii thermal fan [last unloaded: ftdi_sio]
CPU: 0 PID: 20900 Comm: kworker/0:14 Tainted: G     U          4.13.12-amd64-stkreg-sysrq-20171018 #2
Hardware name: System manufacturer System Product Name/P8H67-M PRO, BIOS 3904 04/27/2013
Workqueue: events cached_dev_free [bcache]
task: ffff8908c3712000 task.stack: ffffa9f76c30c000
RIP: 0010:ida_remove+0xe8/0x10d
RSP: 0018:ffffa9f76c30fdb0 EFLAGS: 00210082
RAX: 0000000000000033 RBX: 0000000000000042 RCX: 0000000000000000
RDX: 0000000000000000 RSI: ffff890b1e20dd58 RDI: ffff890b1e20dd58
RBP: ffffa9f76c30fe18 R08: 0000000000000000 R09: 0000000000000000
R10: 0000000000002184 R11: ffffffffb9899a20 R12: ffffffffc065b688
R13: ffffffffc065b680 R14: 000000000000007e R15: 0000000000000040
FS:  0000000000000000(0000) GS:ffff890b1e200000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 00000000df77d000 CR3: 000000002ec09000 CR4: 00000000001406f0
Call Trace:
 ? _raw_spin_unlock_irqrestore+0x14/0x24
 ida_simple_remove+0x2e/0x43
 bcache_device_free+0x8c/0xc4 [bcache]
 cached_dev_free+0x7c/0xf2 [bcache]
 process_one_work+0x179/0x2a5
 worker_thread+0x1b1/0x262
 ? rescuer_thread+0x273/0x273
 kthread+0xfb/0x100
 ? init_completion+0x24/0x24
 ret_from_fork+0x25/0x30
Code: 00 75 2a 4c 89 f7 e8 c2 5e a6 ff 48 8d 75 a8 4c 89 e2 4c 89 ef e8 3c 4b 00 00 eb 11 44 89 fe 48 c7 c7 60 a6 b6 b9 e8 42 35 97 ff <0f> ff 48 8b 45 d0 65 48 33 04 25 28 00 00 00 74 05 e8 d7 7f 92 
---[ end trace 288d702433470881 ]---
md5: detected capacity change from 16002603548672 to 0
md: md5 stopped.

-- 
"A mouse is a device used to point at the xterm you want to type in" - A.S.R.
Microsoft is to operating systems ....
                                      .... what McDonalds is to gourmet cooking
Home page: http://marc.merlins.org/                         | PGP 1024R/763BE901
