From: Hubert Kempkensteffen <hubert-39zlLzowylnAQEp6PLVxx6xOck334EZe@public.gmane.org>
Subject: Re: Bcache hangs with Debian 7 (Wheezy), sync does not come back
Date: Tue, 17 Sep 2013 10:23:07 +0000 (UTC)
Message-ID: <loom.20130917T122135-908@post.gmane.org>
References: <loom.20130916T150548-751@post.gmane.org> <20130917020316.GC10907@kmo-pixel>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-bcache-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-bcache-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-bcache-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-bcache@vger.kernel.org

Kent Overstreet <kmo@...> writes:

> 
> On Mon, Sep 16, 2013 at 01:07:49PM +0000, Hubert Kempkensteffen wrote:
> > Sorry for my English.
> > But my Bcache depends on if I have many  Copy files.
> > I have tested it on two computers with me and
> > i have the problem with kernel 3.10.10, 3.10.11,3.10.12,3.11 and 3.11.1.
> > 
> > My Bcache-Tools are from git:
> > git clone http://evilpiepirate.org/git/bcache-tools.git
> > cd bcache-tools
> > make
> > make install
> > 
> > My Test:
> > ||make-bcache -C /dev/sda4 -B /dev/sdb1
> > mkfs.ext4 -L Data /dev/bcache0
> > mkdir x
> > mount /dev/bcache0 x
> > rsync -avr --progress --delete /usr/src ./x/
> > sync
> > 
> > First, rsync copies the files very quickly then to be getting slower,
> > that goes to halt!
> > I give in another console "sync" here, not the command returns.
> > I can take the computer will not reboot with "init 6".
> 
> Hey - thanks for narrowing it down to those kernels - that helps a
> _lot_.
> 
> Can you tell me what else is in your setup? Are you using LVM or md?
> 
Hello and thanks for the quick reply :-),
i use either LVM or software RAID. The computer boot from /dev/sda1
and there is even a Corsair neutron and the other built a times a
Samsung 840 per.

Here are the dates from the PC this the Samsung:
root@server:~# lspci
00:00.0 Host bridge: Advanced Micro Devices [AMD] nee ATI RS690 Host
Bridge
00:01.0 PCI bridge: Advanced Micro Devices [AMD] nee ATI RS690 PCI to
PCI Bridge (Internal gfx)
00:07.0 PCI bridge: Advanced Micro Devices [AMD] nee ATI RS690 PCI to
PCI Bridge (PCI Express Port 3)
00:12.0 SATA controller: Advanced Micro Devices [AMD] nee ATI SB600
Non-Raid-5 SATA
00:13.0 USB controller: Advanced Micro Devices [AMD] nee ATI SB600 USB
(OHCI0)
00:13.1 USB controller: Advanced Micro Devices [AMD] nee ATI SB600 USB
(OHCI1)
00:13.2 USB controller: Advanced Micro Devices [AMD] nee ATI SB600 USB
(OHCI2)
00:13.3 USB controller: Advanced Micro Devices [AMD] nee ATI SB600 USB
(OHCI3)
00:13.4 USB controller: Advanced Micro Devices [AMD] nee ATI SB600 USB
(OHCI4)
00:13.5 USB controller: Advanced Micro Devices [AMD] nee ATI SB600 USB
Controller (EHCI)
00:14.0 SMBus: Advanced Micro Devices [AMD] nee ATI SBx00 SMBus
Controller (rev 13)
00:14.1 IDE interface: Advanced Micro Devices [AMD] nee ATI SB600 IDE
00:14.2 Audio device: Advanced Micro Devices [AMD] nee ATI SBx00
Azalia (Intel HDA)
00:14.3 ISA bridge: Advanced Micro Devices [AMD] nee ATI SB600 PCI to
LPC Bridge
00:14.4 PCI bridge: Advanced Micro Devices [AMD] nee ATI SBx00 PCI to
PCI Bridge
00:18.0 Host bridge: Advanced Micro Devices [AMD] K8
[Athlon64/Opteron] HyperTransport Technology Configuration
00:18.1 Host bridge: Advanced Micro Devices [AMD] K8
[Athlon64/Opteron] Address Map
00:18.2 Host bridge: Advanced Micro Devices [AMD] K8
[Athlon64/Opteron] DRAM Controller
00:18.3 Host bridge: Advanced Micro Devices [AMD] K8
[Athlon64/Opteron] Miscellaneous Control
01:05.0 VGA compatible controller: Advanced Micro Devices [AMD] nee
ATI RS690 [Radeon X1200 Series]
02:00.0 Ethernet controller: Realtek Semiconductor Co., Ltd.
RTL8111/8168B PCI Express Gigabit Ethernet controller (rev 01)
03:07.0 FireWire (IEEE 1394): VIA Technologies, Inc. VT6306/7/8 [Fire
II(M)] IEEE 1394 OHCI Controller (rev c0)


The 80GB drive is also the only test, i am still waiting for a TB drive.
But the second computer has a larger disk but since I'm at the moment
not turn.
Cache is sda4
Backing is sdb1

fdisk -l
Disk /dev/sda: 256.1 GB, 256060514304 bytes
255 heads, 63 sectors/track, 31130 cylinders, total 500118192 sectors
Units = sectors of 1 * 512 = 512 bytes
Sector size (logical/physical): 512 bytes / 512 bytes
I/O size (minimum/optimal): 512 bytes / 512 bytes
Disk identifier: 0x396aa1cc

   Device Boot      Start         End      Blocks   Id  System
/dev/sda1   *        2048    62916607    31457280   83  Linux
/dev/sda2        62916608    67110911     2097152   82  Linux swap /
Solaris
/dev/sda3        67110912   434112511   183500800   83  Linux
/dev/sda4       434112512   500118191    33002840   83  Linux

Disk /dev/sdb: 80.0 GB, 80026361856 bytes
81 heads, 63 sectors/track, 30629 cylinders, total 156301488 sectors
Units = sectors of 1 * 512 = 512 bytes
Sector size (logical/physical): 512 bytes / 512 bytes
I/O size (minimum/optimal): 512 bytes / 512 bytes
Disk identifier: 0xbe08d558

   Device Boot      Start         End      Blocks   Id  System
