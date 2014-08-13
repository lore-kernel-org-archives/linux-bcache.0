From: Larkin Lowrey <llowrey@nuclearwinter.com>
Subject: Re: Null pointer oops
Date: Wed, 13 Aug 2014 13:35:23 -0500
Message-ID: <53EBAFEB.8000109@nuclearwinter.com>
References: <53EAF170.90600@nuclearwinter.com>	<CALJ65z=25CrrO9uMc2vfYVAQWb=6eK+OhB5TGJJrCp=D4ALvrQ@mail.gmail.com>	<53EB9513.8010200@nuclearwinter.com> <CACHGV4LDe6YUAUAFxvzfu8XvyJJ+yjuRefGvteuRA99B-Cn2YQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-bcache-owner@vger.kernel.org>
Received: from titan.nuclearwinter.com ([174.136.96.186]:57794 "EHLO
	mail.nuclearwinter.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752031AbaHMSfV (ORCPT
	<rfc822;linux-bcache@vger.kernel.org>);
	Wed, 13 Aug 2014 14:35:21 -0400
In-Reply-To: <CACHGV4LDe6YUAUAFxvzfu8XvyJJ+yjuRefGvteuRA99B-Cn2YQ@mail.gmail.com>
Sender: linux-bcache-owner@vger.kernel.org
List-Id: linux-bcache@vger.kernel.org
To: Slava Pestov <sp@datera.io>
Cc: Kent Overstreet <kmo@daterainc.com>, linux-bcache@vger.kernel.org

Thanks. Trying gdb helped me find the answer. I needed to install the
kernel-debuginfo-3.15.8-200.fc20.x86_64  package via yum.

From addr2line:
> bch_btree_node_read_done+0x4c
> drivers/md/bcache/btree.c:207

Here'a a snippet from gdb:

> (gdb) list *(bch_btree_node_read_done+0x4c)
> 0x65fc is in bch_btree_node_read_done (drivers/md/bcache/btree.c:207).
> 202             struct bset *i = btree_bset_first(b);
> 203             struct btree_iter *iter;
> 204
> 205             iter = mempool_alloc(b->c->fill_iter, GFP_NOWAIT);
> 206             iter->size = b->c->sb.bucket_size / b->c->sb.block_size;
> 207             iter->used = 0;
> 208
> 209     #ifdef CONFIG_BCACHE_DEBUG
> 210             iter->b = &b->keys;
> 211     #endif

This doesn't make any sense to me. If iter was null I would expect line
206 to blow up first.

--Larkin

On 8/13/2014 12:41 PM, Slava Pestov wrote:
> You can try to use gdb:
>
> gdb /lib/modules/.../foo.ko
>
> list *(bch_btree_node_read_done+0x4c)
>
>
> On Wed, Aug 13, 2014 at 9:40 AM, Larkin Lowrey
> <llowrey@nuclearwinter.com> wrote:
>> This is making be feel very dumb. I've googled extensively but can't
>> figure out how to run addr2line for a module.
>>
>> I'm running Fedora 20 and the kernel did not have debugging symbols. I
>> downloaded the version with symbols but I don't know if the addresses
>> are going to be the same. Bcache is a module for me and that's where
>> things get tricky. Do you have any tips?
>>
>> --Larkin
>>
>> On 8/13/2014 12:04 AM, Kent Overstreet wrote:
>>> Any chance you could do an addr2line and get me the exact line where
>>> it happened?
>>>
>>> On Aug 12, 2014 10:02 PM, "Larkin Lowrey" <llowrey@nuclearwinter.com
>>> <mailto:llowrey@nuclearwinter.com>> wrote:
>>>
>>>     I got an oops while doing some heavy I/O. I have an md raid10 cache
>>>     device (4 SSDs) and 3 md raid5/6 backing devices. This setup has been
>>>     well behaved for about 6 months.
>>>
>>>     If this isn't a known issue is there anything I can do to provide more
>>>     useful information?
>>>
>>>     I'm running kernel 3.15.8-200.fc20.x86_64.
>>>
>>>     [210884.047249] BUG: unable to handle kernel NULL pointer
>>>     dereference at 0000000000000008
>>>     [210884.055605] IP: [<ffffffffa01625fc>]
>>>     bch_btree_node_read_done+0x4c/0x450 [bcache]
>>>     [210884.063723] PGD 0
>>>     [210884.066053] Oops: 0002 [#1] SMP
>>>     [210884.069610] Modules linked in: lp parport binfmt_misc
>>>     ipt_MASQUERADE iptable_nat nf_nat_ipv4 nf_nat xt_CHECKSUM
>>>     iptable_mangle tun bridge stp llc xt_multiport ebtable_nat
>>>     ebtables hwmon_vid ip6t_REJECT nf_conntrack_ipv6 nf_conntrack_ipv4
>>>     nf_defrag_ipv6 nf_defrag_ipv4 ip6table_filter xt_conntrack
>>>     ip6_tables nf_conntrack keyspan ezusb kvm_amd kvm crct10dif_pclmul
>>>     crc32_pclmul crc32c_intel ghash_clmulni_intel microcode serio_raw
>>>     amd64_edac_mod edac_core fam15h_power k10temp edac_mce_amd
>>>     sp5100_tco i2c_piix4 igb ptp pps_core dca shpchp acpi_cpufreq
>>>     btrfs bcache raid456 async_raid6_recov async_memcpy async_pq
>>>     async_xor async_tx xor raid6_pq raid10 i2c_algo_bit drm_kms_helper
>>>     ttm drm i2c_core mpt2sas mvsas libsas raid_class
>>>     scsi_transport_sas cpufreq_stats
>>>     [210884.140704] CPU: 5 PID: 11188 Comm: kworker/5:1 Not tainted
>>>     3.15.8-200.fc20.x86_64 #1
>>>     [210884.149069] Hardware name:  /H8DG6/H8DGi, BIOS 3.0a       07/2
>>>     [210884.155280] Workqueue: bcache cache_lookup [bcache]
>>>     [210884.160531] task: ffff880218633160 ti: ffff8800217b8000
>>>     task.ti: ffff8800217b8000
>>>     [210884.168502] RIP: 0010:[<ffffffffa01625fc>]
>>>      [<ffffffffa01625fc>] bch_btree_node_read_done+0x4c/0x450 [bcache]
>>>     [210884.179105] RSP: 0000:ffff8800217bbbe8  EFLAGS: 00010212
>>>     [210884.184806] RAX: 0000000000000400 RBX: ffff880245ec0000 RCX:
>>>     0000000000000000
>>>     [210884.192480] RDX: 0000000000000000 RSI: ffff880418380000 RDI:
>>>     0000000000000246
>>>     [210884.200075] RBP: ffff8800217bbc10 R08: 0000000000000000 R09:
>>>     0000000000000f6b
>>>     [210884.207738] R10: 0000000000000000 R11: 0000000000000400 R12:
>>>     ffff880413d06c00
>>>     [210884.215391] R13: 0000000000000000 R14: ffff8800217bbc20 R15:
>>>     ffff880413d06c00
>>>     [210884.222961] FS:  00007f73bacd6880(0000)
>>>     GS:ffff88021fd40000(0000) knlGS:0000000000000000
>>>     [210884.231516] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
>>>     [210884.237557] CR2: 0000000000000008 CR3: 0000000001c11000 CR4:
>>>     00000000000407e0
>>>     [210884.245131] Stack:
>>>     [210884.247395]  ffff880274f4d020 ffff880413d06c00
>>>     0000bfcc44a463f8 ffff8800217bbc20
>>>     [210884.255337]  ffff880413d06c00 ffff8800217bbc78
>>>     ffffffffa0162b68 0000000000000000
>>>     [210884.263256]  ffff880218633160 0000000000000000
>>>     0000000000000000 0000000000000000
>>>     [210884.271234] Call Trace:
>>>     [210884.273985]  [<ffffffffa0162b68>]
>>>     bch_btree_node_read+0x168/0x190 [bcache]
>>>     [210884.281258]  [<ffffffffa0163f69>]
>>>     bch_btree_node_get+0x169/0x290 [bcache]
>>>     [210884.288377]  [<ffffffffa01642f5>]
>>>     bch_btree_map_keys_recurse+0xd5/0x1d0 [bcache]
>>>     [210884.296311]  [<ffffffffa016dcb0>] ?
>>>     cached_dev_congested+0x180/0x180 [bcache]
>>>     [210884.303953]  [<ffffffff8135b204>] ?
>>>     call_rwsem_down_read_failed+0x14/0x30
>>>     [210884.311158]  [<ffffffffa01673f7>]
>>>     bch_btree_map_keys+0x127/0x150 [bcache]
>>>     [210884.318273]  [<ffffffffa016dcb0>] ?
>>>     cached_dev_congested+0x180/0x180 [bcache]
>>>     [210884.325826]  [<ffffffffa016e7f5>] cache_lookup+0xf5/0x1f0 [bcache]
>>>     [210884.332325]  [<ffffffff810a4af6>] process_one_work+0x176/0x430
>>>     [210884.338427]  [<ffffffff810a578b>] worker_thread+0x11b/0x3a0
>>>     [210884.344282]  [<ffffffff810a5670>] ? rescuer_thread+0x3b0/0x3b0
>>>     [210884.350447]  [<ffffffff810ac528>] kthread+0xd8/0xf0
>>>     [210884.355615]  [<ffffffff810ac450>] ? insert_kthread_work+0x40/0x40
>>>     [210884.362017]  [<ffffffff816ff93c>] ret_from_fork+0x7c/0xb0
>>>     [210884.367756]  [<ffffffff810ac450>] ? insert_kthread_work+0x40/0x40
>>>     [210884.374234] Code: 08 01 00 00 48 8b b8 58 cb 00 00 e8 bf 25 01
>>>     e1 49 8b b4 24 80 00 00 00 49 89 c5 31 d2 0f b7 86 32 04 00 00 66
>>>     f7 b6 30 04 00 00 <49> c7 45 08 00 00 00 00 0f b7 c0 49 89 45 00
>>>     48 8b 43 10 48 85
>>>     [210884.395405] RIP  [<ffffffffa01625fc>]
>>>     bch_btree_node_read_done+0x4c/0x450 [bcache]
>>>     [210884.403389]  RSP <ffff8800217bbbe8>
>>>     [210884.407171] CR2: 0000000000000008
>>>     [210884.411233] ---[ end trace 0064e6abfd068c85 ]---
>>>     [210884.416352] BUG: unable to handle kernel paging request at
>>>     ffffffffffffffd8
>>>     [210884.423871] IP: [<ffffffff810acb10>] kthread_data+0x10/0x20
>>>     [210884.429915] PGD 1c14067 PUD 1c16067 PMD 0
>>>
>>>     --Larkin
>>>
>>>     --
>>>     To unsubscribe from this list: send the line "unsubscribe
>>>     linux-bcache" in
>>>     the body of a message to majordomo@vger.kernel.org
>>>     <mailto:majordomo@vger.kernel.org>
>>>     More majordomo info at  http://vger.kernel.org/majordomo-info.html
>>>
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-bcache" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> --
> To unsubscribe from this list: send the line "unsubscribe linux-bcache" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
