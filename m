From: Eric Wheeler <bcache@lists.ewheeler.net>
Subject: Re: Bug in bch_hprint related to SHOW(__bch_cached_dev)
Date: Sun, 6 Dec 2015 14:13:02 -0800 (PST)
Message-ID: <alpine.LRH.2.11.1512061403280.24989@mail.ewheeler.net>
References: <CADr68WaASnBHqJ=xL05Stbnzg4=YV4Leoa=_4pRbyrnvH_ix1g@mail.gmail.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-bcache-owner@vger.kernel.org>
Received: from [71.19.153.34] ([71.19.153.34]:47519 "EHLO mail.ewheeler.net"
	rhost-flags-FAIL-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
	id S1754589AbbLFWNn (ORCPT <rfc822;linux-bcache@vger.kernel.org>);
	Sun, 6 Dec 2015 17:13:43 -0500
In-Reply-To: <CADr68WaASnBHqJ=xL05Stbnzg4=YV4Leoa=_4pRbyrnvH_ix1g@mail.gmail.com>
Sender: linux-bcache-owner@vger.kernel.org
List-Id: linux-bcache@vger.kernel.org
To: Jens Rosenboom <j.rosenboom@x-ion.de>
Cc: linux-bcache@vger.kernel.org

On Fri, 20 Nov 2015, Jens Rosenboom wrote:

> It will e.g. print 1.10k for a value between 2024 and 2047, which when
> parsed back would appear to be a much lower value. 

Also note that /sys/block/bcache0/bcache/writeback_rate_debug (I think) 
has a nasty bug that will hang the whole system inside of 
sysfs.c:SHOW(__bch_cached_dev).  I believe it needs a lock around the P/D 
metric updater.  It may extend to other attributes as well.  I've not had 
time to investigate, but something like this under heavy IO will lock 
hard:

while true; tail /sys/block/bcache0/bcache/* > /dev/null; done

I recommend stepping lightly around the sysfs attributes if you plan to 
poll them regularly for monitoring (I was about to write a munin plugin at 
the time).

More detail below:

Sep  1 23:20:37 hv1.drbd [605542.593499] Kernel panic - not syncing: stack-protector: Kernel stack is corrupted in: ffffffffa0e5aeb5#012[605542.593499] 
Sep  1 23:20:37 hv1.drbd [605542.593866] CPU: 6 PID: 16898 Comm: tail Tainted: G           OE   4.1.6+ #43
Sep  1 23:20:37 hv1.drbd [605542.594105] Hardware name: Supermicro X9SCL/X9SCM/X9SCL/X9SCM, BIOS 2.10 01/09/2014
Sep  1 23:20:37 hv1.drbd [605542.594357]  000226bcdfd5aedf
Sep  1 23:20:37 hv1.drbd  ffff880105003b68
Sep  1 23:20:37 hv1.drbd  ffffffff815fa76b
Sep  1 23:20:37 hv1.drbd  0000000000000001
Sep  1 23:20:37 hv1.drbd  
Sep  1 23:20:37 hv1.drbd [605542.594612]  ffffffff81a00938
Sep  1 23:20:37 hv1.drbd  ffff880105003be8
Sep  1 23:20:37 hv1.drbd  ffffffff815f5e5a
Sep  1 23:20:37 hv1.drbd  000226bcdfd5aedf
Sep  1 23:20:37 hv1.drbd  
Sep  1 23:20:37 hv1.drbd [605542.594868]  ffff880100000010
Sep  1 23:20:37 hv1.drbd  ffff880105003bf8
Sep  1 23:20:37 hv1.drbd  ffff880105003b98
Sep  1 23:20:37 hv1.drbd  ffff880105003bf8
Sep  1 23:20:37 hv1.drbd  
Sep  1 23:20:37 hv1.drbd [605542.595121] Call Trace:
Sep  1 23:20:37 hv1.drbd [605542.595247]  [<ffffffff815fa76b>] dump_stack+0x45/0x57
Sep  1 23:20:37 hv1.drbd [605542.595375]  [<ffffffff815f5e5a>] panic+0xc1/0x1f5
Sep  1 23:20:37 hv1.drbd [605542.595508]  [<ffffffffa0e5aeb5>] ? __bch_cached_dev_show+0x505/0x510 [bcache]
Sep  1 23:20:37 hv1.drbd [605542.595757]  [<ffffffff8107fa3b>] __stack_chk_fail+0x1b/0x20
Sep  1 23:20:37 hv1.drbd [605542.595888]  [<ffffffffa0e5aeb5>] __bch_cached_dev_show+0x505/0x510 [bcache]
Sep  1 23:20:37 hv1.drbd [605542.596021]  [<ffffffff81174009>] ? file_ra_state_init+0x19/0x30
Sep  1 23:20:37 hv1.drbd [605542.596153]  [<ffffffffa0e5aef5>] bch_cached_dev_show+0x35/0x60 [bcache]
Sep  1 23:20:37 hv1.drbd [605542.596282]  [<ffffffff8124c5bf>] sysfs_kf_seq_show+0xaf/0x140
Sep  1 23:20:37 hv1.drbd [605542.596409]  [<ffffffff8124ac30>] kernfs_seq_show+0x20/0x30
Sep  1 23:20:37 hv1.drbd [605542.596540]  [<ffffffff811f9f7a>] seq_read+0xea/0x370
Sep  1 23:20:37 hv1.drbd [605542.596672]  [<ffffffff8124b3fd>] kernfs_fop_read+0x10d/0x180
Sep  1 23:20:37 hv1.drbd [605542.596807]  [<ffffffff811d6298>] __vfs_read+0x28/0xe0
Sep  1 23:20:37 hv1.drbd [605542.596948]  [<ffffffff8126d894>] ? security_file_permission+0x84/0xa0
Sep  1 23:20:37 hv1.drbd [605542.597077]  [<ffffffff811d67f6>] ? rw_verify_area+0x56/0xe0
Sep  1 23:20:37 hv1.drbd [605542.597205]  [<ffffffff811d6906>] vfs_read+0x86/0x140
Sep  1 23:20:37 hv1.drbd [605542.597342]  [<ffffffff811d7786>] SyS_read+0x46/0xb0
Sep  1 23:20:37 hv1.drbd [605542.597465]  [<ffffffff8111a804>] ? __audit_syscall_entry+0xb4/0x110
Sep  1 23:20:37 hv1.drbd [605542.597592]  [<ffffffff81601a6e>] system_call_fastpath+0x12/0x71
Sep  1 23:20:37 hv1.drbd [605542.597749] Kernel Offset: disabled
Sep  1 23:20:38 hv1.drbd [605543.105302] ---[ end Kernel panic - not syncing: stack-protector: Kernel stack is corrupted in: ffffffffa0e5aeb5#012[605543.105302] 
Sep  1 23:20:38 hv1.drbd [605543.105721] ------------[ cut here ]------------
Sep  1 23:20:38 hv1.drbd [605543.105895] WARNING: CPU: 6 PID: 16898 at arch/x86/kernel/smp.c:124 native_smp_send_reschedule+0x5d/0x60()
Sep  1 23:20:38 hv1.drbd [605543.106188] Modules linked in:
Sep  1 23:20:38 hv1.drbd  btrfs
Sep  1 23:20:38 hv1.drbd  xor
Sep  1 23:20:38 hv1.drbd  raid6_pq
Sep  1 23:20:38 hv1.drbd  sha256_ssse3
Sep  1 23:20:38 hv1.drbd  sha256_generic
Sep  1 23:20:38 hv1.drbd  dm_crypt
Sep  1 23:20:38 hv1.drbd  vhost_net
Sep  1 23:20:38 hv1.drbd  vhost
Sep  1 23:20:38 hv1.drbd  macvtap
Sep  1 23:20:38 hv1.drbd  macvlan
Sep  1 23:20:38 hv1.drbd  tun
Sep  1 23:20:38 hv1.drbd  dm_snapshot
Sep  1 23:20:38 hv1.drbd  drbd(OE)
Sep  1 23:20:38 hv1.drbd  dm_thin_pool
Sep  1 23:20:38 hv1.drbd  dm_persistent_data
Sep  1 23:20:38 hv1.drbd  dm_bio_prison
Sep  1 23:20:38 hv1.drbd  dm_bufio
Sep  1 23:20:38 hv1.drbd  libcrc32c
Sep  1 23:20:38 hv1.drbd  bcache
Sep  1 23:20:38 hv1.drbd  zram
Sep  1 23:20:38 hv1.drbd  lz4_compress
Sep  1 23:20:38 hv1.drbd  netconsole
Sep  1 23:20:38 hv1.drbd  configfs
Sep  1 23:20:38 hv1.drbd  bridge
Sep  1 23:20:38 hv1.drbd  stp
Sep  1 23:20:38 hv1.drbd  llc
Sep  1 23:20:38 hv1.drbd  8021q
Sep  1 23:20:38 hv1.drbd  ext3
Sep  1 23:20:38 hv1.drbd  jbd
Sep  1 23:20:38 hv1.drbd  x86_pkg_temp_thermal
Sep  1 23:20:38 hv1.drbd  coretemp
Sep  1 23:20:38 hv1.drbd  kvm_intel
Sep  1 23:20:38 hv1.drbd  kvm
Sep  1 23:20:38 hv1.drbd  iTCO_wdt
Sep  1 23:20:38 hv1.drbd  iTCO_vendor_support
Sep  1 23:20:38 hv1.drbd  crc32c_intel
Sep  1 23:20:38 hv1.drbd  shpchp
Sep  1 23:20:38 hv1.drbd  ghash_clmulni_intel
Sep  1 23:20:38 hv1.drbd  video
Sep  1 23:20:38 hv1.drbd  serio_raw
Sep  1 23:20:38 hv1.drbd  i2c_i801
Sep  1 23:20:38 hv1.drbd  lpc_ich
Sep  1 23:20:38 hv1.drbd  i2c_core
Sep  1 23:20:38 hv1.drbd  microcode
Sep  1 23:20:38 hv1.drbd  mfd_core
Sep  1 23:20:38 hv1.drbd  ext4
Sep  1 23:20:38 hv1.drbd  jbd2
Sep  1 23:20:38 hv1.drbd  mbcache
Sep  1 23:20:38 hv1.drbd  sd_mod
Sep  1 23:20:38 hv1.drbd  ixgbe
Sep  1 23:20:38 hv1.drbd  e1000e
Sep  1 23:20:38 hv1.drbd  mdio
Sep  1 23:20:38 hv1.drbd  ahci
Sep  1 23:20:38 hv1.drbd  dca
Sep  1 23:20:38 hv1.drbd  libahci
Sep  1 23:20:38 hv1.drbd  ptp
Sep  1 23:20:38 hv1.drbd  pps_core
Sep  1 23:20:38 hv1.drbd  arcmsr
Sep  1 23:20:38 hv1.drbd  dm_mirror
Sep  1 23:20:38 hv1.drbd  dm_region_hash
Sep  1 23:20:38 hv1.drbd  dm_log
Sep  1 23:20:38 hv1.drbd  dm_mod
Sep  1 23:20:38 hv1.drbd  ipv6
Sep  1 23:20:38 hv1.drbd  autofs4
Sep  1 23:20:38 hv1.drbd  [last unloaded: bcache]
Sep  1 23:20:38 hv1.drbd  
Sep  1 23:20:38 hv1.drbd [605543.110412] CPU: 6 PID: 16898 Comm: tail Tainted: G           OE   4.1.6+ #43
Sep  1 23:20:38 hv1.drbd [605543.110701] Hardware name: Supermicro X9SCL/X9SCM/X9SCL/X9SCM, BIOS 2.10 01/09/2014
Sep  1 23:20:38 hv1.drbd [605543.110990]  ffffffff819f4559
Sep  1 23:20:38 hv1.drbd  ffff88082fd83d58
Sep  1 23:20:38 hv1.drbd  ffffffff815fa76b
Sep  1 23:20:38 hv1.drbd  0000000000000000
Sep  1 23:20:38 hv1.drbd  
Sep  1 23:20:38 hv1.drbd [605543.111468]  0000000000000000
Sep  1 23:20:38 hv1.drbd  ffff88082fd83d98
Sep  1 23:20:38 hv1.drbd  ffffffff8107fc4a
Sep  1 23:20:38 hv1.drbd  ffff88082fd83d98
Sep  1 23:20:38 hv1.drbd  
Sep  1 23:20:38 hv1.drbd [605543.111945]  0000000000000002
Sep  1 23:20:38 hv1.drbd  ffff88082fc96040
Sep  1 23:20:38 hv1.drbd  0000000000000006
Sep  1 23:20:38 hv1.drbd  0000000000000006
Sep  1 23:20:38 hv1.drbd  
Sep  1 23:20:38 hv1.drbd [605543.112424] Call Trace:
Sep  1 23:20:38 hv1.drbd [605543.112587]  <IRQ> 
Sep  1 23:20:38 hv1.drbd  [<ffffffff815fa76b>] dump_stack+0x45/0x57
Sep  1 23:20:38 hv1.drbd [605543.112810]  [<ffffffff8107fc4a>] warn_slowpath_common+0x8a/0xc0
Sep  1 23:20:38 hv1.drbd [605543.112981]  [<ffffffff8107fd3a>] warn_slowpath_null+0x1a/0x20
Sep  1 23:20:38 hv1.drbd [605543.113153]  [<ffffffff810383ed>] native_smp_send_reschedule+0x5d/0x60
Sep  1 23:20:38 hv1.drbd [605543.113330]  [<ffffffff810b8245>] trigger_load_balance+0x145/0x1f0
Sep  1 23:20:38 hv1.drbd [605543.113505]  [<ffffffff810a8dfc>] scheduler_tick+0x9c/0xd0
Sep  1 23:20:38 hv1.drbd [605543.113678]  [<ffffffff810e41d1>] update_process_times+0x51/0x60
Sep  1 23:20:38 hv1.drbd [605543.113851]  [<ffffffff810f3b35>] tick_sched_handle.isra.16+0x25/0x60
Sep  1 23:20:38 hv1.drbd [605543.114024]  [<ffffffff810f3bb4>] tick_sched_timer+0x44/0x80
Sep  1 23:20:38 hv1.drbd [605543.114195]  [<ffffffff810e4df7>] __run_hrtimer+0x77/0x1d0
Sep  1 23:20:38 hv1.drbd [605543.114364]  [<ffffffff810f3b70>] ? tick_sched_handle.isra.16+0x60/0x60
Sep  1 23:20:38 hv1.drbd [605543.114537]  [<ffffffff810e51c3>] hrtimer_interrupt+0xf3/0x220
Sep  1 23:20:38 hv1.drbd [605543.114708]  [<ffffffff8103b2a9>] local_apic_timer_interrupt+0x39/0x60
Sep  1 23:20:38 hv1.drbd [605543.114882]  [<ffffffff81604605>] smp_apic_timer_interrupt+0x45/0x60
Sep  1 23:20:38 hv1.drbd [605543.115058]  [<ffffffff816028be>] apic_timer_interrupt+0x6e/0x80
Sep  1 23:20:38 hv1.drbd [605543.115232]  <EOI> 
Sep  1 23:20:38 hv1.drbd  [<ffffffff815f5f4d>] ? panic+0x1b4/0x1f5
Sep  1 23:20:38 hv1.drbd [605543.115451]  [<ffffffff815f5f46>] ? panic+0x1ad/0x1f5
Sep  1 23:20:38 hv1.drbd [605543.115625]  [<ffffffffa0e5aeb5>] ? __
+0x505/0x510 [bcache]
Sep  1 23:20:38 hv1.drbd [605543.115914]  [<ffffffff8107fa3b>] __stack_chk_fail+0x1b/0x20
Sep  1 23:20:38 hv1.drbd [605543.116086]  [<ffffffffa0e5aeb5>] __bch_cached_dev_show+0x505/0x510 [bcache]
Sep  1 23:20:38 hv1.drbd [605543.116262]  [<ffffffff81174009>] ? file_ra_state_init+0x19/0x30
Sep  1 23:20:38 hv1.drbd [605543.116439]  [<ffffffffa0e5aef5>] bch_cached_dev_show+0x35/0x60 [bcache]
Sep  1 23:20:38 hv1.drbd [605543.116613]  [<ffffffff8124c5bf>] sysfs_kf_seq_show+0xaf/0x140
Sep  1 23:20:38 hv1.drbd [605543.116783]  [<ffffffff8124ac30>] kernfs_seq_show+0x20/0x30
Sep  1 23:20:38 hv1.drbd [605543.116952]  [<ffffffff811f9f7a>] seq_read+0xea/0x370
Sep  1 23:20:38 hv1.drbd [605543.117122]  [<ffffffff8124b3fd>] kernfs_fop_read+0x10d/0x180
Sep  1 23:20:38 hv1.drbd [605543.117294]  [<ffffffff811d6298>] __vfs_read+0x28/0xe0
Sep  1 23:20:38 hv1.drbd [605543.117464]  [<ffffffff8126d894>] ? security_file_permission+0x84/0xa0
Sep  1 23:20:38 hv1.drbd [605543.117640]  [<ffffffff811d67f6>] ? rw_verify_area+0x56/0xe0
Sep  1 23:20:38 hv1.drbd [605543.117814]  [<ffffffff811d6906>] vfs_read+0x86/0x140
Sep  1 23:20:38 hv1.drbd [605543.117986]  [<ffffffff811d7786>] SyS_read+0x46/0xb0
Sep  1 23:20:38 hv1.drbd [605543.118159]  [<ffffffff8111a804>] ? __audit_syscall_entry+0xb4/0x110
Sep  1 23:20:38 hv1.drbd [605543.118332]  [<ffffffff81601a6e>] system_call_fastpath+0x12/0x71
Sep  1 23:20:38 hv1.drbd [605543.118502] ---[ end trace c31b473c28e226c5 ]---

While tailing these every 2 seconds with `watch`:

==> dirty_data <==
6.4G
==> writeback_delay <==
30
==> writeback_metadata <==
1
==> writeback_percent <==
10
==> writeback_rate <==
57.5k
==> writeback_rate_debug <==
rate:           57.5k/sec
dirty:          6.4G
target:         6.4G
proportional:   -3.5k
derivative:     1.5k
change:         -1.0k/sec
next io:        963ms
==> writeback_rate_d_term <==
30
==> writeback_rate_p_term_inverse <==
6000
==> writeback_rate_update_seconds <==
5
==> writeback_running <==
1
==> stats_five_minute/bypassed <==
120M
==> stats_five_minute/cache_bypass_hits <==
6483
==> stats_five_minute/cache_bypass_misses <==
0
==> stats_five_minute/cache_hit_ratio <==
49
==> stats_five_minute/cache_hits <==
32832
==> stats_five_minute/cache_miss_collisions <==
1051
==> stats_five_minute/cache_misses <==
33406
==> stats_five_minute/cache_readaheads <==
0
==> stats_day/bypassed <==
17.8G
==> stats_day/cache_bypass_hits <==
747652
==> stats_day/cache_bypass_misses <==
0
==> stats_day/cache_hit_ratio <==
32
==> stats_day/cache_hits <==
1330122
==> stats_day/cache_miss_collisions <==
175352
==> stats_day/cache_misses <==
2765517
==> stats_day/cache_readaheads <==
0

-Eric