/dev/sdb1            2048   156301487    78149720   83  Linux
root@server:~#
Here's the complete output of demsg:
[    0.000000] Initializing cgroup subsys cpuset
[    0.000000] Initializing cgroup subsys cpu
[    0.000000] Initializing cgroup subsys cpuacct
[    0.000000] Linux version 3.10.3 (root@server) (gcc version 4.7.2
(Debian 4.7.2-5) ) #1 SMP Tue Sep 17 08:30:22 CEST 2013
[    0.000000] Command line: BOOT_IMAGE=/boot/vmlinuz-3.10.3
root=UUID=21d0d91e-b4cf-4571-b265-5d6165653a75 ro quiet
[    0.000000] e820: BIOS-provided physical RAM map:
[    0.000000] BIOS-e820: [mem 0x0000000000000000-0x000000000009efff]
usable
[    0.000000] BIOS-e820: [mem 0x000000000009f000-0x000000000009ffff]
reserved
[    0.000000] BIOS-e820: [mem 0x00000000000f0000-0x00000000000fffff]
reserved
[    0.000000] BIOS-e820: [mem 0x0000000000100000-0x00000000d7edffff]
usable
[    0.000000] BIOS-e820: [mem 0x00000000d7ee0000-0x00000000d7ee2fff]
ACPI NVS
[    0.000000] BIOS-e820: [mem 0x00000000d7ee3000-0x00000000d7eeffff]
ACPI data
[    0.000000] BIOS-e820: [mem 0x00000000d7ef0000-0x00000000d7efffff]
reserved
[    0.000000] BIOS-e820: [mem 0x00000000e0000000-0x00000000efffffff]
reserved
[    0.000000] BIOS-e820: [mem 0x00000000fec00000-0x00000000ffffffff]
reserved
[    0.000000] BIOS-e820: [mem 0x0000000100000000-0x000000011fffffff]
usable
[    0.000000] NX (Execute Disable) protection: active
[    0.000000] SMBIOS 2.4 present.
[    0.000000] DMI: System manufacturer System Product Name/M2A-VM,
BIOS ASUS M2A-VM ACPI BIOS Revision 0402 03/29/2007
[    0.000000] e820: update [mem 0x00000000-0x00000fff] usable ==>
reserved
[    0.000000] e820: remove [mem 0x000a0000-0x000fffff] usable
[    0.000000] No AGP bridge found
[    0.000000] e820: last_pfn = 0x120000 max_arch_pfn = 0x400000000
[    0.000000] MTRR default type: uncachable
[    0.000000] MTRR fixed ranges enabled:
[    0.000000]   00000-9FFFF write-back
[    0.000000]   A0000-BFFFF uncachable
[    0.000000]   C0000-C7FFF write-protect
[    0.000000]   C8000-FFFFF uncachable
[    0.000000] MTRR variable ranges enabled:
[    0.000000]   0 base 0000000000 mask FF80000000 write-back
[    0.000000]   1 base 0080000000 mask FFC0000000 write-back
[    0.000000]   2 base 00C0000000 mask FFF0000000 write-back
[    0.000000]   3 base 00D0000000 mask FFF8000000 write-back
[    0.000000]   4 base 00D7F00000 mask FFFFF00000 uncachable
[    0.000000]   5 base 0100000000 mask FFE0000000 write-back
[    0.000000]   6 disabled
[    0.000000]   7 disabled
[    0.000000] TOM2: 0000000120000000 aka 4608M
[    0.000000] x86 PAT enabled: cpu 0, old 0x7040600070406, new
0x7010600070106
[    0.000000] e820: update [mem 0xd7f00000-0xffffffff] usable ==>
reserved
[    0.000000] e820: last_pfn = 0xd7ee0 max_arch_pfn = 0x400000000
[    0.000000] found SMP MP-table at [mem 0x000f6580-0x000f658f]
mapped at [ffff8800000f6580]
[    0.000000] Base memory trampoline at [ffff880000099000] 99000 size
24576
[    0.000000] init_memory_mapping: [mem 0x00000000-0x000fffff]
[    0.000000]  [mem 0x00000000-0x000fffff] page 4k
[    0.000000] BRK [0x0184a000, 0x0184afff] PGTABLE
[    0.000000] BRK [0x0184b000, 0x0184bfff] PGTABLE
[    0.000000] BRK [0x0184c000, 0x0184cfff] PGTABLE
[    0.000000] init_memory_mapping: [mem 0x11fe00000-0x11fffffff]
[    0.000000]  [mem 0x11fe00000-0x11fffffff] page 2M
[    0.000000] BRK [0x0184d000, 0x0184dfff] PGTABLE
[    0.000000] init_memory_mapping: [mem 0x11c000000-0x11fdfffff]
[    0.000000]  [mem 0x11c000000-0x11fdfffff] page 2M
[    0.000000] init_memory_mapping: [mem 0x100000000-0x11bffffff]
[    0.000000]  [mem 0x100000000-0x11bffffff] page 2M
[    0.000000] init_memory_mapping: [mem 0x00100000-0xd7edffff]
[    0.000000]  [mem 0x00100000-0x001fffff] page 4k
[    0.000000]  [mem 0x00200000-0xd7dfffff] page 2M
[    0.000000]  [mem 0xd7e00000-0xd7edffff] page 4k
[    0.000000] RAMDISK: [mem 0x27a84000-0x2fd39fff]
[    0.000000] ACPI: RSDP 00000000000f8170 00024 (v02 ATI   )
[    0.000000] ACPI: XSDT 00000000d7ee30c0 00054 (v01 _ASUS_ Notebook
42302E31 AWRD 00000000)
[    0.000000] ACPI: FACP 00000000d7ee8480 000F4 (v03 _ASUS_ Notebook
42302E31 AWRD 00000000)
[    0.000000] ACPI: DSDT 00000000d7ee3240 051D3 (v01 _ASUS_ Notebook
00001000 MSFT 03000000)
[    0.000000] ACPI: FACS 00000000d7ee0000 00040
[    0.000000] ACPI: SLIC 00000000d7ee8680 00176 (v01 _ASUS_ Notebook
42302E31 AWRD 00000000)
[    0.000000] ACPI: SSDT 00000000d7ee8840 0030E (v01 _ASUS_ Notebook
00000001  LTP 00000001)
[    0.000000] ACPI: HPET 00000000d7ee8bc0 00038 (v01 _ASUS_ Notebook
42302E31 AWRD 00000098)
[    0.000000] ACPI: MCFG 00000000d7ee8c40 0003C (v01 _ASUS_ Notebook
42302E31 AWRD 00000000)
[    0.000000] ACPI: APIC 00000000d7ee85c0 00068 (v01 _ASUS_ Notebook
42302E31 AWRD 00000000)
[    0.000000] ACPI: Local APIC address 0xfee00000
[    0.000000] Scanning NUMA topology in Northbridge 24
[    0.000000] No NUMA configuration found
[    0.000000] Faking a node at [mem
0x0000000000000000-0x000000011fffffff]
[    0.000000] Initmem setup node 0 [mem 0x00000000-0x11fffffff]
[    0.000000]   NODE_DATA [mem 0x11fff8000-0x11fffbfff]
[    0.000000]  [ffffea0000000000-ffffea0003ffffff] PMD ->
[ffff88011b800000-ffff88011effffff] on node 0
[    0.000000] Zone ranges:
[    0.000000]   DMA      [mem 0x00001000-0x00ffffff]
[    0.000000]   DMA32    [mem 0x01000000-0xffffffff]
[    0.000000]   Normal   [mem 0x100000000-0x11fffffff]
[    0.000000] Movable zone start for each node
[    0.000000] Early memory node ranges
[    0.000000]   node   0: [mem 0x00001000-0x0009efff]
[    0.000000]   node   0: [mem 0x00100000-0xd7edffff]
[    0.000000]   node   0: [mem 0x100000000-0x11fffffff]
[    0.000000] On node 0 totalpages: 1015422
[    0.000000]   DMA zone: 56 pages used for memmap
[    0.000000]   DMA zone: 21 pages reserved
[    0.000000]   DMA zone: 3998 pages, LIFO batch:0
[    0.000000]   DMA32 zone: 12037 pages used for memmap
[    0.000000]   DMA32 zone: 880352 pages, LIFO batch:31
[    0.000000]   Normal zone: 1792 pages used for memmap
[    0.000000]   Normal zone: 131072 pages, LIFO batch:31
[    0.000000] ACPI: PM-Timer IO Port: 0x4008
[    0.000000] ACPI: Local APIC address 0xfee00000
[    0.000000] ACPI: LAPIC (acpi_id[0x00] lapic_id[0x00] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x01] lapic_id[0x01] enabled)
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x00] high edge lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x01] high edge lint[0x1])
[    0.000000] ACPI: IOAPIC (id[0x02] address[0xfec00000] gsi_base[0])
[    0.000000] IOAPIC[0]: apic_id 2, version 33, address 0xfec00000,
GSI 0-23
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 0 global_irq 2 dfl dfl)
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 9 global_irq 9 low level)
[    0.000000] ACPI: IRQ0 used by override.
[    0.000000] ACPI: IRQ2 used by override.
[    0.000000] ACPI: IRQ9 used by override.
[    0.000000] Using ACPI (MADT) for SMP configuration information
[    0.000000] ACPI: HPET id: 0x8200 base: 0xfed00000
[    0.000000] smpboot: Allowing 2 CPUs, 0 hotplug CPUs
[    0.000000] nr_irqs_gsi: 40
[    0.000000] PM: Registered nosave memory: 000000000009f000 -
00000000000a0000
[    0.000000] PM: Registered nosave memory: 00000000000a0000 -
00000000000f0000
[    0.000000] PM: Registered nosave memory: 00000000000f0000 -
0000000000100000
[    0.000000] PM: Registered nosave memory: 00000000d7ee0000 -
00000000d7ee3000
[    0.000000] PM: Registered nosave memory: 00000000d7ee3000 -
00000000d7ef0000
[    0.000000] PM: Registered nosave memory: 00000000d7ef0000 -
00000000d7f00000
[    0.000000] PM: Registered nosave memory: 00000000d7f00000 -
00000000e0000000
[    0.000000] PM: Registered nosave memory: 00000000e0000000 -
00000000f0000000
[    0.000000] PM: Registered nosave memory: 00000000f0000000 -
00000000fec00000
[    0.000000] PM: Registered nosave memory: 00000000fec00000 -
0000000100000000
[    0.000000] e820: [mem 0xf0000000-0xfebfffff] available for PCI devices
[    0.000000] setup_percpu: NR_CPUS:512 nr_cpumask_bits:512
nr_cpu_ids:2 nr_node_ids:1
[    0.000000] PERCPU: Embedded 27 pages/cpu @ffff88011fc00000 s80512
r8192 d21888 u1048576
[    0.000000] pcpu-alloc: s80512 r8192 d21888 u1048576 alloc=1*2097152
[    0.000000] pcpu-alloc: [0] 0 1
[    0.000000] Built 1 zonelists in Node order, mobility grouping on.
 Total pages: 1001516
