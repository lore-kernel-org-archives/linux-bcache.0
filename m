From: Jonathan Tripathy <jonnyt-Nf8S+5hNwl710XsdtD+oqA@public.gmane.org>
Subject: Re: Expected Behavior
Date: Thu, 30 Aug 2012 08:34:39 +0100
Message-ID: <503F178F.3090304@abpni.co.uk>
References: <503F132E.6060305@abpni.co.uk> <503F147A.10101@abpni.co.uk> <503F15A9.5020000@abpni.co.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-bcache-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <503F15A9.5020000-Nf8S+5hNwl710XsdtD+oqA@public.gmane.org>
Sender: linux-bcache-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "linux-bcache-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-bcache-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-bcache@vger.kernel.org

On 30/08/2012 08:26, Jonathan Tripathy wrote:
> On 30/08/2012 08:21, Jonathan Tripathy wrote:
>> On 30/08/2012 08:15, Jonathan Tripathy wrote:
>>> Hi There,
>>>
>>> On my WIndows DomU (Xen VM) which is running on a LV which is using 
>>> bcache (against two SSD in MDRAID1 and a MD-RAID10 spindle array), I 
>>> ran an IOMeter test for about 2 hours (with 30 workers and a io 
>>> depth of 256). This was a very heavy workload (Got an average iops 
>>> of about 6.5k). After I stopped the test, I then went back to fio on 
>>> my Linux Xen Host (Dom0). The random write performance isn't as good 
>>> as it was before I started the IOMeter test. It used to be about 25k 
>>> and now showed about 7k iops. I assumed that maybe this was due to 
>>> the fact that bcache was writing out dirty data to the spindles so 
>>> the SSD was busy.
>>>
>>> However, this morning, after the spindles have calmed down, 
>>> performance of fio is still not great (still about 7k).
>>>
>>> Is there something wrong here? What is expected behavior?
>>>
>>> Thanks
>>>
>> BTW, I can confirm that this isn't an SSD issue, as I have a 
>> partition on the SSD that I kept seperate from bcache and I'm getting 
>> excellent (about 28k) iops performance there.
>>
>> It's as if after the heavy workload I did with IOMeter, bcache has 
>> somehow throttled the writeback cache?
>>
>> Any help is appreciated.
>>
>>
> Also, I'm not sure if this is related, but is there a memory leak 
> somewhere in the bcache code? I haven't used this machine for anything 
> else apart from running the above tests and here is my RAM usage:
>
> free -m
>              total       used       free     shared    buffers cached
> Mem:          1155       1021        133          0 0          8
> -/+ buffers/cache:       1013        142
> Swap:          952         53        899
>
> Any ideas? Please let me know if you need me to run any other commands.
>
>
Here are some other outputs (meminfo and vmallocinfo) that you may find 
useful:

# cat /proc/meminfo
MemTotal:        1183420 kB
MemFree:          135760 kB
Buffers:            1020 kB
Cached:             8840 kB
SwapCached:         2824 kB
Active:              628 kB
Inactive:          13332 kB
Active(anon):        392 kB
Inactive(anon):     3664 kB
Active(file):        236 kB
Inactive(file):     9668 kB
Unevictable:          72 kB
Mlocked:              72 kB
SwapTotal:        975856 kB
SwapFree:         917124 kB
Dirty:                 0 kB
Writeback:             0 kB
AnonPages:          2248 kB
Mapped:             1940 kB
Shmem:                 0 kB
Slab:              47316 kB
SReclaimable:      13048 kB
SUnreclaim:        34268 kB
KernelStack:        1296 kB
PageTables:         2852 kB
NFS_Unstable:          0 kB
Bounce:                0 kB
WritebackTmp:          0 kB
CommitLimit:     1567564 kB
Committed_AS:     224408 kB
VmallocTotal:   34359738367 kB
VmallocUsed:      134624 kB
VmallocChunk:   34359595328 kB
HardwareCorrupted:     0 kB
AnonHugePages:         0 kB
HugePages_Total:       0
HugePages_Free:        0
HugePages_Rsvd:        0
HugePages_Surp:        0
Hugepagesize:       2048 kB
DirectMap4k:    17320640 kB
DirectMap2M:           0 kB


