From: Stefan Priebe - Profihost AG <s.priebe@profihost.ag>
Subject: Re: bcache: for-next unable to handle kernel NULL pointer dereference
 at 0000000000000019
Date: Mon, 23 Oct 2017 14:59:02 +0200
Message-ID: <b3fe481a-67d7-1e70-1f52-0aa285dc48e7@profihost.ag>
References: <5cd9d4e9-88b2-c24b-f6ed-dad3f8b21283@profihost.ag>
 <4f1c616f-2e86-2cd3-162c-4ee7a3a02bf4@coly.li>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Return-path: <linux-bcache-owner@vger.kernel.org>
Received: from cloud1-vm154.de-nserver.de ([178.250.10.56]:64300 "EHLO
        cloud1-vm154.de-nserver.de" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S932210AbdJWM7E (ORCPT
        <rfc822;linux-bcache@vger.kernel.org>);
        Mon, 23 Oct 2017 08:59:04 -0400
In-Reply-To: <4f1c616f-2e86-2cd3-162c-4ee7a3a02bf4@coly.li>
Content-Language: de-DE
Sender: linux-bcache-owner@vger.kernel.org
List-Id: linux-bcache@vger.kernel.org
To: Coly Li <i@coly.li>, linux-bcache@vger.kernel.org
Cc: Michael Lyle <mlyle@lyle.org>

Hi Coly,


Am 23.10.2017 um 14:56 schrieb Coly Li:
> On 2017/10/23 下午7:42, Stefan Priebe - Profihost AG wrote:
>> Hello,
>>
>> i picked all bcache patches from for-next to my 4.4 kernel to test the
>> new controller.
>>
>> After doing so i see random kernel panics with the following trace:
> 
> Hi Stefan,
> 
> Thanks for the report. This is the 3rd report I see recently for NULL
> pointer dereference, maybe they are related (or maybe not). Is it a
> panic when bcache starts to run, or during heavy workload ?

It's during heavy / normal workload.

> If I may have chance to trigger similar oops on my server, that will be
> much easier. So far I cannot reproduce any oops, neither by rebooting
> and assemble bcache device by udev rules, nor compose bcache device and
> run it by bash scripts...

Do you need the line where this happens? It should be possible to get
the line from the IP: [<ffffffffc04ef62e>] output?

Greets,
Stefan