[    0.000000] Policy zone: Normal
[    0.000000] Kernel command line: BOOT_IMAGE=/boot/vmlinuz-3.10.3
root=UUID=21d0d91e-b4cf-4571-b265-5d6165653a75 ro quiet
[    0.000000] PID hash table entries: 4096 (order: 3, 32768 bytes)
[    0.000000] Checking aperture...
[    0.000000] No AGP bridge found
[    0.000000] Node 0: aperture @ cc000000 size 32 MB
[    0.000000] Aperture pointing to e820 RAM. Ignoring.
[    0.000000] Your BIOS doesn't leave a aperture memory hole
[    0.000000] Please enable the IOMMU option in the BIOS setup
[    0.000000] This costs you 64 MB of RAM
[    0.000000] Mapping aperture over 65536 KB of RAM @ cc000000
[    0.000000] PM: Registered nosave memory: 00000000cc000000 -
00000000d0000000
[    0.000000] Memory: 3729820k/4718592k available (3516k kernel code,
656904k absent, 331868k reserved, 3217k data, 868k init)
[    0.000000] Hierarchical RCU implementation.
[    0.000000] 	RCU dyntick-idle grace-period acceleration is enabled.
[    0.000000] 	RCU restricting CPUs from NR_CPUS=512 to nr_cpu_ids=2.
[    0.000000] NR_IRQS:33024 nr_irqs:512 16
[    0.000000] spurious 8259A interrupt: IRQ7.
[    0.000000] Console: colour VGA+ 80x25
[    0.000000] console [tty0] enabled
[    0.000000] hpet clockevent registered
[    0.000000] tsc: Fast TSC calibration using PIT
[    0.000000] tsc: Detected 2999.843 MHz processor
[    0.000000] tsc: Marking TSC unstable due to TSCs unsynchronized
[    0.004004] Calibrating delay loop (skipped), value calculated
using timer frequency.. 5999.68 BogoMIPS (lpj=11999372)
[    0.004007] pid_max: default: 32768 minimum: 301
[    0.004042] Security Framework initialized
[    0.004047] AppArmor: AppArmor disabled by boot time parameter
[    0.004297] Dentry cache hash table entries: 524288 (order: 10,
4194304 bytes)
[    0.006325] Inode-cache hash table entries: 262144 (order: 9,
2097152 bytes)
[    0.007206] Mount-cache hash table entries: 256
[    0.007427] Initializing cgroup subsys devices
[    0.007430] Initializing cgroup subsys freezer
[    0.007432] Initializing cgroup subsys net_cls
[    0.007434] Initializing cgroup subsys blkio
[    0.007435] Initializing cgroup subsys perf_event
[    0.007464] tseg: 00d7f00000
[    0.007466] CPU: Physical Processor ID: 0
[    0.007468] CPU: Processor Core ID: 0
[    0.007470] mce: CPU supports 5 MCE banks
[    0.007477] LVT offset 0 assigned for vector 0xf9
[    0.007480] process: using AMD E400 aware idle routine
[    0.007483] Last level iTLB entries: 4KB 512, 2MB 8, 4MB 4
[    0.007483] Last level dTLB entries: 4KB 512, 2MB 8, 4MB 4
[    0.007483] tlb_flushall_shift: 4
[    0.007534] Freeing SMP alternatives: 8k freed
[    0.007541] ACPI: Core revision 20130328
[    0.009710] ACPI: All ACPI Tables successfully acquired
[    0.012696] ..TIMER: vector=0x30 apic1=0 pin1=2 apic2=-1 pin2=-1
[    0.054285] smpboot: CPU0: AMD Athlon(tm) 64 X2 Dual Core Processor
6000+ (fam: 0f, model: 43, stepping: 03)
[    0.056000] Performance Events: AMD PMU driver.
[    0.056000] ... version:                0
[    0.056000] ... bit width:              48
[    0.056000] ... generic registers:      4
[    0.056000] ... value mask:             0000ffffffffffff
[    0.056000] ... max period:             00007fffffffffff
[    0.056000] ... fixed-purpose events:   0
[    0.056000] ... event mask:             000000000000000f
[    0.056000] NMI watchdog: enabled on all CPUs, permanently consumes
one hw-PMU counter.
[    0.056000] smpboot: Booting Node   0, Processors  #1 OK
[    0.140045] Brought up 2 CPUs
[    0.140047] smpboot: Total of 2 processors activated (11999.41
BogoMIPS)
[    0.144062] devtmpfs: initialized
[    0.146971] PM: Registering ACPI NVS region [mem
0xd7ee0000-0xd7ee2fff] (12288 bytes)
[    0.146971] regulator-dummy: no parameters
[    0.146971] NET: Registered protocol family 16
[    0.146971] node 0 link 0: io port [c000, ffff]
[    0.146971] TOM: 00000000e0000000 aka 3584M
[    0.146971] node 0 link 0: mmio [a0000, bffff]
[    0.146971] node 0 link 0: mmio [f0000000, f7ffffff]
[    0.146971] node 0 link 0: mmio [e0000000, dfffffff]
[    0.146971] node 0 link 0: mmio [f8000000, fe02ffff]
[    0.146971] node 0 link 0: mmio [e0000000, e03fffff]
[    0.146971] TOM2: 0000000120000000 aka 4608M
[    0.146971] bus: [bus 00-03] on node 0 link 0
[    0.146971] bus: 00 [io  0x0000-0xffff]
[    0.146971] bus: 00 [mem 0x000a0000-0x000bffff]
[    0.146971] bus: 00 [mem 0xe0400000-0xffffffff]
[    0.146971] bus: 00 [mem 0xe0000000-0xe03fffff]
[    0.146971] bus: 00 [mem 0x120000000-0xfcffffffff]
[    0.146971] ACPI: bus type PCI registered
[    0.146971] acpiphp: ACPI Hot Plug PCI Controller Driver version: 0.5
[    0.146971] PCI: MMCONFIG for domain 0000 [bus 00-ff] at [mem
0xe0000000-0xefffffff] (base 0xe0000000)
[    0.146971] PCI: MMCONFIG at [mem 0xe0000000-0xefffffff] reserved
in E820
[    0.156267] PCI: Using configuration type 1 for base access
[    0.157029] bio: create slab <bio-0> at 0
[    0.157029] ACPI: Added _OSI(Module Device)
[    0.157029] ACPI: Added _OSI(Processor Device)
[    0.157029] ACPI: Added _OSI(3.0 _SCP Extensions)
[    0.157029] ACPI: Added _OSI(Processor Aggregator Device)
[    0.157029] ACPI: EC: Look up EC in DSDT
[    0.162409] ACPI: Interpreter enabled
[    0.162420] ACPI Exception: AE_NOT_FOUND, While evaluating Sleep
State [\_S2_] (20130328/hwxface-568)
[    0.162433] ACPI: (supports S0 S1 S3 S4 S5)
[    0.162434] ACPI: Using IOAPIC for interrupt routing
[    0.162484] PCI: Ignoring host bridge windows from ACPI; if
necessary, use "pci=use_crs" and report a bug
[    0.162558] ACPI: No dock devices found.
[    0.168137] ACPI: PCI Root Bridge [PCI0] (domain 0000 [bus 00-ff])
[    0.168248] acpi PNP0A03:00: host bridge window [io  0x0000-0x0cf7]
(ignored)
[    0.168250] acpi PNP0A03:00: host bridge window [io  0x0d00-0xffff]
(ignored)
[    0.168253] acpi PNP0A03:00: host bridge window [mem
0x000a0000-0x000bffff] (ignored)
[    0.168255] acpi PNP0A03:00: host bridge window [mem
0x000c0000-0x000dffff] (ignored)
[    0.168258] acpi PNP0A03:00: host bridge window [mem
0xe0000000-0xfebfffff] (ignored)
[    0.168260] PCI: root bus 00: hardware-probed resources
[    0.168349] PCI host bridge to bus 0000:00
[    0.168352] pci_bus 0000:00: root bus resource [bus 00-ff]
[    0.168355] pci_bus 0000:00: root bus resource [io  0x0000-0xffff]
[    0.168357] pci_bus 0000:00: root bus resource [mem
0x000a0000-0x000bffff]
[    0.168360] pci_bus 0000:00: root bus resource [mem
0xe0400000-0xffffffff]
[    0.168362] pci_bus 0000:00: root bus resource [mem
0xe0000000-0xe03fffff]
[    0.168365] pci_bus 0000:00: root bus resource [mem
0x120000000-0xfcffffffff]
[    0.168373] pci 0000:00:00.0: [1002:7910] type 00 class 0x060000
[    0.168467] pci 0000:00:01.0: [1002:7912] type 01 class 0x060400
[    0.168571] pci 0000:00:07.0: [1002:7917] type 01 class 0x060400
[    0.168598] pci 0000:00:07.0: PME# supported from D0 D3hot D3cold
[    0.168642] pci 0000:00:07.0: System wakeup disabled by ACPI
[    0.168700] pci 0000:00:12.0: [1002:4380] type 00 class 0x01018f
[    0.168720] pci 0000:00:12.0: reg 10: [io  0xff00-0xff07]
[    0.168730] pci 0000:00:12.0: reg 14: [io  0xfe00-0xfe03]
[    0.168740] pci 0000:00:12.0: reg 18: [io  0xfd00-0xfd07]
[    0.168750] pci 0000:00:12.0: reg 1c: [io  0xfc00-0xfc03]
[    0.168760] pci 0000:00:12.0: reg 20: [io  0xfb00-0xfb0f]
[    0.168770] pci 0000:00:12.0: reg 24: [mem 0xfe02f000-0xfe02f3ff]
[    0.168792] pci 0000:00:12.0: set SATA to AHCI mode
[    0.168888] pci 0000:00:13.0: [1002:4387] type 00 class 0x0c0310
[    0.168902] pci 0000:00:13.0: reg 10: [mem 0xfe02e000-0xfe02efff]
[    0.168971] pci 0000:00:13.0: System wakeup disabled by ACPI
[    0.169011] pci 0000:00:13.1: [1002:4388] type 00 class 0x0c0310
[    0.169025] pci 0000:00:13.1: reg 10: [mem 0xfe02d000-0xfe02dfff]
[    0.169095] pci 0000:00:13.1: System wakeup disabled by ACPI
[    0.169136] pci 0000:00:13.2: [1002:4389] type 00 class 0x0c0310
[    0.169150] pci 0000:00:13.2: reg 10: [mem 0xfe02c000-0xfe02cfff]
[    0.169222] pci 0000:00:13.2: System wakeup disabled by ACPI
[    0.169262] pci 0000:00:13.3: [1002:438a] type 00 class 0x0c0310
[    0.169276] pci 0000:00:13.3: reg 10: [mem 0xfe02b000-0xfe02bfff]
[    0.169349] pci 0000:00:13.3: System wakeup disabled by ACPI
[    0.169389] pci 0000:00:13.4: [1002:438b] type 00 class 0x0c0310
[    0.169403] pci 0000:00:13.4: reg 10: [mem 0xfe02a000-0xfe02afff]
[    0.169479] pci 0000:00:13.4: System wakeup disabled by ACPI
[    0.169527] pci 0000:00:13.5: [1002:4386] type 00 class 0x0c0320
[    0.169546] pci 0000:00:13.5: reg 10: [mem 0xfe029000-0xfe0290ff]
[    0.169630] pci 0000:00:13.5: supports D1 D2
[    0.169632] pci 0000:00:13.5: PME# supported from D0 D1 D2 D3hot
[    0.169662] pci 0000:00:13.5: System wakeup disabled by ACPI
[    0.169708] pci 0000:00:14.0: [1002:4385] type 00 class 0x0c0500
[    0.169730] pci 0000:00:14.0: reg 10: [io  0x0b00-0x0b0f]
[    0.169740] pci 0000:00:14.0: reg 14: [mem 0xfed00000-0xfed003ff]
[    0.169850] pci 0000:00:14.1: [1002:438c] type 00 class 0x010182
[    0.169867] pci 0000:00:14.1: reg 10: [io  0x0000-0x0007]
[    0.169877] pci 0000:00:14.1: reg 14: [io  0x0000-0x0003]
[    0.169887] pci 0000:00:14.1: reg 18: [io  0x0000-0x0007]
[    0.169897] pci 0000:00:14.1: reg 1c: [io  0x0000-0x0003]
[    0.169907] pci 0000:00:14.1: reg 20: [io  0xf900-0xf90f]
[    0.170016] pci 0000:00:14.2: [1002:4383] type 00 class 0x040300
[    0.170040] pci 0000:00:14.2: reg 10: [mem 0xfe020000-0xfe023fff 64bit]
[    0.170118] pci 0000:00:14.2: PME# supported from D0 D3hot D3cold
[    0.170149] pci 0000:00:14.2: System wakeup disabled by ACPI
[    0.170190] pci 0000:00:14.3: [1002:438d] type 00 class 0x060100
[    0.170317] pci 0000:00:14.4: [1002:4384] type 01 class 0x060401
[    0.170377] pci 0000:00:14.4: System wakeup disabled by ACPI
[    0.170421] pci 0000:00:18.0: [1022:1100] type 00 class 0x060000
[    0.170506] pci 0000:00:18.1: [1022:1101] type 00 class 0x060000
[    0.170588] pci 0000:00:18.2: [1022:1102] type 00 class 0x060000
[    0.170670] pci 0000:00:18.3: [1022:1103] type 00 class 0x060000
[    0.170794] pci 0000:01:05.0: [1002:791e] type 00 class 0x030000
[    0.170803] pci 0000:01:05.0: reg 10: [mem 0xf0000000-0xf7ffffff
64bit pref]
[    0.170808] pci 0000:01:05.0: reg 18: [mem 0xfdcf0000-0xfdcfffff 64bit]
[    0.170812] pci 0000:01:05.0: reg 20: [io  0xde00-0xdeff]
[    0.170817] pci 0000:01:05.0: reg 24: [mem 0xfdb00000-0xfdbfffff]
[    0.170831] pci 0000:01:05.0: supports D1 D2
[    0.170870] pci 0000:00:01.0: PCI bridge to [bus 01]
[    0.170873] pci 0000:00:01.0:   bridge window [io  0xd000-0xdfff]
[    0.170876] pci 0000:00:01.0:   bridge window [mem
0xfdb00000-0xfdcfffff]
[    0.170879] pci 0000:00:01.0:   bridge window [mem
0xf0000000-0xf7ffffff 64bit pref]
[    0.170932] pci 0000:02:00.0: [10ec:8168] type 00 class 0x020000
[    0.170947] pci 0000:02:00.0: reg 10: [io  0xee00-0xeeff]
[    0.170971] pci 0000:02:00.0: reg 18: [mem 0xfdaff000-0xfdafffff 64bit]
[    0.170998] pci 0000:02:00.0: reg 30: [mem 0x00000000-0x0001ffff pref]
[    0.171058] pci 0000:02:00.0: supports D1 D2
[    0.171060] pci 0000:02:00.0: PME# supported from D1 D2 D3hot D3cold
[    0.171108] pci 0000:02:00.0: disabling ASPM on pre-1.1 PCIe
device.  You can enable it with 'pcie_aspm=force'
[    0.171116] pci 0000:00:07.0: PCI bridge to [bus 02]
[    0.171120] pci 0000:00:07.0:   bridge window [io  0xe000-0xefff]
[    0.171122] pci 0000:00:07.0:   bridge window [mem
0xfda00000-0xfdafffff]
[    0.171126] pci 0000:00:07.0:   bridge window [mem
0xfdf00000-0xfdffffff 64bit pref]
[    0.171178] pci 0000:03:07.0: [1106:3044] type 00 class 0x0c0010
[    0.171201] pci 0000:03:07.0: reg 10: [mem 0xfdeff000-0xfdeff7ff]
[    0.171214] pci 0000:03:07.0: reg 14: [io  0xcf00-0xcf7f]
[    0.171307] pci 0000:03:07.0: supports D2
[    0.171309] pci 0000:03:07.0: PME# supported from D2 D3hot D3cold
[    0.171389] pci 0000:00:14.4: PCI bridge to [bus 03] (subtractive
decode)
[    0.171394] pci 0000:00:14.4:   bridge window [io  0xc000-0xcfff]
[    0.171398] pci 0000:00:14.4:   bridge window [mem
0xfde00000-0xfdefffff]
[    0.171403] pci 0000:00:14.4:   bridge window [mem
0xfdd00000-0xfddfffff pref]
[    0.171405] pci 0000:00:14.4:   bridge window [io  0x0000-0xffff]
(subtractive decode)
[    0.171408] pci 0000:00:14.4:   bridge window [mem
0x000a0000-0x000bffff] (subtractive decode)
[    0.171410] pci 0000:00:14.4:   bridge window [mem
0xe0400000-0xffffffff] (subtractive decode)
[    0.171413] pci 0000:00:14.4:   bridge window [mem
0xe0000000-0xe03fffff] (subtractive decode)
[    0.171416] pci 0000:00:14.4:   bridge window [mem
0x120000000-0xfcffffffff] (subtractive decode)
[    0.171428] acpi PNP0A03:00: ACPI _OSC support notification failed,
disabling PCIe ASPM
[    0.171430] acpi PNP0A03:00: Unable to request _OSC control (_OSC
support mask: 0x08)
[    0.171505] ACPI: PCI Interrupt Link [LNKA] (IRQs 3 4 5 6 7 10 11)
*0, disabled.
[    0.171563] ACPI: PCI Interrupt Link [LNKB] (IRQs 3 4 5 6 7 10 11)
*0, disabled.
[    0.171620] ACPI: PCI Interrupt Link [LNKC] (IRQs 3 4 5 6 7 10 11)
*0, disabled.
[    0.171678] ACPI: PCI Interrupt Link [LNKD] (IRQs 3 4 5 6 7 10 11)
*0, disabled.
[    0.171735] ACPI: PCI Interrupt Link [LNKE] (IRQs 3 4 5 6 7 10 11)
*0, disabled.
[    0.171792] ACPI: PCI Interrupt Link [LNKF] (IRQs 3 4 5 6 7 10 11)
*0, disabled.
[    0.171849] ACPI: PCI Interrupt Link [LNK0] (IRQs 3 4 5 6 7 10 *11)
[    0.171905] ACPI: PCI Interrupt Link [LNK1] (IRQs 3 4 5 6 7 10 11)
*0, disabled.
[    0.172540] acpi root: \_SB_.PCI0 notify handler is installed
[    0.172564] Found 1 acpi root devices
[    0.172627] vgaarb: device added:
PCI:0000:01:05.0,decodes=io+mem,owns=io+mem,locks=none
[    0.172627] vgaarb: loaded
[    0.172627] vgaarb: bridge control possible 0000:01:05.0
[    0.172627] PCI: Using ACPI for IRQ routing
[    0.181569] PCI: pci_cache_line_size set to 64 bytes
[    0.181616] Expanded resource reserved due to conflict with PCI Bus #00
[    0.181619] e820: reserve RAM buffer [mem 0x0009f000-0x0009ffff]
[    0.181621] e820: reserve RAM buffer [mem 0xd7ee0000-0xd7ffffff]
[    0.181751] hpet0: at MMIO 0xfed00000, IRQs 2, 8, 0, 0
[    0.181755] hpet0: 4 comparators, 32-bit 14.318180 MHz counter
[    0.183783] Switching to clocksource hpet
[    0.183793] pnp: PnP ACPI init
[    0.183793] ACPI: bus type PNP registered
[    0.183793] pnp 00:00: disabling [mem 0x00000000-0x00000fff window]
because it overlaps 0000:02:00.0 BAR 6 [mem 0x00000000-0x0001ffff pref]
[    0.183793] system 00:00: [io  0x4100-0x411f] has been reserved
[    0.183793] system 00:00: [io  0x0228-0x022f] has been reserved
[    0.183793] system 00:00: [io  0x040b] has been reserved
[    0.183793] system 00:00: [io  0x04d6] has been reserved
[    0.183793] system 00:00: [io  0x0c00-0x0c01] has been reserved
[    0.183793] system 00:00: [io  0x0c14] has been reserved
[    0.183793] system 00:00: [io  0x0c50-0x0c52] has been reserved
[    0.183793] system 00:00: [io  0x0c6c-0x0c6d] has been reserved
[    0.183793] system 00:00: [io  0x0c6f] has been reserved
[    0.183793] system 00:00: [io  0x0cd0-0x0cd1] has been reserved
[    0.183793] system 00:00: [io  0x0cd2-0x0cd3] has been reserved
[    0.183793] system 00:00: [io  0x0cd4-0x0cdf] has been reserved
[    0.183793] system 00:00: [io  0x4000-0x40fe] has been reserved
[    0.183793] system 00:00: [io  0x4210-0x4217] has been reserved
[    0.183793] system 00:00: [io  0x0b00-0x0b0f] has been reserved
[    0.183793] system 00:00: [io  0x0b10-0x0b1f] has been reserved
[    0.183793] system 00:00: [mem 0xfee00400-0xfee00fff window] has
been reserved
[    0.183793] system 00:00: Plug and Play ACPI device, IDs PNP0c02
(active)
[    0.183793] pnp 00:01: [dma 4]
[    0.183793] pnp 00:01: Plug and Play ACPI device, IDs PNP0200 (active)
[    0.183793] pnp 00:02: Plug and Play ACPI device, IDs PNP0103 (active)
[    0.183793] pnp 00:03: Plug and Play ACPI device, IDs PNP0b00 (active)
[    0.183793] pnp 00:04: Plug and Play ACPI device, IDs PNP0800 (active)
[    0.183793] pnp 00:05: Plug and Play ACPI device, IDs PNP0c04 (active)
[    0.183793] system 00:06: [io  0x04d0-0x04d1] has been reserved
[    0.183793] system 00:06: [io  0x0220-0x0225] has been reserved
[    0.183793] system 00:06: Plug and Play ACPI device, IDs PNP0c02
(active)
[    0.183793] pnp 00:07: Plug and Play ACPI device, IDs PNP0501 (active)
[    0.183793] pnp 00:08: Plug and Play ACPI device, IDs PNP0400 (active)
[    0.183793] pnp 00:09: Plug and Play ACPI device, IDs PNP0f13 (active)
[    0.183793] pnp 00:0a: Plug and Play ACPI device, IDs PNP0303
PNP030b (active)
[    0.183793] system 00:0b: [mem 0xe0000000-0xefffffff] could not be
reserved
[    0.183793] system 00:0b: Plug and Play ACPI device, IDs PNP0c02
(active)
[    0.183793] pnp 00:0c: disabling [mem 0xfed00000-0xfed000ff]
because it overlaps 0000:00:14.0 BAR 1 [mem 0xfed00000-0xfed003ff]
[    0.183793] system 00:0c: [mem 0x000cd400-0x000cffff] has been reserved
[    0.183793] system 00:0c: [mem 0x000f0000-0x000f7fff] could not be
reserved
[    0.183793] system 00:0c: [mem 0x000f8000-0x000fbfff] could not be
reserved
[    0.183793] system 00:0c: [mem 0x000fc000-0x000fffff] could not be
reserved
[    0.183793] system 00:0c: [mem 0xd7ef0000-0xd7feffff] could not be
reserved
[    0.183793] system 00:0c: [mem 0xd7ee0000-0xd7efffff] could not be
reserved
[    0.183793] system 00:0c: [mem 0xffff0000-0xffffffff] has been reserved
[    0.183793] system 00:0c: [mem 0x00000000-0x0009ffff] could not be
reserved
[    0.183793] system 00:0c: [mem 0x00100000-0xd7edffff] could not be
reserved
[    0.183793] system 00:0c: [mem 0xd7ff0000-0xdffeffff] could not be
reserved
[    0.183793] system 00:0c: [mem 0xfec00000-0xfec00fff] could not be
reserved
[    0.183793] system 00:0c: [mem 0xfee00000-0xfee00fff] could not be
reserved
[    0.183796] system 00:0c: [mem 0xfff80000-0xfffeffff] has been reserved
[    0.183799] system 00:0c: Plug and Play ACPI device, IDs PNP0c01
(active)
[    0.183818] pnp: PnP ACPI: found 13 devices
[    0.183820] ACPI: bus type PNP unregistered
[    0.191178] pci 0000:00:01.0: PCI bridge to [bus 01]
[    0.191181] pci 0000:00:01.0:   bridge window [io  0xd000-0xdfff]
[    0.191184] pci 0000:00:01.0:   bridge window [mem
0xfdb00000-0xfdcfffff]
[    0.191187] pci 0000:00:01.0:   bridge window [mem
0xf0000000-0xf7ffffff 64bit pref]
[    0.191193] pci 0000:02:00.0: BAR 6: assigned [mem
0xfdf00000-0xfdf1ffff pref]
[    0.191196] pci 0000:00:07.0: PCI bridge to [bus 02]
[    0.191198] pci 0000:00:07.0:   bridge window [io  0xe000-0xefff]
[    0.191201] pci 0000:00:07.0:   bridge window [mem
0xfda00000-0xfdafffff]
[    0.191204] pci 0000:00:07.0:   bridge window [mem
0xfdf00000-0xfdffffff 64bit pref]
[    0.191207] pci 0000:00:14.4: PCI bridge to [bus 03]
[    0.191210] pci 0000:00:14.4:   bridge window [io  0xc000-0xcfff]
[    0.191216] pci 0000:00:14.4:   bridge window [mem
0xfde00000-0xfdefffff]
[    0.191220] pci 0000:00:14.4:   bridge window [mem
0xfdd00000-0xfddfffff pref]
[    0.191236] pci_bus 0000:00: resource 4 [io  0x0000-0xffff]
[    0.191238] pci_bus 0000:00: resource 5 [mem 0x000a0000-0x000bffff]
[    0.191240] pci_bus 0000:00: resource 6 [mem 0xe0400000-0xffffffff]
[    0.191243] pci_bus 0000:00: resource 7 [mem 0xe0000000-0xe03fffff]
[    0.191245] pci_bus 0000:00: resource 8 [mem 0x120000000-0xfcffffffff]
[    0.191248] pci_bus 0000:01: resource 0 [io  0xd000-0xdfff]
[    0.191250] pci_bus 0000:01: resource 1 [mem 0xfdb00000-0xfdcfffff]
[    0.191253] pci_bus 0000:01: resource 2 [mem 0xf0000000-0xf7ffffff
64bit pref]
[    0.191255] pci_bus 0000:02: resource 0 [io  0xe000-0xefff]
[    0.191258] pci_bus 0000:02: resource 1 [mem 0xfda00000-0xfdafffff]
[    0.191260] pci_bus 0000:02: resource 2 [mem 0xfdf00000-0xfdffffff
64bit pref]
[    0.191263] pci_bus 0000:03: resource 0 [io  0xc000-0xcfff]
[    0.191265] pci_bus 0000:03: resource 1 [mem 0xfde00000-0xfdefffff]
[    0.191268] pci_bus 0000:03: resource 2 [mem 0xfdd00000-0xfddfffff
pref]
[    0.191270] pci_bus 0000:03: resource 4 [io  0x0000-0xffff]
[    0.191273] pci_bus 0000:03: resource 5 [mem 0x000a0000-0x000bffff]
[    0.191275] pci_bus 0000:03: resource 6 [mem 0xe0400000-0xffffffff]
[    0.191278] pci_bus 0000:03: resource 7 [mem 0xe0000000-0xe03fffff]
[    0.191280] pci_bus 0000:03: resource 8 [mem 0x120000000-0xfcffffffff]
[    0.191334] NET: Registered protocol family 2
[    0.191558] TCP established hash table entries: 32768 (order: 7,
524288 bytes)
[    0.191800] TCP bind hash table entries: 32768 (order: 7, 524288 bytes)
[    0.192033] TCP: Hash tables configured (established 32768 bind 32768)
[    0.192114] TCP: reno registered
[    0.192122] UDP hash table entries: 2048 (order: 4, 65536 bytes)
[    0.192157] UDP-Lite hash table entries: 2048 (order: 4, 65536 bytes)
[    0.192279] NET: Registered protocol family 1
[    0.484285] pci 0000:01:05.0: Boot video device
[    0.484293] PCI: CLS 32 bytes, default 64
[    0.484342] Unpacking initramfs...
[    3.117430] Freeing initrd memory: 133848k freed
[    3.183676] PCI-DMA: Disabling AGP.
[    3.183753] PCI-DMA: aperture base @ cc000000 size 65536 KB
[    3.183755] PCI-DMA: using GART IOMMU.
[    3.183758] PCI-DMA: Reserving 64MB of IOMMU area in the AGP aperture
[    3.187475] audit: initializing netlink socket (disabled)
[    3.187490] type=2000 audit(1379400035.184:1): initialized
[    3.203527] bounce pool size: 64 pages
[    3.203533] HugeTLB registered 2 MB page size, pre-allocated 0 pages
[    3.205393] VFS: Disk quotas dquot_6.5.2
[    3.205418] Dquot-cache hash table entries: 512 (order 0, 4096 bytes)
[    3.205523] msgmni has been set to 7675
[    3.205707] alg: No test for stdrng (krng)
[    3.205729] Block layer SCSI generic (bsg) driver version 0.4
loaded (major 252)
[    3.205731] io scheduler noop registered
[    3.205732] io scheduler deadline registered
[    3.205742] io scheduler cfq registered (default)
[    3.205856] pcieport 0000:00:07.0: irq 40 for MSI/MSI-X
[    3.205929] pci_hotplug: PCI Hot Plug PCI Core version: 0.5
[    3.205948] pciehp: PCI Express Hot Plug Controller Driver version: 0.4
[    3.206043] GHES: HEST is not enabled!
[    3.206101] Serial: 8250/16550 driver, 4 ports, IRQ sharing enabled
[    3.226602] 00:07: ttyS0 at I/O 0x3f8 (irq = 4) is a 16550A
[    3.227072] Linux agpgart interface v0.103
[    3.227163] i8042: PNP: PS/2 Controller [PNP0303:PS2K,PNP0f13:PS2M]
at 0x60,0x64 irq 1,12
[    3.227569] serio: i8042 KBD port at 0x60,0x64 irq 1
[    3.227573] serio: i8042 AUX port at 0x60,0x64 irq 12
[    3.227711] mousedev: PS/2 mouse device common for all mice
[    3.227753] rtc_cmos 00:03: RTC can wake from S4
[    3.227879] rtc_cmos 00:03: rtc core: registered rtc_cmos as rtc0
[    3.227916] rtc_cmos 00:03: alarms up to one month, 242 bytes
nvram, hpet irqs
[    3.227925] cpuidle: using governor ladder
[    3.227927] cpuidle: using governor menu
[    3.227952] drop_monitor: Initializing network drop monitor service
[    3.228020] TCP: cubic registered
[    3.228057] NET: Registered protocol family 10
[    3.228244] mip6: Mobile IPv6
[    3.228246] NET: Registered protocol family 17
[    3.228257] Key type dns_resolver registered
[    3.228539] PM: Hibernation image not present or could not be loaded.
[    3.228548] registered taskstats version 1
[    3.230544] rtc_cmos 00:03: setting system clock to 2013-09-17
06:40:35 UTC (1379400035)
[    3.231527] Freeing unused kernel memory: 868k freed
[    3.231821] Write protecting the kernel read-only data: 6144k
[    3.233832] Freeing unused kernel memory: 572k freed
[    3.236020] Freeing unused kernel memory: 580k freed
[    3.263987] input: AT Translated Set 2 keyboard as
/devices/platform/i8042/serio0/input/input0
[    3.318600] udevd[58]: starting version 175
[    3.342887] r8169 Gigabit Ethernet driver 2.3LK-NAPI loaded
[    3.343136] r8169 0000:02:00.0: irq 41 for MSI/MSI-X
[    3.343327] r8169 0000:02:00.0 eth0: RTL8168b/8111b at
0xffffc90000646000, 00:1a:92:72:ac:4b, XID 18000000 IRQ 41
[    3.343329] r8169 0000:02:00.0 eth0: jumbo features [frames: 4080
bytes, tx checksumming: ko]
[    3.373552] ACPI: bus type USB registered
[    3.373588] usbcore: registered new interface driver usbfs
[    3.373600] usbcore: registered new interface driver hub
[    3.377405] SCSI subsystem initialized
[    3.382003] ACPI: bus type ATA registered
[    3.387849] usbcore: registered new device driver usb
[    3.389235] ehci_hcd: USB 2.0 'Enhanced' Host Controller (EHCI) Driver
[    3.390017] ohci_hcd: USB 1.1 'Open' Host Controller (OHCI) Driver
[    3.390182] ohci_hcd 0000:00:13.0: OHCI Host Controller
[    3.390190] ohci_hcd 0000:00:13.0: new USB bus registered, assigned
bus number 1
[    3.390232] ohci_hcd 0000:00:13.0: irq 16, io mem 0xfe02e000
[    3.398610] thermal LNXTHERM:00: registered as thermal_zone0
[    3.398613] ACPI: Thermal Zone [THRM] (40 C)
[    3.399377] ACPI: Fan [FAN] (on)
[    3.403829] libata version 3.00 loaded.
[    3.448050] usb usb1: New USB device found, idVendor=1d6b,
idProduct=0001
[    3.448055] usb usb1: New USB device strings: Mfr=3, Product=2,
SerialNumber=1
[    3.448057] usb usb1: Product: OHCI Host Controller
[    3.448059] usb usb1: Manufacturer: Linux 3.10.3 ohci_hcd
[    3.448061] usb usb1: SerialNumber: 0000:00:13.0
[    3.448189] hub 1-0:1.0: USB hub found
[    3.448199] hub 1-0:1.0: 2 ports detected
[    3.448320] ahci 0000:00:12.0: version 3.0
[    3.448441] ahci 0000:00:12.0: ASUS M2A-VM: BIOS too old, forcing
32bit DMA, update BIOS
[    3.448451] ahci 0000:00:12.0: controller can't do 64bit DMA,
forcing 32bit
[    3.448545] ahci 0000:00:12.0: AHCI 0001.0100 32 slots 4 ports 3
Gbps 0xf impl SATA mode
[    3.448548] ahci 0000:00:12.0: flags: ncq sntf ilck pm led clo pmp
pio slum part ccc
[    3.449305] scsi0 : ahci
[    3.449404] scsi1 : ahci
[    3.449475] scsi2 : ahci
[    3.449547] scsi3 : ahci
[    3.449614] ata1: SATA max UDMA/133 abar m1024@0xfe02f000 port
0xfe02f100 irq 22
[    3.449617] ata2: SATA max UDMA/133 abar m1024@0xfe02f000 port
0xfe02f180 irq 22
[    3.449620] ata3: SATA max UDMA/133 abar m1024@0xfe02f000 port
0xfe02f200 irq 22
[    3.449623] ata4: SATA max UDMA/133 abar m1024@0xfe02f000 port
0xfe02f280 irq 22
[    3.450180] scsi4 : pata_atiixp
[    3.451585] scsi5 : pata_atiixp
[    3.451651] ata5: PATA max UDMA/100 cmd 0x1f0 ctl 0x3f6 bmdma
0xf900 irq 14
[    3.451653] ata6: PATA max UDMA/100 cmd 0x170 ctl 0x376 bmdma
0xf908 irq 15
[    3.452727] ohci_hcd 0000:00:13.1: OHCI Host Controller
[    3.452734] ohci_hcd 0000:00:13.1: new USB bus registered, assigned
bus number 2
[    3.452776] ohci_hcd 0000:00:13.1: irq 17, io mem 0xfe02d000
[    3.456064] firewire_ohci 0000:03:07.0: added OHCI v1.10 device as
card 0, 4 IR + 8 IT contexts, quirks 0x11
[    3.512022] usb usb2: New USB device found, idVendor=1d6b,
idProduct=0001
[    3.512025] usb usb2: New USB device strings: Mfr=3, Product=2,
SerialNumber=1
[    3.512027] usb usb2: Product: OHCI Host Controller
[    3.512029] usb usb2: Manufacturer: Linux 3.10.3 ohci_hcd
[    3.512031] usb usb2: SerialNumber: 0000:00:13.1
[    3.512151] hub 2-0:1.0: USB hub found
[    3.512159] hub 2-0:1.0: 2 ports detected
[    3.512349] ohci_hcd 0000:00:13.2: OHCI Host Controller
[    3.512355] ohci_hcd 0000:00:13.2: new USB bus registered, assigned
bus number 3
[    3.512391] ohci_hcd 0000:00:13.2: irq 18, io mem 0xfe02c000
[    3.572018] usb usb3: New USB device found, idVendor=1d6b,
idProduct=0001
[    3.572020] usb usb3: New USB device strings: Mfr=3, Product=2,
SerialNumber=1
[    3.572022] usb usb3: Product: OHCI Host Controller
[    3.572024] usb usb3: Manufacturer: Linux 3.10.3 ohci_hcd
[    3.572026] usb usb3: SerialNumber: 0000:00:13.2
[    3.572126] hub 3-0:1.0: USB hub found
[    3.572133] hub 3-0:1.0: 2 ports detected
[    3.572287] ohci_hcd 0000:00:13.3: OHCI Host Controller
[    3.572292] ohci_hcd 0000:00:13.3: new USB bus registered, assigned
bus number 4
[    3.572307] ohci_hcd 0000:00:13.3: irq 17, io mem 0xfe02b000
[    3.616542] ata5.01: ATAPI: RICOH   CD-RW MP7320A, BP07, max UDMA/33
[    3.632484] usb usb4: New USB device found, idVendor=1d6b,
idProduct=0001
[    3.632487] usb usb4: New USB device strings: Mfr=3, Product=2,
SerialNumber=1
[    3.632489] usb usb4: Product: OHCI Host Controller
[    3.632491] usb usb4: Manufacturer: Linux 3.10.3 ohci_hcd
[    3.632492] usb usb4: SerialNumber: 0000:00:13.3
[    3.632495] ata5.01: configured for UDMA/33
[    3.632592] hub 4-0:1.0: USB hub found
[    3.632599] hub 4-0:1.0: 2 ports detected
[    3.632756] ohci_hcd 0000:00:13.4: OHCI Host Controller
[    3.632761] ohci_hcd 0000:00:13.4: new USB bus registered, assigned
bus number 5
[    3.632777] ohci_hcd 0000:00:13.4: irq 18, io mem 0xfe02a000
[    3.692014] usb usb5: New USB device found, idVendor=1d6b,
idProduct=0001
[    3.692017] usb usb5: New USB device strings: Mfr=3, Product=2,
SerialNumber=1
[    3.692019] usb usb5: Product: OHCI Host Controller
[    3.692020] usb usb5: Manufacturer: Linux 3.10.3 ohci_hcd
[    3.692022] usb usb5: SerialNumber: 0000:00:13.4
[    3.692114] hub 5-0:1.0: USB hub found
[    3.692121] hub 5-0:1.0: 2 ports detected
[    3.708330] device-mapper: uevent: version 1.0.3
[    3.708396] device-mapper: ioctl: 4.24.0-ioctl (2013-01-15)
initialised: dm-devel-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
[    3.768067] ata4: SATA link down (SStatus 0 SControl 300)
[    3.768104] ata3: SATA link down (SStatus 0 SControl 300)
[    3.940029] ata1: softreset failed (device not ready)
[    3.940064] ata1: applying PMP SRST workaround and retrying
[    3.940080] ata2: softreset failed (device not ready)
[    3.940117] ata2: applying PMP SRST workaround and retrying
[    3.956112] firewire_core 0000:03:07.0: created device fw0: GUID
0011d80001065823, S400
[    4.112032] ata1: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
[    4.112058] ata2: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
[    4.112628] ata1.00: ATA-9: Samsung SSD 840 PRO Series, DXM04B0Q,
max UDMA/133
[    4.112630] ata1.00: 500118192 sectors, multi 1: LBA48 NCQ (depth
31/32), AA
[    4.112702] ata1.00: SB600 AHCI: limiting to 255 sectors per cmd
[    4.112982] ata1.00: SB600 AHCI: limiting to 255 sectors per cmd
[    4.112984] ata1.00: configured for UDMA/133
[    4.113129] scsi 0:0:0:0: Direct-Access     ATA      Samsung SSD
840  DXM0 PQ: 0 ANSI: 5
[    4.116224] sd 0:0:0:0: [sda] 500118192 512-byte logical blocks:
(256 GB/238 GiB)
[    4.116292] sd 0:0:0:0: [sda] Write Protect is off
[    4.116294] sd 0:0:0:0: [sda] Mode Sense: 00 3a 00 00
[    4.116315] sd 0:0:0:0: [sda] Write cache: enabled, read cache:
enabled, doesn't support DPO or FUA
[    4.116960]  sda: sda1 sda2 sda3 sda4
[    4.117499] sd 0:0:0:0: [sda] Attached SCSI disk
[    4.147923] ata2.00: ATA-7: ST3808110AS, 3.AAE, max UDMA/133
[    4.147926] ata2.00: 156301488 sectors, multi 1: LBA48 NCQ (depth
31/32)
[    4.147929] ata2.00: SB600 AHCI: limiting to 255 sectors per cmd
[    4.206230] ata2.00: SB600 AHCI: limiting to 255 sectors per cmd
[    4.206232] ata2.00: configured for UDMA/133
[    4.206337] scsi 1:0:0:0: Direct-Access     ATA      ST3808110AS
   3.AA PQ: 0 ANSI: 5
