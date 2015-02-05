From: Francis Moreau <francis.moro@gmail.com>
Subject: Re: [GIT PULL] bcache changes for 3.17
Date: Thu, 05 Feb 2015 14:40:49 +0100
Message-ID: <54D372E1.30304@gmail.com>
References: <20140805043346.GF541@moria.home.lan> <53E10D48.1010700@kernel.dk> <53E7251B.3080305@kieser.ca> <540966BA.9030106@gmail.com> <5409C5FC.6020406@kernel.dk> <5409D8BC.7030003@ehuk.net> <5409E7AB.7040704@kieser.ca> <F71A0899-EF6F-44A3-B207-E1DACC8721B6@cern.ch> <5409EE75.9060407@kernel.dk>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <5409EE75.9060407@kernel.dk>
Sender: linux-kernel-owner@vger.kernel.org
To: Jens Axboe <axboe@kernel.dk>, Arne Wiebalck <Arne.Wiebalck@cern.ch>, Peter Kieser <peter@kieser.ca>, "eddie@ehuk.net" <eddie@ehuk.net>, Kent Overstreet <kmo@daterainc.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "linux-bcache@vger.kernel.org" <linux-bcache@vger.kernel.org>, stable <stable@vger.kernel.org>
List-Id: linux-bcache@vger.kernel.org

On 09/05/2014 07:10 PM, Jens Axboe wrote:
> On 09/05/2014 11:03 AM, Arne Wiebalck wrote:
>>
>> On Sep 5, 2014, at 6:41 PM, Peter Kieser <peter@kieser.ca>
>>  wrote:
>>
>>>
>>> On 2014-09-05 8:37 AM, Eddie Chapman wrote:
>>>> On 05/09/14 15:17, Jens Axboe wrote:
>>>>> (from oldest to newest). And that's just from 3.16 to 3.17-rc3, going
>>>>> all the way back to 3.10 would be a lot of work. If there's anyone that
>>>>> cares about bcache on stable kernels (and actually use it), now would be
>>>>> a good time to pipe up.
>>>>
>>>> Just "piping up" as I care about bcache and actually use it in production on 3.10! Shame I don't have the knowledge to try and backport these though :-)
>>>>
>>>> Eddie
>>>
>>> I'm "piping up" as well, I use bcache on 3.10 in production.
>>>
>>> -Peter
>>>
>>
>>
>> More "piping up": we currently use bcache on a few nodes in production, on 3.14 and 3.15, and plan to roll it out on a wider scale now.
>> If necessary we'll go with these kernels, but we'd certainly prefer our usual 3.10-based CentOS kernel.
> 
> OK, so we definitely have people using it in production. My concern was
> that whomever does the backport of the appropriate patches to 3.10/14/15
> stable would have an audience for getting some amount of testing of such
> a patch series.
> 
> Now we just need someone to line up to do the work...
> 

Ok it's becoming insane: my system crashes every 2 days: any processes
that attempt a write to the disk get stuck, and cpu are at 100%.

So I can try to backport the fixes that address the following oops for
kernel 3.14 but someone has to point me the corresponding commits since
I don't know bcache.

Thanks.

BUG: soft lockup - CPU#0 stuck for 22s! [bcache_gc:152]
Modules linked in: tun xt_nat xt_tcpudp mmc_block btrfs raid6_pq xor ses
enclosure usb_storage veth xt_addrtype xt_conntrack ipt_MASQUERADE
iptable_nat nf_conntrack_ipv4 nf_defrag_ipv4 nf_nat_ipv4 nf_nat
nf_conntrack bridge stp llc dm_thin_pool dm_persistent_data
dm_bio_prison dm_bufio libcrc32c loop dm_mod iptable_filter ip_tables
x_tables hid_generic usbhid hid ctr ccm fuse joydev mousedev coretemp
hwmon arc4 iwldvm led_class nls_iso8859_1 nls_cp437 vfat mac80211 fat
intel_rapl x86_pkg_temp_thermal iTCO_wdt intel_powerclamp
iTCO_vendor_support kvm_intel snd_hda_codec_hdmi kvm snd_hda_codec_via
snd_hda_codec_generic crct10dif_pclmul iwlwifi crc32_pclmul crc32c_intel
btusb ghash_clmulni_intel bluetooth aesni_intel aes_x86_64 cfg80211 lrw
snd_hda_intel gf128mul glue_helper ablk_helper
 6lowpan_iphc cryptd r8169 snd_hda_codec psmouse rtsx_pci_ms i2c_i801
