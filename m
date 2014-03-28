From: Daniel Smedegaard Buus <danielbuus@gmail.com>
Subject: Missing cache prevents AWS instance from booting
Date: Fri, 28 Mar 2014 13:25:59 +0100
Message-ID: <CAHnuAezfCLEC5oxi7FxyC2qjCtEB5=Yc2ztfRb7uXrq1Hr7bdQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-bcache-owner@vger.kernel.org>
Received: from mail-oa0-f53.google.com ([209.85.219.53]:60790 "EHLO
	mail-oa0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751095AbaC1M0j (ORCPT
	<rfc822;linux-bcache@vger.kernel.org>);
	Fri, 28 Mar 2014 08:26:39 -0400
Received: by mail-oa0-f53.google.com with SMTP id j17so5814518oag.26
        for <linux-bcache@vger.kernel.org>; Fri, 28 Mar 2014 05:26:39 -0700 (PDT)
Sender: linux-bcache-owner@vger.kernel.org
List-Id: linux-bcache@vger.kernel.org
To: linux-bcache@vger.kernel.org

Hi again :)

On EC2 instances, if I set up bcache to use an ephemeral device as a
cache for an EBS device:

    # wipefs --all /dev/xvdb
    2 bytes were erased at offset 0x438 (ext3)
    they were: 53 ef

    # make-bcache -B /dev/xvdm -C /dev/xvdb
    UUID: 002f2398-f474-48aa-a017-f1e3576f26a4
    Set UUID: 999ebd08-4743-4c66-9d62-4b1e00f887e8
    version: 0
    nbuckets: 31243
    block_size: 1
    bucket_size: 1024
    nr_in_set: 1
    nr_this_dev: 0
    first_bucket: 1
    UUID: 8b99bab0-ad5f-47fd-98e2-f5d524f15de2
    Set UUID: 999ebd08-4743-4c66-9d62-4b1e00f887e8
    version: 1
    block_size: 1
    data_offset: 16

    # mkfs.xfs /dev/bcache0
    meta-data=/dev/bcache0           isize=256    agcount=4, agsize=1310720 blks
            =                       sectsz=512   attr=2, projid32bit=0
    data     =                       bsize=4096   blocks=5242878, imaxpct=25
            =                       sunit=0      swidth=0 blks
    naming   =version 2              bsize=4096   ascii-ci=0
    log      =internal log           bsize=4096   blocks=2560, version=2
            =                       sectsz=512   sunit=0 blks, lazy-count=1
    realtime =none                   extsz=4096   blocks=0, rtextents=0

    # echo "/dev/bcache0  /mnt  xfs  defaults,noatime  0 0" >> /etc/fstab

All is well. After a reboot, all is still well.

If, however I shut down that instance, and thus wiping the ephemeral
data, and then start it back up, it'll never boot. It dies early
enough that I cannot access it via SSH either. The last thing it
manages to do is mount /.

The system log from the AWS console doesn't, to me, provide much
insight, but perhaps there's something here that makes sense to any
one of you :)

Here goes:
----

Xen Minimal OS!
  start_info: 0x112e000(VA)
    nr_pages: 0xf0000
  shared_inf: 0x5c697000(MA)
     pt_base: 0x1131000(VA)
nr_pt_frames: 0xd
    mfn_list: 0x9ae000(VA)
   mod_start: 0x0(VA)
     mod_len: 0
       flags: 0x0
    cmd_line: root=/dev/sda1 ro 4
  stack:      0x96d840-0x98d840
MM: Init
      _text: 0x0(VA)
     _etext: 0x7dc7d(VA)
   _erodata: 0x9a000(VA)
     _edata: 0x9fce0(VA)
stack start: 0x96d840(VA)
       _end: 0x9ade40(VA)
  start_pfn: 1141
    max_pfn: f0000