# cat /proc/vmallocinfo
0xffffc90000000000-0xffffc90002001000 33558528 
alloc_large_system_hash+0x14b/0x215 pages=8192 vmalloc vpages N0=8192
0xffffc90002001000-0xffffc90002012000   69632 
alloc_large_system_hash+0x14b/0x215 pages=16 vmalloc N0=16
0xffffc90002012000-0xffffc90003013000 16781312 
alloc_large_system_hash+0x14b/0x215 pages=4096 vmalloc vpages N0=4096
0xffffc90003013000-0xffffc9000301c000   36864 
alloc_large_system_hash+0x14b/0x215 pages=8 vmalloc N0=8
0xffffc9000301c000-0xffffc9000301f000   12288 
acpi_os_map_memory+0x98/0x119 phys=ddfa9000 ioremap
0xffffc90003020000-0xffffc9000302d000   53248 
acpi_os_map_memory+0x98/0x119 phys=ddf9e000 ioremap
0xffffc9000302e000-0xffffc90003030000    8192 
acpi_os_map_memory+0x98/0x119 phys=ddfbd000 ioremap
0xffffc90003030000-0xffffc90003032000    8192 
acpi_os_map_memory+0x98/0x119 phys=f7d05000 ioremap
0xffffc90003032000-0xffffc90003034000    8192 
acpi_os_map_memory+0x98/0x119 phys=ddfac000 ioremap
0xffffc90003034000-0xffffc90003036000    8192 
acpi_os_map_memory+0x98/0x119 phys=ddfbc000 ioremap
0xffffc90003036000-0xffffc90003038000    8192 
acpi_pre_map_gar+0xa9/0x1bc phys=dde34000 ioremap
0xffffc90003038000-0xffffc9000303b000   12288 
acpi_os_map_memory+0x98/0x119 phys=ddfaa000 ioremap
0xffffc9000303c000-0xffffc9000303e000    8192 
acpi_os_map_memory+0x98/0x119 phys=fed40000 ioremap
0xffffc9000303e000-0xffffc90003040000    8192 
acpi_os_map_memory+0x98/0x119 phys=fed1f000 ioremap
0xffffc90003040000-0xffffc90003061000  135168 
arch_gnttab_map_shared+0x58/0x70 ioremap
0xffffc90003061000-0xffffc90003064000   12288 
alloc_large_system_hash+0x14b/0x215 pages=2 vmalloc N0=2
0xffffc90003064000-0xffffc90003069000   20480 
alloc_large_system_hash+0x14b/0x215 pages=4 vmalloc N0=4
0xffffc9000306a000-0xffffc9000306c000    8192 
acpi_os_map_memory+0x98/0x119 phys=ddfbe000 ioremap
0xffffc9000306c000-0xffffc90003070000   16384 erst_init+0x196/0x2a5 
phys=dde34000 ioremap
0xffffc90003070000-0xffffc90003073000   12288 ghes_init+0x90/0x16f ioremap
0xffffc90003074000-0xffffc90003076000    8192 
acpi_pre_map_gar+0xa9/0x1bc phys=dde15000 ioremap
0xffffc90003076000-0xffffc90003078000    8192 
usb_hcd_pci_probe+0x228/0x3d0 phys=f7d04000 ioremap
0xffffc90003078000-0xffffc9000307a000    8192 pci_iomap+0x80/0xc0 
phys=f7d02000 ioremap
0xffffc9000307a000-0xffffc9000307c000    8192 
usb_hcd_pci_probe+0x228/0x3d0 phys=f7d03000 ioremap
0xffffc9000307c000-0xffffc9000307e000    8192 
pci_enable_msix+0x195/0x3d0 phys=f7c20000 ioremap
0xffffc9000307e000-0xffffc90003080000    8192 
pci_enable_msix+0x195/0x3d0 phys=f7b20000 ioremap
0xffffc90003080000-0xffffc90007081000 67112960 
pci_mmcfg_arch_init+0x30/0x84 phys=f8000000 ioremap
0xffffc90007081000-0xffffc90007482000 4198400 
alloc_large_system_hash+0x14b/0x215 pages=1024 vmalloc vpages N0=1024
0xffffc90007482000-0xffffc90007c83000 8392704 
alloc_large_system_hash+0x14b/0x215 pages=2048 vmalloc vpages N0=2048
0xffffc90007c83000-0xffffc90007d84000 1052672 
alloc_large_system_hash+0x14b/0x215 pages=256 vmalloc N0=256
0xffffc90007d84000-0xffffc90007e05000  528384 
alloc_large_system_hash+0x14b/0x215 pages=128 vmalloc N0=128
0xffffc90007e05000-0xffffc90007e86000  528384 
alloc_large_system_hash+0x14b/0x215 pages=128 vmalloc N0=128
0xffffc90007e86000-0xffffc90007e88000    8192 
pci_enable_msix+0x195/0x3d0 phys=f7a20000 ioremap
0xffffc90007e88000-0xffffc90007e8a000    8192 
pci_enable_msix+0x195/0x3d0 phys=f7920000 ioremap
0xffffc90007e8a000-0xffffc90007e8c000    8192 
swap_cgroup_swapon+0x60/0x170 pages=1 vmalloc N0=1
0xffffc90007e8c000-0xffffc90007e90000   16384 
e1000e_setup_tx_resources+0x34/0xc0 [e1000e] pages=3 vmalloc N0=3
0xffffc90007e90000-0xffffc90007e94000   16384 
e1000e_setup_rx_resources+0x2f/0x150 [e1000e] pages=3 vmalloc N0=3
0xffffc90007e94000-0xffffc90007e98000   16384 
e1000e_setup_tx_resources+0x34/0xc0 [e1000e] pages=3 vmalloc N0=3
0xffffc90007e98000-0xffffc90007e9c000   16384 
e1000e_setup_rx_resources+0x2f/0x150 [e1000e] pages=3 vmalloc N0=3
0xffffc90007eba000-0xffffc90007ebc000    8192 dm_vcalloc+0x2b/0x30 
pages=1 vmalloc N0=1
0xffffc90007ebc000-0xffffc90007ebe000    8192 dm_vcalloc+0x2b/0x30 
pages=1 vmalloc N0=1
0xffffc90007ec0000-0xffffc90007ee1000  135168 e1000_probe+0x23d/0xb64 
[e1000e] phys=f7c00000 ioremap
0xffffc90007ee3000-0xffffc90007ee7000   16384 
e1000e_setup_tx_resources+0x34/0xc0 [e1000e] pages=3 vmalloc N0=3
0xffffc90007ee7000-0xffffc90007eeb000   16384 
e1000e_setup_rx_resources+0x2f/0x150 [e1000e] pages=3 vmalloc N0=3
0xffffc90007f00000-0xffffc90007f21000  135168 e1000_probe+0x23d/0xb64 
[e1000e] phys=f7b00000 ioremap
0xffffc90007f40000-0xffffc90007f61000  135168 e1000_probe+0x23d/0xb64 
[e1000e] phys=f7a00000 ioremap
0xffffc90007f80000-0xffffc90007fa1000  135168 e1000_probe+0x23d/0xb64 
[e1000e] phys=f7900000 ioremap
0xffffc90007fa1000-0xffffc90007fde000  249856 sys_swapon+0x306/0xbe0 
pages=60 vmalloc N0=60
0xffffc90007fde000-0xffffc90007fe0000    8192 dm_vcalloc+0x2b/0x30 
pages=1 vmalloc N0=1
0xffffc9000803a000-0xffffc9000803c000    8192 dm_vcalloc+0x2b/0x30 
pages=1 vmalloc N0=1
0xffffc90008080000-0xffffc900080db000  372736 0xffffffffa0023046 
pages=90 vmalloc N0=90
0xffffc9000813a000-0xffffc900082c3000 1609728 register_cache+0x3d8/0x7e0 
pages=392 vmalloc N0=392
0xffffc90008766000-0xffffc9000876a000   16384 
xt_alloc_table_info+0xda/0x10e [x_tables] pages=3 vmalloc N0=3
0xffffc9000876a000-0xffffc9000876e000   16384 
xt_alloc_table_info+0xda/0x10e [x_tables] pages=3 vmalloc N0=3
0xffffc9000876e000-0xffffc90008772000   16384 
xt_alloc_table_info+0xda/0x10e [x_tables] pages=3 vmalloc N0=3
0xffffc90008772000-0xffffc90008776000   16384 
xt_alloc_table_info+0xda/0x10e [x_tables] pages=3 vmalloc N0=3
0xffffc90008776000-0xffffc9000877a000   16384 
xt_alloc_table_info+0xda/0x10e [x_tables] pages=3 vmalloc N0=3
0xffffc9000877a000-0xffffc9000877e000   16384 
xt_alloc_table_info+0xda/0x10e [x_tables] pages=3 vmalloc N0=3
0xffffc9000877e000-0xffffc90008782000   16384 
xt_alloc_table_info+0xda/0x10e [x_tables] pages=3 vmalloc N0=3
0xffffc90008782000-0xffffc90008786000   16384 
xt_alloc_table_info+0xda/0x10e [x_tables] pages=3 vmalloc N0=3
0xffffc900087a0000-0xffffc900087a2000    8192 do_replace+0xce/0x1e0 
[ebtables] pages=1 vmalloc N0=1
0xffffc900087a2000-0xffffc900087a4000    8192 do_replace+0xea/0x1e0 
[ebtables] pages=1 vmalloc N0=1
0xffffc900087a8000-0xffffc900087aa000    8192 
xenbus_map_ring_valloc+0x64/0x100 phys=3 ioremap
0xffffc900087aa000-0xffffc900087ac000    8192 
xenbus_map_ring_valloc+0x64/0x100 phys=2 ioremap
0xffffc900087ac000-0xffffc900087ae000    8192 
xenbus_map_ring_valloc+0x64/0x100 phys=e2 ioremap
0xffffc900087ae000-0xffffc900087b0000    8192 
xenbus_map_ring_valloc+0x64/0x100 phys=e7 ioremap
0xffffe8ffffc00000-0xffffe8ffffe00000 2097152 
pcpu_get_vm_areas+0x0/0x530 vmalloc
0xffffffffa0000000-0xffffffffa0005000   20480 
module_alloc_update_bounds+0x1d/0x80 pages=4 vmalloc N0=4
0xffffffffa0008000-0xffffffffa000d000   20480 
module_alloc_update_bounds+0x1d/0x80 pages=4 vmalloc N0=4
0xffffffffa0010000-0xffffffffa0016000   24576 
module_alloc_update_bounds+0x1d/0x80 pages=5 vmalloc N0=5
0xffffffffa0019000-0xffffffffa0023000   40960 
module_alloc_update_bounds+0x1d/0x80 pages=9 vmalloc N0=9
0xffffffffa0027000-0xffffffffa002c000   20480 
module_alloc_update_bounds+0x1d/0x80 pages=4 vmalloc N0=4
0xffffffffa002f000-0xffffffffa0046000   94208 
module_alloc_update_bounds+0x1d/0x80 pages=22 vmalloc N0=22
0xffffffffa0046000-0xffffffffa006d000  159744 
module_alloc_update_bounds+0x1d/0x80 pages=38 vmalloc N0=38
0xffffffffa0071000-0xffffffffa0076000   20480 
module_alloc_update_bounds+0x1d/0x80 pages=4 vmalloc N0=4
0xffffffffa0076000-0xffffffffa007b000   20480 
module_alloc_update_bounds+0x1d/0x80 pages=4 vmalloc N0=4
0xffffffffa007b000-0xffffffffa0087000   49152 
module_alloc_update_bounds+0x1d/0x80 pages=11 vmalloc N0=11
0xffffffffa0087000-0xffffffffa008d000   24576 
module_alloc_update_bounds+0x1d/0x80 pages=5 vmalloc N0=5
0xffffffffa008d000-0xffffffffa009a000   53248 
module_alloc_update_bounds+0x1d/0x80 pages=12 vmalloc N0=12
0xffffffffa009a000-0xffffffffa009f000   20480 
module_alloc_update_bounds+0x1d/0x80 pages=4 vmalloc N0=4
0xffffffffa009f000-0xffffffffa00a4000   20480 
module_alloc_update_bounds+0x1d/0x80 pages=4 vmalloc N0=4
0xffffffffa00a4000-0xffffffffa00aa000   24576 
module_alloc_update_bounds+0x1d/0x80 pages=5 vmalloc N0=5
0xffffffffa00ac000-0xffffffffa00b6000   40960 
module_alloc_update_bounds+0x1d/0x80 pages=9 vmalloc N0=9
0xffffffffa00b6000-0xffffffffa00d0000  106496 
module_alloc_update_bounds+0x1d/0x80 pages=25 vmalloc N0=25
0xffffffffa00d4000-0xffffffffa00da000   24576 
module_alloc_update_bounds+0x1d/0x80 pages=5 vmalloc N0=5
0xffffffffa00da000-0xffffffffa00e0000   24576 
module_alloc_update_bounds+0x1d/0x80 pages=5 vmalloc N0=5
0xffffffffa00e0000-0xffffffffa00e5000   20480 
module_alloc_update_bounds+0x1d/0x80 pages=4 vmalloc N0=4
0xffffffffa00ea000-0xffffffffa00ef000   20480 
module_alloc_update_bounds+0x1d/0x80 pages=4 vmalloc N0=4
0xffffffffa00ef000-0xffffffffa00f5000   24576 
module_alloc_update_bounds+0x1d/0x80 pages=5 vmalloc N0=5
0xffffffffa00f6000-0xffffffffa0103000   53248 
module_alloc_update_bounds+0x1d/0x80 pages=12 vmalloc N0=12
0xffffffffa0103000-0xffffffffa0108000   20480 
module_alloc_update_bounds+0x1d/0x80 pages=4 vmalloc N0=4
0xffffffffa0108000-0xffffffffa010d000   20480 
module_alloc_update_bounds+0x1d/0x80 pages=4 vmalloc N0=4
0xffffffffa010d000-0xffffffffa011c000   61440 
module_alloc_update_bounds+0x1d/0x80 pages=14 vmalloc N0=14
0xffffffffa011c000-0xffffffffa0121000   20480 
module_alloc_update_bounds+0x1d/0x80 pages=4 vmalloc N0=4
0xffffffffa0121000-0xffffffffa0127000   24576 
module_alloc_update_bounds+0x1d/0x80 pages=5 vmalloc N0=5
0xffffffffa0127000-0xffffffffa013a000   77824 
module_alloc_update_bounds+0x1d/0x80 pages=18 vmalloc N0=18
0xffffffffa013a000-0xffffffffa0144000   40960 
module_alloc_update_bounds+0x1d/0x80 pages=9 vmalloc N0=9
0xffffffffa0144000-0xffffffffa0154000   65536 
module_alloc_update_bounds+0x1d/0x80 pages=15 vmalloc N0=15
0xffffffffa0154000-0xffffffffa015a000   24576 
module_alloc_update_bounds+0x1d/0x80 pages=5 vmalloc N0=5
0xffffffffa015e000-0xffffffffa0163000   20480 
module_alloc_update_bounds+0x1d/0x80 pages=4 vmalloc N0=4
0xffffffffa0163000-0xffffffffa0169000   24576 
module_alloc_update_bounds+0x1d/0x80 pages=5 vmalloc N0=5
0xffffffffa0169000-0xffffffffa0172000   36864 
module_alloc_update_bounds+0x1d/0x80 pages=8 vmalloc N0=8
0xffffffffa0172000-0xffffffffa0177000   20480 
module_alloc_update_bounds+0x1d/0x80 pages=4 vmalloc N0=4
0xffffffffa0178000-0xffffffffa0180000   32768 
module_alloc_update_bounds+0x1d/0x80 pages=7 vmalloc N0=7
0xffffffffa0180000-0xffffffffa0188000   32768 
module_alloc_update_bounds+0x1d/0x80 pages=7 vmalloc N0=7
0xffffffffa018c000-0xffffffffa0191000   20480 
module_alloc_update_bounds+0x1d/0x80 pages=4 vmalloc N0=4
0xffffffffa0191000-0xffffffffa019a000   36864 
module_alloc_update_bounds+0x1d/0x80 pages=8 vmalloc N0=8
0xffffffffa019e000-0xffffffffa01a3000   20480 
module_alloc_update_bounds+0x1d/0x80 pages=4 vmalloc N0=4
0xffffffffa01a3000-0xffffffffa01a8000   20480 
module_alloc_update_bounds+0x1d/0x80 pages=4 vmalloc N0=4
0xffffffffa01a8000-0xffffffffa01bf000   94208 
module_alloc_update_bounds+0x1d/0x80 pages=22 vmalloc N0=22
0xffffffffa01bf000-0xffffffffa01c4000   20480 
module_alloc_update_bounds+0x1d/0x80 pages=4 vmalloc N0=4
0xffffffffa01c8000-0xffffffffa01cd000   20480 
module_alloc_update_bounds+0x1d/0x80 pages=4 vmalloc N0=4
0xffffffffa01cd000-0xffffffffa01d4000   28672 
module_alloc_update_bounds+0x1d/0x80 pages=6 vmalloc N0=6
0xffffffffa01d4000-0xffffffffa01db000   28672 
module_alloc_update_bounds+0x1d/0x80 pages=6 vmalloc N0=6
0xffffffffa01df000-0xffffffffa01e7000   32768 
module_alloc_update_bounds+0x1d/0x80 pages=7 vmalloc N0=7
