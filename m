From: Richard Bade <hitrich@gmail.com>
Subject: Re: Bcache still unstable for me (memory problems)
Date: Mon, 21 Mar 2016 13:05:28 +1300
Message-ID: <CA+nZN+gr8Z8nG+cBkYFYFPQEbB5M1nLnJ+_BL3GhoV9H1AON-A@mail.gmail.com>
References: <CA+nZN+i0fmEc0Uz1X5k0DJaNB_sNu2EP0dEUy32_ipsW66MFmA@mail.gmail.com>
	<alpine.LRH.2.11.1603090344040.15354@mail.ewheeler.net>
	<alpine.LRH.2.11.1603100125110.13488@mail.ewheeler.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Return-path: <linux-bcache-owner@vger.kernel.org>
Received: from mail-vk0-f54.google.com ([209.85.213.54]:35090 "EHLO
	mail-vk0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751485AbcCUAFa convert rfc822-to-8bit (ORCPT
	<rfc822;linux-bcache@vger.kernel.org>);
	Sun, 20 Mar 2016 20:05:30 -0400
Received: by mail-vk0-f54.google.com with SMTP id e6so198550728vkh.2
        for <linux-bcache@vger.kernel.org>; Sun, 20 Mar 2016 17:05:29 -0700 (PDT)
In-Reply-To: <alpine.LRH.2.11.1603100125110.13488@mail.ewheeler.net>
Sender: linux-bcache-owner@vger.kernel.org
List-Id: linux-bcache@vger.kernel.org
To: Eric Wheeler <bcache@lists.ewheeler.net>
Cc: linux-bcache@vger.kernel.org, Marc MERLIN <marc@merlins.org>

Hi Eric,
We built a kernel with the 3 patches applied and I still got the box to lock up.
I don't have any of the traces any more. Also I'm wondering what is
the best way to get these? When this happens my machine completely
locks up so can't grab anything from dmesg.
Let me know what you want me to grab and I'll crash it again.

Regards,
Richard

On 10 March 2016 at 14:34, Eric Wheeler <bcache@lists.ewheeler.net> wrote:
> Hi Richard, Marc,
>
>>>> [290623.673871] bcache-register: page allocation failure: order:7, mode:0x24080c0
>
> Do you still have the backtraces that show the function call stack for
> errors that look like this?
>         %s: page allocation failure: order:%d, mode:0x%x
>
> Please send as many relevant OOM failure traces that you can.  I would
> like to see which memory allocation(s) are failing and if they are always
> the same stack trace.
>
> In the example above, order 7 means 2^7 of 4k pages, so it means the
> kernel can't find 512k of contiguous memory that can be allocated.
>
> It looks like the OOM is triggered in bch_cache_set_alloc, but might be
> cache_alloc too.  I'm not sure if an alternate allocation mechanism can be
> used safely, but thats what I want to look into.
>
> Thanks!
>
> -Eric
>
> --
> Eric Wheeler
>
> On Wed, 9 Mar 2016, Eric Wheeler wrote:
>
>> On Wed, 9 Mar 2016, Richard Bade wrote:
>>
>> > Hi Guys,
>> > I've also seen this issue when registering a device.
>> > [Fri Feb  5 14:06:59 2016] bcache: register_cache() error opening
>> > dm-6: cannot allocate memory
>> >
>> > For me the situation happens because I'm running Ceph OSD's on the
>> > host. These are using all the available memory and for some reason the
>> > register cannot allocate memory.
>> > I've reproduced this several times, but basically if I register on a
>> > system that has been up for a while and therefore using all it's RAM
>> > this will happen.
>> > Here's two specific time's it's happened:
>> > when creating using "make-bcache --cache /dev/vg-raid0/lv-ceph_j19
>> > --bdev /dev/sdf1". It failed due to xfs still remaining on /dev/sdf1.
>>
>> Do you get a kernel failure, or is it just make-bcache being safe?
>>
>> > Then run wipefs and "make-bcache --cache /dev/vg-raid0/lv-ceph_j19
>> > --bdev /dev/sdf1" again. CRASH.
>>
>> make-bcache will auto register.  (Maybe there's an option to stop that,
>> I've not looked.)
>>
>> > when manually creating a cache device using "make-bcache --cache
>> > /dev/vg-raid0/lv-bcache". The cache set didn't show up in
>> > /sys/fs/bcache. echo "/dev/vg-raid0/lv-bcache" >
>> > /sys/fs/bcache/register. CRASH.
>> > I was able to work around this issue by stopping the osd's before
>> > registering and therefore freeing up memory.
>>
>> I would be curious if setting /proc/sys/vm/min_free_kbytes to 256*1024
>> fixes that.
>>
>> > Because I am able to reproduce this relatively easily, I'm happy to
>> > test any patches.
>>
>> Yes, thank you, please do:
>>
>> Try the three patches at the top of these two branches and see if you
>> crash.  I'm hoping it fails gracefully on OOM:
>>
>> https://bitbucket.org/ewheelerinc/linux/branch/v4.5-rc6-bcache-fixes
>>       commits 84a2edd, a704484
>> https://bitbucket.org/ewheelerinc/linux/branch/v4.5-rc7-bcache-fixes
>>       commit 87264e9
>>
>> If it stops crashing, then maybe we can work out a way to allocate memory
>> such that it succeeds.  Please send any dmesg output.
>>
>> -Eric
>>
>> > Apart from the register crash, the cache sets have been up and stable
>> > for over 1 month.
>> >
>> > Regards,
>> > Richard
>> >
>> > On Mon, 7 Mar 2016, Marc MERLIN wrote:
>> >
>> > > I started a btrfs copy from a bcached device to another one (both are in
>> > > the 5 to 15TB range).
>> > > A minute later, my system that had been up for several days, crashed.
>> > >
>> > > Ultimately, it crashed on this:
>> > > bcache: register_cache() error opening sdl2: cannot allocate memory
>> > > BUG: unable to handle kernel NULL pointer dereference at 00000000000009b8
>> > > IP: [<ffffffffc0516e8d>] cache_set_flush+0x102/0x15c [bcache]
>> >
>> > Strange about memory allocation issues.  Do you have
>> > /proc/sys/vm/min_free_kbytes set to something like $((256*1024)) ? Is this
>> > a multi-socket machine with all memory plugged into only one CPU?
>> >
>> > I'm curious though, why was registration called a second time? Was the
>> > drive external?  Could udev be re-registering the device?
>> >
>> > You might find where the registration is being done and prevent it from
>> > running automatically.  At least that might solve the re-registration
>> > problem.
>> >
>> > As for the memory allocation issue, the backtrace indicates that this is a
>> > registration-time problem, not a runtime issue.  I'm guessing it is one of
>> > the threads attempting to proceed after a memory allocation error similar
>> > to the writeback thread issue you had last time which was fixed by adding
>> > some locking around the initialization.
>> >
>> > I'll look and see if I can come up with a reasonable patch to cleanup the
>> > allocator or gc thread under OOM conditions at registration time.
>> >
>> > -Eric
>> >
>> > >
>> > > I'm not sure why it tried to register sdl2 then when it was already
>> > > registered from boot. Did it time out and had to be registered again?
>> > >
>> > > At this point, things with bcache have been bad enough, that I'm
>> > > considering removing it. My system has been very unstable with it :(
>> > > Or maybe I can just remove the caching devices, leave the backing ones,
>> > > and run without cache for now, giving me the option to re-add the cache later.
>> > >
>> > > I actually just added 16GB of RAM to the server after adding bcache, and
>> > > clearly going from 8 to 24GB made no difference. I'm wondering if there
>> > > is a memory leak somewhere?
>> > >
>> > > Just before the system crashed, memory looked like this, which isn't bad:
>> > >              total       used       free     shared    buffers     cached
>> > > Mem:      24392440   24241440     151000          0         88   20116748
>> > > -/+ buffers/cache:    4124604   20267836
>> > > Swap:     15616764     244452   15372312
>> > >
>> > > I'm using btrfs on top of dmcrypt on top of bcache.
>> > > btrfs on top of dmcrypt was stable, I had been using it for years. Adding bcache is what
>> > > caused all my recent problems to start.
>> > >
>> > > Any ideas?
>> > >
>> > > Thanks,
>> > > Marc
>> > >
>> > >
>> > > [290569.458707] Process accounting resumed
>> > > [290623.673871] bcache-register: page allocation failure: order:7, mode:0x24080c0
>> > > [290623.697143] CPU: 0 PID: 1284 Comm: bcache-register Tainted: G        W       4.4.2-amd64-i915-volpreempt-20160214bc3 #5
>> > > [290623.732143] Hardware name: System manufacturer System Product Name/P8H67-M PRO, BIOS 3904 04/27/2013
>> > > [290623.762428]  0000000000000000 ffff88001df7bb08 ffffffff8134ae0a 0000000000000001
>> > > [290623.787470]  ffff88001df7bba0 ffffffff81124ab6 024080c01df7bc44 024080c000000040
>> > > [290623.811775]  0000000700000001 0000000000000007 0000000000000007 0000000000000040
>> > > [290623.836443] Call Trace:
>> > > [290623.846280]  [<ffffffff8134ae0a>] dump_stack+0x44/0x55
>> > > [290623.864123]  [<ffffffff81124ab6>] warn_alloc_failed+0x114/0x12c
>> > > [290623.883425]  [<ffffffff811274b8>] __alloc_pages_nodemask+0x7cb/0x84c
>> > > [290623.904159]  [<ffffffff8107df80>] ? try_to_wake_up+0x1d9/0x1eb
>> > > [290623.923173]  [<ffffffff8115f6d7>] alloc_pages_current+0xa9/0xcd
>> > > [290623.942435]  [<ffffffff8112377e>] __get_free_pages+0xe/0x3c
>> > > [290623.960621]  [<ffffffffc05192f0>] bch_cache_set_alloc+0x3c7/0x479 [bcache]
>> > > [290623.983825]  [<ffffffffc051a5e3>] register_bcache+0x1241/0x1452 [bcache]
>> > > [290624.005456]  [<ffffffff8134c853>] kobj_attr_store+0x10/0x1a
>> > > [290624.023729]  [<ffffffff811df9df>] sysfs_kf_write+0x39/0x3b
>> > > [290624.041739]  [<ffffffff811df2e1>] kernfs_fop_write+0xed/0x130
>> > > [290624.060394]  [<ffffffff8117d97d>] __vfs_write+0x26/0xa5
>> > > [290624.077452]  [<ffffffff810b2969>] ? current_kernel_time64+0x10/0x36
>> > > [290624.097921]  [<ffffffff812d6050>] ? security_file_permission+0x3b/0x42
>> > > [290624.119197]  [<ffffffff810915ea>] ? percpu_down_read+0x12/0x41
>> > > [290624.138945]  [<ffffffff8117fb61>] ? __sb_start_write+0x2b/0x48
>> > > [290624.158291]  [<ffffffff8117dfe8>] vfs_write+0x9d/0xe8
>> > > [290624.174919]  [<ffffffff8117e7bd>] SyS_write+0x4d/0x78
>> > > [290624.191455]  [<ffffffff810039c3>] do_fast_syscall_32+0xb3/0xf3
>> > > [290624.210331]  [<ffffffff816e3e32>] sysenter_flags_fixed+0x8/0x12
>> > > [290624.229355] Mem-Info:
>> > > [290624.237432] active_anon:607145 inactive_anon:208571 isolated_anon:0
>> > > [290624.237432]  active_file:2103407 inactive_file:1565209 isolated_file:0
>> > > [290624.237432]  unevictable:1307 dirty:188846 writeback:138775 unstable:0
>> > > [290624.237432]  slab_reclaimable:180112 slab_unreclaimable:73373
>> > > [290624.237432]  mapped:419640 shmem:466581 pagetables:5778 bounce:0
>> > > [290624.237432]  free:988612 free_pcp:2130 free_cma:14
>> > > [290624.351715] Node 0 DMA free:15884kB min:12kB low:12kB high:16kB active_anon:0kB inactive_anon:0kB active_file:0kB inactive_file:0kB unevictable:0kB isolated(anon):0kB isolated(file):0kB present:15976kB managed:15892kB mlocked:0kB dirty:0kB writeback:0kB mapped:0kB shmem:0kB slab_reclaimable:0kB slab_unreclaimable:0kB kernel_stack:0kB pagetables:0kB unstable:0kB bounce:0kB free_pcp:0kB local_pcp:0kB free_cma:0kB writeback_tmp:0kB pages_scanned:0 all_unreclaimable? yes
>> > > [290624.483875] lowmem_reserve[]: 0 3201 23800 23800
>> > > [290624.500998] Node 0 DMA32 free:581000kB min:2648kB low:3308kB high:3972kB active_anon:229220kB inactive_anon:248156kB active_file:1102468kB inactive_file:832264kB unevictable:948kB isolated(anon):0kB isolated(file):68kB present:3362068kB managed:3283032kB mlocked:68719477684kB dirty:94316kB writeback:65996kB mapped:253400kB shmem:282168kB slab_reclaimable:96344kB slab_unreclaimable:41308kB kernel_stack:2480kB pagetables:2952kB unstable:0kB bounce:0kB free_pcp:4008kB local_pcp:140kB free_cma:0kB writeback_tmp:0kB pages_scanned:0 all_unreclaimable? no
>> > > [290624.655741] lowmem_reserve[]: 0 0 20599 20599
>> > > [290624.674232] Node 0 Normal free:3368136kB min:17048kB low:21308kB high:25572kB active_anon:2203780kB inactive_anon:586104kB active_file:7311280kB inactive_file:5430068kB unevictable:4280kB isolated(anon):0kB isolated(file):0kB present:21485568kB managed:21093516kB mlocked:481036341432kB dirty:662172kB writeback:472472kB mapped:1425288kB shmem:1584132kB slab_reclaimable:624104kB slab_unreclaimable:251680kB kernel_stack:11696kB pagetables:20180kB unstable:0kB bounce:0kB free_pcp:4304kB local_pcp:588kB free_cma:56kB writeback_tmp:0kB pages_scanned:0 all_unreclaimable? no
>> > > [290624.834378] lowmem_reserve[]: 0 0 0 0
>> > > [290624.848459] Node 0 DMA: 1*4kB (U) 1*8kB (U) 0*16kB 0*32kB 2*64kB (U) 1*128kB (U) 1*256kB (U) 0*512kB 1*1024kB (U) 1*2048kB (M) 3*4096kB (M) = 15884kB
>> > > [290624.895688] Node 0 DMA32: 30635*4kB (UME) 23925*8kB (UME) 7478*16kB (UME) 2420*32kB (UME) 794*64kB (UME) 139*128kB (UME) 10*256kB (UM) 0*512kB 0*1024kB 0*2048kB 0*4096kB = 582196kB
>> > > [290624.947950] Node 0 Normal: 241499*4kB (UME) 161875*8kB (UME) 33424*16kB (UME) 10915*32kB (UME) 2795*64kB (UME) 334*128kB (UME) 15*256kB (UM) 0*512kB 0*1024kB 0*2048kB 0*4096kB = 3370532kB
>> > > [290625.003724] Node 0 hugepages_total=0 hugepages_free=0 hugepages_surp=0 hugepages_size=2048kB
>> > > [290625.030463] 4142937 total pagecache pages
>> > > [290625.043969] 5782 pages in swap cache
>> > > [290625.056118] Swap cache stats: add 102837, delete 97055, find 627323/635133
>> > > [290625.078329] Free swap  = 15372324kB
>> > > [290625.090190] Total swap = 15616764kB
>> > > [290625.102186] 6215903 pages RAM
>> > > [290625.112399] 0 pages HighMem/MovableOnly
>> > > [290625.125747] 117793 pages reserved
>> > > [290625.137495] 4096 pages cma reserved
>> > > [290625.149199] 0 pages hwpoisoned
>> > > [290625.159961] bcache: register_cache() error opening sdl2: cannot allocate memory
>> > > [290625.183410] BUG: unable to handle kernel NULL pointer dereference at 00000000000009b8
>> > > [290625.208648] IP: [<ffffffffc0516e8d>] cache_set_flush+0x102/0x15c [bcache]
>> > > [290625.230734] PGD 0
>> > > [290625.238446] Oops: 0000 [#1] SMP
>> > > [290625.249857] Modules linked in: udp_diag tcp_diag inet_diag veth ip6table_filter ip6_tables ebtable_nat ebtables ppdev lp xt_addrtype tun bridge stp llc autofs4 softdog binfmt_misc ftdi_sio nfsd nfs_acl auth_rpcgss nfs fscache lockd grace sunrpc ipt_REJECT nf_reject_ipv4 xt_conntrack xt_mark xt_nat xt_tcpudp nf_log_ipv4 nf_log_common xt_LOG iptable_mangle iptable_filter bcache lm85 hwmon_vid pl2303 iptable_nat nf_conntrack_ipv4 nf_defrag_ipv4 nf_nat_ipv4 ip_tables nf_conntrack_ftp ipt_MASQUERADE x_tables nf_nat_masquerade_ipv4 nf_nat nf_conntrack sg st snd_pcm_oss snd_mixer_oss kvm_intel snd_hda_codec_realtek snd_hda_codec_generic snd_opl3_synth kvm snd_seq_midi_emul snd_hda_intel snd_cmipci gameport snd_hda_codec snd_opl3_lib snd_mpu401_uart snd_seq_midi irqbypass snd_seq_midi_e
 vent snd_seq snd_hda_core snd_hwdep snd_rawmidi asix coretemp eeepc_wmi tpm_infineon rc_ati_x10 snd_pcm libphy snd_seq_device asus_wmi snd_timer sparse_keymap rfkill intel_rapl 8250_fintek at
>  i_
>>  re
>> >  mo
>> > >  te usbnet tpm_tis snd rc_core battery tpm evdev iosf_mbi wmi pcspkr input_leds intel_powerclamp parport_pc processor i2c_i801 xhci_pci x86_pkg_temp_thermal usbserial soundcore parport xhci_hcd lpc_ich e1000e ptp pps_core fuse raid456 multipath mmc_block mmc_core dm_snapshot dm_bufio dm_mirror dm_region_hash dm_log dm_crypt dm_mod async_raid6_recov async_pq async_xor async_memcpy async_tx blowfish_x86_64 blowfish_common ecb xts ansi_cprng drbg aesni_intel ablk_helper lrw gf128mul glue_helper aes_x86_64 crct10dif_pclmul crc32_pclmul crc32c_intel r8169 ehci_pci fjes ehci_hcd thermal mii sata_mv fan cryptd usbcore usb_common sata_sil24 [last unloaded: ftdi_sio]
>> > > [290625.713109] CPU: 0 PID: 25842 Comm: kworker/0:0 Tainted: G        W       4.4.2-amd64-i915-volpreempt-20160214bc3 #5
>> > > [290625.747597] Hardware name: System manufacturer System Product Name/P8H67-M PRO, BIOS 3904 04/27/2013
>> > > [290625.776918] Workqueue: events cache_set_flush [bcache]
>> > > [290625.794260] task: ffff880467caa0c0 ti: ffff8805af184000 task.ti: ffff8805af184000
>> > > [290625.818544] RIP: 0010:[<ffffffffc0516e8d>]  [<ffffffffc0516e8d>] cache_set_flush+0x102/0x15c [bcache]
>> > > [290625.848082] RSP: 0018:ffff8805af187e10  EFLAGS: 00010202
>> > > [290625.866890] RAX: 0000000000000001 RBX: ffff880153a40ce8 RCX: 0000000000000282
>> > > [290625.891136] RDX: 0000000000000000 RSI: 0000000000000000 RDI: 0000000000000000
>> > > [290625.914365] RBP: ffff8805af187e30 R08: 00000000000000fa R09: ffffe8ffffc01900
>> > > [290625.937588] R10: ffff880088430838 R11: ffff880088430838 R12: 0000000000000000
>> > > [290625.960781] R13: ffff880153a40de8 R14: 0000000000000000 R15: ffffe8ffffc01900
>> > > [290625.983951] FS:  0000000000000000(0000) GS:ffff88061e200000(0000) knlGS:0000000000000000
>> > > [290626.010918] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
>> > > [290626.030800] CR2: 00000000000009b8 CR3: 0000000001e0a000 CR4: 00000000001406f0
>> > > [290626.053914] Stack:
>> > > [290626.061687]  ffff8805d6183280 ffff88061e216040 ffff880153a40ce8 0000000000000000
>> > > [290626.085725]  ffff8805af187e78 ffffffff81070fcf ffff8805d61832b0 000000001e216058
>> > > [290626.110510]  ffff8805d6183280 ffff88061e216040 ffff8805d61832b0 ffff88061e216058
>> > > [290626.135329] Call Trace:
>> > > [290626.145108]  [<ffffffff81070fcf>] process_one_work+0x15b/0x260
>> > > [290626.164241]  [<ffffffff81071574>] worker_thread+0x1f0/0x29d
>> > > [290626.182561]  [<ffffffff81071384>] ? rescuer_thread+0x281/0x281
>> > > [290626.201721]  [<ffffffff810758e9>] kthread+0xa5/0xad
>> > > [290626.217966]  [<ffffffff81075844>] ? kthread_parkme+0x24/0x24
>> > > [290626.236505]  [<ffffffff816e1c0f>] ret_from_fork+0x3f/0x70
>> > > [290626.255052]  [<ffffffff81075844>] ? kthread_parkme+0x24/0x24
>> > > [290626.274460] Code: 89 1c c1 4d 8b a4 24 f0 01 00 00 49 81 ec f0 01 00 00 eb b4 45 31 e4 0f b7 83 4c f7 ff ff 4a 8b 94 e3 58 ff ff ff 44 39 e0 76 16 <48> 8b ba b8 09 00 00 48 85 ff 74 05 e8 61 e8 b5 c0 49 ff c4 eb
>> > > [290626.337443] RIP  [<ffffffffc0516e8d>] cache_set_flush+0x102/0x15c [bcache]
>> > > [290626.359833]  RSP <ffff8805af187e10>
>> > > [290626.372050] CR2: 00000000000009b8
>> > > [290626.383646] ---[ end trace f97d88b8bb456800 ]---
>> > > [290626.399977] Kernel panic - not syncing: Fatal exception
>> > > [290626.418169] Kernel Offset: disabled
>> > > [290626.430278] Rebooting in 20 seconds..
>> > > [290646.378903] ACPI MEMORY or I/O RESET_REG.
>> > > --
>> > > "A mouse is a device used to point at the xterm you want to type in" - A.S.R.
>> > > Microsoft is to operating systems ....
>> > >                                       .... what McDonalds is to gourmet cooking
>> > > Home page: http://marc.merlins.org/                         | PGP 1024R/763BE901
>> > > --
>> > > To unsubscribe from this list: send the line "unsubscribe linux-bcache" in
>> > > the body of a message to majordomo@vger.kernel.org
>> > > More majordomo info at  http://vger.kernel.org/majordomo-info.html
>> > >
>> > --
>> > To unsubscribe from this list: send the line "unsubscribe linux-bcache" in
>> > the body of a message to majordomo@vger.kernel.org
>> > More majordomo info at  http://vger.kernel.org/majordomo-info.html
>> > --
>> > To unsubscribe from this list: send the line "unsubscribe linux-bcache" in
>> > the body of a message to majordomo@vger.kernel.org
>> > More majordomo info at  http://vger.kernel.org/majordomo-info.html
>> >
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-bcache" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>>