Mapping memory range 0x1400000 - 0xf0000000
setting 0x0-0x9a000 readonly
skipped 0x1000
MM: Initialise page allocator for 18ba000(18ba000)-f0000000(f0000000)
MM: done
Demand map pfns at f0001000-20f0001000.
Heap resides at 20f0002000-40f0002000.
Initialising timer interface
Initialising console ... done.
gnttab_table mapped at 0xf0001000.
Initialising scheduler
Thread "Idle": pointer: 0x20f0002050, stack: 0x2070000
Thread "xenstore": pointer: 0x20f0002800, stack: 0x2080000
xenbus initialised on irq 1 mfn 0x752c43
Thread "shutdown": pointer: 0x20f0002fb0, stack: 0x2090000
Dummy main: start_info=0x98d940
Thread "main": pointer: 0x20f0003760, stack: 0x20a0000
"main" "root=/dev/sda1" "ro" "4"
vbd 2049 is hd0
******************* BLKFRONT for device/vbd/2049 **********


backend at /local/domain/0/backend/vbd/1401/2049
16777216 sectors of 512 bytes
**************************
vbd 2064 is hd1
******************* BLKFRONT for device/vbd/2064 **********


backend at /local/domain/0/backend/vbd/1401/2064
31992832 sectors of 512 bytes
**************************
vbd 2080 is hd2
******************* BLKFRONT for device/vbd/2080 **********


backend at /local/domain/0/backend/vbd/1401/2080
31992832 sectors of 512 bytes
**************************
vbd 2240 is hd3
******************* BLKFRONT for device/vbd/2240 **********


