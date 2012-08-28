From: Jonathan Tripathy <jonnyt-Nf8S+5hNwl710XsdtD+oqA@public.gmane.org>
Subject: Re: Block Size for Windows
Date: Tue, 28 Aug 2012 21:03:29 +0100
Message-ID: <503D2411.70105@abpni.co.uk>
References: <503BC71A.6050207@abpni.co.uk> <CAH+dOxJ1GPQgmgDv4T3On-QovazSshU89GdVp=EHFmpaAzAGnQ@mail.gmail.com> <503BC82F.1030107@abpni.co.uk> <CAH+dOxJZEH9=ZEsB4RsS-8MdH-AGRh3jvo31bMUwXsMdirLMMQ@mail.gmail.com> <503BC897.3020606@abpni.co.uk> <CAH+dOxKx=kaW4duTyhRYrFH-5mYDUT6CGgY7WX9vqsMD_CpJaQ@mail.gmail.com> <503BCDC6.9010807@abpni.co.uk> <503BD1E8.7060402@abpni.co.uk> <503BD37C.9010403@abpni.co.uk> <503BD55D.2060408@abpni.co.uk> <CAOzFzEi6AzHFJVUGGc+J2p7QYe2f2i_XKrpad8wHDXo2xO=buA@mail.gmail.com> <503BEE7F.4020202@abpni.co.uk> <6035A0D088A63A46850C3988ED045A4B29A75808@BITCOM1.int.sbss.com.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8;
	format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-bcache-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <6035A0D088A63A46850C3988ED045A4B29A75808-mzsoxcrO4/2UD0RQwgcqbDSf8X3wrgjD@public.gmane.org>
Sender: linux-bcache-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: James Harper <james.harper-NMzNsA1hOHcW+bLBXbPJGg@public.gmane.org>
Cc: Joseph Glanville <joseph.glanville-2MxvZkOi9dvvnOemgxGiVw@public.gmane.org>, Kent Overstreet <koverstreet-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, "linux-bcache-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-bcache-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-bcache@vger.kernel.org

On 28/08/2012 01:59, James Harper wrote:
>> On 27/08/2012 21:18, Joseph Glanville wrote:
>>> On 28 August 2012 06:15, Jonathan Tripathy <jonnyt-Nf8S+5hNwl710XsdtD+oqA@public.gmane.org> wro=
te:
>>>> On 27/08/2012 21:07, Jonathan Tripathy wrote:
>>>>> On 27/08/2012 21:00, Jonathan Tripathy wrote:
>>>>>>> 2) The windows setup didn't complain that it couldn't install o=
n
>>>>>>> the LV, but once I clicked 'next', the Dom0 crashed and the ser=
ver
>>>>>>> rebooted. A lot of output was displayed on screen but quickly
>>>>>>> vanished as the system rebooted. I'm trying to see if the outpu=
t
>>>>>>> was saved anywhere. Any ideas why this could of happened and/or
>> where the output might be saved?
>>>>>>>
>>>>>> I'd also like to add that after the server came back up, the md
>>>>>> raid array started rebuilding. I wondering if that's just a
>>>>>> coincidence (due to the forced reboot), or a sign of something
>>>>>> wrong with the md integration with bcache?
>>>>>>
>>>>>> I'm going to see if Windows installs natively on the md array (i=
t's
>>>>>> RAID
>>>>>> 10 btw) and post back here.
>>>>> Ok, so trying to install Windows directly onto the spindles cause=
s
>>>>> the same thing to happen. I'm going to try and boot up into the
>>>>> non-bcache kernel (The default ubuntu one) and see if it works
>>>>> there. If it fails there, then this is clearly a xen and/or mdrai=
d issue...
>>>>>
>>>>> Thanks
>>>>>
>>>>>
>>>> Ok, so booting into the default Ubuntu kernel, the windows
>>>> installation seems to progress just fine.
>>>>
>>>> Does this mean there is something wrong with the mdraid code in th=
e
>>>> bcache kernel?
>>>>
>>>> Actually, I'm not telling the whole story. The kernel I'm using is
>>>> the
>>>> bcache-3.2 tree (from evilpriate.org) with changes merged in from
>>>> kernel.org's 3.2.27 tree. There were no merge conflicts when I did
>>>> the git merge.
>>>>
>>>> What do you think I should do?
>>>>
>>>>
>>>> Thanks
>>>>
>>>> --
>>>> To unsubscribe from this list: send the line "unsubscribe
>>>> linux-bcache" in the body of a message to majordomo-u79uwXL29TaqPxH82wqD4g@public.gmane.org=
g
>>>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>>> I would recommend booting with the raw bcache-3.2 branch before
>>> applying the stable patches (even though they should be fine) and
>>> trying to catch the panic.
>>> This is easiest done with a serial port and setting it to the kerne=
l
>>> console on the kernel command line in grub.
>>>
>>> Joseph.
>> Hi There,
>>
>> I can confirm that the problem occurs even when using the raw bcache=
-3.2
>> branch from evilpirate.org. Just to clarify, I am trying to install =
Windows
>> Server 2008 in a Xen HVM DomU, onto an LV which is on top of a MDRAI=
D 10
>> array. Using the bcache-3.2 kernel, the system reboots (after
>> panicing) as soon as I click 'next' after selecting the drive to ins=
tall windows
>> onto. Using the standard Ubuntu kernel everything works as normal. T=
his
>> leads me to believe that there is an issue with the mdraid code insi=
de the
>> bcache-3.2 tree. I'd like to stress that I wasn't doing any bcaching=
 during this