> Thank you in advance.
> 
> Coly Li
> 
>>
>> BUG: unable to handle kernel NULL pointer dereference at 0000000000000019
>> IP: [<ffffffffc04ef62e>] closure_sub+0xe/0xc0 [bcache]
>> PGD 0
>> Oops: 0002 [#1] SMP
>> Modules linked in: netconsole xt_multiport ipt_REJECT nf_reject_ipv4
>> xt_set iptable_filter ip_tables x_tables ip_set_hash_net ip_set
>> nfnetlink bonding ipmi_devintf sb_edac edac_core x86_pkg_temp_thermal
>> mgag200 kvm_intel ttm drm_kms_helper kvm irqbypass drm fb_sys_fops
>> syscopyarea crc32_pclmul sysfillrect sysimgblt ghash_clmulni_intel wmi
>> ipmi_si ipmi_msghandler shpchp button coretemp 8021q garp fuse btrfs xor
>> raid6_pq dm_mod usb_storage ohci_hcd usbhid bcache sg sd_mod ahci
>> ehci_pci i2c_i801 libahci ehci_hcd isci igb i2c_algo_bit ixgbe usbcore
>> libsas i2c_core mdio usb_common scsi_transport_sas ptp pps_core
>> CPU: 6 PID: 50 Comm: ksoftirqd/6 Not tainted 4.4.92+534-ph #1
>> Hardware name: Supermicro
>> X9SRE/X9SRE-3F/X9SRi/X9SRi-3F/X9SRE/X9SRE-3F/X9SRi/X9SRi-3F, BIOS 3.0
>> 07/05/2013
>> task: ffff8802196ccb00 ti: ffff8802196d4000 task.ti: ffff8802196d4000
>> RIP: 0010:[<ffffffffc04ef62e>] [<ffffffffc04ef62e>] closure_sub+0xe/0xc0
>> [bcache]
>> RSP: 0018:ffff8802196d7c20 EFLAGS: 00010297
>> RAX: 00000000fdffffff RBX: fffffffffffffff1 RCX: 00000000000f4240
>> RDX: 0000000000070651 RSI: 0000000002000001 RDI: fffffffffffffff1
>> RBP: ffff8802196d7c28 R08: 0000000000000007 R09: ffff880219568000
>> R10: 0000000000000000 R11: 0000000000000000 R12: 0000000000000e00
>> R13: 0000000000000000 R14: 0000000000000e00 R15: ffff8805eb2dbd60
>> FS: 0000000000000000(0000) GS:ffff880c7f580000(0000) knlGS:0000000000000000
>> CS: 0010 DS: 0000 ES: 0000 CR0: 0000000080050033
>> CR2: 0000000000000019 CR3: 0000000c7ee0b000 CR4: 00000000001406e0Stack:
>> fffffffffffffff1 ffff8802196d7c40 ffffffffc04ef70d ffff880c459ecbc0
>> ffff8802196d7c58 ffffffffc04f20df ffff880c459eccf0 ffff8802196d7c70
>> ffffffffc04ef616 ffff880c459eccf0 ffff8802196d7c88 ffffffffc04f16a7
>> Call Trace:
>> [<ffffffffc04ef70d>] __closure_wake_up+0x2d/0x40 [bcache]
>> [<ffffffffc04f20df>] journal_write_done+0x2f/0xa0 [bcache]
>> [<ffffffffc04ef616>] closure_put+0xb6/0xc0 [bcache]
>> [<ffffffffc04f16a7>] journal_write_endio+0x37/0x40 [bcache]
>> [<ffffffff81397b16>] bio_endio+0x56/0x60
>> [<ffffffff813a00cb>] blk_update_request+0x8b/0x370
>> [<ffffffff8150b663>] scsi_end_request+0x33/0x1c0
>> [<ffffffff8150dddd>] scsi_io_completion+0x18d/0x660
>> [<ffffffff815046df>] scsi_finish_command+0xcf/0x120
>> [<ffffffff8150d566>] scsi_softirq_done+0x126/0x150
>> [<ffffffff813a7f88>] blk_done_softirq+0x78/0x90
>> [<ffffffff8108a48c>] __do_softirq+0x11c/0x2e0
>> [<ffffffff8108a678>] run_ksoftirqd+0x28/0x50
>> [<ffffffff810a6fb9>] smpboot_thread_fn+0x139/0x1a0
>> [<ffffffff810a3aeb>] kthread+0xeb/0x110
>> [<ffffffff816dbd0f>] ret_from_fork+0x3f/0x70
>> DWARF2 unwinder stuck at ret_from_fork+0x3f/0x70
>> Leftover inexact backtrace:
>> 2017-10-23 13:35:09
>> [<ffffffff810a3a00>] ? kthread_park+0x60/0x60
>> Code: e8 a8 d6 ba c0 84 c0 75 83 0f 0b 48 8b 5f 20 eb af ff d1 e9 74 ff
>> ff ff 0f 0b 0f 1f 00 0f 1f 44 00 00 55 89 f0 f7 d8 48 89 e5 53 <f0> 0f
>> c1 47 28 29 f0 89 c1 81 e1 ff ff 7f 00 a9 00 00 00 55 75
>> RIP [<ffffffffc04ef62e>] closure_sub+0xe/0xc0 [bcache]
>> RSP <ffff8802196d7c20>
>> CR2: 0000000000000019
>> ---[ end trace a4cc6c37159f8e49 ]---
>> Kernel panic - not syncing: Fatal exception in interrupt
>> Kernel Offset: 0x0 from 0xffffffff81000000 (relocation range:
>> 0xffffffff80000000-0xffffffffbfffffff)
> --
> To unsubscribe from this list: send the line "unsubscribe linux-bcache" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