snd_hwdep serio_raw rfkill memstick mii snd_pcm wmi snd_timer snd evdev
tpm_infineon mei_me tpm_tis mei tpm soundcore shpchp mac_hid lpc_ich
battery ac processor thermal sch_fq_codel nfs lockd sunrpc fscache ext4
crc16 mbcache jbd2 bcache sd_mod sr_mod crc_t10dif cdrom
crct10dif_common rtsx_pci_sdmmc mmc_core atkbd libps2 ahci libahci
libata ehci_pci xhci_hcd ehci_hcd scsi_mod rtsx_pci usbcore usb_common
i8042 serio i915 video button intel_gtt i2c_algo_bit drm_kms_helper drm
i2c_core
CPU: 0 PID: 152 Comm: bcache_gc Not tainted 3.14.30-1-lts #1
Hardware name: CLEVO CO.                        W55xEU
        /W55xEU                          , BIOS 4.6.5 03/05/2013
task: ffff880406b1a780 ti: ffff88040461e000 task.ti: ffff88040461e000
RIP: 0010:[<ffffffffa0443af2>]  [<ffffffffa0443af2>]
bch_extent_bad+0x122/0x1d0 [bcache]
RSP: 0018:ffff88040461fa90  EFLAGS: 00000207
RAX: 9000000000800001 RBX: ffffffffa04439b9 RCX: ffffc90017452000
RDX: ffffc90017468f38 RSI: 000000007a6b5813 RDI: ffff88007ff20000
RBP: ffff88040461fac0 R08: 0000000000000013 R09: 0000000000000008
R10: 000007ffffffffff R11: ffff880405fe8000 R12: ffff8804055b08a0
R13: ffff8804055b08a0 R14: ffff880404844760 R15: 0000000000000018
FS:  0000000000000000(0000) GS:ffff88041e200000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 00007f1b36926007 CR3: 000000000280c000 CR4: 00000000001427e0
Stack:
 ffff88040461faa0 ffff880404844760 ffff88040461fc48 ffffffffa043ba80
 ffff8804055b08a0 ffff880405e2dc60 ffff88040461fad0 ffffffffa043ba8a
 ffff88040461fb00 ffffffffa043b879 00000000000008e8 ffff8804055b08a0
Call Trace:
 [<ffffffffa043ba80>] ? bch_ptr_invalid+0x10/0x10 [bcache]
 [<ffffffffa043ba8a>] bch_ptr_bad+0xa/0x10 [bcache]
 [<ffffffffa043b879>] bch_btree_iter_next_filter+0x29/0x50 [bcache]
 [<ffffffffa04409f5>] btree_gc_recurse+0x175/0xc10 [bcache]
 [<ffffffffa043ba70>] ? bch_btree_keys_stats+0xf0/0xf0 [bcache]
 [<ffffffffa0444a85>] ? __bch_btree_ptr_invalid+0xa5/0xc0 [bcache]
 [<ffffffffa043ba70>] ? bch_btree_keys_stats+0xf0/0xf0 [bcache]
 [<ffffffffa043efc3>] ? btree_gc_mark_node+0x73/0x230 [bcache]
 [<ffffffffa0441bbf>] bch_btree_gc+0x50f/0x690 [bcache]
 [<ffffffff8109f59c>] ? try_to_wake_up+0x20c/0x2d0
 [<ffffffff810b23d0>] ? __wake_up_sync+0x20/0x20
 [<ffffffffa0441d88>] bch_gc_thread+0x48/0x130 [bcache]
 [<ffffffffa0441d40>] ? bch_btree_gc+0x690/0x690 [bcache]
 [<ffffffff8108e3aa>] kthread+0xea/0x100
 [<ffffffff8108e2c0>] ? kthread_create_on_node+0x1a0/0x1a0
 [<ffffffff8150e0bc>] ret_from_fork+0x7c/0xb0
 [<ffffffff8108e2c0>] ? kthread_create_on_node+0x1a0/0x1a0
Code: 00 00 4c 8b 84 d7 40 0c 00 00 48 89 f2 48 c1 ea 08 4c 21 fa 48 d3
ea 49 8b 88 00 0b 00 00 48 8d 14 52 48 8d 14 91 44 0f b6 42 06 <41> 29
f0 41 80 f8 80 77 75 41 80 f8 60 76 29 0f b6 8f 6e 0e 00
BUG: soft lockup - CPU#0 stuck for 23s! [bcache_gc:152]
Modules linked in: tun xt_nat xt_tcpudp mmc_block btrfs raid6_pq xor ses
enclosure usb_storage veth xt_addrtype xt_conntrack ipt_MASQUERADE
iptable_nat nf_conntrack_ipv4 nf_defrag_ipv4 nf_nat_ipv4 nf_nat
nf_conntrack bridge stp llc dm_thin_pool dm_persistent_data
dm_bio_prison dm_bufio libcrc32c loop dm_mod iptable_filter ip_tables
x_tables hid_generic usbhid hid ctr ccm fuse joydev mousedev coretemp
hwmon arc4 iwldvm led_class nls_iso8859_1 nls_cp437 vfat mac80211 fat
intel_rapl x86_pkg_temp_thermal iTCO_wdt intel_powerclamp
iTCO_vendor_support kvm_intel snd_hda_codec_hdmi kvm snd_hda_codec_via
snd_hda_codec_generic crct10dif_pclmul iwlwifi crc32_pclmul crc32c_intel
btusb ghash_clmulni_intel bluetooth aesni_intel aes_x86_64 cfg80211 lrw
snd_hda_intel gf128mul glue_helper ablk_helper
 6lowpan_iphc cryptd r8169 snd_hda_codec psmouse rtsx_pci_ms i2c_i801
