From: "David H. Rhodes Clymer" <david@zettazebra.com>
Subject: Another bcache hang
Date: Thu, 21 Nov 2013 08:56:04 -0500
Message-ID: <20131121135604.GA26424@professorx.home.zettazebra.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-bcache-owner@vger.kernel.org>
Received: from mail-qc0-f170.google.com ([209.85.216.170]:34571 "EHLO
	mail-qc0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751609Ab3KUN4j (ORCPT
	<rfc822;linux-bcache@vger.kernel.org>);
	Thu, 21 Nov 2013 08:56:39 -0500
Received: by mail-qc0-f170.google.com with SMTP id e20so4214136qcy.15
        for <linux-bcache@vger.kernel.org>; Thu, 21 Nov 2013 05:56:38 -0800 (PST)
Received: from localhost (c-174-55-248-12.hsd1.pa.comcast.net. [174.55.248.12])
        by mx.google.com with ESMTPSA id lc1sm64053174qeb.5.2013.11.21.05.56.34
        for <linux-bcache@vger.kernel.org>
        (version=TLSv1.2 cipher=RC4-SHA bits=128/128);
        Thu, 21 Nov 2013 05:56:35 -0800 (PST)
Content-Disposition: inline
Sender: linux-bcache-owner@vger.kernel.org
List-Id: linux-bcache@vger.kernel.org
To: linux-bcache@vger.kernel.org

Bcache is hanging for me. When this first started occurring, I upgraded
from 3.10.9 to 3.10.19, hoping that it was fixed recently. At that time,
when I rebooted the machine everything returned to normal. However, the
machine hung up again within 24 hours.

I have two bcache devices with different backing devices, but with shared
cache. The backing devices are LVM logical volumes on top of an RAID1
software raid device (/dev/md2). The filesystem is ext4.

hydra:~# hdparm -I /dev/sdc |grep -E 'Model|Firmware'
        Model Number:       Samsung SSD 840 Series
        Firmware Revision:  DXT06B0Q

hydra:~# cat /proc/mdstat
Personalities : [raid1]
md2 : active raid1 sda3[0] sdb3[2]
      976260984 blocks super 1.2 [2/2] [UU]

md0 : active raid1 sda2[0] sdb2[1]
      497600 blocks [2/2] [UU]

unused devices: <none>

hydra:~# mount |grep bcache
/dev/bcache0 on /var/lib/postgresql/9.2/main type ext4 (rw,noatime)
/dev/bcache1 on /var/lib/postgresql/9.3/devel type ext4 (rw,noatime)

hydra:~# tune2fs -l /dev/bcache0
tune2fs 1.42.5 (29-Jul-2012)
Filesystem volume name:   <none>
Last mounted on:          /var/lib/postgresql/9.2/main
Filesystem UUID:          0c7f609c-739f-421a-ba63-b2e89ab1e971
Filesystem magic number:  0xEF53
Filesystem revision #:    1 (dynamic)
Filesystem features:      has_journal ext_attr resize_inode dir_index filetype needs_recovery extent flex_bg sparse_super large_file huge_file uninit_
bg dir_nlink extra_isize
Filesystem flags:         signed_directory_hash
Default mount options:    journal_data_writeback
Filesystem state:         clean
Errors behavior:          Continue
Filesystem OS type:       Linux
Inode count:              16384000
Block count:              65535998
Reserved block count:     3276799
Free blocks:              55944091
Free inodes:              16064785
First block:              0
Block size:               4096
Fragment size:            4096
Reserved GDT blocks:      1008
Blocks per group:         32768
Fragments per group:      32768
Inodes per group:         8192
Inode blocks per group:   512
Flex block group size:    16
Filesystem created:       Tue Mar 12 13:49:30 2013
Last mount time:          Mon Nov 18 17:52:39 2013
Last write time:          Mon Nov 18 17:52:39 2013
Mount count:              1
Maximum mount count:      29
Last checked:             Mon Nov 18 17:51:23 2013
Check interval:           15552000 (6 months)
Next check after:         Sat May 17 18:51:23 2014
Lifetime writes:          5062 MB
Reserved blocks uid:      0 (user root)
Reserved blocks gid:      0 (group root)
First inode:              11
Inode size:               256
Required extra isize:     28
Desired extra isize:      28
Journal inode:            8
Default directory hash:   half_md4
Directory Hash Seed:      b44b29b3-6f8f-4c09-bd16-02a064233237
Journal backup:           inode blocks


hydra:~# uname -a
Linux hydra 3.10.19 #1 SMP Thu Nov 14 14:05:35 EST 2013 x86_64 GNU/Linux

hydra:~# ps awux |grep D
USER       PID %CPU %MEM    VSZ   RSS TTY      STAT START   TIME COMMAND
root      1368  0.0  0.0   5592   320 pts/14   D    Nov20   0:00 sync
root      2469  0.0  0.0   5592   324 pts/14   D    Nov20   0:00 sync
root      5171  0.0  0.0      0     0 ?        D    Nov18   0:00 [jbd2/bcache0-8]
postgres  5372  0.0  0.0  69072  2848 ?        D    Nov18   0:03 /usr/lib/postgresql/9.2/bin/postgres -D /var/lib/postgresql/9.2/main -c config_file=/etc/postgresql/9.2/main/postgresql.conf
postgres  5378  0.0  0.2 2239044 35904 ?       Ds   Nov18   0:00 postgres: checkpointer process
postgres  5382  0.0  0.0  69600  1320 ?        Ds   Nov18   0:00 postgres: stats collector process
postgres  5435  0.0 16.7 2241992 2059196 ?     Ds   Nov18   0:15 postgres: checkpointer process
root     13943  0.0  0.0   7832   876 pts/14   S+   08:17   0:00 grep D
postgres 20973  0.0  0.4 2251524 55736 ?       Ds   Nov18   0:06 postgres: postgres vistashare_2013_11_14 127.0.0.1(35215) CREATE TABLE
root     21082  0.0  0.0      0     0 ?        D    Nov18   0:00 [kworker/u32:2]
root     21090  0.0  0.0   6016  1304 ?        D    Nov19   0:00 /usr/bin/updatedb.mlocate
postgres 25749  0.0  0.1 2243844 15032 ?       Ds   Nov19   0:00 postgres: vistashare_dba vistashare_2013_09_21 127.0.0.1(46763) COMMIT
root     29452  0.0  0.0   5592   324 pts/8    D+   Nov19   0:00 sync


dmesg:

[    0.000000] Initializing cgroup subsys cpuset
[    0.000000] Initializing cgroup subsys cpu
[    0.000000] Initializing cgroup subsys cpuacct
[    0.000000] Linux version 3.10.19 (root@hydra) (gcc version 4.7.2 (Debian 4.7.2-5) ) #1 SMP Thu Nov 14 14:05:35 EST 2013
[    0.000000] Command line: BOOT_IMAGE=/vmlinuz-3.10.19 root=/dev/mapper/pve-root ro
[    0.000000] e820: BIOS-provided physical RAM map:
[    0.000000] BIOS-e820: [mem 0x0000000000000000-0x000000000009d7ff] usable
[    0.000000] BIOS-e820: [mem 0x000000000009d800-0x000000000009ffff] reserved
[    0.000000] BIOS-e820: [mem 0x00000000000e0000-0x00000000000fffff] reserved
[    0.000000] BIOS-e820: [mem 0x0000000000100000-0x00000000bf78ffff] usable
[    0.000000] BIOS-e820: [mem 0x00000000bf790000-0x00000000bf79dfff] ACPI data
[    0.000000] BIOS-e820: [mem 0x00000000bf79e000-0x00000000bf7cffff] ACPI NVS
[    0.000000] BIOS-e820: [mem 0x00000000bf7d0000-0x00000000bf7dffff] reserved
[    0.000000] BIOS-e820: [mem 0x00000000bf7ec000-0x00000000bfffffff] reserved
[    0.000000] BIOS-e820: [mem 0x00000000e0000000-0x00000000efffffff] reserved
[    0.000000] BIOS-e820: [mem 0x00000000fee00000-0x00000000fee00fff] reserved
[    0.000000] BIOS-e820: [mem 0x00000000ffc00000-0x00000000ffffffff] reserved
[    0.000000] BIOS-e820: [mem 0x0000000100000000-0x000000033fffffff] usable
[    0.000000] NX (Execute Disable) protection: active
[    0.000000] SMBIOS 2.6 present.
[    0.000000] DMI: Supermicro X8SAX/X8SAX, BIOS 1.1a    04/29/2010
[    0.000000] e820: update [mem 0x00000000-0x00000fff] usable ==> reserved
[    0.000000] e820: remove [mem 0x000a0000-0x000fffff] usable
[    0.000000] No AGP bridge found
[    0.000000] e820: last_pfn = 0x340000 max_arch_pfn = 0x400000000
[    0.000000] MTRR default type: uncachable
[    0.000000] MTRR fixed ranges enabled:
[    0.000000]   00000-9FFFF write-back
[    0.000000]   A0000-BFFFF uncachable
[    0.000000]   C0000-CFFFF write-protect
[    0.000000]   D0000-DFFFF uncachable
[    0.000000]   E0000-E3FFF write-protect
[    0.000000]   E4000-E7FFF write-through
[    0.000000]   E8000-EBFFF write-protect
[    0.000000]   EC000-EFFFF write-through
[    0.000000]   F0000-FFFFF write-protect
[    0.000000] MTRR variable ranges enabled:
[    0.000000]   0 base 000000000 mask E00000000 write-back
[    0.000000]   1 base 200000000 mask F00000000 write-back
[    0.000000]   2 base 300000000 mask FC0000000 write-back
[    0.000000]   3 base 0C0000000 mask FC0000000 uncachable
[    0.000000]   4 base 0BF800000 mask FFF800000 uncachable
[    0.000000]   5 disabled
[    0.000000]   6 disabled
[    0.000000]   7 disabled
[    0.000000] x86 PAT enabled: cpu 0, old 0x7040600070406, new 0x7010600070106
[    0.000000] e820: update [mem 0xbf800000-0xffffffff] usable ==> reserved
[    0.000000] e820: last_pfn = 0xbf790 max_arch_pfn = 0x400000000
[    0.000000] found SMP MP-table at [mem 0x000ff780-0x000ff78f] mapped at [ffff8800000ff780]
[    0.000000] Base memory trampoline at [ffff880000097000] 97000 size 24576
[    0.000000] init_memory_mapping: [mem 0x00000000-0x000fffff]
[    0.000000]  [mem 0x00000000-0x000fffff] page 4k
[    0.000000] BRK [0x0182e000, 0x0182efff] PGTABLE
[    0.000000] BRK [0x0182f000, 0x0182ffff] PGTABLE
[    0.000000] BRK [0x01830000, 0x01830fff] PGTABLE
[    0.000000] init_memory_mapping: [mem 0x33fe00000-0x33fffffff]
[    0.000000]  [mem 0x33fe00000-0x33fffffff] page 2M
[    0.000000] BRK [0x01831000, 0x01831fff] PGTABLE
[    0.000000] init_memory_mapping: [mem 0x33c000000-0x33fdfffff]
[    0.000000]  [mem 0x33c000000-0x33fdfffff] page 2M
[    0.000000] init_memory_mapping: [mem 0x300000000-0x33bffffff]
[    0.000000]  [mem 0x300000000-0x33bffffff] page 2M
[    0.000000] init_memory_mapping: [mem 0x00100000-0xbf78ffff]
[    0.000000]  [mem 0x00100000-0x001fffff] page 4k
[    0.000000]  [mem 0x00200000-0xbf5fffff] page 2M
[    0.000000]  [mem 0xbf600000-0xbf78ffff] page 4k
[    0.000000] init_memory_mapping: [mem 0x100000000-0x2ffffffff]
[    0.000000]  [mem 0x100000000-0x2ffffffff] page 2M
[    0.000000] BRK [0x01832000, 0x01832fff] PGTABLE
[    0.000000] BRK [0x01833000, 0x01833fff] PGTABLE
[    0.000000] RAMDISK: [mem 0x286a4000-0x30349fff]
[    0.000000] ACPI: RSDP 00000000000fa610 00024 (v02 ACPIAM)
[    0.000000] ACPI: XSDT 00000000bf790100 0005C (v01 SMCI            20100429 MSFT 00000097)
[    0.000000] ACPI: FACP 00000000bf790290 000F4 (v03 042910 FACP1735 20100429 MSFT 00000097)
[    0.000000] ACPI: DSDT 00000000bf790630 05CF1 (v01  1F380 1F380000 00000000 INTL 20051117)
[    0.000000] ACPI: FACS 00000000bf79e000 00040
[    0.000000] ACPI: APIC 00000000bf790390 000D2 (v01 042910 APIC1735 20100429 MSFT 00000097)
[    0.000000] ACPI: MCFG 00000000bf790470 0003C (v01 042910 OEMMCFG  20100429 MSFT 00000097)
[    0.000000] ACPI: SLIC 00000000bf7904b0 00176 (v01 SMCI            20100429 MSFT 00000097)
[    0.000000] ACPI: OEMB 00000000bf79e040 0007B (v01 042910 OEMB1735 20100429 MSFT 00000097)
[    0.000000] ACPI: HPET 00000000bf79a630 00038 (v01 042910 OEMHPET  20100429 MSFT 00000097)
[    0.000000] ACPI: SSDT 00000000bf7a0540 00363 (v01 DpgPmm    CpuPm 00000012 INTL 20051117)
[    0.000000] ACPI: Local APIC address 0xfee00000
[    0.000000] No NUMA configuration found
[    0.000000] Faking a node at [mem 0x0000000000000000-0x000000033fffffff]
[    0.000000] Initmem setup node 0 [mem 0x00000000-0x33fffffff]
[    0.000000]   NODE_DATA [mem 0x33fff3000-0x33fff6fff]
[    0.000000]  [ffffea0000000000-ffffea000cffffff] PMD -> [ffff880333600000-ffff88033f5fffff] on node 0
[    0.000000] Zone ranges:
[    0.000000]   DMA      [mem 0x00001000-0x00ffffff]
[    0.000000]   DMA32    [mem 0x01000000-0xffffffff]
[    0.000000]   Normal   [mem 0x100000000-0x33fffffff]
[    0.000000] Movable zone start for each node
[    0.000000] Early memory node ranges
[    0.000000]   node   0: [mem 0x00001000-0x0009cfff]
[    0.000000]   node   0: [mem 0x00100000-0xbf78ffff]
[    0.000000]   node   0: [mem 0x100000000-0x33fffffff]
[    0.000000] On node 0 totalpages: 3143468
[    0.000000]   DMA zone: 64 pages used for memmap
[    0.000000]   DMA zone: 21 pages reserved
[    0.000000]   DMA zone: 3996 pages, LIFO batch:0
[    0.000000]   DMA32 zone: 12191 pages used for memmap
[    0.000000]   DMA32 zone: 780176 pages, LIFO batch:31
[    0.000000]   Normal zone: 36864 pages used for memmap
[    0.000000]   Normal zone: 2359296 pages, LIFO batch:31
[    0.000000] ACPI: PM-Timer IO Port: 0x808
[    0.000000] ACPI: Local APIC address 0xfee00000
[    0.000000] ACPI: LAPIC (acpi_id[0x01] lapic_id[0x00] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x02] lapic_id[0x02] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x03] lapic_id[0x04] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x04] lapic_id[0x06] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x05] lapic_id[0x01] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x06] lapic_id[0x03] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x07] lapic_id[0x05] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x08] lapic_id[0x07] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x09] lapic_id[0x88] disabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x0a] lapic_id[0x89] disabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x0b] lapic_id[0x8a] disabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x0c] lapic_id[0x8b] disabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x0d] lapic_id[0x8c] disabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x0e] lapic_id[0x8d] disabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x0f] lapic_id[0x8e] disabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x10] lapic_id[0x8f] disabled)
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0xff] dfl dfl lint[0x1])
[    0.000000] ACPI: IOAPIC (id[0x08] address[0xfec00000] gsi_base[0])
[    0.000000] IOAPIC[0]: apic_id 8, version 32, address 0xfec00000, GSI 0-23
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 0 global_irq 2 dfl dfl)
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 9 global_irq 9 high level)
[    0.000000] ACPI: IRQ0 used by override.
[    0.000000] ACPI: IRQ2 used by override.
[    0.000000] ACPI: IRQ9 used by override.
[    0.000000] Using ACPI (MADT) for SMP configuration information
[    0.000000] ACPI: HPET id: 0x8086a301 base: 0xfed00000
[    0.000000] smpboot: Allowing 16 CPUs, 8 hotplug CPUs
[    0.000000] nr_irqs_gsi: 40
[    0.000000] PM: Registered nosave memory: 000000000009d000 - 000000000009e000
[    0.000000] PM: Registered nosave memory: 000000000009e000 - 00000000000a0000
[    0.000000] PM: Registered nosave memory: 00000000000a0000 - 00000000000e0000
[    0.000000] PM: Registered nosave memory: 00000000000e0000 - 0000000000100000
[    0.000000] PM: Registered nosave memory: 00000000bf790000 - 00000000bf79e000
[    0.000000] PM: Registered nosave memory: 00000000bf79e000 - 00000000bf7d0000
[    0.000000] PM: Registered nosave memory: 00000000bf7d0000 - 00000000bf7e0000
[    0.000000] PM: Registered nosave memory: 00000000bf7e0000 - 00000000bf7ec000
[    0.000000] PM: Registered nosave memory: 00000000bf7ec000 - 00000000c0000000
[    0.000000] PM: Registered nosave memory: 00000000c0000000 - 00000000e0000000
[    0.000000] PM: Registered nosave memory: 00000000e0000000 - 00000000f0000000
[    0.000000] PM: Registered nosave memory: 00000000f0000000 - 00000000fee00000
[    0.000000] PM: Registered nosave memory: 00000000fee00000 - 00000000fee01000
[    0.000000] PM: Registered nosave memory: 00000000fee01000 - 00000000ffc00000
[    0.000000] PM: Registered nosave memory: 00000000ffc00000 - 0000000100000000
[    0.000000] e820: [mem 0xc0000000-0xdfffffff] available for PCI devices
[    0.000000] setup_percpu: NR_CPUS:512 nr_cpumask_bits:512 nr_cpu_ids:16 nr_node_ids:1
[    0.000000] PERCPU: Embedded 27 pages/cpu @ffff88033fc00000 s79872 r8192 d22528 u131072
[    0.000000] pcpu-alloc: s79872 r8192 d22528 u131072 alloc=1*2097152
[    0.000000] pcpu-alloc: [0] 00 01 02 03 04 05 06 07 08 09 10 11 12 13 14 15 
[    0.000000] Built 1 zonelists in Zone order, mobility grouping on.  Total pages: 3094328
[    0.000000] Policy zone: Normal
[    0.000000] Kernel command line: BOOT_IMAGE=/vmlinuz-3.10.19 root=/dev/mapper/pve-root ro
[    0.000000] PID hash table entries: 4096 (order: 3, 32768 bytes)
[    0.000000] Checking aperture...
[    0.000000] No AGP bridge found
[    0.000000] Calgary: detecting Calgary via BIOS EBDA area
[    0.000000] Calgary: Unable to locate Rio Grande table in EBDA - bailing!
[    0.000000] Memory: 12173060k/13631488k available (3366k kernel code, 1057616k absent, 400812k reserved, 3294k data, 832k init)
[    0.000000] SLUB: HWalign=64, Order=0-3, MinObjects=0, CPUs=16, Nodes=1
[    0.000000] Hierarchical RCU implementation.
[    0.000000] 	RCU restricting CPUs from NR_CPUS=512 to nr_cpu_ids=16.
[    0.000000] NR_IRQS:33024 nr_irqs:808 16
[    0.000000] Console: colour VGA+ 80x25
[    0.000000] console [tty0] enabled
[    0.000000] hpet clockevent registered
[    0.000000] tsc: Fast TSC calibration using PIT
[    0.004000] tsc: Detected 2792.969 MHz processor
[    0.000003] Calibrating delay loop (skipped), value calculated using timer frequency.. 5585.93 BogoMIPS (lpj=11171876)
[    0.000124] pid_max: default: 32768 minimum: 301
[    0.000211] Security Framework initialized
[    0.000271] SELinux:  Disabled at boot.
[    0.001351] Dentry cache hash table entries: 2097152 (order: 12, 16777216 bytes)
[    0.004550] Inode-cache hash table entries: 1048576 (order: 11, 8388608 bytes)
[    0.005958] Mount-cache hash table entries: 256
[    0.006223] Initializing cgroup subsys devices
[    0.006284] Initializing cgroup subsys freezer
[    0.006343] Initializing cgroup subsys net_cls
[    0.006422] CPU: Physical Processor ID: 0
[    0.006479] CPU: Processor Core ID: 0
[    0.006539] mce: CPU supports 9 MCE banks
[    0.006609] CPU0: Thermal monitoring enabled (TM1)
[    0.006678] Last level iTLB entries: 4KB 512, 2MB 7, 4MB 7
[    0.006678] Last level dTLB entries: 4KB 512, 2MB 32, 4MB 32
[    0.006678] tlb_flushall_shift: 6
[    0.006851] Freeing SMP alternatives: 8k freed
[    0.006913] ACPI: Core revision 20130328
[    0.009354] ACPI: All ACPI Tables successfully acquired
[    0.009714] Switched APIC routing to physical flat.
[    0.010166] ..TIMER: vector=0x30 apic1=0 pin1=2 apic2=-1 pin2=-1
[    0.049949] smpboot: CPU0: Intel(R) Xeon(R) CPU           W3530  @ 2.80GHz (fam: 06, model: 1a, stepping: 05)
[    0.156847] Performance Events: PEBS fmt1+, 16-deep LBR, Nehalem events, Intel PMU driver.
[    0.157072] perf_event_intel: CPU erratum AAJ80 worked around
[    0.157133] perf_event_intel: CPUID marked event: 'bus cycles' unavailable
[    0.157197] ... version:                3
[    0.157254] ... bit width:              48
[    0.157312] ... generic registers:      4
[    0.157369] ... value mask:             0000ffffffffffff
[    0.157429] ... max period:             000000007fffffff
[    0.157489] ... fixed-purpose events:   3
[    0.157546] ... event mask:             000000070000000f
[    0.157879] smpboot: Booting Node   0, Processors  #1 #2 #3 #4 #5 #6 #7
[    0.250737] Brought up 8 CPUs
[    0.250846] smpboot: Total of 8 processors activated (44687.50 BogoMIPS)
[    0.256276] devtmpfs: initialized
[    0.259279] PM: Registering ACPI NVS region [mem 0xbf79e000-0xbf7cffff] (204800 bytes)
[    0.259497] regulator-dummy: no parameters
[    0.259606] NET: Registered protocol family 16
[    0.259743] ACPI: bus type PCI registered
[    0.259852] PCI: MMCONFIG for domain 0000 [bus 00-ff] at [mem 0xe0000000-0xefffffff] (base 0xe0000000)
[    0.259935] PCI: MMCONFIG at [mem 0xe0000000-0xefffffff] reserved in E820
[    0.267463] PCI: Using configuration type 1 for base access
[    0.268124] bio: create slab <bio-0> at 0
[    0.268286] ACPI: Added _OSI(Module Device)
[    0.268344] ACPI: Added _OSI(Processor Device)
[    0.268403] ACPI: Added _OSI(3.0 _SCP Extensions)
[    0.268461] ACPI: Added _OSI(Processor Aggregator Device)
[    0.269121] ACPI: EC: Look up EC in DSDT
[    0.269860] ACPI: Executed 1 blocks of module-level executable AML code
[    0.272633] ACPI: SSDT 00000000bf79e0c0 01E1C (v01 DpgPmm  P001Ist 00000011 INTL 20051117)
[    0.273025] ACPI: Dynamic OEM Table Load:
[    0.273153] ACPI: SSDT           (null) 01E1C (v01 DpgPmm  P001Ist 00000011 INTL 20051117)
[    0.273381] ACPI: SSDT 00000000bf79fee0 00659 (v01  PmRef  P001Cst 00003001 INTL 20051117)
[    0.273686] ACPI: Dynamic OEM Table Load:
[    0.273813] ACPI: SSDT           (null) 00659 (v01  PmRef  P001Cst 00003001 INTL 20051117)
[    0.285241] ACPI: Interpreter enabled
[    0.285305] ACPI Exception: AE_NOT_FOUND, While evaluating Sleep State [\_S2_] (20130328/hwxface-568)
[    0.289408] ACPI Exception: AE_NOT_FOUND, While evaluating Sleep State [\_S3_] (20130328/hwxface-568)
[    0.289566] ACPI: (supports S0 S1 S4 S5)
[    0.289623] ACPI: Using IOAPIC for interrupt routing
[    0.289705] PCI: Using host bridge windows from ACPI; if necessary, use "pci=nocrs" and report a bug
[    0.289845] ACPI: No dock devices found.
[    0.295955] ACPI: PCI Root Bridge [PCI0] (domain 0000 [bus 00-ff])
[    0.296151] PCI host bridge to bus 0000:00
[    0.296211] pci_bus 0000:00: root bus resource [bus 00-ff]
[    0.296272] pci_bus 0000:00: root bus resource [io  0x0000-0x0cf7]
[    0.296334] pci_bus 0000:00: root bus resource [io  0x0d00-0xffff]
[    0.296396] pci_bus 0000:00: root bus resource [mem 0x000a0000-0x000bffff]
[    0.296459] pci_bus 0000:00: root bus resource [mem 0x000d0000-0x000dffff]
[    0.296522] pci_bus 0000:00: root bus resource [mem 0xc0000000-0xdfffffff]
[    0.296585] pci_bus 0000:00: root bus resource [mem 0xf0000000-0xfed8ffff]
[    0.296659] pci 0000:00:00.0: [8086:3405] type 00 class 0x060000
[    0.296712] pci 0000:00:00.0: PME# supported from D0 D3hot D3cold
[    0.296790] pci 0000:00:01.0: [8086:3408] type 01 class 0x060400
[    0.296847] pci 0000:00:01.0: PME# supported from D0 D3hot D3cold
[    0.296898] pci 0000:00:01.0: System wakeup disabled by ACPI
[    0.296994] pci 0000:00:03.0: [8086:340a] type 01 class 0x060400
[    0.297050] pci 0000:00:03.0: PME# supported from D0 D3hot D3cold
[    0.297100] pci 0000:00:03.0: System wakeup disabled by ACPI
[    0.297193] pci 0000:00:07.0: [8086:340e] type 01 class 0x060400
[    0.297250] pci 0000:00:07.0: PME# supported from D0 D3hot D3cold
[    0.297299] pci 0000:00:07.0: System wakeup disabled by ACPI
[    0.297394] pci 0000:00:14.0: [8086:342e] type 00 class 0x080000
[    0.297510] pci 0000:00:14.1: [8086:3422] type 00 class 0x080000
[    0.297626] pci 0000:00:14.2: [8086:3423] type 00 class 0x080000
[    0.297739] pci 0000:00:14.3: [8086:3438] type 00 class 0x080000
[    0.297847] pci 0000:00:16.0: [8086:3430] type 00 class 0x088000
[    0.297860] pci 0000:00:16.0: reg 10: [mem 0xfbbfc000-0xfbbfffff 64bit]
[    0.297980] pci 0000:00:16.1: [8086:3431] type 00 class 0x088000
[    0.297993] pci 0000:00:16.1: reg 10: [mem 0xfbbf8000-0xfbbfbfff 64bit]
[    0.298112] pci 0000:00:16.2: [8086:3432] type 00 class 0x088000
[    0.298125] pci 0000:00:16.2: reg 10: [mem 0xfbbf4000-0xfbbf7fff 64bit]
[    0.298245] pci 0000:00:16.3: [8086:3433] type 00 class 0x088000
[    0.298257] pci 0000:00:16.3: reg 10: [mem 0xfbbf0000-0xfbbf3fff 64bit]
[    0.298375] pci 0000:00:16.4: [8086:3429] type 00 class 0x088000
[    0.298387] pci 0000:00:16.4: reg 10: [mem 0xfbbec000-0xfbbeffff 64bit]
[    0.298509] pci 0000:00:16.5: [8086:342a] type 00 class 0x088000
[    0.298521] pci 0000:00:16.5: reg 10: [mem 0xfbbe8000-0xfbbebfff 64bit]
[    0.298640] pci 0000:00:16.6: [8086:342b] type 00 class 0x088000
[    0.298653] pci 0000:00:16.6: reg 10: [mem 0xfbbe4000-0xfbbe7fff 64bit]
[    0.298773] pci 0000:00:16.7: [8086:342c] type 00 class 0x088000
[    0.298785] pci 0000:00:16.7: reg 10: [mem 0xfbbe0000-0xfbbe3fff 64bit]
[    0.298907] pci 0000:00:1a.0: [8086:3a37] type 00 class 0x0c0300
[    0.298949] pci 0000:00:1a.0: reg 20: [io  0xbc00-0xbc1f]
[    0.299042] pci 0000:00:1a.0: System wakeup disabled by ACPI
[    0.299133] pci 0000:00:1a.1: [8086:3a38] type 00 class 0x0c0300
[    0.299175] pci 0000:00:1a.1: reg 20: [io  0xb880-0xb89f]
[    0.299266] pci 0000:00:1a.1: System wakeup disabled by ACPI
[    0.299356] pci 0000:00:1a.2: [8086:3a39] type 00 class 0x0c0300
[    0.299398] pci 0000:00:1a.2: reg 20: [io  0xb800-0xb81f]
[    0.299488] pci 0000:00:1a.2: System wakeup disabled by ACPI
[    0.299587] pci 0000:00:1a.7: [8086:3a3c] type 00 class 0x0c0320
[    0.299608] pci 0000:00:1a.7: reg 10: [mem 0xfbbde000-0xfbbde3ff]
[    0.299697] pci 0000:00:1a.7: PME# supported from D0 D3hot D3cold
[    0.299748] pci 0000:00:1a.7: System wakeup disabled by ACPI
[    0.299841] pci 0000:00:1b.0: [8086:3a3e] type 00 class 0x040300
[    0.299856] pci 0000:00:1b.0: reg 10: [mem 0xfbbd8000-0xfbbdbfff 64bit]
[    0.299923] pci 0000:00:1b.0: PME# supported from D0 D3hot D3cold
[    0.299999] pci 0000:00:1c.0: [8086:3a40] type 01 class 0x060400
[    0.300067] pci 0000:00:1c.0: PME# supported from D0 D3hot D3cold
[    0.300119] pci 0000:00:1c.0: System wakeup disabled by ACPI
[    0.300210] pci 0000:00:1c.4: [8086:3a48] type 01 class 0x060400
[    0.300279] pci 0000:00:1c.4: PME# supported from D0 D3hot D3cold
[    0.300330] pci 0000:00:1c.4: System wakeup disabled by ACPI
[    0.300420] pci 0000:00:1c.5: [8086:3a4a] type 01 class 0x060400
[    0.300489] pci 0000:00:1c.5: PME# supported from D0 D3hot D3cold
[    0.300541] pci 0000:00:1c.5: System wakeup disabled by ACPI
[    0.300632] pci 0000:00:1d.0: [8086:3a34] type 00 class 0x0c0300
[    0.300673] pci 0000:00:1d.0: reg 20: [io  0xb480-0xb49f]
[    0.300766] pci 0000:00:1d.0: System wakeup disabled by ACPI
[    0.300856] pci 0000:00:1d.1: [8086:3a35] type 00 class 0x0c0300
[    0.300898] pci 0000:00:1d.1: reg 20: [io  0xb400-0xb41f]
[    0.300992] pci 0000:00:1d.1: System wakeup disabled by ACPI
[    0.301083] pci 0000:00:1d.2: [8086:3a36] type 00 class 0x0c0300
[    0.301125] pci 0000:00:1d.2: reg 20: [io  0xb080-0xb09f]
[    0.301216] pci 0000:00:1d.2: System wakeup disabled by ACPI
[    0.301314] pci 0000:00:1d.7: [8086:3a3a] type 00 class 0x0c0320
[    0.301335] pci 0000:00:1d.7: reg 10: [mem 0xfbbdc000-0xfbbdc3ff]
[    0.301425] pci 0000:00:1d.7: PME# supported from D0 D3hot D3cold
[    0.301476] pci 0000:00:1d.7: System wakeup disabled by ACPI
[    0.301564] pci 0000:00:1e.0: [8086:244e] type 01 class 0x060401
[    0.301653] pci 0000:00:1e.0: System wakeup disabled by ACPI
[    0.301745] pci 0000:00:1f.0: [8086:3a16] type 00 class 0x060100
[    0.301822] pci 0000:00:1f.0: quirk: [io  0x0800-0x087f] claimed by ICH6 ACPI/GPIO/TCO
[    0.301904] pci 0000:00:1f.0: quirk: [io  0x0500-0x053f] claimed by ICH6 GPIO
[    0.301970] pci 0000:00:1f.0: ICH7 LPC Generic IO decode 1 PIO at 0a00 (mask 00ff)
[    0.302052] pci 0000:00:1f.0: ICH7 LPC Generic IO decode 4 PIO at 0290 (mask 000f)
[    0.302226] pci 0000:00:1f.2: [8086:3a22] type 00 class 0x010601
[    0.302245] pci 0000:00:1f.2: reg 10: [io  0xa480-0xa487]
[    0.302253] pci 0000:00:1f.2: reg 14: [io  0xb000-0xb003]
[    0.302260] pci 0000:00:1f.2: reg 18: [io  0xac00-0xac07]
[    0.302268] pci 0000:00:1f.2: reg 1c: [io  0xa880-0xa883]
[    0.302276] pci 0000:00:1f.2: reg 20: [io  0xa800-0xa81f]
[    0.302284] pci 0000:00:1f.2: reg 24: [mem 0xfbbd6000-0xfbbd67ff]
[    0.302329] pci 0000:00:1f.2: PME# supported from D3hot
[    0.302402] pci 0000:00:1f.3: [8086:3a30] type 00 class 0x0c0500
[    0.302417] pci 0000:00:1f.3: reg 10: [mem 0xfbbd4000-0xfbbd40ff 64bit]
[    0.302437] pci 0000:00:1f.3: reg 20: [io  0x0400-0x041f]
[    0.302562] pci 0000:01:00.0: [8086:032c] type 01 class 0x060400
[    0.302579] pci 0000:01:00.0: PXH quirk detected; SHPC device MSI disabled
[    0.302699] pci 0000:01:00.0: PME# supported from D0 D3hot D3cold
[    0.302746] pci 0000:01:00.0: disabling ASPM on pre-1.1 PCIe device.  You can enable it with 'pcie_aspm=force'
[    0.302832] pci 0000:00:01.0: PCI bridge to [bus 01-02]
[    0.302966] pci 0000:01:00.0: PCI bridge to [bus 02]
[    0.303088] pci 0000:03:00.0: [10de:06e4] type 00 class 0x030000
[    0.303098] pci 0000:03:00.0: reg 10: [mem 0xf7000000-0xf7ffffff]
[    0.303107] pci 0000:03:00.0: reg 14: [mem 0xd0000000-0xdfffffff 64bit pref]
[    0.303117] pci 0000:03:00.0: reg 1c: [mem 0xf8000000-0xf9ffffff 64bit]
[    0.303124] pci 0000:03:00.0: reg 24: [io  0xcc00-0xcc7f]
[    0.303131] pci 0000:03:00.0: reg 30: [mem 0xf6fe0000-0xf6ffffff pref]
[    0.309004] pci 0000:00:03.0: PCI bridge to [bus 03]
[    0.309071] pci 0000:00:03.0:   bridge window [io  0xc000-0xcfff]
[    0.309077] pci 0000:00:03.0:   bridge window [mem 0xf6f00000-0xf9ffffff]
[    0.309085] pci 0000:00:03.0:   bridge window [mem 0xd0000000-0xdfffffff 64bit pref]
[    0.309130] pci 0000:00:07.0: PCI bridge to [bus 04]
[    0.309242] pci 0000:00:1c.0: PCI bridge to [bus 05]
[    0.309381] pci 0000:06:00.0: [8086:10d3] type 00 class 0x020000
[    0.309405] pci 0000:06:00.0: reg 10: [mem 0xfbce0000-0xfbcfffff]
[    0.309437] pci 0000:06:00.0: reg 18: [io  0xdc00-0xdc1f]
[    0.309454] pci 0000:06:00.0: reg 1c: [mem 0xfbcdc000-0xfbcdffff]
[    0.309593] pci 0000:06:00.0: PME# supported from D0 D3hot D3cold
[    0.317021] pci 0000:00:1c.4: PCI bridge to [bus 06]
[    0.317089] pci 0000:00:1c.4:   bridge window [io  0xd000-0xdfff]
[    0.317095] pci 0000:00:1c.4:   bridge window [mem 0xfbc00000-0xfbcfffff]
[    0.317176] pci 0000:07:00.0: [8086:10d3] type 00 class 0x020000
[    0.317200] pci 0000:07:00.0: reg 10: [mem 0xfbde0000-0xfbdfffff]
[    0.317232] pci 0000:07:00.0: reg 18: [io  0xec00-0xec1f]
[    0.317250] pci 0000:07:00.0: reg 1c: [mem 0xfbddc000-0xfbddffff]
[    0.317388] pci 0000:07:00.0: PME# supported from D0 D3hot D3cold
[    0.325033] pci 0000:00:1c.5: PCI bridge to [bus 07]
[    0.325100] pci 0000:00:1c.5:   bridge window [io  0xe000-0xefff]
[    0.325107] pci 0000:00:1c.5:   bridge window [mem 0xfbd00000-0xfbdfffff]
[    0.325160] pci 0000:08:08.0: [104c:8023] type 00 class 0x0c0010
[    0.325178] pci 0000:08:08.0: reg 10: [mem 0xfbefb800-0xfbefbfff]
[    0.325188] pci 0000:08:08.0: reg 14: [mem 0xfbefc000-0xfbefffff]
[    0.325257] pci 0000:08:08.0: supports D1 D2
[    0.325259] pci 0000:08:08.0: PME# supported from D0 D1 D2 D3hot
[    0.325315] pci 0000:00:1e.0: PCI bridge to [bus 08] (subtractive decode)
[    0.325382] pci 0000:00:1e.0:   bridge window [mem 0xfbe00000-0xfbefffff]
[    0.325388] pci 0000:00:1e.0:   bridge window [io  0x0000-0x0cf7] (subtractive decode)
[    0.325389] pci 0000:00:1e.0:   bridge window [io  0x0d00-0xffff] (subtractive decode)
[    0.325392] pci 0000:00:1e.0:   bridge window [mem 0x000a0000-0x000bffff] (subtractive decode)
[    0.325393] pci 0000:00:1e.0:   bridge window [mem 0x000d0000-0x000dffff] (subtractive decode)
[    0.325395] pci 0000:00:1e.0:   bridge window [mem 0xc0000000-0xdfffffff] (subtractive decode)
[    0.325397] pci 0000:00:1e.0:   bridge window [mem 0xf0000000-0xfed8ffff] (subtractive decode)
[    0.325425] acpi PNP0A08:00: ACPI _OSC support notification failed, disabling PCIe ASPM
[    0.325505] acpi PNP0A08:00: Unable to request _OSC control (_OSC support mask: 0x08)
[    0.326090] ACPI: PCI Interrupt Link [LNKA] (IRQs 3 4 6 7 10 *11 12 14 15)
[    0.326585] ACPI: PCI Interrupt Link [LNKB] (IRQs 3 4 6 7 *10 11 12 14 15)
[    0.327080] ACPI: PCI Interrupt Link [LNKC] (IRQs 3 4 6 7 10 11 12 *14 15)
[    0.327573] ACPI: PCI Interrupt Link [LNKD] (IRQs 3 4 6 7 10 11 12 14 *15)
[    0.328065] ACPI: PCI Interrupt Link [LNKE] (IRQs 3 4 6 7 10 11 12 14 15) *0, disabled.
[    0.328644] ACPI: PCI Interrupt Link [LNKF] (IRQs 3 4 6 *7 10 11 12 14 15)
[    0.329141] ACPI: PCI Interrupt Link [LNKG] (IRQs 3 4 6 7 *10 11 12 14 15)
[    0.329633] ACPI: PCI Interrupt Link [LNKH] (IRQs 3 4 6 7 10 *11 12 14 15)
[    0.330149] ACPI: Enabled 1 GPEs in block 00 to 3F
[    0.330283] acpi root: \_SB_.PCI0 notify handler is installed
[    0.330309] Found 1 acpi root devices
[    0.330361] vgaarb: device added: PCI:0000:03:00.0,decodes=io+mem,owns=io+mem,locks=none
[    0.330440] vgaarb: loaded
[    0.330495] vgaarb: bridge control possible 0000:03:00.0
[    0.330586] PCI: Using ACPI for IRQ routing
[    0.336779] PCI: Discovered peer bus ff
[    0.336836] PCI: root bus ff: using default resources
[    0.336838] PCI: Probing PCI hardware (bus ff)
[    0.336853] PCI host bridge to bus 0000:ff
[    0.336912] pci_bus 0000:ff: root bus resource [io  0x0000-0xffff]
[    0.336974] pci_bus 0000:ff: root bus resource [mem 0x00000000-0xfffffffff]
[    0.337039] pci_bus 0000:ff: No busn resource found for root bus, will use [bus ff-ff]
[    0.337122] pci 0000:ff:00.0: [8086:2c41] type 00 class 0x060000
[    0.337155] pci 0000:ff:00.1: [8086:2c01] type 00 class 0x060000
[    0.337188] pci 0000:ff:02.0: [8086:2c10] type 00 class 0x060000
[    0.337219] pci 0000:ff:02.1: [8086:2c11] type 00 class 0x060000
[    0.337250] pci 0000:ff:03.0: [8086:2c18] type 00 class 0x060000
[    0.337279] pci 0000:ff:03.1: [8086:2c19] type 00 class 0x060000
[    0.337309] pci 0000:ff:03.4: [8086:2c1c] type 00 class 0x060000
[    0.337340] pci 0000:ff:04.0: [8086:2c20] type 00 class 0x060000
[    0.337372] pci 0000:ff:04.1: [8086:2c21] type 00 class 0x060000
[    0.337404] pci 0000:ff:04.2: [8086:2c22] type 00 class 0x060000
[    0.337435] pci 0000:ff:04.3: [8086:2c23] type 00 class 0x060000
[    0.337465] pci 0000:ff:05.0: [8086:2c28] type 00 class 0x060000
[    0.337495] pci 0000:ff:05.1: [8086:2c29] type 00 class 0x060000
[    0.337525] pci 0000:ff:05.2: [8086:2c2a] type 00 class 0x060000
[    0.337554] pci 0000:ff:05.3: [8086:2c2b] type 00 class 0x060000
[    0.337585] pci 0000:ff:06.0: [8086:2c30] type 00 class 0x060000
[    0.337614] pci 0000:ff:06.1: [8086:2c31] type 00 class 0x060000
[    0.337644] pci 0000:ff:06.2: [8086:2c32] type 00 class 0x060000
[    0.337676] pci 0000:ff:06.3: [8086:2c33] type 00 class 0x060000
[    0.337716] pci_bus 0000:ff: busn_res: [bus ff] end is updated to ff
[    0.337720] PCI: pci_cache_line_size set to 64 bytes
[    0.337811] e820: reserve RAM buffer [mem 0x0009d800-0x0009ffff]
[    0.337812] e820: reserve RAM buffer [mem 0xbf790000-0xbfffffff]
[    0.337896] HPET: 4 timers in total, 0 timers will be used for per-cpu timer
[    0.337962] hpet0: at MMIO 0xfed00000, IRQs 2, 8, 0, 0
[    0.338198] hpet0: 4 comparators, 64-bit 14.318180 MHz counter
[    0.340467] Switching to clocksource hpet
[    0.341599] pnp: PnP ACPI init
[    0.341661] ACPI: bus type PNP registered
[    0.341767] system 00:00: [mem 0xfbf00000-0xfbffffff] has been reserved
[    0.341831] system 00:00: [mem 0xfc000000-0xfcffffff] has been reserved
[    0.341894] system 00:00: [mem 0xfd000000-0xfdffffff] has been reserved
[    0.341958] system 00:00: [mem 0xfe000000-0xfebfffff] has been reserved
[    0.342023] system 00:00: [mem 0xfec8a000-0xfec8afff] has been reserved
[    0.342086] system 00:00: [mem 0xfed10000-0xfed10fff] has been reserved
[    0.342150] system 00:00: Plug and Play ACPI device, IDs PNP0c01 (active)
[    0.342175] pnp 00:01: [dma 4]
[    0.342190] pnp 00:01: Plug and Play ACPI device, IDs PNP0200 (active)
[    0.342216] pnp 00:02: Plug and Play ACPI device, IDs PNP0b00 (active)
[    0.342236] pnp 00:03: Plug and Play ACPI device, IDs PNP0800 (active)
[    0.342258] pnp 00:04: Plug and Play ACPI device, IDs PNP0c04 (active)
[    0.342428] pnp 00:05: [dma 0 disabled]
[    0.342477] pnp 00:05: Plug and Play ACPI device, IDs PNP0501 (active)
[    0.342641] pnp 00:06: [dma 0 disabled]
[    0.342708] pnp 00:06: Plug and Play ACPI device, IDs PNP0501 (active)
[    0.342889] pnp 00:07: Plug and Play ACPI device, IDs PNP0303 PNP030b (active)
[    0.342942] pnp 00:08: Plug and Play ACPI device, IDs PNP0f03 PNP0f13 (active)
[    0.343039] system 00:09: [io  0x0a00-0x0a0f] has been reserved
[    0.343104] system 00:09: [io  0x0290-0x029f] has been reserved
[    0.343166] system 00:09: Plug and Play ACPI device, IDs PNP0c02 (active)
[    0.343306] system 00:0a: [io  0x04d0-0x04d1] has been reserved
[    0.343369] system 00:0a: [io  0x0800-0x087f] has been reserved
[    0.343431] system 00:0a: [io  0x0500-0x057f] could not be reserved
[    0.343494] system 00:0a: [mem 0xfed1c000-0xfed1ffff] has been reserved
[    0.343557] system 00:0a: [mem 0xfed20000-0xfed3ffff] has been reserved
[    0.343620] system 00:0a: [mem 0xfed40000-0xfed8ffff] has been reserved
[    0.343684] system 00:0a: Plug and Play ACPI device, IDs PNP0c02 (active)
[    0.343751] pnp 00:0b: Plug and Play ACPI device, IDs PNP0103 (active)
[    0.343839] system 00:0c: [mem 0xfec00000-0xfec00fff] could not be reserved
[    0.343904] system 00:0c: [mem 0xfee00000-0xfee00fff] has been reserved
[    0.343967] system 00:0c: Plug and Play ACPI device, IDs PNP0c02 (active)
[    0.344022] system 00:0d: [mem 0xe0000000-0xefffffff] has been reserved
[    0.344086] system 00:0d: Plug and Play ACPI device, IDs PNP0c02 (active)
[    0.344244] system 00:0e: [mem 0x00000000-0x0009ffff] could not be reserved
[    0.344309] system 00:0e: [mem 0x000c0000-0x000cffff] could not be reserved
[    0.344372] system 00:0e: [mem 0x000e0000-0x000fffff] could not be reserved
[    0.344436] system 00:0e: [mem 0x00100000-0xbfffffff] could not be reserved
[    0.344500] system 00:0e: [mem 0xfed90000-0xffffffff] could not be reserved
[    0.344571] system 00:0e: Plug and Play ACPI device, IDs PNP0c01 (active)
[    0.344676] pnp: PnP ACPI: found 15 devices
[    0.344734] ACPI: bus type PNP unregistered
[    0.350788] pci 0000:00:1c.0: bridge window [io  0x1000-0x0fff] to [bus 05] add_size 1000
[    0.350791] pci 0000:00:1c.0: bridge window [mem 0x00100000-0x000fffff 64bit pref] to [bus 05] add_size 200000
[    0.350794] pci 0000:00:1c.0: bridge window [mem 0x00100000-0x000fffff] to [bus 05] add_size 200000
[    0.350802] pci 0000:00:1c.4: bridge window [mem 0x00100000-0x000fffff 64bit pref] to [bus 06] add_size 200000
[    0.350810] pci 0000:00:1c.5: bridge window [mem 0x00100000-0x000fffff 64bit pref] to [bus 07] add_size 200000
[    0.350825] pci 0000:00:1c.0: res[14]=[mem 0x00100000-0x000fffff] get_res_add_size add_size 200000
[    0.350827] pci 0000:00:1c.0: res[15]=[mem 0x00100000-0x000fffff 64bit pref] get_res_add_size add_size 200000
[    0.350830] pci 0000:00:1c.4: res[15]=[mem 0x00100000-0x000fffff 64bit pref] get_res_add_size add_size 200000
[    0.350832] pci 0000:00:1c.5: res[15]=[mem 0x00100000-0x000fffff 64bit pref] get_res_add_size add_size 200000
[    0.350834] pci 0000:00:1c.0: res[13]=[io  0x1000-0x0fff] get_res_add_size add_size 1000
[    0.350837] pci 0000:00:1c.0: BAR 14: assigned [mem 0xc0000000-0xc01fffff]
[    0.350902] pci 0000:00:1c.0: BAR 15: assigned [mem 0xc0200000-0xc03fffff 64bit pref]
[    0.350982] pci 0000:00:1c.4: BAR 15: assigned [mem 0xc0400000-0xc05fffff 64bit pref]
[    0.351062] pci 0000:00:1c.5: BAR 15: assigned [mem 0xc0600000-0xc07fffff 64bit pref]
[    0.351142] pci 0000:00:1c.0: BAR 13: assigned [io  0x1000-0x1fff]
[    0.351204] pci 0000:01:00.0: PCI bridge to [bus 02]
[    0.351271] pci 0000:00:01.0: PCI bridge to [bus 01-02]
[    0.351338] pci 0000:00:03.0: PCI bridge to [bus 03]
[    0.351398] pci 0000:00:03.0:   bridge window [io  0xc000-0xcfff]
[    0.351462] pci 0000:00:03.0:   bridge window [mem 0xf6f00000-0xf9ffffff]
[    0.351526] pci 0000:00:03.0:   bridge window [mem 0xd0000000-0xdfffffff 64bit pref]
[    0.351608] pci 0000:00:07.0: PCI bridge to [bus 04]
[    0.351674] pci 0000:00:1c.0: PCI bridge to [bus 05]
[    0.351734] pci 0000:00:1c.0:   bridge window [io  0x1000-0x1fff]
[    0.351799] pci 0000:00:1c.0:   bridge window [mem 0xc0000000-0xc01fffff]
[    0.351864] pci 0000:00:1c.0:   bridge window [mem 0xc0200000-0xc03fffff 64bit pref]
[    0.351946] pci 0000:00:1c.4: PCI bridge to [bus 06]
[    0.352007] pci 0000:00:1c.4:   bridge window [io  0xd000-0xdfff]
[    0.352071] pci 0000:00:1c.4:   bridge window [mem 0xfbc00000-0xfbcfffff]
[    0.352136] pci 0000:00:1c.4:   bridge window [mem 0xc0400000-0xc05fffff 64bit pref]
[    0.352218] pci 0000:00:1c.5: PCI bridge to [bus 07]
[    0.352278] pci 0000:00:1c.5:   bridge window [io  0xe000-0xefff]
[    0.352342] pci 0000:00:1c.5:   bridge window [mem 0xfbd00000-0xfbdfffff]
[    0.352407] pci 0000:00:1c.5:   bridge window [mem 0xc0600000-0xc07fffff 64bit pref]
[    0.352489] pci 0000:00:1e.0: PCI bridge to [bus 08]
[    0.352556] pci 0000:00:1e.0:   bridge window [mem 0xfbe00000-0xfbefffff]
[    0.352638] pci 0000:00:1c.0: enabling device (0104 -> 0107)
[    0.352991] pci 0000:00:1e.0: setting latency timer to 64
[    0.352995] pci_bus 0000:00: resource 4 [io  0x0000-0x0cf7]
[    0.352997] pci_bus 0000:00: resource 5 [io  0x0d00-0xffff]
[    0.352999] pci_bus 0000:00: resource 6 [mem 0x000a0000-0x000bffff]
[    0.353001] pci_bus 0000:00: resource 7 [mem 0x000d0000-0x000dffff]
[    0.353003] pci_bus 0000:00: resource 8 [mem 0xc0000000-0xdfffffff]
[    0.353004] pci_bus 0000:00: resource 9 [mem 0xf0000000-0xfed8ffff]
[    0.353007] pci_bus 0000:03: resource 0 [io  0xc000-0xcfff]
[    0.353009] pci_bus 0000:03: resource 1 [mem 0xf6f00000-0xf9ffffff]
[    0.353011] pci_bus 0000:03: resource 2 [mem 0xd0000000-0xdfffffff 64bit pref]
[    0.353013] pci_bus 0000:05: resource 0 [io  0x1000-0x1fff]
[    0.353015] pci_bus 0000:05: resource 1 [mem 0xc0000000-0xc01fffff]
[    0.353017] pci_bus 0000:05: resource 2 [mem 0xc0200000-0xc03fffff 64bit pref]
[    0.353019] pci_bus 0000:06: resource 0 [io  0xd000-0xdfff]
[    0.353021] pci_bus 0000:06: resource 1 [mem 0xfbc00000-0xfbcfffff]
[    0.353023] pci_bus 0000:06: resource 2 [mem 0xc0400000-0xc05fffff 64bit pref]
[    0.353025] pci_bus 0000:07: resource 0 [io  0xe000-0xefff]
[    0.353026] pci_bus 0000:07: resource 1 [mem 0xfbd00000-0xfbdfffff]
[    0.353028] pci_bus 0000:07: resource 2 [mem 0xc0600000-0xc07fffff 64bit pref]
[    0.353030] pci_bus 0000:08: resource 1 [mem 0xfbe00000-0xfbefffff]
[    0.353032] pci_bus 0000:08: resource 4 [io  0x0000-0x0cf7]
[    0.353034] pci_bus 0000:08: resource 5 [io  0x0d00-0xffff]
[    0.353036] pci_bus 0000:08: resource 6 [mem 0x000a0000-0x000bffff]
[    0.353038] pci_bus 0000:08: resource 7 [mem 0x000d0000-0x000dffff]
[    0.353040] pci_bus 0000:08: resource 8 [mem 0xc0000000-0xdfffffff]
[    0.353042] pci_bus 0000:08: resource 9 [mem 0xf0000000-0xfed8ffff]
[    0.353044] pci_bus 0000:ff: resource 4 [io  0x0000-0xffff]
[    0.353046] pci_bus 0000:ff: resource 5 [mem 0x00000000-0xfffffffff]
[    0.353071] NET: Registered protocol family 2
[    0.353334] TCP established hash table entries: 131072 (order: 9, 2097152 bytes)
[    0.353726] TCP bind hash table entries: 65536 (order: 8, 1048576 bytes)
[    0.353920] TCP: Hash tables configured (established 131072 bind 65536)
[    0.354005] TCP: reno registered
[    0.354076] UDP hash table entries: 8192 (order: 6, 262144 bytes)
[    0.354187] UDP-Lite hash table entries: 8192 (order: 6, 262144 bytes)
[    0.354354] NET: Registered protocol family 1
[    0.356005] pci 0000:01:00.0: rerouting interrupts for [8086:032c]
[    0.356077] pci 0000:03:00.0: Boot video device
[    0.356104] PCI: CLS 256 bytes, default 64
[    0.356136] Unpacking initramfs...
[    2.489508] Freeing initrd memory: 127640k freed
[    2.507872] PCI-DMA: Using software bounce buffering for IO (SWIOTLB)
[    2.507939] software IO TLB [mem 0xbb790000-0xbf790000] (64MB) mapped at [ffff8800bb790000-ffff8800bf78ffff]
[    2.508421] audit: initializing netlink socket (disabled)
[    2.508495] type=2000 audit(1384814917.396:1): initialized
[    2.522021] bounce pool size: 64 pages
[    2.522081] HugeTLB registered 2 MB page size, pre-allocated 0 pages
[    2.523764] VFS: Disk quotas dquot_6.5.2
[    2.523857] Dquot-cache hash table entries: 512 (order 0, 4096 bytes)
[    2.524006] msgmni has been set to 24024
[    2.524256] Block layer SCSI generic (bsg) driver version 0.4 loaded (major 252)
[    2.524335] io scheduler noop registered
[    2.524392] io scheduler deadline registered
[    2.524469] io scheduler cfq registered (default)
[    2.524719] pcieport 0000:00:1c.0: irq 40 for MSI/MSI-X
[    2.524782] pcieport 0000:00:1c.4: irq 41 for MSI/MSI-X
[    2.524839] pcieport 0000:00:1c.5: irq 42 for MSI/MSI-X
[    2.524951] intel_idle: MWAIT substates: 0x1120
[    2.524962] intel_idle: v0.4 model 0x1A
[    2.524963] intel_idle: lapic_timer_reliable_states 0x2
[    2.525040] Serial: 8250/16550 driver, 4 ports, IRQ sharing enabled
[    2.545539] 00:05: ttyS0 at I/O 0x3f8 (irq = 4) is a 16550A
[    2.566026] 00:06: ttyS1 at I/O 0x2f8 (irq = 3) is a 16550A
[    2.566431] Linux agpgart interface v0.103
[    2.566617] i8042: PNP: PS/2 Controller [PNP0303:PS2K,PNP0f03:PS2M] at 0x60,0x64 irq 1,12
[    2.569142] serio: i8042 KBD port at 0x60,0x64 irq 1
[    2.569206] serio: i8042 AUX port at 0x60,0x64 irq 12
[    2.569324] mousedev: PS/2 mouse device common for all mice
[    2.569409] rtc_cmos 00:02: RTC can wake from S4
[    2.569586] rtc_cmos 00:02: rtc core: registered rtc_cmos as rtc0
[    2.569673] rtc_cmos 00:02: alarms up to one month, y3k, 114 bytes nvram, hpet irqs
[    2.569883] cpuidle: using governor ladder
[    2.574067] cpuidle: using governor menu
[    2.574148] drop_monitor: Initializing network drop monitor service
[    2.574274] TCP: cubic registered
[    2.574415] NET: Registered protocol family 10
[    2.574639] mip6: Mobile IPv6
[    2.574696] NET: Registered protocol family 17
[    2.574760] Key type dns_resolver registered
[    2.575040] PM: Hibernation image not present or could not be loaded.
[    2.575047] registered taskstats version 1
[    2.576181] rtc_cmos 00:02: setting system clock to 2013-11-18 22:48:38 UTC (1384814918)
[    2.577088] Freeing unused kernel memory: 832k freed
[    2.577259] Write protecting the kernel read-only data: 6144k
[    2.578808] Freeing unused kernel memory: 720k freed
[    2.582142] Freeing unused kernel memory: 728k freed
[    2.620318] input: AT Translated Set 2 keyboard as /devices/platform/i8042/serio0/input/input0
[    2.639284] udevd[85]: starting version 175
[    2.655245] pps_core: LinuxPPS API ver. 1 registered
[    2.655316] pps_core: Software ver. 5.3.6 - Copyright 2005-2007 Rodolfo Giometti <giometti@linux.it>
[    2.660425] ACPI: bus type USB registered
[    2.660550] usbcore: registered new interface driver usbfs
[    2.660656] usbcore: registered new interface driver hub
[    2.661359] PTP clock support registered
[    2.665374] e1000e: Intel(R) PRO/1000 Network Driver - 2.3.2-k
[    2.665442] e1000e: Copyright(c) 1999 - 2013 Intel Corporation.
[    2.665537] e1000e 0000:06:00.0: Disabling ASPM L0s L1
[    2.665766] e1000e 0000:06:00.0: Interrupt Throttling Rate (ints/sec) set to dynamic conservative mode
[    2.665884] e1000e 0000:06:00.0: irq 43 for MSI/MSI-X
[    2.665893] e1000e 0000:06:00.0: irq 44 for MSI/MSI-X
[    2.665901] e1000e 0000:06:00.0: irq 45 for MSI/MSI-X
[    2.668966] usbcore: registered new device driver usb
[    2.670169] ehci_hcd: USB 2.0 'Enhanced' Host Controller (EHCI) Driver
[    2.670997] uhci_hcd: USB Universal Host Controller Interface driver
[    2.671274] uhci_hcd 0000:00:1a.0: setting latency timer to 64
[    2.671279] uhci_hcd 0000:00:1a.0: UHCI Host Controller
[    2.671347] uhci_hcd 0000:00:1a.0: new USB bus registered, assigned bus number 1
[    2.671477] uhci_hcd 0000:00:1a.0: irq 16, io base 0x0000bc00
[    2.671584] usb usb1: New USB device found, idVendor=1d6b, idProduct=0001
[    2.671651] usb usb1: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[    2.671733] usb usb1: Product: UHCI Host Controller
[    2.671796] usb usb1: Manufacturer: Linux 3.10.19 uhci_hcd
[    2.671860] usb usb1: SerialNumber: 0000:00:1a.0
[    2.672062] hub 1-0:1.0: USB hub found
[    2.672077] SCSI subsystem initialized
[    2.672188] hub 1-0:1.0: 2 ports detected
[    2.672520] uhci_hcd 0000:00:1a.1: setting latency timer to 64
[    2.672524] uhci_hcd 0000:00:1a.1: UHCI Host Controller
[    2.672592] uhci_hcd 0000:00:1a.1: new USB bus registered, assigned bus number 2
[    2.672710] uhci_hcd 0000:00:1a.1: irq 21, io base 0x0000b880
[    2.672805] usb usb2: New USB device found, idVendor=1d6b, idProduct=0001
[    2.672873] usb usb2: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[    2.672955] usb usb2: Product: UHCI Host Controller
[    2.673019] usb usb2: Manufacturer: Linux 3.10.19 uhci_hcd
[    2.673081] usb usb2: SerialNumber: 0000:00:1a.1
[    2.673251] hub 2-0:1.0: USB hub found
[    2.673314] hub 2-0:1.0: 2 ports detected
[    2.673632] uhci_hcd 0000:00:1a.2: setting latency timer to 64
[    2.673637] uhci_hcd 0000:00:1a.2: UHCI Host Controller
[    2.673705] uhci_hcd 0000:00:1a.2: new USB bus registered, assigned bus number 3
[    2.673827] uhci_hcd 0000:00:1a.2: irq 19, io base 0x0000b800
[    2.673928] usb usb3: New USB device found, idVendor=1d6b, idProduct=0001
[    2.673995] usb usb3: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[    2.674077] usb usb3: Product: UHCI Host Controller
[    2.674141] usb usb3: Manufacturer: Linux 3.10.19 uhci_hcd
[    2.674205] usb usb3: SerialNumber: 0000:00:1a.2
[    2.674379] hub 3-0:1.0: USB hub found
[    2.674440] hub 3-0:1.0: 2 ports detected
[    2.674708] uhci_hcd 0000:00:1d.0: setting latency timer to 64
[    2.674712] uhci_hcd 0000:00:1d.0: UHCI Host Controller
[    2.674775] uhci_hcd 0000:00:1d.0: new USB bus registered, assigned bus number 4
[    2.674904] uhci_hcd 0000:00:1d.0: irq 23, io base 0x0000b480
[    2.674992] usb usb4: New USB device found, idVendor=1d6b, idProduct=0001
[    2.675056] usb usb4: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[    2.675135] usb usb4: Product: UHCI Host Controller
[    2.675194] usb usb4: Manufacturer: Linux 3.10.19 uhci_hcd
[    2.675257] usb usb4: SerialNumber: 0000:00:1d.0
[    2.675612] hub 4-0:1.0: USB hub found
[    2.675675] hub 4-0:1.0: 2 ports detected
[    2.675953] ACPI: bus type ATA registered
[    2.676028] uhci_hcd 0000:00:1d.1: setting latency timer to 64
[    2.676032] uhci_hcd 0000:00:1d.1: UHCI Host Controller
[    2.676100] uhci_hcd 0000:00:1d.1: new USB bus registered, assigned bus number 5
[    2.676208] uhci_hcd 0000:00:1d.1: irq 19, io base 0x0000b400
[    2.676309] usb usb5: New USB device found, idVendor=1d6b, idProduct=0001
[    2.676377] usb usb5: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[    2.676459] usb usb5: Product: UHCI Host Controller
[    2.676522] usb usb5: Manufacturer: Linux 3.10.19 uhci_hcd
[    2.676586] usb usb5: SerialNumber: 0000:00:1d.1
[    2.676704] libata version 3.00 loaded.
[    2.676764] hub 5-0:1.0: USB hub found
[    2.676831] hub 5-0:1.0: 2 ports detected
[    2.677117] uhci_hcd 0000:00:1d.2: setting latency timer to 64
[    2.677121] uhci_hcd 0000:00:1d.2: UHCI Host Controller
[    2.677260] uhci_hcd 0000:00:1d.2: new USB bus registered, assigned bus number 6
[    2.677381] uhci_hcd 0000:00:1d.2: irq 18, io base 0x0000b080
[    2.677480] usb usb6: New USB device found, idVendor=1d6b, idProduct=0001
[    2.677546] usb usb6: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[    2.677629] usb usb6: Product: UHCI Host Controller
[    2.677691] usb usb6: Manufacturer: Linux 3.10.19 uhci_hcd
[    2.677752] usb usb6: SerialNumber: 0000:00:1d.2
[    2.677951] hub 6-0:1.0: USB hub found
[    2.678015] hub 6-0:1.0: 2 ports detected
[    2.678153] ahci 0000:00:1f.2: version 3.0
[    2.678341] ahci 0000:00:1f.2: irq 46 for MSI/MSI-X
[    2.678388] ahci: SSS flag set, parallel bus scan disabled
[    2.678495] ahci 0000:00:1f.2: AHCI 0001.0200 32 slots 6 ports 3 Gbps 0x3f impl SATA mode
[    2.678578] ahci 0000:00:1f.2: flags: 64bit ncq sntf stag pm led clo pio slum part ccc ems sxs 
[    2.678664] ahci 0000:00:1f.2: setting latency timer to 64
[    2.715605] scsi0 : ahci
[    2.715897] scsi1 : ahci
[    2.716125] scsi2 : ahci
[    2.716385] scsi3 : ahci
[    2.716663] scsi4 : ahci
[    2.716860] scsi5 : ahci
[    2.717028] ata1: SATA max UDMA/133 abar m2048@0xfbbd6000 port 0xfbbd6100 irq 46
[    2.717107] ata2: SATA max UDMA/133 abar m2048@0xfbbd6000 port 0xfbbd6180 irq 46
[    2.717185] ata3: SATA max UDMA/133 abar m2048@0xfbbd6000 port 0xfbbd6200 irq 46
[    2.717264] ata4: SATA max UDMA/133 abar m2048@0xfbbd6000 port 0xfbbd6280 irq 46
[    2.717342] ata5: SATA max UDMA/133 abar m2048@0xfbbd6000 port 0xfbbd6300 irq 46
[    2.717420] ata6: SATA max UDMA/133 abar m2048@0xfbbd6000 port 0xfbbd6380 irq 46
[    2.739223] firewire_ohci 0000:08:08.0: added OHCI v1.10 device as card 0, 4 IR + 8 IT contexts, quirks 0x2
[    2.778658] e1000e 0000:06:00.0 eth0: registered PHC clock
[    2.778722] e1000e 0000:06:00.0 eth0: (PCI Express:2.5GT/s:Width x1) 00:30:48:fd:84:24
[    2.778802] e1000e 0000:06:00.0 eth0: Intel(R) PRO/1000 Network Connection
[    2.778950] e1000e 0000:06:00.0 eth0: MAC: 3, PHY: 8, PBA No: 0101FF-0FF
[    2.779086] e1000e 0000:07:00.0: Disabling ASPM L0s L1
[    2.779280] e1000e 0000:07:00.0: Interrupt Throttling Rate (ints/sec) set to dynamic conservative mode
[    2.779383] e1000e 0000:07:00.0: irq 47 for MSI/MSI-X
[    2.779389] e1000e 0000:07:00.0: irq 48 for MSI/MSI-X
[    2.779394] e1000e 0000:07:00.0: irq 49 for MSI/MSI-X
[    2.895913] e1000e 0000:07:00.0 eth1: registered PHC clock
[    2.895982] e1000e 0000:07:00.0 eth1: (PCI Express:2.5GT/s:Width x1) 00:30:48:fd:84:25
[    2.896068] e1000e 0000:07:00.0 eth1: Intel(R) PRO/1000 Network Connection
[    2.896215] e1000e 0000:07:00.0 eth1: MAC: 3, PHY: 8, PBA No: 0101FF-0FF
[    3.035347] ata1: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
[    3.036351] ata1.00: ATA-8: Hitachi HDS721010DLE630, MS2OA610, max UDMA/133
[    3.036422] ata1.00: 1953525168 sectors, multi 0: LBA48 NCQ (depth 31/32), AA
[    3.037533] ata1.00: configured for UDMA/133
[    3.037939] scsi 0:0:0:0: Direct-Access     ATA      Hitachi HDS72101 MS2O PQ: 0 ANSI: 5
[    3.239752] firewire_core 0000:08:08.0: created device fw0: GUID 0030480000018f74, S400
[    3.355668] ata2: SATA link down (SStatus 0 SControl 300)
[    3.507868] tsc: Refined TSC clocksource calibration: 2792.999 MHz
[    3.507939] Switching to clocksource tsc
[    3.675983] ata3: SATA link down (SStatus 0 SControl 300)
[    3.996362] ata4: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
[    3.997580] ata4.00: ATA-8: ST31000528AS, CC38, max UDMA/133
[    3.997648] ata4.00: 1953525168 sectors, multi 0: LBA48 NCQ (depth 31/32)
[    3.999067] ata4.00: configured for UDMA/133
[    3.999443] scsi 3:0:0:0: Direct-Access     ATA      ST31000528AS     CC38 PQ: 0 ANSI: 5
[    4.316629] ata5: SATA link up 1.5 Gbps (SStatus 113 SControl 300)
[    4.318355] ata5.00: ATAPI: ATAPI   iHAS124   Y, BL0V, max UDMA/100
[    4.320416] ata5.00: configured for UDMA/100
[    4.322434] scsi 4:0:0:0: CD-ROM            ATAPI    iHAS124   Y      BL0V PQ: 0 ANSI: 5
[    4.640955] ata6: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
[    4.641651] ata6.00: ATA-9: Samsung SSD 840 Series, DXT06B0Q, max UDMA/133
[    4.641721] ata6.00: 488397168 sectors, multi 16: LBA48 NCQ (depth 31/32), AA
[    4.642333] ata6.00: configured for UDMA/133
[    4.642687] scsi 5:0:0:0: Direct-Access     ATA      Samsung SSD 840  DXT0 PQ: 0 ANSI: 5
[    4.646688] sd 0:0:0:0: [sda] 1953525168 512-byte logical blocks: (1.00 TB/931 GiB)
[    4.646690] sd 3:0:0:0: [sdb] 1953525168 512-byte logical blocks: (1.00 TB/931 GiB)
[    4.646728] sd 5:0:0:0: [sdc] 488397168 512-byte logical blocks: (250 GB/232 GiB)
[    4.646820] sd 3:0:0:0: [sdb] Write Protect is off
[    4.646822] sd 3:0:0:0: [sdb] Mode Sense: 00 3a 00 00
[    4.646953] sd 3:0:0:0: [sdb] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
[    4.647020] sd 5:0:0:0: [sdc] Write Protect is off
[    4.647022] sd 5:0:0:0: [sdc] Mode Sense: 00 3a 00 00
[    4.647057] sd 5:0:0:0: [sdc] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
[    4.648697] sr0: scsi3-mmc drive: 48x/48x writer dvd-ram cd/rw xa/form2 cdda tray
[    4.648698] cdrom: Uniform CD-ROM driver Revision: 3.20
[    4.648800] sr 4:0:0:0: Attached scsi CD-ROM sr0
[    4.650313]  sdc: sdc1
[    4.650409] sd 0:0:0:0: Attached scsi generic sg0 type 0
[    4.650451] sd 3:0:0:0: Attached scsi generic sg1 type 0
[    4.650489] sr 4:0:0:0: Attached scsi generic sg2 type 5
[    4.650578] sd 5:0:0:0: Attached scsi generic sg3 type 0
[    4.651171] sd 5:0:0:0: [sdc] Attached SCSI disk
[    4.651711] sd 0:0:0:0: [sda] 4096-byte physical blocks
[    4.651941] sd 0:0:0:0: [sda] Write Protect is off
[    4.652003] sd 0:0:0:0: [sda] Mode Sense: 00 3a 00 00
[    4.652072] sd 0:0:0:0: [sda] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
[    4.681340]  sdb: sdb1 sdb2 sdb3
[    4.681807] sd 3:0:0:0: [sdb] Attached SCSI disk
[    4.693974]  sda: sda1 sda2 sda3
[    4.694705] sd 0:0:0:0: [sda] Attached SCSI disk
[    4.715083] bio: create slab <bio-1> at 1
[    5.948054] bcache: bch_journal_replay() journal replay done, 25 keys in 4 entries, seq 21363885
[    5.948198] bcache: register_cache() registered cache device sdc1
[    5.994007] md: md0 stopped.
[    5.994964] md: bind<sdb2>
[    5.995167] md: bind<sda2>
[    5.996451] md: raid1 personality registered for level 1
[    5.997258] md/raid1:md0: active with 2 out of 2 mirrors
[    5.997334] md0: detected capacity change from 0 to 509542400
[    5.997500] RAID1 conf printout:
[    5.997506]  --- wd:2 rd:2
[    5.997507]  disk 0, wo:0, o:1, dev:sda2
[    5.997508]  disk 1, wo:0, o:1, dev:sdb2
[    5.998176]  md0: unknown partition table
[    6.021119] md: md2 stopped.
[    6.046390] md: bind<sdb3>
[    6.046595] md: bind<sda3>
[    6.047631] md/raid1:md2: active with 2 out of 2 mirrors
[    6.047706] md2: detected capacity change from 0 to 999691247616
[    6.047777] RAID1 conf printout:
[    6.047780]  --- wd:2 rd:2
[    6.047781]  disk 0, wo:0, o:1, dev:sda3
[    6.047781]  disk 1, wo:0, o:1, dev:sdb3
[    6.056651]  md2: unknown partition table
[    6.253219] device-mapper: uevent: version 1.0.3
[    6.253350] device-mapper: ioctl: 4.24.0-ioctl (2013-01-15) initialised: dm-devel@redhat.com
[    6.434798] raid6: sse2x1    6972 MB/s
[    6.502860] raid6: sse2x2    8103 MB/s
[    6.570987] raid6: sse2x4    9130 MB/s
[    6.571045] raid6: using algorithm sse2x4 (9130 MB/s)
[    6.571104] raid6: using ssse3x2 recovery algorithm
[    6.571685] xor: measuring software checksum speed
[    6.610972]    prefetch64-sse: 11703.000 MB/sec
[    6.651009]    generic_sse: 10337.000 MB/sec
[    6.651068] xor: using function: prefetch64-sse (11703.000 MB/sec)
[    6.662152] bio: create slab <bio-2> at 2
[    6.662463] Btrfs loaded
[    6.861995] kjournald starting.  Commit interval 5 seconds
[    6.862040] EXT3-fs (dm-0): mounted filesystem with ordered data mode
[    8.286066] udevd[560]: starting version 175
[    8.542537] input: Power Button as /devices/LNXSYSTM:00/device:00/PNP0C0C:00/input/input1
[    8.542625] ACPI: Power Button [PWRB]
[    8.542750] input: Power Button as /devices/LNXSYSTM:00/LNXPWRBN:00/input/input2
[    8.542829] ACPI: Power Button [PWRF]
[    8.572463] wmi: Mapper loaded
[    8.652454] microcode: CPU0 sig=0x106a5, pf=0x2, revision=0x11
[    8.725162] pci_hotplug: PCI Hot Plug PCI Core version: 0.5
[    8.743080] shpchp: Standard Hot Plug PCI Controller Driver version: 0.4
[    8.781555] ACPI: Requesting acpi_cpufreq
[    8.788655] ACPI Warning: 0x0000000000000828-0x000000000000082f SystemIO conflicts with Region \PMRG 1 (20130328/utaddress-251)
[    8.788815] ACPI: If an ACPI driver is available for this device, you should use it instead of the native driver
[    8.788900] ACPI Warning: 0x0000000000000530-0x000000000000053f SystemIO conflicts with Region \GP35 1 (20130328/utaddress-251)
[    8.789150] ACPI: If an ACPI driver is available for this device, you should use it instead of the native driver
[    8.789252] lpc_ich: Resource conflict(s) found affecting gpio_ich
[    8.821815] dca service started, version 1.12.1
[    8.892807] ioatdma: Intel(R) QuickData Technology Driver 4.00
[    8.893078] ioatdma 0000:00:16.0: irq 50 for MSI/MSI-X
[    8.893496] ioatdma 0000:00:16.1: irq 51 for MSI/MSI-X
[    8.893837] ioatdma 0000:00:16.2: irq 52 for MSI/MSI-X
[    8.894135] ioatdma 0000:00:16.3: irq 53 for MSI/MSI-X
[    8.894434] ioatdma 0000:00:16.4: irq 54 for MSI/MSI-X
[    8.894738] ioatdma 0000:00:16.5: irq 55 for MSI/MSI-X
[    8.895046] ioatdma 0000:00:16.6: irq 56 for MSI/MSI-X
[    8.895343] ioatdma 0000:00:16.7: irq 57 for MSI/MSI-X
[    9.074428] ehci-pci: EHCI PCI platform driver
[    9.074735] ehci-pci 0000:00:1a.7: setting latency timer to 64
[    9.076180] input: PC Speaker as /devices/platform/pcspkr/input/input3
[    9.145621] ehci-pci 0000:00:1a.7: EHCI Host Controller
[    9.145689] ehci-pci 0000:00:1a.7: new USB bus registered, assigned bus number 7
[    9.145780] ehci-pci 0000:00:1a.7: debug port 1
[    9.149727] ehci-pci 0000:00:1a.7: cache line size of 256 is not supported
[    9.149734] ehci-pci 0000:00:1a.7: irq 18, io mem 0xfbbde000
[    9.161581] ehci-pci 0000:00:1a.7: USB 2.0 started, EHCI 1.00
[    9.161663] usb usb7: New USB device found, idVendor=1d6b, idProduct=0002
[    9.161727] usb usb7: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[    9.161804] usb usb7: Product: EHCI Host Controller
[    9.161864] usb usb7: Manufacturer: Linux 3.10.19 ehci_hcd
[    9.161924] usb usb7: SerialNumber: 0000:00:1a.7
[    9.162180] hub 7-0:1.0: USB hub found
[    9.162246] hub 7-0:1.0: 6 ports detected
[    9.179886] iTCO_vendor_support: vendor-support=0
[    9.185720] hub 1-0:1.0: USB hub found
[    9.185787] hub 1-0:1.0: 2 ports detected
[    9.189096] iTCO_wdt: Intel TCO WatchDog Timer Driver v1.10
[    9.189181] iTCO_wdt: Found a ICH10R TCO device (Version=2, TCOBASE=0x0860)
[    9.189421] iTCO_wdt: initialized. heartbeat=30 sec (nowayout=0)
[    9.209703] hub 2-0:1.0: USB hub found
[    9.209780] hub 2-0:1.0: 2 ports detected
[    9.226739] microcode: CPU1 sig=0x106a5, pf=0x2, revision=0x11
[    9.229530] microcode: CPU2 sig=0x106a5, pf=0x2, revision=0x11
[    9.232086] microcode: CPU3 sig=0x106a5, pf=0x2, revision=0x11
[    9.233628] hub 3-0:1.0: USB hub found
[    9.233689] hub 3-0:1.0: 2 ports detected
[    9.233957] ehci-pci 0000:00:1d.7: setting latency timer to 64
[    9.234734] microcode: CPU4 sig=0x106a5, pf=0x2, revision=0x11
[    9.237111] microcode: CPU5 sig=0x106a5, pf=0x2, revision=0x11
[    9.239434] microcode: CPU6 sig=0x106a5, pf=0x2, revision=0x11
[    9.241814] microcode: CPU7 sig=0x106a5, pf=0x2, revision=0x11
[    9.244247] microcode: Microcode Update Driver: v2.00 <tigran@aivazian.fsnet.co.uk>, Peter Oruba
[    9.292852] [drm] Initialized drm 1.1.0 20060810
[    9.309670] ehci-pci 0000:00:1d.7: EHCI Host Controller
[    9.309737] ehci-pci 0000:00:1d.7: new USB bus registered, assigned bus number 8
[    9.309826] ehci-pci 0000:00:1d.7: debug port 1
[    9.313775] ehci-pci 0000:00:1d.7: cache line size of 256 is not supported
[    9.313783] ehci-pci 0000:00:1d.7: irq 23, io mem 0xfbbdc000
[    9.329593] ehci-pci 0000:00:1d.7: USB 2.0 started, EHCI 1.00
[    9.329682] usb usb8: New USB device found, idVendor=1d6b, idProduct=0002
[    9.329747] usb usb8: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[    9.329826] usb usb8: Product: EHCI Host Controller
[    9.329886] usb usb8: Manufacturer: Linux 3.10.19 ehci_hcd
[    9.329948] usb usb8: SerialNumber: 0000:00:1d.7
[    9.330183] hub 8-0:1.0: USB hub found
[    9.330250] hub 8-0:1.0: 6 ports detected
[    9.353780] hub 4-0:1.0: USB hub found
[    9.353868] hub 4-0:1.0: 2 ports detected
[    9.377792] hub 5-0:1.0: USB hub found
[    9.377858] hub 5-0:1.0: 2 ports detected
[    9.401711] hub 6-0:1.0: USB hub found
[    9.401775] hub 6-0:1.0: 2 ports detected
[    9.402104] i801_smbus 0000:00:1f.3: SMBus using PCI Interrupt
[    9.549708] kvm: VM_EXIT_LOAD_IA32_PERF_GLOBAL_CTRL does not work properly. Using workaround
[    9.604397] snd_hda_intel 0000:00:1b.0: irq 58 for MSI/MSI-X
[    9.626812] bcache: register_bcache() error opening /dev/sdc1: device busy
[    9.664935] Error: Driver 'pcspkr' is already registered, aborting...
[    9.770529] input: HDA Intel Front Headphone as /devices/pci0000:00/0000:00:1b.0/sound/card0/input4
[    9.770789] input: HDA Intel Line Out Side as /devices/pci0000:00/0000:00:1b.0/sound/card0/input5
[    9.771019] input: HDA Intel Line Out CLFE as /devices/pci0000:00/0000:00:1b.0/sound/card0/input6
[    9.771217] input: HDA Intel Line Out Surround as /devices/pci0000:00/0000:00:1b.0/sound/card0/input7
[    9.771423] input: HDA Intel Line Out Front as /devices/pci0000:00/0000:00:1b.0/sound/card0/input8
[    9.771641] input: HDA Intel Line as /devices/pci0000:00/0000:00:1b.0/sound/card0/input9
[    9.771823] input: HDA Intel Rear Mic as /devices/pci0000:00/0000:00:1b.0/sound/card0/input10
[    9.771965] input: HDA Intel Front Mic as /devices/pci0000:00/0000:00:1b.0/sound/card0/input11
[   10.009428] MXM: GUID detected in BIOS
[   10.010001] nouveau  [  DEVICE][0000:03:00.0] BOOT0  : 0x298200a2
[   10.010070] nouveau  [  DEVICE][0000:03:00.0] Chipset: G98 (NV98)
[   10.010135] nouveau  [  DEVICE][0000:03:00.0] Family : NV50
[   10.010824] nouveau  [   VBIOS][0000:03:00.0] checking PRAMIN for image...
[   10.064695] nouveau  [   VBIOS][0000:03:00.0] ... appears to be valid
[   10.064757] nouveau  [   VBIOS][0000:03:00.0] using image from PRAMIN
[   10.064954] nouveau  [   VBIOS][0000:03:00.0] BIT signature found
[   10.065016] nouveau  [   VBIOS][0000:03:00.0] version 62.98.71.00.05
[   10.085200] nouveau  [     PFB][0000:03:00.0] RAM type: DDR2
[   10.085267] nouveau  [     PFB][0000:03:00.0] RAM size: 256 MiB
[   10.085333] nouveau  [     PFB][0000:03:00.0]    ZCOMP: 960 tags
[   10.581943] input: PS/2 Generic Mouse as /devices/platform/i8042/serio1/input/input12
[   11.367648] nouveau  [  PTHERM][0000:03:00.0] FAN control: none / external
[   11.367795] nouveau  [  PTHERM][0000:03:00.0] fan management: disabled
[   11.367871] nouveau  [  PTHERM][0000:03:00.0] internal sensor: yes
[   11.368196] [TTM] Zone  kernel: Available graphics memory: 6151494 kiB
[   11.368270] [TTM] Zone   dma32: Available graphics memory: 2097152 kiB
[   11.368343] [TTM] Initializing pool allocator
[   11.368415] [TTM] Initializing DMA pool allocator
[   11.368500] mtrr: type mismatch for d0000000,10000000 old: write-back new: write-combining
[   11.368593] nouveau  [     DRM] VRAM: 256 MiB
[   11.368661] nouveau  [     DRM] GART: 512 MiB
[   11.368732] nouveau  [     DRM] TMDS table version 2.0
[   11.368802] nouveau  [     DRM] DCB version 4.0
[   11.368872] nouveau  [     DRM] DCB outp 00: 02000300 00000028
[   11.368944] nouveau  [     DRM] DCB outp 01: 01000302 00020030
[   11.369017] nouveau  [     DRM] DCB outp 02: 04011310 00000028
[   11.369088] nouveau  [     DRM] DCB conn 00: 00001030
[   11.369201] nouveau  [     DRM] DCB conn 01: 00000200
[   11.413631] [drm] Supports vblank timestamp caching Rev 1 (10.10.2010).
[   11.413705] [drm] No driver support for vblank timestamp query.
[   11.413911] nouveau  [     DRM] 1 available performance level(s)
[   11.413986] nouveau  [     DRM] 3: core 567MHz shader 1400MHz memory 400MHz fanspeed 100%
[   11.414079] nouveau  [     DRM] c: core 500MHz shader 1300MHz memory 399MHz
[   11.475669] nouveau  [     DRM] MM: using M2MF for buffer copies
[   11.521757] nouveau  [     DRM] allocated 1024x768 fb: 0x60000, bo ffff880330f8ac00
[   11.522076] fbcon: nouveaufb (fb0) is primary device
[   11.602827] Console: switching to colour frame buffer device 128x48
[   11.603755] nouveau 0000:03:00.0: fb0: nouveaufb frame buffer device
[   11.603766] nouveau 0000:03:00.0: registered panic notifier
[   11.603781] [drm] Initialized nouveau 1.1.1 20120801 for 0000:03:00.0 on minor 0
[   12.893295] EXT3-fs (dm-0): using internal journal
[   14.855689] bcache: register_bdev() registered backing device dm-2
[   14.858533] bcache: bch_cached_dev_attach() Caching dm-2 as bcache0 on set 317844fc-5de8-48ad-9569-4a705c09d62e
[   14.964023] bcache: register_bcache() error opening /dev/dm-2: device busy
[   14.983517] bcache: register_bdev() registered backing device dm-3
[   15.217041] bcache: bch_cached_dev_attach() Caching dm-3 as bcache1 on set 317844fc-5de8-48ad-9569-4a705c09d62e
[   15.244015] bcache: register_bcache() error opening /dev/dm-3: device busy
[   15.367835] Adding 11534332k swap on /dev/mapper/pve-swap.  Priority:-1 extents:1 across:11534332k 
[   16.620708] EXT4-fs (dm-5): mounted filesystem with ordered data mode. Opts: (null)
[   16.682924] EXT4-fs (dm-4): mounted filesystem with ordered data mode. Opts: (null)
[   18.209473] Bridge firewalling registered
[   18.255260] device eth0 entered promiscuous mode
[   18.357319] IPv6: ADDRCONF(NETDEV_UP): eth0: link is not ready
[   18.361870] IPv6: ADDRCONF(NETDEV_UP): vmbr0: link is not ready
[   20.979966] RPC: Registered named UNIX socket transport module.
[   20.980204] RPC: Registered udp transport module.
[   20.980424] RPC: Registered tcp transport module.
[   20.980891] RPC: Registered tcp NFSv4.1 backchannel transport module.
[   21.022333] FS-Cache: Loaded
[   21.107831] FS-Cache: Netfs 'nfs' registered for caching
[   21.234996] Installing knfsd (copyright (C) 1996 okir@monad.swb.de).
[   21.487039] e1000e: eth0 NIC Link is Up 1000 Mbps Full Duplex, Flow Control: None
[   21.487913] IPv6: ADDRCONF(NETDEV_CHANGE): eth0: link becomes ready
[   21.488449] vmbr0: port 1(eth0) entered forwarding state
[   21.491488] vmbr0: port 1(eth0) entered forwarding state
[   21.494516] IPv6: ADDRCONF(NETDEV_CHANGE): vmbr0: link becomes ready
[   21.506182] NFS: Registering the id_resolver key type
[   21.506661] Key type id_resolver registered
[   21.507124] Key type id_legacy registered
[   37.538073] RPC: AUTH_GSS upcall timed out.
[   37.538073] Please check user daemon is running.
[   38.450571] fuse init (API version 7.22)
[   38.990690] Loading iSCSI transport class v2.0-870.
[   39.032353] iscsi: registered transport (tcp)
[   39.179911] iscsi: registered transport (iser)
[   47.443116] postgres (3934): /proc/3934/oom_adj is deprecated, please use /proc/3934/oom_score_adj instead.
[  244.521479] EXT4-fs (bcache0): mounted filesystem with writeback data mode. Opts: (null)
[  257.173523] EXT4-fs (bcache1): mounted filesystem with writeback data mode. Opts: (null)
[ 6969.730581] INFO: task postgres:20973 blocked for more than 120 seconds.
[ 6969.730602] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
[ 6969.730611] postgres        D ffff88033fc12b80     0 20973   5372 0x00000000
[ 6969.730626]  ffff880313979c80 0000000000000082 ffffffff81610400 ffffffff81189ff6
[ 6969.730642]  0000000000012b80 ffff880002b6dfd8 ffff880002b6dfd8 ffff880313979c80
[ 6969.730657]  ffffffff81007433 ffff88033fc12b80 ffff880313979c80 ffff880002b6ddb0
[ 6969.730672] Call Trace:
[ 6969.730684]  [<ffffffff81189ff6>] ? queue_unplugged+0x54/0x78
[ 6969.730695]  [<ffffffff81007433>] ? read_tsc+0x5/0x14
[ 6969.730705]  [<ffffffff810b0efc>] ? __lock_page+0x66/0x66
[ 6969.730715]  [<ffffffff8133f956>] ? io_schedule+0x56/0x6d
[ 6969.730724]  [<ffffffff810b0f03>] ? sleep_on_page+0x7/0xb
[ 6969.730733]  [<ffffffff8133e78f>] ? __wait_on_bit+0x3e/0x75
[ 6969.730741]  [<ffffffff810b12c1>] ? find_get_pages_tag+0xe7/0x121
[ 6969.730750]  [<ffffffff810b0fb6>] ? wait_on_page_bit+0x6e/0x73
[ 6969.730762]  [<ffffffff81049225>] ? autoremove_wake_function+0x2a/0x2a
[ 6969.730771]  [<ffffffff810b1663>] ? filemap_fdatawait_range+0x66/0xfe
[ 6969.730781]  [<ffffffff810b2207>] ? __filemap_fdatawrite_range+0x50/0x55
[ 6969.730790]  [<ffffffff810b2243>] ? filemap_write_and_wait_range+0x37/0x55
[ 6969.730812]  [<ffffffffa05447d4>] ? ext4_sync_file+0x88/0x2f4 [ext4]
[ 6969.730823]  [<ffffffff8111743b>] ? do_fsync+0x2b/0x50
[ 6969.730832]  [<ffffffff81117637>] ? SyS_fsync+0x9/0xe
[ 6969.730842]  [<ffffffff81346352>] ? system_call_fastpath+0x16/0x1b
[ 7089.854889] INFO: task postgres:5435 blocked for more than 120 seconds.
[ 7089.854904] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
[ 7089.854913] postgres        D ffff88033fc52b80     0  5435   5433 0x00000000
[ 7089.854930]  ffff88032e856ae0 0000000000000086 ffff88033149c740 ffffffff81189ff6
[ 7089.854944]  0000000000012b80 ffff8803117bffd8 ffff8803117bffd8 ffff88032e856ae0
[ 7089.854957]  ffffffff81007433 ffff88033fc52b80 ffff88032e856ae0 ffff8803117bfdb0
[ 7089.854971] Call Trace:
[ 7089.854981]  [<ffffffff81189ff6>] ? queue_unplugged+0x54/0x78
[ 7089.854992]  [<ffffffff81007433>] ? read_tsc+0x5/0x14
[ 7089.855000]  [<ffffffff810b0efc>] ? __lock_page+0x66/0x66
[ 7089.855009]  [<ffffffff8133f956>] ? io_schedule+0x56/0x6d
[ 7089.855017]  [<ffffffff810b0f03>] ? sleep_on_page+0x7/0xb
[ 7089.855024]  [<ffffffff8133e78f>] ? __wait_on_bit+0x3e/0x75
[ 7089.855032]  [<ffffffff810b1240>] ? find_get_pages_tag+0x66/0x121
[ 7089.855039]  [<ffffffff810b0fb6>] ? wait_on_page_bit+0x6e/0x73
[ 7089.855052]  [<ffffffff81049225>] ? autoremove_wake_function+0x2a/0x2a
[ 7089.855061]  [<ffffffff810b1663>] ? filemap_fdatawait_range+0x66/0xfe
[ 7089.855069]  [<ffffffff810b2243>] ? filemap_write_and_wait_range+0x37/0x55
[ 7089.855089]  [<ffffffffa05447d4>] ? ext4_sync_file+0x88/0x2f4 [ext4]
[ 7089.855098]  [<ffffffff8111743b>] ? do_fsync+0x2b/0x50
[ 7089.855106]  [<ffffffff81117637>] ? SyS_fsync+0x9/0xe
[ 7089.855116]  [<ffffffff81346352>] ? system_call_fastpath+0x16/0x1b
[ 7089.855138] INFO: task postgres:20973 blocked for more than 120 seconds.
[ 7089.855145] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
[ 7089.855153] postgres        D ffff88033fc12b80     0 20973   5372 0x00000000
[ 7089.855164]  ffff880313979c80 0000000000000082 ffffffff81610400 ffffffff81189ff6
[ 7089.855177]  0000000000012b80 ffff880002b6dfd8 ffff880002b6dfd8 ffff880313979c80
[ 7089.855190]  ffffffff81007433 ffff88033fc12b80 ffff880313979c80 ffff880002b6ddb0
[ 7089.855503] Call Trace:
[ 7089.855800]  [<ffffffff81189ff6>] ? queue_unplugged+0x54/0x78
[ 7089.856101]  [<ffffffff81007433>] ? read_tsc+0x5/0x14
[ 7089.856394]  [<ffffffff810b0efc>] ? __lock_page+0x66/0x66
[ 7089.856682]  [<ffffffff8133f956>] ? io_schedule+0x56/0x6d
[ 7089.856971]  [<ffffffff810b0f03>] ? sleep_on_page+0x7/0xb
[ 7089.857260]  [<ffffffff8133e78f>] ? __wait_on_bit+0x3e/0x75
[ 7089.857562]  [<ffffffff810b12c1>] ? find_get_pages_tag+0xe7/0x121
[ 7089.857900]  [<ffffffff810b0fb6>] ? wait_on_page_bit+0x6e/0x73
[ 7089.858238]  [<ffffffff81049225>] ? autoremove_wake_function+0x2a/0x2a
[ 7089.858572]  [<ffffffff810b1663>] ? filemap_fdatawait_range+0x66/0xfe
[ 7089.858969]  [<ffffffff810b2207>] ? __filemap_fdatawrite_range+0x50/0x55
[ 7089.859263]  [<ffffffff810b2243>] ? filemap_write_and_wait_range+0x37/0x55
[ 7089.859587]  [<ffffffffa05447d4>] ? ext4_sync_file+0x88/0x2f4 [ext4]
[ 7089.859927]  [<ffffffff8111743b>] ? do_fsync+0x2b/0x50
[ 7089.860267]  [<ffffffff81117637>] ? SyS_fsync+0x9/0xe
[ 7089.860610]  [<ffffffff81346352>] ? system_call_fastpath+0x16/0x1b
[ 7209.983185] INFO: task postgres:5435 blocked for more than 120 seconds.
[ 7209.983533] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
[ 7209.983872] postgres        D ffff88033fc52b80     0  5435   5433 0x00000000
[ 7209.984213]  ffff88032e856ae0 0000000000000086 ffff88033149c740 ffffffff81189ff6
[ 7209.984558]  0000000000012b80 ffff8803117bffd8 ffff8803117bffd8 ffff88032e856ae0
[ 7209.984907]  ffffffff81007433 ffff88033fc52b80 ffff88032e856ae0 ffff8803117bfdb0
[ 7209.985255] Call Trace:
[ 7209.985602]  [<ffffffff81189ff6>] ? queue_unplugged+0x54/0x78
[ 7209.985953]  [<ffffffff81007433>] ? read_tsc+0x5/0x14
[ 7209.986292]  [<ffffffff810b0efc>] ? __lock_page+0x66/0x66
[ 7209.986630]  [<ffffffff8133f956>] ? io_schedule+0x56/0x6d
[ 7209.986962]  [<ffffffff810b0f03>] ? sleep_on_page+0x7/0xb
[ 7209.987345]  [<ffffffff8133e78f>] ? __wait_on_bit+0x3e/0x75
[ 7209.987668]  [<ffffffff810b1240>] ? find_get_pages_tag+0x66/0x121
[ 7209.987952]  [<ffffffff810b0fb6>] ? wait_on_page_bit+0x6e/0x73
[ 7209.988236]  [<ffffffff81049225>] ? autoremove_wake_function+0x2a/0x2a
[ 7209.988539]  [<ffffffff810b1663>] ? filemap_fdatawait_range+0x66/0xfe
[ 7209.988864]  [<ffffffff810b2243>] ? filemap_write_and_wait_range+0x37/0x55
[ 7209.989201]  [<ffffffffa05447d4>] ? ext4_sync_file+0x88/0x2f4 [ext4]
[ 7209.989528]  [<ffffffff8111743b>] ? do_fsync+0x2b/0x50
[ 7209.989856]  [<ffffffff81117637>] ? SyS_fsync+0x9/0xe
[ 7209.990185]  [<ffffffff81346352>] ? system_call_fastpath+0x16/0x1b
[ 7209.990528] INFO: task postgres:20973 blocked for more than 120 seconds.
[ 7209.990861] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
[ 7209.991310] postgres        D ffff88033fc12b80     0 20973   5372 0x00000000
[ 7209.991648]  ffff880313979c80 0000000000000082 ffffffff81610400 ffffffff81189ff6
[ 7209.991987]  0000000000012b80 ffff880002b6dfd8 ffff880002b6dfd8 ffff880313979c80
[ 7209.992335]  ffffffff81007433 ffff88033fc12b80 ffff880313979c80 ffff880002b6ddb0
[ 7209.992679] Call Trace:
[ 7209.993017]  [<ffffffff81189ff6>] ? queue_unplugged+0x54/0x78
[ 7209.993362]  [<ffffffff81007433>] ? read_tsc+0x5/0x14
[ 7209.993708]  [<ffffffff810b0efc>] ? __lock_page+0x66/0x66
[ 7209.994060]  [<ffffffff8133f956>] ? io_schedule+0x56/0x6d
[ 7209.994417]  [<ffffffff810b0f03>] ? sleep_on_page+0x7/0xb
[ 7209.994771]  [<ffffffff8133e78f>] ? __wait_on_bit+0x3e/0x75
[ 7209.995227]  [<ffffffff810b12c1>] ? find_get_pages_tag+0xe7/0x121
[ 7209.995560]  [<ffffffff810b0fb6>] ? wait_on_page_bit+0x6e/0x73
[ 7209.995888]  [<ffffffff81049225>] ? autoremove_wake_function+0x2a/0x2a
[ 7209.996213]  [<ffffffff810b1663>] ? filemap_fdatawait_range+0x66/0xfe
[ 7209.996540]  [<ffffffff810b2207>] ? __filemap_fdatawrite_range+0x50/0x55
[ 7209.996870]  [<ffffffff810b2243>] ? filemap_write_and_wait_range+0x37/0x55
[ 7209.997208]  [<ffffffffa05447d4>] ? ext4_sync_file+0x88/0x2f4 [ext4]
[ 7209.997545]  [<ffffffff8111743b>] ? do_fsync+0x2b/0x50
[ 7209.997885]  [<ffffffff81117637>] ? SyS_fsync+0x9/0xe
[ 7209.998235]  [<ffffffff81346352>] ? system_call_fastpath+0x16/0x1b
[ 7330.119458] INFO: task jbd2/bcache0-8:5171 blocked for more than 120 seconds.
[ 7330.119759] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
[ 7330.120053] jbd2/bcache0-8  D ffff88033fc32b80     0  5171      2 0x00000000
[ 7330.120355]  ffff88032e9fc740 0000000000000046 ffff88033149c020 0000000000000000
[ 7330.120657]  0000000000012b80 ffff88031603dfd8 ffff88031603dfd8 ffff88032e9fc740
[ 7330.120958]  0000000000000246 ffff88031b9b0000 ffff88031603dd80 ffff880326a67570
[ 7330.121264] Call Trace:
[ 7330.121573]  [<ffffffffa004b499>] ? jbd2_journal_commit_transaction+0x22e/0x137d [jbd2]
[ 7330.121902]  [<ffffffff81001597>] ? __switch_to+0x19f/0x3b9
[ 7330.122277]  [<ffffffff810491fb>] ? abort_exclusive_wait+0x79/0x79
[ 7330.122644]  [<ffffffff8103900c>] ? lock_timer_base.isra.35+0x23/0x48
[ 7330.123013]  [<ffffffff81039131>] ? try_to_del_timer_sync+0x4e/0x59
[ 7330.123449]  [<ffffffffa00504e9>] ? kjournald2+0xb7/0x234 [jbd2]
[ 7330.123741]  [<ffffffff810491fb>] ? abort_exclusive_wait+0x79/0x79
[ 7330.124093]  [<ffffffffa0050432>] ? journal_init_common+0x15a/0x15a [jbd2]
[ 7330.124463]  [<ffffffffa0050432>] ? journal_init_common+0x15a/0x15a [jbd2]
[ 7330.124809]  [<ffffffff81048880>] ? kthread+0x81/0x89
[ 7330.125161]  [<ffffffff810487ff>] ? __kthread_parkme+0x5d/0x5d
[ 7330.125513]  [<ffffffff813462ac>] ? ret_from_fork+0x7c/0xb0
[ 7330.125864]  [<ffffffff810487ff>] ? __kthread_parkme+0x5d/0x5d
[ 7330.126219] INFO: task postgres:5378 blocked for more than 120 seconds.
[ 7330.126571] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
[ 7330.126935] postgres        D ffff88033fc32b80     0  5378   5372 0x00000000
[ 7330.127304]  ffff880314819560 0000000000000082 ffff88033149c020 0000020013cd1a60
[ 7330.127875]  0000000000012b80 ffff880313cd1fd8 ffff880313cd1fd8 ffff880314819560
[ 7330.128194]  ffffffff81007433 ffff88033fc32b80 ffff880314819560 ffff880313cd1b10
[ 7330.128508] Call Trace:
[ 7330.128823]  [<ffffffff81007433>] ? read_tsc+0x5/0x14
[ 7330.129181]  [<ffffffff810b0efc>] ? __lock_page+0x66/0x66
[ 7330.129557]  [<ffffffff8133f956>] ? io_schedule+0x56/0x6d
[ 7330.129934]  [<ffffffff810b0f03>] ? sleep_on_page+0x7/0xb
[ 7330.130306]  [<ffffffff8133e78f>] ? __wait_on_bit+0x3e/0x75
[ 7330.130671]  [<ffffffff810b0fb6>] ? wait_on_page_bit+0x6e/0x73
[ 7330.131032]  [<ffffffff81049225>] ? autoremove_wake_function+0x2a/0x2a
[ 7330.131528]  [<ffffffffa054af24>] ? ext4_da_write_begin+0x19f/0x250 [ext4]
[ 7330.131836]  [<ffffffff810b0aba>] ? iov_iter_fault_in_readable+0x52/0x67
[ 7330.132137]  [<ffffffff810b1d01>] ? generic_file_buffered_write+0x115/0x235
[ 7330.132455]  [<ffffffff812ab68e>] ? ip_skb_dst_mtu+0x32/0x32
[ 7330.132802]  [<ffffffff810b257a>] ? __generic_file_aio_write+0x1cf/0x1ff
[ 7330.133153]  [<ffffffff810b25fe>] ? generic_file_aio_write+0x54/0xa2
[ 7330.133511]  [<ffffffffa054471b>] ? ext4_file_write+0x335/0x366 [ext4]
[ 7330.133862]  [<ffffffff81103be3>] ? core_sys_select+0x1ae/0x1f9
[ 7330.134222]  [<ffffffff810f5093>] ? do_sync_write+0x55/0x7c
[ 7330.134580]  [<ffffffff810f5a8b>] ? vfs_write+0x9d/0x103
[ 7330.134938]  [<ffffffff810f5d7d>] ? SyS_write+0x51/0x80
[ 7330.135296]  [<ffffffff81346352>] ? system_call_fastpath+0x16/0x1b
[ 7330.135779] INFO: task postgres:5382 blocked for more than 120 seconds.
[ 7330.136086] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
[ 7330.136391] postgres        D ffff88033fc72b80     0  5382   5372 0x00000000
[ 7330.136736]  ffff88031481b900 0000000000000086 ffff88033149ce60 ffff88030fa81fd8
[ 7330.137106]  0000000000012b80 ffff88030fa81fd8 ffff88030fa81fd8 ffff88031481b900
[ 7330.137483]  0000000000000246 ffff88031b9b0000 0000000000000000 ffff88031b9b0070
[ 7330.137859] Call Trace:
[ 7330.138234]  [<ffffffffa00494ca>] ? start_this_handle+0x2d0/0x46b [jbd2]
[ 7330.138606]  [<ffffffffa05470d7>] ? __check_block_validity.constprop.53+0x27/0x65 [ext4]
[ 7330.138976]  [<ffffffff810491fb>] ? abort_exclusive_wait+0x79/0x79
[ 7330.139471]  [<ffffffffa00497f3>] ? jbd2__journal_start+0x88/0x151 [jbd2]
[ 7330.139788]  [<ffffffff81109010>] ? new_inode_pseudo+0x32/0x4e
[ 7330.140108]  [<ffffffffa0545b6c>] ? __ext4_new_inode+0x485/0xc85 [ext4]
[ 7330.140457]  [<ffffffff8113692d>] ? dquot_active+0x28/0x50
[ 7330.140831]  [<ffffffffa05515dd>] ? ext4_create+0xa0/0x13e [ext4]
[ 7330.141186]  [<ffffffff8110682d>] ? d_splice_alias+0xbb/0xc7
[ 7330.141548]  [<ffffffff810ff578>] ? vfs_create+0x62/0x8b
[ 7330.141902]  [<ffffffff81100717>] ? do_last+0x595/0xa16
[ 7330.142260]  [<ffffffff81100c5c>] ? path_openat+0xc4/0x335
[ 7330.142611]  [<ffffffff81101178>] ? do_filp_open+0x2a/0x6e
[ 7330.142962]  [<ffffffff8110a02e>] ? __alloc_fd+0xd0/0xe1
[ 7330.143312]  [<ffffffff810f4d84>] ? do_sys_open+0x5c/0xe0
[ 7330.143788]  [<ffffffff81346352>] ? system_call_fastpath+0x16/0x1b
[ 7330.144095] INFO: task postgres:5435 blocked for more than 120 seconds.
[ 7330.144395] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
[ 7330.144726] postgres        D ffff88033fc52b80     0  5435   5433 0x00000000
[ 7330.145096]  ffff88032e856ae0 0000000000000086 ffff88033149c740 ffffffff81189ff6
[ 7330.145468]  0000000000012b80 ffff8803117bffd8 ffff8803117bffd8 ffff88032e856ae0
[ 7330.145844]  ffffffff81007433 ffff88033fc52b80 ffff88032e856ae0 ffff8803117bfdb0
[ 7330.146216] Call Trace:
[ 7330.146579]  [<ffffffff81189ff6>] ? queue_unplugged+0x54/0x78
[ 7330.146936]  [<ffffffff81007433>] ? read_tsc+0x5/0x14
[ 7330.147294]  [<ffffffff810b0efc>] ? __lock_page+0x66/0x66
[ 7330.147778]  [<ffffffff8133f956>] ? io_schedule+0x56/0x6d
[ 7330.148077]  [<ffffffff810b0f03>] ? sleep_on_page+0x7/0xb
[ 7330.148377]  [<ffffffff8133e78f>] ? __wait_on_bit+0x3e/0x75
[ 7330.148714]  [<ffffffff810b1240>] ? find_get_pages_tag+0x66/0x121
[ 7330.149067]  [<ffffffff810b0fb6>] ? wait_on_page_bit+0x6e/0x73
[ 7330.149421]  [<ffffffff81049225>] ? autoremove_wake_function+0x2a/0x2a
[ 7330.149776]  [<ffffffff810b1663>] ? filemap_fdatawait_range+0x66/0xfe
[ 7330.150133]  [<ffffffff810b2243>] ? filemap_write_and_wait_range+0x37/0x55
[ 7330.150498]  [<ffffffffa05447d4>] ? ext4_sync_file+0x88/0x2f4 [ext4]
[ 7330.150851]  [<ffffffff8111743b>] ? do_fsync+0x2b/0x50
[ 7330.151204]  [<ffffffff81117637>] ? SyS_fsync+0x9/0xe
[ 7330.151681]  [<ffffffff81346352>] ? system_call_fastpath+0x16/0x1b
[ 7330.151996] INFO: task postgres:20973 blocked for more than 120 seconds.
[ 7330.152295] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
[ 7330.152613] postgres        D ffff88033fc12b80     0 20973   5372 0x00000000
[ 7330.152976]  ffff880313979c80 0000000000000082 ffffffff81610400 ffffffff81189ff6
[ 7330.153343]  0000000000012b80 ffff880002b6dfd8 ffff880002b6dfd8 ffff880313979c80
[ 7330.153715]  ffffffff81007433 ffff88033fc12b80 ffff880313979c80 ffff880002b6ddb0
[ 7330.154091] Call Trace:
[ 7330.154461]  [<ffffffff81189ff6>] ? queue_unplugged+0x54/0x78
[ 7330.154836]  [<ffffffff81007433>] ? read_tsc+0x5/0x14
[ 7330.155212]  [<ffffffff810b0efc>] ? __lock_page+0x66/0x66
[ 7330.155713]  [<ffffffff8133f956>] ? io_schedule+0x56/0x6d
[ 7330.156018]  [<ffffffff810b0f03>] ? sleep_on_page+0x7/0xb
[ 7330.156322]  [<ffffffff8133e78f>] ? __wait_on_bit+0x3e/0x75
[ 7330.156660]  [<ffffffff810b12c1>] ? find_get_pages_tag+0xe7/0x121
[ 7330.157015]  [<ffffffff810b0fb6>] ? wait_on_page_bit+0x6e/0x73
[ 7330.157366]  [<ffffffff81049225>] ? autoremove_wake_function+0x2a/0x2a
[ 7330.157714]  [<ffffffff810b1663>] ? filemap_fdatawait_range+0x66/0xfe
[ 7330.158059]  [<ffffffff810b2207>] ? __filemap_fdatawrite_range+0x50/0x55
[ 7330.158409]  [<ffffffff810b2243>] ? filemap_write_and_wait_range+0x37/0x55
[ 7330.158749]  [<ffffffffa05447d4>] ? ext4_sync_file+0x88/0x2f4 [ext4]
[ 7330.159085]  [<ffffffff8111743b>] ? do_fsync+0x2b/0x50
[ 7330.159550]  [<ffffffff81117637>] ? SyS_fsync+0x9/0xe
[ 7330.159835]  [<ffffffff81346352>] ? system_call_fastpath+0x16/0x1b


Is there anything else that might be useful to know?

-davidc