>> test.
>>
> FWIW, i'm using the 3.2 patches applied to a Debian kernel with lvm o=
n raid1 (not raid10) on bcache and it's all working fine since I change=
d to a 512 byte block size. I haven't done an install of 2008, just 200=
3, but there doesn't seem to be any problems.
>
>> What should my next step be? Try and find a serial cable to capture =
the
>> debug output?
>>
> Before tinkering with a serial cable, see if the system is alive enou=
gh to use netconsole - it can be a bit of a timesaver.
>
> James
Hi Everyone,

Here is the trace as capture by netconsole:

[ 130.844069] ------------[ cut here ]------------
[ 130.844165] kernel BUG at fs/bio.c:420!
[ 130.844232] invalid opcode: 0000 [#1] SMP
[ 130.844404] CPU 4
[ 130.844448] Modules linked in: xen_netback xen_blkback 8021q garp=20
xt_physdev bridge stp ebtable_filter ebtables ip6table_filter ip6_table=
s=20
iptable_filter ip_tables x_tables xen_gntdev xen_evtchn xenfs=20
nls_iso8859_1 nls_cp437 vfat fat netconsole configfs psmouse lp joydev=20
parport video mac_hid serio_raw usb_storage uas raid456 async_pq=20
async_xor xor async_memcpy async_raid6_recov usbhid hid raid10 e1000e=20
raid6_pq async_tx raid1 raid0 multipath linear
[ 130.846688]
[ 130.846746] Pid: 0, comm: swapper/4 Not tainted 3.2.0+ #1 Supermicro=20
X9SCI/X9SCA/X9SCI/X9SCA
[ 130.846956] RIP: e030:[<ffffffff811a6ef7>] [<ffffffff811a6ef7>]=20
bio_put+0x27/0x30
[ 130.847089] RSP: e02b:ffff88005ff3cb80 EFLAGS: 00010246
[ 130.847155] RAX: 0000000000000000 RBX: 00000000fffffffb RCX:=20
00000000000003a6
[ 130.847224] RDX: 00000000000003a5 RSI: 0000000000016c00 RDI:=20
ffff880039b58918
[ 130.847293] RBP: ffff88005ff3cb80 R08: ffffffff81115e67 R09:=20
0000000000000100
[ 130.847362] R10: ffff88001a16eea0 R11: 0000000000000000 R12:=20
ffff880017fd4018
[ 130.847431] R13: ffff880039b58918 R14: ffff880017220028 R15:=20
ffff88001a6dd400
[ 130.847504] FS: 00007f507e004700(0000) GS:ffff88005ff39000(0000)=20
knlGS:0000000000000000
[ 130.847590] CS: e033 DS: 002b ES: 002b CR0: 000000008005003b
[ 130.847656] CR2: 00007f507d6910b0 CR3: 000000003989a000 CR4:=20
0000000000002660
[ 130.847725] DR0: 0000000000000000 DR1: 0000000000000000 DR2:=20
0000000000000000
[ 130.847794] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7:=20
0000000000000400
[ 130.847863] Process swapper/4 (pid: 0, threadinfo ffff88003d646000,=20
task ffff88003d648000)
[ 130.847952] Stack:
[ 130.848012] ffff88005ff3cbc0 ffffffff8150238e ffff88003d6e40b0=20
ffff880039b58900
[ 130.848258] ffff880039b58920 ffff88001a278100 0000000000000018=20
0000000000000001
[ 130.848505] ffff88005ff3cbd0 ffffffff811a5f5d ffff88005ff3cbf0=20
ffffffff811a6f3e
[ 130.848749] Call Trace:
[ 130.848810] <IRQ>
[ 130.848914] [<ffffffff8150238e>] clone_endio+0x8e/0xd0
[ 130.848979] [<ffffffff811a5f5d>] bio_endio+0x1d/0x40
[ 130.849047] [<ffffffff811a6f3e>] bio_pair_release+0x3e/0x50
[ 130.849113] [<ffffffff811a6f6f>] bio_pair_end+0x1f/0x30
[ 130.849180] [<ffffffff811a5f5d>] bio_endio+0x1d/0x40
[ 130.849248] [<ffffffffa00dd3d2>] raid_end_bio_io+0xf2/0x100 [raid10]
[ 130.849319] [<ffffffffa00ddf38>] one_write_done+0x38/0x50 [raid10]
[ 130.849390] [<ffffffffa00deec4>] raid10_end_write_request+0xc4/0x130=20
[raid10]
[ 130.849476] [<ffffffff811a5f5d>] bio_endio+0x1d/0x40
[ 130.849543] [<ffffffff812e7a03>] req_bio_endio.isra.49+0xa3/0xe0
[ 130.849614] [<ffffffff812e839d>] blk_update_request+0xfd/0x480
[ 130.849681] [<ffffffff812e8751>] blk_update_bidi_request+0x31/0x90
[ 130.849751] [<ffffffff812e9a4c>] blk_end_bidi_request+0x2c/0x80
[ 130.849819] [<ffffffff812e9ae0>] blk_end_request+0x10/0x20
[ 130.849888] [<ffffffff8141d89f>] scsi_io_completion+0xaf/0x630
[ 130.849960] [<ffffffff8165c88e>] ? _raw_spin_unlock_irqrestore+0x1e/0=
x30
[ 130.850031] [<ffffffff81413d31>] scsi_finish_command+0xc1/0x120
[ 130.850098] [<ffffffff8141d6fe>] scsi_softirq_done+0x13e/0x150
[ 130.850167] [<ffffffff812ef9f3>] blk_done_softirq+0x83/0xa0
[ 130.850237] [<ffffffff8106d4d8>] __do_softirq+0xa8/0x210
[ 130.850304] [<ffffffff8139ddf7>] ? __xen_evtchn_do_upcall+0x207/0x250
[ 130.850373] [<ffffffff816669ac>] call_softirq+0x1c/0x30
[ 130.850442] [<ffffffff81015195>] do_softirq+0x65/0xa0
[ 130.850507] [<ffffffff8106d8be>] irq_exit+0x8e/0xb0
[ 130.850574] [<ffffffff8139fbb5>] xen_evtchn_do_upcall+0x35/0x50
[ 130.850643] [<ffffffff816669fe>] xen_do_hypervisor_callback+0x1e/0x30
[ 130.850711] <EOI>
[ 130.850810] [<ffffffff810013aa>] ? hypercall_page+0x3aa/0x1000
[ 130.850881] [<ffffffff810013aa>] ? hypercall_page+0x3aa/0x1000
[ 130.850950] [<ffffffff8100a170>] ? xen_safe_halt+0x10/0x20
[ 130.851017] [<ffffffff8101b5a3>] ? default_idle+0x53/0x1d0
[ 130.851085] [<ffffffff81012236>] ? cpu_idle+0xd6/0x120
[ 130.851153] [<ffffffff8100a9a9>] ? xen_irq_enable_direct_reloc+0x4/0x=
4
[ 130.851223] [<ffffffff81643992>] ? cpu_bringup_and_idle+0xe/0x10
[ 130.851291] Code: 00 00 00 00 55 48 89 e5 66 66 66 66 90 8b 47 40 85=20
c0 74 17 f0 ff 4f 40 0f 94 c0 84 c0 75 05 5d c3 0f 1f 00 e8 2b ff ff ff=
=20
5d c3 <0f> 0b 0f 1f 80 00 00 00 00 55 48 89 e5 53 48 83 ec 08 66 66 66
[ 130.854057] RIP [<ffffffff811a6ef7>] bio_put+0x27/0x30
[ 130.854163] RSP <ffff88005ff3cb80>
[ 130.854226] ---[ end trace fa3fbcc21926358a ]---
[ 130.855127] Kernel panic - not syncing: Fatal exception in interrupt
[ 130.855198] Pid: 0, comm: swapper/4 Tainted: G D 3.2.0+ #1
[ 130.855267] Call Trace:
[ 130.855327] <IRQ> [<ffffffff816516ef>] panic+0x91/0x1a7
[ 130.855438] [<ffffffff8165d85a>] oops_end+0xea/0xf0
[ 130.855505] [<ffffffff81016708>] die+0x58/0x90
[ 130.855571] [<ffffffff8165d194>] do_trap+0xc4/0x170
[ 130.855636] [<ffffffff81013e25>] do_invalid_op+0x95/0xb0
[ 130.855702] [<ffffffff811a6ef7>] ? bio_put+0x27/0x30
[ 130.855767] [<ffffffff8100a23d>] ? xen_force_evtchn_callback+0xd/0x10
[ 130.855838] [<ffffffff8100aa02>] ? check_events+0x12/0x20
[ 130.855906] [<ffffffff8166672b>] invalid_op+0x1b/0x20
[ 130.855974] [<ffffffff81115e67>] ? mempool_free_slab+0x17/0x20
[ 130.856041] [<ffffffff811a6ef7>] ? bio_put+0x27/0x30
[ 130.856109] [<ffffffff8150238e>] clone_endio+0x8e/0xd0
[ 130.856175] [<ffffffff811a5f5d>] bio_endio+0x1d/0x40
[ 130.856241] [<ffffffff811a6f3e>] bio_pair_release+0x3e/0x50
[ 130.856308] [<ffffffff811a6f6f>] bio_pair_end+0x1f/0x30
[ 130.856374] [<ffffffff811a5f5d>] bio_endio+0x1d/0x40
[ 130.856443] [<ffffffffa00dd3d2>] raid_end_bio_io+0xf2/0x100 [raid10]
[ 130.856513] [<ffffffffa00ddf38>] one_write_done+0x38/0x50 [raid10]
[ 130.856584] [<ffffffffa00deec4>] raid10_end_write_request+0xc4/0x130=20
[raid10]
[ 130.856671] [<ffffffff811a5f5d>] bio_endio+0x1d/0x40
[ 130.856738] [<ffffffff812e7a03>] req_bio_endio.isra.49+0xa3/0xe0
[ 130.856807] [<ffffffff812e839d>] blk_update_request+0xfd/0x480
[ 130.856877] [<ffffffff812e8751>] blk_update_bidi_request+0x31/0x90
[ 130.856946] [<ffffffff812e9a4c>] blk_end_bidi_request+0x2c/0x80
[ 130.857014] [<ffffffff812e9ae0>] blk_end_request+0x10/0x20
[ 130.857081] [<ffffffff8141d89f>] scsi_io_completion+0xaf/0x630
[ 130.857150] [<ffffffff8165c88e>] ? _raw_spin_unlock_irqrestore+0x1e/0=
x30
[ 130.857219] [<ffffffff81413d31>] scsi_finish_command+0xc1/0x120
[ 130.857287] [<ffffffff8141d6fe>] scsi_softirq_done+0x13e/0x150
[ 130.857356] [<ffffffff812ef9f3>] blk_done_softirq+0x83/0xa0
[ 130.857423] [<ffffffff8106d4d8>] __do_softirq+0xa8/0x210
[ 130.857491] [<ffffffff8139ddf7>] ? __xen_evtchn_do_upcall+0x207/0x250
[ 130.857562] [<ffffffff816669ac>] call_softirq+0x1c/0x30
[ 130.857631] [<ffffffff81015195>] do_softirq+0x65/0xa0
[ 130.857697] [<ffffffff8106d8be>] irq_exit+0x8e/0xb0
[ 130.857761] [<ffffffff8139fbb5>] xen_evtchn_do_upcall+0x35/0x50
[ 130.857829] [<ffffffff816669fe>] xen_do_hypervisor_callback+0x1e/0x30
[ 130.857897] <EOI> [<ffffffff810013aa>] ? hypercall_page+0x3aa/0x1000
[ 130.858010] [<ffffffff810013aa>] ? hypercall_page+0x3aa/0x1000
[ 130.858080] [<ffffffff8100a170>] ? xen_safe_halt+0x10/0x20
[ 130.858146] [<ffffffff8101b5a3>] ? default_idle+0x53/0x1d0
[ 130.858214] [<ffffffff81012236>] ? cpu_idle+0xd6/0x120
[ 130.858282] [<ffffffff8100a9a9>] ? xen_irq_enable_direct_reloc+0x4/0x=
4
[ 130.858351] [<ffffffff81643992>] ? cpu_bringup_and_idle+0xe/0x10


I hope this helps. Let me know if you need me to do any further testing=
,=20
or if you have any other questions regarding my environment.

Thanks
=EF=BB=BF