snd_hwdep serio_raw rfkill memstick mii snd_pcm wmi snd_timer snd evdev
tpm_infineon mei_me tpm_tis mei tpm soundcore shpchp mac_hid lpc_ich
battery ac processor thermal sch_fq_codel nfs lockd sunrpc fscache ext4
crc16 mbcache jbd2 bcache sd_mod sr_mod crc_t10dif cdrom
crct10dif_common rtsx_pci_sdmmc mmc_core atkbd libps2 ahci libahci
libata ehci_pci xhci_hcd ehci_hcd scsi_mod rtsx_pci usbcore usb_common
i8042 serio i915 video button intel_gtt i2c_algo_bit drm_kms_helper drm
i2c_core
CPU: 0 PID: 152 Comm: bcache_gc Not tainted 3.14.30-1-lts #1
Hardware name: CLEVO CO.                        W55xEU
        /W55xEU                          , BIOS 4.6.5 03/05/2013
task: ffff880406b1a780 ti: ffff88040461e000 task.ti: ffff88040461e000
RIP: 0010:[<ffffffffa044394a>]  [<ffffffffa044394a>]
bch_extent_invalid+0x3a/0xc0 [bcache]
RSP: 0018:ffff88040461fa18  EFLAGS: 00000283
RAX: 0000000000000001 RBX: 0000000000000001 RCX: 0000000000000010
RDX: 0000000000054b68 RSI: ffff8804048482e8 RDI: ffff8804055b08a0
RBP: ffff88040461fa80 R08: ffff88040461fc58 R09: ffff880404862820
R10: ffff880404848300 R11: ffff880405fe8000 R12: 000007ffffffffff
R13: ffff880405fe8000 R14: 0000000000000001 R15: ffff88040461fa08
FS:  0000000000000000(0000) GS:ffff88041e200000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 00007f1b36926007 CR3: 000000000280c000 CR4: 00000000001427e0
Stack:
 ffffffffa0444a85 000007ffffffffff ffff88040461fad0 0000000000000001
 ffff88040461fa58 ffffffffa0438e9f ffff880405b10004 0000000000000001
 ffff88040461fab8 ffffffffa043a681 00000000a5765a18 ffff8804048482e8
Call Trace:
 [<ffffffffa0444a85>] ? __bch_btree_ptr_invalid+0xa5/0xc0 [bcache]
 [<ffffffffa0438e9f>] ? tree_to_bkey+0x1f/0x50 [bcache]
 [<ffffffffa043a681>] ? __bch_bset_search+0x1e1/0x4c0 [bcache]
 [<ffffffffa0443a13>] bch_extent_bad+0x43/0x1d0 [bcache]
 [<ffffffffa043ba80>] ? bch_ptr_invalid+0x10/0x10 [bcache]
 [<ffffffffa043ba8a>] bch_ptr_bad+0xa/0x10 [bcache]
 [<ffffffffa043b879>] bch_btree_iter_next_filter+0x29/0x50 [bcache]
 [<ffffffffa04409f5>] btree_gc_recurse+0x175/0xc10 [bcache]
 [<ffffffffa043ba70>] ? bch_btree_keys_stats+0xf0/0xf0 [bcache]
 [<ffffffffa0444a85>] ? __bch_btree_ptr_invalid+0xa5/0xc0 [bcache]
 [<ffffffffa043ba70>] ? bch_btree_keys_stats+0xf0/0xf0 [bcache]
 [<ffffffffa043efc3>] ? btree_gc_mark_node+0x73/0x230 [bcache]
 [<ffffffffa0441bbf>] bch_btree_gc+0x50f/0x690 [bcache]
 [<ffffffff8109f59c>] ? try_to_wake_up+0x20c/0x2d0
 [<ffffffff810b23d0>] ? __wake_up_sync+0x20/0x20
 [<ffffffffa0441d88>] bch_gc_thread+0x48/0x130 [bcache]
 [<ffffffffa0441d40>] ? bch_btree_gc+0x690/0x690 [bcache]
 [<ffffffff8108e3aa>] kthread+0xea/0x100
 [<ffffffff8108e2c0>] ? kthread_create_on_node+0x1a0/0x1a0
 [<ffffffff8150e0bc>] ret_from_fork+0x7c/0xb0
 [<ffffffff8108e2c0>] ? kthread_create_on_node+0x1a0/0x1a0

...