backend at /local/domain/0/backend/vbd/1401/2240
41943040 sectors of 512 bytes
**************************
 [H [J  Booting 'Ubuntu Trusty Tahr (development branch), kernel
3.13.0-19-generic'



root  (hd0)

 Filesystem type is ext2fs, using whole disk

kernel  /boot/vmlinuz-3.13.0-19-generic root=LABEL=cloudimg-rootfs ro console=h

vc0

initrd  /boot/initrd.img-3.13.0-19-generic



============= Init TPM Front ================
Tpmfront:Error Unable to read device/vtpm/0/backend-id during tpmfront
initialization! error = ENOENT
Tpmfront:Info Shutting down tpmfront
close blk: backend=/local/domain/0/backend/vbd/1401/2049 node=device/vbd/2049
close blk: backend=/local/domain/0/backend/vbd/1401/2064 node=device/vbd/2064
close blk: backend=/local/domain/0/backend/vbd/1401/2080 node=device/vbd/2080
close blk: backend=/local/domain/0/backend/vbd/1401/2240 node=device/vbd/2240
[    0.000000] Initializing cgroup subsys cpuset
[    0.000000] Initializing cgroup subsys cpu
[    0.000000] Initializing cgroup subsys cpuacct
[    0.000000] Linux version 3.13.0-19-generic (buildd@comet) (gcc
version 4.8.2 (Ubuntu 4.8.2-16ubuntu6) ) #39-Ubuntu SMP Fri Mar 21
14:18:44 UTC 2014 (Ubuntu 3.13.0-19.39-generic 3.13.6)
[    0.000000] Command line: root=LABEL=cloudimg-rootfs ro console=hvc0
[    0.000000] KERNEL supported cpus:
[    0.000000]   Intel GenuineIntel
[    0.000000]   AMD AuthenticAMD
[    0.000000]   Centaur CentaurHauls
[    0.000000] ACPI in unprivileged domain disabled
[    0.000000] e820: BIOS-provided physical RAM map:
[    0.000000] Xen: [mem 0x0000000000000000-0x000000000009ffff] usable
[    0.000000] Xen: [mem 0x00000000000a0000-0x00000000000fffff] reserved
[    0.000000] Xen: [mem 0x0000000000100000-0x00000000f07fffff] usable
[    0.000000] NX (Execute Disable) protection: active
[    0.000000] DMI not present or invalid.
[    0.000000] No AGP bridge found
[    0.000000] e820: last_pfn = 0xf0800 max_arch_pfn = 0x400000000
[    0.000000] Scanning 1 areas for low memory corruption
[    0.000000] init_memory_mapping: [mem 0x00000000-0x000fffff]
[    0.000000] init_memory_mapping: [mem 0xefe00000-0xefffffff]
[    0.000000] init_memory_mapping: [mem 0xec000000-0xefdfffff]
[    0.000000] init_memory_mapping: [mem 0x80000000-0xebffffff]
[    0.000000] init_memory_mapping: [mem 0x00100000-0x7fffffff]
[    0.000000] init_memory_mapping: [mem 0xf0000000-0xf07fffff]
[    0.000000] RAMDISK: [mem 0x023ff000-0x03912fff]
[    0.000000] NUMA turned off
[    0.000000] Faking a node at [mem 0x0000000000000000-0x00000000f07fffff]
[    0.000000] Initmem setup node 0 [mem 0x00000000-0xf07fffff]
[    0.000000]   NODE_DATA [mem 0xef89c000-0xef8a0fff]
[    0.000000] Zone ranges:
[    0.000000]   DMA      [mem 0x00001000-0x00ffffff]
[    0.000000]   DMA32    [mem 0x01000000-0xffffffff]
[    0.000000]   Normal   empty
[    0.000000] Movable zone start for each node
[    0.000000] Early memory node ranges
[    0.000000]   node   0: [mem 0x00001000-0x0009ffff]
[    0.000000]   node   0: [mem 0x00100000-0xf07fffff]
[    0.000000] SFI: Simple Firmware Interface v0.81 http://simplefirmware.org
[    0.000000] smpboot: Allowing 2 CPUs, 0 hotplug CPUs
[    0.000000] PM: Registered nosave memory: [mem 0x000a0000-0x000fffff]
[    0.000000] e820: [mem 0xf0800000-0xffffffff] available for PCI devices
[    0.000000] Booting paravirtualized kernel on Xen
[    0.000000] Xen version: 4.2.amazon (preserve-AD)
[    0.000000] setup_percpu: NR_CPUS:256 nr_cpumask_bits:256
nr_cpu_ids:2 nr_node_ids:1
[    0.000000] PERCPU: Embedded 29 pages/cpu @ffff8800ef600000 s86336
r8192 d24256 u1048576
[    0.000000] Built 1 zonelists in Node order, mobility grouping on.
Total pages: 969578
[    0.000000] Policy zone: DMA32
[    0.000000] Kernel command line: root=LABEL=cloudimg-rootfs ro console=hvc0
[    0.000000] PID hash table entries: 4096 (order: 3, 32768 bytes)
[    0.000000] Checking aperture...
[    0.000000] No AGP bridge found
[    0.000000] Memory: 3814260K/3939964K available (7320K kernel code,
1138K rwdata, 3384K rodata, 1336K init, 1440K bss, 125704K reserved)
[    0.000000] SLUB: HWalign=64, Order=0-3, MinObjects=0, CPUs=2, Nodes=1
[    0.000000] Hierarchical RCU implementation.
[    0.000000] RCU dyntick-idle grace-period acceleration is enabled.
[    0.000000] RCU restricting CPUs from NR_CPUS=256 to nr_cpu_ids=2.
[    0.000000] Offload RCU callbacks from all CPUs
[    0.000000] Offload RCU callbacks from CPUs: 0-1.
[    0.000000] NR_IRQS:16640 nr_irqs:288 16
[    0.000000] Console: colour dummy device 80x25
[    0.000000] console [tty0] enabled
[    0.000000] console [hvc0] enabled
[    0.000000] allocated 16252928 bytes of page_cgroup
[    0.000000] please try 'cgroup_disable=memory' option if you don't
want memory cgroups
[    0.000000] installing Xen timer for CPU 0
[    0.000000] tsc: Detected 2800.060 MHz processor
[    0.004000] Calibrating delay loop (skipped), value calculated
using timer frequency.. 5600.12 BogoMIPS (lpj=11200240)
[    0.004000] pid_max: default: 32768 minimum: 301
[    0.004000] Security Framework initialized
[    0.004000] AppArmor: AppArmor initialized
[    0.004000] Yama: becoming mindful.
[    0.004000] Dentry cache hash table entries: 524288 (order: 10,
4194304 bytes)
[    0.004000] Inode-cache hash table entries: 262144 (order: 9, 2097152 bytes)
[    0.004000] Mount-cache hash table entries: 256
[    0.004000] Initializing cgroup subsys memory
[    0.004000] Initializing cgroup subsys devices
[    0.004000] Initializing cgroup subsys freezer
[    0.004000] Initializing cgroup subsys blkio
[    0.004000] Initializing cgroup subsys perf_event
[    0.004000] Initializing cgroup subsys hugetlb
[    0.004000] CPU: Physical Processor ID: 0
[    0.004000] CPU: Processor Core ID: 1
[    0.004000] Last level iTLB entries: 4KB 512, 2MB 0, 4MB 0
[    0.004000] Last level dTLB entries: 4KB 512, 2MB 0, 4MB 0
[    0.004000] tlb_flushall_shift: 6
[    0.038013] ftrace: allocating 28370 entries in 111 pages
[    0.044057] cpu 0 spinlock event irq 17
[    0.054417] Performance Events: unsupported p6 CPU model 62 no PMU
driver, software events only.
[    0.055591] NMI watchdog: disabled (cpu0): hardware events not enabled
[    0.055657] installing Xen timer for CPU 1
[    0.055667] cpu 1 spinlock event irq 24
[    0.055716] SMP alternatives: switching to SMP code
[    0.087777] x86: Booted up 1 node, 2 CPUs
[    0.087852] devtmpfs: initialized
[    0.087852] EVM: security.selinux
[    0.087852] EVM: security.SMACK64
[    0.087852] EVM: security.ima
[    0.087852] EVM: security.capability
[    0.088652] pinctrl core: initialized pinctrl subsystem
[    0.088710] xen:grant_table: Grant tables using version 2 layout
[    0.088724] Grant table initialized
[    0.088758] regulator-dummy: no parameters
[    0.106489] RTC time: 165:165:165, date: 165/165/65
[    0.106529] NET: Registered protocol family 16
[    0.108388] PCI: setting up Xen PCI frontend stub
[    0.108935] bio: create slab <bio-0> at 0
[    0.108935] ACPI: Interpreter disabled.
[    0.108935] xen:balloon: Initialising balloon driver
[    0.112019] xen_balloon: Initialising balloon driver
[    0.112048] vgaarb: loaded
[    0.112168] SCSI subsystem initialized
[    0.112186] usbcore: registered new interface driver usbfs
[    0.112186] usbcore: registered new interface driver hub
[    0.112186] usbcore: registered new device driver usb
[    0.112186] PCI: System does not support PCI
[    0.112186] PCI: System does not support PCI
[    0.112186] NetLabel: Initializing
[    0.112186] NetLabel:  domain hash size = 128
[    0.112186] NetLabel:  protocols = UNLABELED CIPSOv4
[    0.112186] NetLabel:  unlabeled traffic allowed by default
[    0.112186] Switched to clocksource xen
[    0.115822] AppArmor: AppArmor Filesystem Enabled
[    0.115837] pnp: PnP ACPI: disabled
[    0.118430] NET: Registered protocol family 2
[    0.118556] TCP established hash table entries: 32768 (order: 6,
262144 bytes)
[    0.118652] TCP bind hash table entries: 32768 (order: 7, 524288 bytes)
[    0.118715] TCP: Hash tables configured (established 32768 bind 32768)
[    0.118746] TCP: reno registered
[    0.118757] UDP hash table entries: 2048 (order: 4, 65536 bytes)
[    0.118777] UDP-Lite hash table entries: 2048 (order: 4, 65536 bytes)
[    0.118826] NET: Registered protocol family 1
[    0.118883] Trying to unpack rootfs image as initramfs...
[    0.138738] Freeing initrd memory: 21584K (ffff8800023ff000 -
ffff880003913000)
[    0.138850] platform rtc_cmos: registered platform RTC device (no
PNP device found)
[    0.138927] microcode: CPU0 sig=0x306e4, pf=0x1, revision=0x415
[    0.138939] microcode: CPU1 sig=0x306e4, pf=0x1, revision=0x415
[    0.180432] microcode: Microcode Update Driver: v2.00
<tigran@aivazian.fsnet.co.uk>, Peter Oruba
[    0.180439] Scanning for low memory corruption every 60 seconds
[    0.180710] Initialise system trusted keyring
[    0.180746] audit: initializing netlink socket (disabled)
[    0.180758] type=2000 audit(1396008263.578:1): initialized
[    0.201020] HugeTLB registered 2 MB page size, pre-allocated 0 pages
[    0.201666] zbud: loaded
[    0.201809] VFS: Disk quotas dquot_6.5.2
[    0.201842] Dquot-cache hash table entries: 512 (order 0, 4096 bytes)
[    0.202213] fuse init (API version 7.22)
[    0.202284] msgmni has been set to 7491
[    0.202326] Key type big_key registered
[    0.202911] Key type asymmetric registered
[    0.202918] Asymmetric key parser 'x509' registered
[    0.202946] Block layer SCSI generic (bsg) driver version 0.4
loaded (major 252)
[    0.202994] io scheduler noop registered
[    0.203000] io scheduler deadline registered (default)
[    0.203024] io scheduler cfq registered
[    0.203066] pci_hotplug: PCI Hot Plug PCI Core version: 0.5
[    0.203078] pciehp: PCI Express Hot Plug Controller Driver version: 0.4
[    0.203116] ipmi message handler version 39.2
[    0.203562] Serial: 8250/16550 driver, 32 ports, IRQ sharing enabled
[    0.205029] Linux agpgart interface v0.103
[    0.206171] brd: module loaded
[    0.206811] loop: module loaded
[    0.219128] blkfront: xvda1: barrier or flush: disabled; persistent
grants: disabled; indirect descriptors: disabled;
[    0.228188] blkfront: xvdb: flush diskcache: enabled; persistent
grants: disabled; indirect descriptors: disabled;
[    0.236375] libphy: Fixed MDIO Bus: probed
[    0.236440] tun: Universal TUN/TAP device driver, 1.6
[    0.236443] tun: (C) 1999-2004 Max Krasnyansky <maxk@qualcomm.com>
[    0.236506] PPP generic driver version 2.4.2
[    0.236550] xen_netfront: Initialising Xen virtual ethernet driver
[    0.238018] ehci_hcd: USB 2.0 'Enhanced' Host Controller (EHCI) Driver
[    0.238026] ehci-pci: EHCI PCI platform driver
[    0.238035] ehci-platform: EHCI generic platform driver
[    0.238041] ohci_hcd: USB 1.1 'Open' Host Controller (OHCI) Driver
[    0.238043] ohci-pci: OHCI PCI platform driver
[    0.238048] ohci-platform: OHCI generic platform driver
[    0.238053] uhci_hcd: USB Universal Host Controller Interface driver
[    0.238086] i8042: PNP: No PS/2 controller found. Probing ports directly.
[    0.238181]  xvdb: unknown partition table
[    0.238812] Setting capacity to 31992832
[    0.238818] xvdb: detected capacity change from 0 to 16380329984
[    0.240684] blkfront: xvdc: flush diskcache: enabled; persistent
grants: disabled; indirect descriptors: disabled;
[    0.241909]  xvdc: unknown partition table
[    0.242073] Setting capacity to 31992832
[    0.242078] xvdc: detected capacity change from 0 to 16380329984
[    0.242768] blkfront: xvdm: barrier or flush: disabled; persistent
grants: disabled; indirect descriptors: disabled;
[    0.245716]  xvdm: unknown partition table
[    0.253559] Setting capacity to 41943040
[    0.253567] xvdm: detected capacity change from 0 to 21474836480
[    1.238668] i8042: No controller found
[    1.238830] mousedev: PS/2 mouse device common for all mice
[    1.298537] rtc_cmos rtc_cmos: rtc core: registered rtc_cmos as rtc0
[    1.298600] rtc_cmos: probe of rtc_cmos failed with error -38
[    1.298659] device-mapper: uevent: version 1.0.3
[    1.298722] device-mapper: ioctl: 4.27.0-ioctl (2013-10-30)
initialised: dm-devel@redhat.com
[    1.298730] ledtrig-cpu: registered to indicate activity on CPUs
[    1.298811] TCP: cubic registered
[    1.298875] NET: Registered protocol family 10
[    1.299031] NET: Registered protocol family 17
[    1.299047] Key type dns_resolver registered
[    1.299191] Loading compiled-in X.509 certificates
[    1.299845] Loaded X.509 cert 'Magrathea: Glacier signing key:
95d90450e6e64c197b13031a0cccc12bd5109524'
[    1.299861] registered taskstats version 1
[    1.303450] Key type trusted registered
[    1.306823] Key type encrypted registered
[    1.310135] AppArmor: AppArmor sha1 policy hashing enabled
[    1.310142] IMA: No TPM chip found, activating TPM-bypass!
[    1.310231]   Magic number: 1:252:3141
[    1.310261] /build/buildd/linux-3.13.0/drivers/rtc/hctosys.c:
unable to open rtc device (rtc0)
[    1.310318] BIOS EDD facility v0.16 2004-Jun-25, 0 devices found
[    1.310323] EDD information not available.
[    1.310959] Freeing unused kernel memory: 1336K (ffffffff81d1e000 -
ffffffff81e6c000)
[    1.310965] Write protecting the kernel read-only data: 12288k
[    1.313789] Freeing unused kernel memory: 860K (ffff880001729000 -
ffff880001800000)
[    1.314123] Freeing unused kernel memory: 712K (ffff880001b4e000 -
ffff880001c00000)
Loading, please wait...
[    1.344337] systemd-udevd[102]: starting version 204
[    1.537849] bio: create slab <bio-1> at 1
[    1.538038] bcache: register_bdev() registered backing device xvdm
error: unexpectedly disconnected from boot status daemon
Begin: Loading essential drivers ... [    2.658676] md: linear
personality registered for level -1
[    2.662427] md: multipath personality registered for level -4
[    2.666131] md: raid0 personality registered for level 0
[    2.670644] md: raid1 personality registered for level 1
[    2.740068] raid6: sse2x1    8098 MB/s
[    2.808059] raid6: sse2x2    9848 MB/s
[    2.876061] raid6: sse2x4   11510 MB/s
[    2.876066] raid6: using algorithm sse2x4 (11510 MB/s)
[    2.876068] raid6: using ssse3x2 recovery algorithm
[    2.877010] xor: measuring software checksum speed
[    2.916058]    prefetch64-sse:  8942.000 MB/sec
[    2.956057]    generic_sse:  8534.000 MB/sec
[    2.956063] xor: using function: prefetch64-sse (8942.000 MB/sec)
[    2.956914] async_tx: api initialized (async)
[    2.963517] md: raid6 personality registered for level 6
[    2.963522] md: raid5 personality registered for level 5
[    2.963524] md: raid4 personality registered for level 4
[    2.973771] md: raid10 personality registered for level 10
done.
Begin: Running /scripts/init-premount ... done.
Begin: Mounting root file system ... Begin: Running /scripts/local-top ... done.
Begin: Running /scripts/local-premount ... done.
[    3.429706] EXT4-fs (xvda1): mounted filesystem with ordered data
mode. Opts: (null)
Begin: Running /scripts/local-bottom ... done.
done.
Begin: Running /scripts/init-bottom ... done.
[    3.527214] random: nonblocking pool is initialized
[    6.261486] EXT4-fs (xvda1): re-mounted. Opts: (null)
----

Thanks,
Daniel