[    4.206646] sd 1:0:0:0: [sdb] 156301488 512-byte logical blocks:
(80.0 GB/74.5 GiB)
[    4.206694] sd 1:0:0:0: [sdb] Write Protect is off
[    4.206696] sd 1:0:0:0: [sdb] Mode Sense: 00 3a 00 00
[    4.206717] sd 1:0:0:0: [sdb] Write cache: enabled, read cache:
enabled, doesn't support DPO or FUA
[    4.208158] scsi 4:0:1:0: CD-ROM            RICOH    CD-RW MP7320A
   BP07 PQ: 0 ANSI: 5
[    4.209872] sd 0:0:0:0: Attached scsi generic sg0 type 0
[    4.209918] sd 1:0:0:0: Attached scsi generic sg1 type 0
[    4.209951] scsi 4:0:1:0: Attached scsi generic sg2 type 5
[    4.213750] sr0: scsi3-mmc drive: 40x/40x writer cd/rw xa/form2
cdda tray
[    4.213754] cdrom: Uniform CD-ROM driver Revision: 3.20
[    4.213902] sr 4:0:1:0: Attached scsi CD-ROM sr0
[    4.245981]  sdb: sdb1
[    4.246261] sd 1:0:0:0: [sdb] Attached SCSI disk
[    4.313287] bio: create slab <bio-1> at 1
[    4.336771] bcache: bch_journal_replay() journal replay done, 2
keys in 3 entries, seq 1114
[    4.336939] bcache: register_cache() registered cache device sda4
[    4.371595] EXT4-fs (sda1): mounted filesystem with ordered data
mode. Opts: (null)
[    4.586825] udevd[411]: starting version 175
[    4.684940] ehci-pci: EHCI PCI platform driver
[    4.712601] EDAC MC: Ver: 3.0.0
[    4.721894] MCE: In-kernel MCE decoding enabled.
[    4.722348] input: Power Button as
/devices/LNXSYSTM:00/device:00/PNP0C0C:00/input/input1
[    4.722353] ACPI: Power Button [PWRB]
[    4.722427] input: Power Button as
/devices/LNXSYSTM:00/LNXPWRBN:00/input/input2
[    4.722429] ACPI: Power Button [PWRF]
[    4.727858] AMD64 EDAC driver v3.4.0
[    4.740748] input: PC Speaker as /devices/platform/pcspkr/input/input3
[    4.786074] parport_pc 00:08: reported by Plug and Play ACPI
[    4.786120] parport0: PC-style at 0x378, irq 7 [PCSPP,TRISTATE,EPP]
[    4.796423] microcode: AMD CPU family 0xf not supported
[    4.862009] kvm: Nested Virtualization enabled
[    4.866127] powernow-k8: fid 0x16 (3000 MHz), vid 0x8
[    4.866131] powernow-k8: fid 0x14 (2800 MHz), vid 0xa
[    4.866133] powernow-k8: fid 0x12 (2600 MHz), vid 0xc
[    4.866134] powernow-k8: fid 0x10 (2400 MHz), vid 0xe
[    4.866135] powernow-k8: fid 0xe (2200 MHz), vid 0x10
[    4.866137] powernow-k8: fid 0xc (2000 MHz), vid 0x10
[    4.866138] powernow-k8: fid 0xa (1800 MHz), vid 0x10
[    4.866139] powernow-k8: fid 0x2 (1000 MHz), vid 0x12
[    4.866266] powernow-k8: Found 1 AMD Athlon(tm) 64 X2 Dual Core
Processor 6000+ (2 cpu cores) (version 2.20.00)
[    5.004189] ehci-pci 0000:00:13.5: EHCI Host Controller
[    5.004201] ehci-pci 0000:00:13.5: new USB bus registered, assigned
bus number 6
[    5.004212] ehci-pci 0000:00:13.5: applying AMD SB600/SB700 USB
freeze workaround
[    5.004228] ehci-pci 0000:00:13.5: debug port 1
[    5.004288] ehci-pci 0000:00:13.5: irq 19, io mem 0xfe029000
[    5.016034] ehci-pci 0000:00:13.5: USB 2.0 started, EHCI 1.00
[    5.016066] usb usb6: New USB device found, idVendor=1d6b,
idProduct=0002
[    5.016069] usb usb6: New USB device strings: Mfr=3, Product=2,
SerialNumber=1
[    5.016072] usb usb6: Product: EHCI Host Controller
[    5.016074] usb usb6: Manufacturer: Linux 3.10.3 ehci_hcd
[    5.016076] usb usb6: SerialNumber: 0000:00:13.5
[    5.016216] hub 6-0:1.0: USB hub found
[    5.016222] hub 6-0:1.0: 10 ports detected
[    5.080061] hub 1-0:1.0: USB hub found
[    5.080068] hub 1-0:1.0: 2 ports detected
[    5.144188] hub 2-0:1.0: USB hub found
[    5.144210] hub 2-0:1.0: 2 ports detected
[    5.161611] bcache: register_bdev() registered backing device sdb1
[    5.164786] bcache: bch_cached_dev_attach() Caching sdb1 as bcache0
on set 157048b2-85da-4096-9dd6-784e1215246d
[    5.202701] psmouse serio1: alps: Unknown ALPS touchpad: E7=10 00
64, EC=10 00 64
[    5.208241] hub 3-0:1.0: USB hub found
[    5.208268] hub 3-0:1.0: 2 ports detected
[    5.272192] hub 4-0:1.0: USB hub found
[    5.272215] hub 4-0:1.0: 2 ports detected
[    5.336184] hub 5-0:1.0: USB hub found
[    5.336204] hub 5-0:1.0: 2 ports detected
[    5.336870] piix4_smbus 0000:00:14.0: SMBus Host Controller at
0xb00, revision 0
[    5.336948] piix4_smbus 0000:00:14.0: Auxiliary SMBus Host
Controller at 0xb10
[    5.337441] shpchp: Standard Hot Plug PCI Controller Driver
version: 0.4
[    5.338365] k8temp 0000:00:18.3: Temperature readouts might be
wrong - check erratum #141
[    5.338997] EDAC amd64: DRAM ECC disabled.
[    5.339010] EDAC amd64: ECC disabled in the BIOS or no ECC
capability, module will not load.
[    5.339010]  Either enable ECC checking or force module loading by
setting 'ecc_enable_override'.
[    5.339010]  (Note that use of the override may cause unknown side
effects.)
[    5.339482] snd_hda_intel 0000:00:14.2: irq 42 for MSI/MSI-X
[    5.342892] sp5100_tco: SP5100/SB800 TCO WatchDog Timer Driver v0.05
[    5.343034] sp5100_tco: PCI Revision ID: 0x13
[    5.343063] sp5100_tco: failed to find MMIO address, giving up.
[    5.389787] input: HDA ATI SB Front Headphone as
/devices/pci0000:00/0000:00:14.2/sound/card0/input4
[    5.390189] input: HDA ATI SB Line Out as
/devices/pci0000:00/0000:00:14.2/sound/card0/input5
[    5.390474] input: HDA ATI SB Line as
/devices/pci0000:00/0000:00:14.2/sound/card0/input6
[    5.390755] input: HDA ATI SB Rear Mic as
/devices/pci0000:00/0000:00:14.2/sound/card0/input7
[    5.391049] input: HDA ATI SB Front Mic as
/devices/pci0000:00/0000:00:14.2/sound/card0/input8
[    5.426406] [drm] Initialized drm 1.1.0 20060810
[    5.561846] [drm] radeon kernel modesetting enabled.
[    5.562691] [drm] initializing kernel modesetting (RS690
0x1002:0x791E 0x1043:0x826D).
[    5.562732] [drm] register mmio base: 0xFDCF0000
[    5.562736] [drm] register mmio size: 65536
[    5.565515] ATOM BIOS: ATI
[    5.565578] radeon 0000:01:05.0: VRAM: 128M 0x00000000D8000000 -
0x00000000DFFFFFFF (128M used)
[    5.565586] radeon 0000:01:05.0: GTT: 512M 0x00000000A0000000 -
0x00000000BFFFFFFF
[    5.566559] [drm] Detected VRAM RAM=128M, BAR=128M
[    5.566568] [drm] RAM width 128bits DDR
[    5.566764] [TTM] Zone  kernel: Available graphics memory: 1965824 kiB
[    5.566768] [TTM] Initializing pool allocator
[    5.566780] [TTM] Initializing DMA pool allocator
[    5.566855] [drm] radeon: 128M of VRAM memory ready
[    5.566860] [drm] radeon: 512M of GTT memory ready.
[    5.566907] [drm] GART: num cpu pages 131072, num gpu pages 131072
[    5.590436] [drm] radeon: 1 quad pipes, 1 z pipes initialized.
[    5.605614] [drm] PCIE GART of 512M enabled (table at
0x00000000D2800000).
[    5.605683] radeon 0000:01:05.0: WB enabled
[    5.605694] radeon 0000:01:05.0: fence driver on ring 0 use gpu
addr 0x00000000a0000000 and cpu addr 0xffff8800d71f4000
[    5.605702] [drm] Supports vblank timestamp caching Rev 1 (10.10.2010).
[    5.605705] [drm] Driver supports precise vblank timestamp query.
[    5.605754] radeon 0000:01:05.0: irq 43 for MSI/MSI-X
[    5.605782] radeon 0000:01:05.0: radeon: using MSI.
[    5.605837] [drm] radeon: irq initialized.
[    5.605964] [drm] Loading RS690/RS740 Microcode
[    5.610554] [drm] radeon: ring at 0x00000000A0001000
[    5.610586] [drm] ring test succeeded in 1 usecs
[    5.610900] [drm] ib test succeeded in 0 usecs
[    5.611580] [drm] Radeon Display Connectors
[    5.611584] [drm] Connector 0:
[    5.611588] [drm]   VGA-1
[    5.611594] [drm]   DDC: 0x7e50 0x7e40 0x7e54 0x7e44 0x7e58 0x7e48
0x7e5c 0x7e4c
[    5.611597] [drm]   Encoders:
[    5.611600] [drm]     CRT1: INTERNAL_KLDSCP_DAC1
[    5.611604] [drm] Connector 1:
[    5.611607] [drm]   SVIDEO-1
[    5.611610] [drm]   Encoders:
[    5.611613] [drm]     TV1: INTERNAL_KLDSCP_DAC1
[    5.611616] [drm] Connector 2:
[    5.611620] [drm]   HDMI-A-1
[    5.611623] [drm]   HPD2
[    5.611628] [drm]   DDC: 0x7e40 0x7e60 0x7e44 0x7e64 0x7e48 0x7e68
0x7e4c 0x7e6c
[    5.611631] [drm]   Encoders:
[    5.611635] [drm]     DFP2: INTERNAL_DDI
[    5.611638] [drm] Connector 3:
[    5.611641] [drm]   DVI-D-1
[    5.611648] [drm]   DDC: 0x7e40 0x7e50 0x7e44 0x7e54 0x7e48 0x7e58
0x7e4c 0x7e5c
[    5.611651] [drm]   Encoders:
[    5.611655] [drm]     DFP3: INTERNAL_LVTM1
[    5.750982] [drm] fb mappable at 0xF0040000
[    5.750987] [drm] vram apper at 0xF0000000
[    5.750990] [drm] size 7258112
[    5.750993] [drm] fb depth is 24
[    5.750996] [drm]    pitch is 6912
[    5.751144] fbcon: radeondrmfb (fb0) is primary device
[    5.776988] input: ImExPS/2 Generic Explorer Mouse as
/devices/platform/i8042/serio1/input/input9
[    5.790982] Console: switching to colour frame buffer device 210x65
[    5.812832] radeon 0000:01:05.0: fb0: radeondrmfb frame buffer device
[    5.812838] radeon 0000:01:05.0: registered panic notifier
[    5.812851] [drm] Initialized radeon 2.33.0 20080528 for
0000:01:05.0 on minor 0
[    6.262334] Adding 2097148k swap on /dev/sda2.  Priority:-1
extents:1 across:2097148k SS
[    6.275211] EXT4-fs (sda1): re-mounted. Opts: (null)
[    6.313730] EXT4-fs (sda1): re-mounted. Opts: errors=remount-ro
[    6.425841] loop: module loaded
[    7.462077] RPC: Registered named UNIX socket transport module.
[    7.462082] RPC: Registered udp transport module.
[    7.462085] RPC: Registered tcp transport module.
[    7.462087] RPC: Registered tcp NFSv4.1 backchannel transport module.
[    7.474385] FS-Cache: Loaded
[    7.524901] FS-Cache: Netfs 'nfs' registered for caching
[    7.566571] Installing knfsd (copyright (C) 1996 okir-pn4DOG8n3UYbFoVRYvo4fw@public.gmane.org).
[    7.909289] r8169 0000:02:00.0 eth0: link down
[    7.909306] r8169 0000:02:00.0 eth0: link down
[    7.909321] IPv6: ADDRCONF(NETDEV_UP): eth0: link is not ready
[    9.753882] Bluetooth: Core ver 2.16
[    9.753915] NET: Registered protocol family 31
[    9.753917] Bluetooth: HCI device and connection manager initialized
[    9.753927] Bluetooth: HCI socket layer initialized
[    9.753930] Bluetooth: L2CAP socket layer initialized
[    9.753937] Bluetooth: SCO socket layer initialized
[    9.767860] Bluetooth: BNEP (Ethernet Emulation) ver 1.3
[    9.767864] Bluetooth: BNEP filters: protocol multicast
[    9.767874] Bluetooth: BNEP socket layer initialized
[    9.769963] r8169 0000:02:00.0 eth0: link up
[    9.769974] IPv6: ADDRCONF(NETDEV_CHANGE): eth0: link becomes ready
[    9.772969] Bluetooth: RFCOMM TTY layer initialized
[    9.772983] Bluetooth: RFCOMM socket layer initialized
[    9.772985] Bluetooth: RFCOMM ver 1.11
[    9.808710] lp0: using parport0 (interrupt-driven).
[    9.825976] ppdev: user-space parallel port driver
[    9.934302] NFSD: Using /var/lib/nfs/v4recovery as the NFSv4 state
recovery directory
[    9.934479] NFSD: starting 90-second grace period (net
ffffffff81674140)
[   13.354273] ip_tables: (C) 2000-2006 Netfilter Core Team
[   13.372743] nf_conntrack version 0.5.0 (16384 buckets, 65536 max)
[   43.655142] EXT4-fs (bcache0): recovery complete
[   43.655542] EXT4-fs (bcache0): mounted filesystem with ordered data
mode. Opts: (null)
[  243.200028] INFO: task kworker/u4:1:35 blocked for more than 120
seconds.
[  243.200034] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs"
disables this message.
[  243.200037] kworker/u4:1    D ffff88011fd12e00     0    35      2
0x00000000
[  243.200048] Workqueue: writeback bdi_writeback_workfn (flush-252:0)
[  243.200051]  ffff8800d29fc180 0000000000000046 ffff8800d5c9d080
0000000000000000
[  243.200056]  0000000000012e00 ffff8800d2a19fd8 ffff8800d2a19fd8
ffff8800d29fc180
[  243.200060]  0000000000000206 ffff88011fd12e00 ffff8800d29fc180
ffff8800d2a19b30
[  243.200064] Call Trace:
[  243.200073]  [<ffffffff810b4c26>] ? __lock_page+0x66/0x66
[  243.200079]  [<ffffffff81365fb5>] ? io_schedule+0x56/0x6c
[  243.200083]  [<ffffffff810b4c2d>] ? sleep_on_page+0x7/0xb
[  243.200087]  [<ffffffff81364db7>] ? __wait_on_bit+0x3e/0x75
[  243.200092]  [<ffffffff810b4feb>] ? find_get_pages_tag+0xe7/0x121
[  243.200096]  [<ffffffff810b4ce0>] ? wait_on_page_bit+0x6e/0x73
[  243.200101]  [<ffffffff8104b885>] ? autoremove_wake_function+0x2a/0x2a
[  243.200106]  [<ffffffff810b5395>] ? filemap_fdatawait_range+0x66/0xfe
[  243.200111]  [<ffffffff8111569c>] ? __writeback_single_inode+0x7e/0x1db
[  243.200115]  [<ffffffff81116459>] ? writeback_sb_inodes+0x1e2/0x314
[  243.200120]  [<ffffffff810bd193>] ? __bdi_update_bandwidth+0x2/0x314
[  243.200124]  [<ffffffff8111675f>] ? wb_writeback+0x129/0x292
[  243.200129]  [<ffffffff810ec2da>] ? __cache_free.isra.45+0x178/0x187
[  243.200133]  [<ffffffff81116a81>] ? wb_do_writeback+0x72/0x1ba
[  243.200138]  [<ffffffff81116c2c>] ? bdi_writeback_workfn+0x63/0xf4
[  243.200142]  [<ffffffff81046588>] ? process_one_work+0x191/0x28f
[  243.200147]  [<ffffffff81046a35>] ? worker_thread+0x121/0x1e7
[  243.200150]  [<ffffffff81046914>] ? rescuer_thread+0x269/0x269
[  243.200154]  [<ffffffff8104aedd>] ? kthread+0x81/0x89
[  243.200159]  [<ffffffff8104ae5c>] ? __kthread_parkme+0x5d/0x5d
[  243.200164]  [<ffffffff8136b9ac>] ? ret_from_fork+0x7c/0xb0
[  243.200167]  [<ffffffff8104ae5c>] ? __kthread_parkme+0x5d/0x5d
[  243.200223] INFO: task sync:5075 blocked for more than 120 seconds.
[  243.200226] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs"
disables this message.
[  243.200228] sync            D ffff88011fd12e00     0  5075   5011
0x00000000
[  243.200232]  ffff8800d5ea8100 0000000000000086 ffff88011b2a48a0
ffff88011fc12e00
[  243.200236]  0000000000012e00 ffff8800d2b7bfd8 ffff8800d2b7bfd8
ffff8800d5ea8100
[  243.200240]  ffff88011fc12e00 7fffffffffffffff 7fffffffffffffff
ffff8800d2b7beb0
[  243.200244] Call Trace:
[  243.200249]  [<ffffffff81364c17>] ?
console_conditional_schedule+0xf/0xf
[  243.200253]  [<ffffffff81364c43>] ? schedule_timeout+0x2c/0x123
[  243.200258]  [<ffffffff81045310>] ? __queue_work+0x1ef/0x23d
[  243.200263]  [<ffffffff81053565>] ? should_resched+0x5/0x23
[  243.200267]  [<ffffffff81365d9e>] ? __wait_for_common+0xa0/0x11b
[  243.200271]  [<ffffffff810560c2>] ? try_to_wake_up+0x199/0x199
[  243.200275]  [<ffffffff81116195>] ? sync_inodes_sb+0xaa/0x18c
[  243.200280]  [<ffffffff8111965b>] ? fdatawrite_one_bdev+0xd/0xd
[  243.200286]  [<ffffffff810fa318>] ? iterate_supers+0x63/0xb5
[  243.200290]  [<ffffffff81119794>] ? sys_sync+0x2e/0x81
[  243.200294]  [<ffffffff8136ba52>] ? system_call_fastpath+0x16/0x1b
[  363.200047] INFO: task kworker/u4:1:35 blocked for more than 120
seconds.
[  363.200058] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs"
disables this message.
[  363.200064] kworker/u4:1    D ffff88011fd12e00     0    35      2
0x00000000
[  363.200084] Workqueue: writeback bdi_writeback_workfn (flush-252:0)
[  363.200090]  ffff8800d29fc180 0000000000000046 ffff8800d5c9d080
0000000000000000
[  363.200099]  0000000000012e00 ffff8800d2a19fd8 ffff8800d2a19fd8
ffff8800d29fc180
[  363.200106]  0000000000000206 ffff88011fd12e00 ffff8800d29fc180
ffff8800d2a19b30
[  363.200113] Call Trace:
[  363.200129]  [<ffffffff810b4c26>] ? __lock_page+0x66/0x66
[  363.200140]  [<ffffffff81365fb5>] ? io_schedule+0x56/0x6c
[  363.200148]  [<ffffffff810b4c2d>] ? sleep_on_page+0x7/0xb
[  363.200155]  [<ffffffff81364db7>] ? __wait_on_bit+0x3e/0x75
[  363.200164]  [<ffffffff810b4feb>] ? find_get_pages_tag+0xe7/0x121
[  363.200171]  [<ffffffff810b4ce0>] ? wait_on_page_bit+0x6e/0x73
[  363.200180]  [<ffffffff8104b885>] ? autoremove_wake_function+0x2a/0x2a
[  363.200189]  [<ffffffff810b5395>] ? filemap_fdatawait_range+0x66/0xfe
[  363.200198]  [<ffffffff8111569c>] ? __writeback_single_inode+0x7e/0x1db
[  363.200205]  [<ffffffff81116459>] ? writeback_sb_inodes+0x1e2/0x314
[  363.200215]  [<ffffffff810bd193>] ? __bdi_update_bandwidth+0x2/0x314
[  363.200222]  [<ffffffff8111675f>] ? wb_writeback+0x129/0x292
[  363.200230]  [<ffffffff810ec2da>] ? __cache_free.isra.45+0x178/0x187
[  363.200237]  [<ffffffff81116a81>] ? wb_do_writeback+0x72/0x1ba
[  363.200245]  [<ffffffff81116c2c>] ? bdi_writeback_workfn+0x63/0xf4
[  363.200254]  [<ffffffff81046588>] ? process_one_work+0x191/0x28f
[  363.200262]  [<ffffffff81046a35>] ? worker_thread+0x121/0x1e7
[  363.200269]  [<ffffffff81046914>] ? rescuer_thread+0x269/0x269
[  363.200276]  [<ffffffff8104aedd>] ? kthread+0x81/0x89
[  363.200283]  [<ffffffff8104ae5c>] ? __kthread_parkme+0x5d/0x5d
[  363.200292]  [<ffffffff8136b9ac>] ? ret_from_fork+0x7c/0xb0
[  363.200298]  [<ffffffff8104ae5c>] ? __kthread_parkme+0x5d/0x5d
[  363.200400] INFO: task sync:5075 blocked for more than 120 seconds.
[  363.200405] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs"
disables this message.
[  363.200409] sync            D ffff88011fd12e00     0  5075   5011
0x00000000
[  363.200417]  ffff8800d5ea8100 0000000000000086 ffff88011b2a48a0
ffff88011fc12e00
[  363.200424]  0000000000012e00 ffff8800d2b7bfd8 ffff8800d2b7bfd8
ffff8800d5ea8100
[  363.200430]  ffff88011fc12e00 7fffffffffffffff 7fffffffffffffff
ffff8800d2b7beb0
[  363.200437] Call Trace:
[  363.200445]  [<ffffffff81364c17>] ?
console_conditional_schedule+0xf/0xf
[  363.200453]  [<ffffffff81364c43>] ? schedule_timeout+0x2c/0x123
[  363.200461]  [<ffffffff81045310>] ? __queue_work+0x1ef/0x23d
[  363.200473]  [<ffffffff81053565>] ? should_resched+0x5/0x23
[  363.200480]  [<ffffffff81365d9e>] ? __wait_for_common+0xa0/0x11b
[  363.200487]  [<ffffffff810560c2>] ? try_to_wake_up+0x199/0x199
[  363.200495]  [<ffffffff81116195>] ? sync_inodes_sb+0xaa/0x18c
[  363.200503]  [<ffffffff8111965b>] ? fdatawrite_one_bdev+0xd/0xd
[  363.200513]  [<ffffffff810fa318>] ? iterate_supers+0x63/0xb5
[  363.200520]  [<ffffffff81119794>] ? sys_sync+0x2e/0x81
[  363.200528]  [<ffffffff8136ba52>] ? system_call_fastpath+0x16/0x1b
[  483.200047] INFO: task kworker/u4:1:35 blocked for more than 120
seconds.
[  483.200058] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs"
disables this message.
[  483.200064] kworker/u4:1    D ffff88011fd12e00     0    35      2
0x00000000
[  483.200084] Workqueue: writeback bdi_writeback_workfn (flush-252:0)
[  483.200090]  ffff8800d29fc180 0000000000000046 ffff8800d5c9d080
0000000000000000
[  483.200099]  0000000000012e00 ffff8800d2a19fd8 ffff8800d2a19fd8
ffff8800d29fc180
[  483.200106]  0000000000000206 ffff88011fd12e00 ffff8800d29fc180
ffff8800d2a19b30
[  483.200113] Call Trace:
[  483.200129]  [<ffffffff810b4c26>] ? __lock_page+0x66/0x66
[  483.200139]  [<ffffffff81365fb5>] ? io_schedule+0x56/0x6c
[  483.200147]  [<ffffffff810b4c2d>] ? sleep_on_page+0x7/0xb
[  483.200155]  [<ffffffff81364db7>] ? __wait_on_bit+0x3e/0x75
[  483.200163]  [<ffffffff810b4feb>] ? find_get_pages_tag+0xe7/0x121
[  483.200171]  [<ffffffff810b4ce0>] ? wait_on_page_bit+0x6e/0x73
[  483.200179]  [<ffffffff8104b885>] ? autoremove_wake_function+0x2a/0x2a
[  483.200188]  [<ffffffff810b5395>] ? filemap_fdatawait_range+0x66/0xfe
[  483.200197]  [<ffffffff8111569c>] ? __writeback_single_inode+0x7e/0x1db
[  483.200205]  [<ffffffff81116459>] ? writeback_sb_inodes+0x1e2/0x314
[  483.200214]  [<ffffffff810bd193>] ? __bdi_update_bandwidth+0x2/0x314
[  483.200221]  [<ffffffff8111675f>] ? wb_writeback+0x129/0x292
[  483.200229]  [<ffffffff810ec2da>] ? __cache_free.isra.45+0x178/0x187
[  483.200237]  [<ffffffff81116a81>] ? wb_do_writeback+0x72/0x1ba
[  483.200245]  [<ffffffff81116c2c>] ? bdi_writeback_workfn+0x63/0xf4
[  483.200254]  [<ffffffff81046588>] ? process_one_work+0x191/0x28f
[  483.200261]  [<ffffffff81046a35>] ? worker_thread+0x121/0x1e7
[  483.200269]  [<ffffffff81046914>] ? rescuer_thread+0x269/0x269
[  483.200276]  [<ffffffff8104aedd>] ? kthread+0x81/0x89
[  483.200283]  [<ffffffff8104ae5c>] ? __kthread_parkme+0x5d/0x5d
[  483.200291]  [<ffffffff8136b9ac>] ? ret_from_fork+0x7c/0xb0
[  483.200298]  [<ffffffff8104ae5c>] ? __kthread_parkme+0x5d/0x5d
[  483.200399] INFO: task sync:5075 blocked for more than 120 seconds.
[  483.200404] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs"
disables this message.
[  483.200408] sync            D ffff88011fd12e00     0  5075   5011
0x00000000
[  483.200416]  ffff8800d5ea8100 0000000000000086 ffff88011b2a48a0
ffff88011fc12e00
[  483.200423]  0000000000012e00 ffff8800d2b7bfd8 ffff8800d2b7bfd8
ffff8800d5ea8100
[  483.200429]  ffff88011fc12e00 7fffffffffffffff 7fffffffffffffff
ffff8800d2b7beb0
[  483.200436] Call Trace:
[  483.200445]  [<ffffffff81364c17>] ?
console_conditional_schedule+0xf/0xf
[  483.200452]  [<ffffffff81364c43>] ? schedule_timeout+0x2c/0x123
[  483.200461]  [<ffffffff81045310>] ? __queue_work+0x1ef/0x23d
[  483.200471]  [<ffffffff81053565>] ? should_resched+0x5/0x23
[  483.200478]  [<ffffffff81365d9e>] ? __wait_for_common+0xa0/0x11b
[  483.200486]  [<ffffffff810560c2>] ? try_to_wake_up+0x199/0x199
[  483.200493]  [<ffffffff81116195>] ? sync_inodes_sb+0xaa/0x18c
[  483.200503]  [<ffffffff8111965b>] ? fdatawrite_one_bdev+0xd/0xd
[  483.200511]  [<ffffffff810fa318>] ? iterate_supers+0x63/0xb5
[  483.200518]  [<ffffffff81119794>] ? sys_sync+0x2e/0x81
[  483.200526]  [<ffffffff8136ba52>] ? system_call_fastpath+0x16/0x1b
