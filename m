From: Josep Lladonosa <jlladono@gmail.com>
Subject: Re: bcache and memory at boot. Bug?
Date: Wed, 26 Feb 2014 17:38:22 +0100
Message-ID: <CAPBO7TbO0Uf+22ExzG3VXhZsjdQ_Voaez4t49-FUqcADA0E82g@mail.gmail.com>
References: <CAPBO7TbEAf7Bhb-kTFQ00CmBih5CdsXRHeOSf4STxQ+ndy66dQ@mail.gmail.com>
	<ldadrd$4a2$1@ger.gmane.org>
	<CAPBO7TZBgfa2CftYZYv2+dTteyBYJYyXD8vuw7KQNN5xexFjpQ@mail.gmail.com>
	<20140210224648.GC2362@kmo>
	<CAPBO7TaS8b4x02sCK8BCK0=1+ScJ+bGa6FWjYeCiaqpoik2cUg@mail.gmail.com>
	<1392117811.5355.YahooMailNeo@web181506.mail.ne1.yahoo.com>
	<CAPBO7TbeuHqur3oi9q82d6_MBG9dw=XcZ7yQyV6iSEx2uDuiMQ@mail.gmail.com>
	<CAPBO7TYN0XPBHPXnABS4uP2yqk0KEoU_vDRfQHEiGXvuq555fQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-bcache-owner@vger.kernel.org>
Received: from mail-ob0-f170.google.com ([209.85.214.170]:51859 "EHLO
	mail-ob0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751066AbaBZQiX (ORCPT
	<rfc822;linux-bcache@vger.kernel.org>);
	Wed, 26 Feb 2014 11:38:23 -0500
Received: by mail-ob0-f170.google.com with SMTP id uz6so1018070obc.15
        for <linux-bcache@vger.kernel.org>; Wed, 26 Feb 2014 08:38:23 -0800 (PST)
In-Reply-To: <CAPBO7TYN0XPBHPXnABS4uP2yqk0KEoU_vDRfQHEiGXvuq555fQ@mail.gmail.com>
Sender: linux-bcache-owner@vger.kernel.org
List-Id: linux-bcache@vger.kernel.org
To: "linux-bcache@vger.kernel.org" <linux-bcache@vger.kernel.org>

Hi again,


I have been "walking" around the code in order to debug.

Now, with kernels 3.13.3, 3.13.2 and 3.12.9 I can boot /dev/bcache0 as
the root system with all RAM available (32 GiB) with a small
modification (one line) in super.c into flash_devs_run().

To recapitulate, my system has sda partitioned with fdisk; sdb is GPT
partitioned. Cache device is /dev/sda. Backed device is another
partition in /dev/sdb. I am using a proportionally big partition for
the cache device (211551921 blocks) and perhaps some code would have
failed with these numbers.

What have I found?
Cache device has 4096 nr_uuids and some of them have an incorrect
value of "sectors". Incorrect values all of them have a value higher
than 0x9000000000000000, so I applied a "filter" in order not to run
the uuids (that avoids the try to allocate such huge quantity of RAM).

Some sample lines from /var/log/messages:
----------------------------------------
(...)
Feb 26 14:10:08 minijep kernel: [    3.589559] bcache:
flash_devs_run() P00: flash_dev_run:  uuids[875] u: ffff88080129b580,
u->sectors: 9000000002800000
Feb 26 14:10:08 minijep kernel: [    3.589561] bcache:
flash_devs_run() P00: flash_dev_run:  uuids[876] u: ffff88080129b600,
u->sectors: 16112800
Feb 26 14:10:08 minijep kernel: [    3.589562] bcache:
flash_devs_run() P00: flash_dev_run:  uuids[877] u: ffff88080129b680,
u->sectors: 41ab21000
Feb 26 14:10:08 minijep kernel: [    3.589563] bcache:
flash_devs_run() P00: flash_dev_run:  uuids[878] u: ffff88080129b700,
u->sectors: 9000000000800000
Feb 26 14:10:08 minijep kernel: [    3.589565] bcache:
flash_devs_run() P00: flash_dev_run:  uuids[879] u: ffff88080129b780,
u->sectors: 16112a40
Feb 26 14:10:08 minijep kernel: [    3.589566] bcache:
flash_devs_run() P00: flash_dev_run:  uuids[880] u: ffff88080129b800,
u->sectors: 41f8dd800
Feb 26 14:10:08 minijep kernel: [    3.589567] bcache:
flash_devs_run() P00: flash_dev_run:  uuids[881] u: ffff88080129b880,
u->sectors: 9000000002000000
Feb 26 14:10:08 minijep kernel: [    3.589569] bcache:
flash_devs_run() P00: flash_dev_run:  uuids[882] u: ffff88080129b900,
u->sectors: 16112c58
Feb 26 14:10:08 minijep kernel: [    3.589570] bcache:
flash_devs_run() P00: flash_dev_run:  uuids[883] u: ffff88080129b980,
u->sectors: 42ab53800
Feb 26 14:10:08 minijep kernel: [    3.589572] bcache:
flash_devs_run() P00: flash_dev_run:  uuids[884] u: ffff88080129ba00,
u->sectors: 9000000000800000
Feb 26 14:10:08 minijep kernel: [    3.589573] bcache:
flash_devs_run() P00: flash_dev_run:  uuids[885] u: ffff88080129ba80,
u->sectors: 16112eb8
Feb 26 14:10:08 minijep kernel: [    3.589574] bcache:
flash_devs_run() P00: flash_dev_run:  uuids[886] u: ffff88080129bb00,
u->sectors: 431732000
Feb 26 14:10:08 minijep kernel: [    3.589576] bcache:
flash_devs_run() P00: flash_dev_run:  uuids[887] u: ffff88080129bb80,
u->sectors: 9000000000800000
Feb 26 14:10:08 minijep kernel: [    3.589577] bcache:
flash_devs_run() P00: flash_dev_run:  uuids[888] u: ffff88080129bc00,
u->sectors: 16118250
Feb 26 14:10:08 minijep kernel: [    3.589578] bcache:
flash_devs_run() P00: flash_dev_run:  uuids[889] u: ffff88080129bc80,
u->sectors: c014a000
Feb 26 14:10:08 minijep kernel: [    3.589580] bcache:
flash_devs_run() P00: flash_dev_run:  uuids[890] u: ffff88080129bd00,
u->sectors: 9000000000800000
Feb 26 14:10:08 minijep kernel: [    3.589581] bcache:
flash_devs_run() P00: flash_dev_run:  uuids[891] u: ffff88080129bd80,
u->sectors: 24bb8960
Feb 26 14:10:08 minijep kernel: [    3.589582] bcache:
flash_devs_run() P00: flash_dev_run:  uuids[892] u: ffff88080129be00,
u->sectors: 162c74800
Feb 26 14:10:08 minijep kernel: [    3.589584] bcache:
flash_devs_run() P00: flash_dev_run:  uuids[893] u: ffff88080129be80,
u->sectors: 9000000001800000
Feb 26 14:10:08 minijep kernel: [    3.589585] bcache:
flash_devs_run() P00: flash_dev_run:  uuids[894] u: ffff88080129bf00,
u->sectors: 24bb8a00
Feb 26 14:10:08 minijep kernel: [    3.589586] bcache:
flash_devs_run() P00: flash_dev_run:  uuids[895] u: ffff88080129bf80,
u->sectors: 162c8e000
(...)
Feb 26 14:10:08 minijep kernel: [    3.593789] bcache:
flash_devs_run() P00: flash_dev_run:  uuids[4093] u: ffff8808012ffe80,
u->sectors: 0
Feb 26 14:10:08 minijep kernel: [    3.593791] bcache:
flash_devs_run() P00: flash_dev_run:  uuids[4094] u: ffff8808012fff00,
u->sectors: 0
Feb 26 14:10:08 minijep kernel: [    3.593792] bcache:
flash_devs_run() P00: flash_dev_run:  uuids[4095] u: ffff8808012fff80,
u->sectors: 0
Feb 26 14:10:08 minijep kernel: [    3.593794] bcache:
register_cache() registered cache device sda1
(...)
Feb 26 14:10:08 minijep kernel: [    5.781599] [drm] Enabling RC6
states: RC6 on, RC6p off, RC6pp off
Feb 26 14:10:08 minijep kernel: [   35.627315] Adding 32225276k swap
on /dev/sdb6.  Priority:-1 extents:1 across:32225276k
(...)
-----------------------------------------


The change to super.c (pr_info() call is for logging and next if is my
salvation ;-):


static int flash_devs_run(struct cache_set *c)
{
    int ret = 0;
    struct uuid_entry *u;
_debug_show_uuids_of_cache_set(9999,c);
    for (u = c->uuids;
         u < c->uuids + c->nr_uuids && !ret;
         u++)
         {
        pr_info("P00: flash_dev_run:  uuids[%d] u: %p, u->sectors:
%llx", u-c->uuids, u, u->sectors);
             if (u->sectors < 0x9000000000000000)
        if (UUID_FLASH_ONLY(u))
            ret = flash_dev_run(c, u);
        }


    return ret;
}


In order to log that large number of lines I boot with kernel
parameter: log_buf_len=10M

I would like to add that booting the system spends (I think that
waiting for something) some time to boot, but it could be another
thing (look at last lines of previous /var/log/messages).

As you have seen this is a "trick" to bypass something wich is going
wrong. My question is:

- where is "sectors" field of each uuids struct filled? Is the value
read from the cache device?

I guess that something could happen (or have happened) in some
conversion (int/long instead of unsigned long) or in addressing to
memory and a pointer which modified something which it should not.

I would like to know what happens in order to avoid the use of the
filtering line for big numbers in sectors field as I guess that
something else should be verified...

Josep

On 26 February 2014 17:03, Josep Lladonosa <jlladono@gmail.com> wrote:
> Hello,
>
> I forward some information wich was missing in the list. After this I
> write another message with some (good news for me and) information
> about things that I have found.
>
> Josep
>
> ---------- Forwarded message ----------
> From: Josep Lladonosa <jlladono@gmail.com>
> Date: 11 February 2014 17:39
> Subject: Re: bcache and memory at boot. Bug?
> To: matthew patton <pattonme@yahoo.com>
>
>
> On 11 February 2014 12:23, matthew patton <pattonme@yahoo.com> wrote:
>>
>>
>>  >>>  -Free memory with kernel 3.11.0-rc7 with 32GiB and bcache0 (halved?)
>>>>>  and bcache1 (mounted)
>>>>>
>>>>>  $ head -2 /proc/meminfo
>>>>>  MemTotal:       32913872 kB
>>>>>  MemFree:        12376640 kB
>>>>>
>>>>>
>>>>>  - Free memory with kernel 3.12.9 with mem=16G and bcache0 (mounted)
>>>>>
>>>>>  $ head -2 /proc/meminfo
>>>>>  MemTotal:       15602144 kB
>>>>>  MemFree:        14005372 kB
>>
>>
>> too many variables. Boot the same box with the SAME kernel, just twiddle how much ram is visible via the GRUB commandline. ... try with mem=16G and other values like 12G, 24G or 31G
>
> O.K. Here you are:
>
> With kernel 3.13.2:
>
> mem=2G  ---> boots O.K. (/dev/bcache0).
> mem=4G  ---> Out of memory. (initramfs appears with bcache0 and
> bcache1 for only one caching device. bcache1 has the two correct
> slaves).
> mem=8G  ---> bcache-register killed. Kernel panic.
> mem=16G --> Out of memory (initramfs appears with bcache0 to bcache7
> for only one caching device. bcache7 has the two correct slaves).
> mem=20G --> Out of memory (no initramfs prompt appearing).
> mem=24G --> Out of memory (initramfs appears with bcache0 to bcache9
> for only one caching device. bcache9 has the two correct slaves).
>
> (the more RAM is given to box, the more messages about out of memory you get.
>
> Kernel 3.12.9
>
> Command line: BOOT_IMAGE=/vmlinuz-3.12.9 root=/dev/bcache0 ro
> "acpi_osi=!Windows 2012" quiet mem=16G intel_pstate=disable
> pcie_aspm=force i915.i915_enable_rc6=1 i915.i915_enable_fbc=1
> i915.lvds_downclock=1 rcutree.rcu_idle_gp_delay=1
>
> (changing mem kernel boot parameter):
>
> mem=12G  ---> boots O.K. (/dev/bcache0).
> mem=14G  ---> boots O.K. (/dev/bcache0).
> mem=16G  ---> boots O.K. (/dev/bcache0).
> mem=17G  ---> boots O.K. (/dev/bcache0).
> mem=18G  ---> boots O.K. (/dev/bcache0).
> mem=20G  ---> Kernel panic.
> mem=24G  ---> Kernel panic.
> mem=32G  ---> Out of memory. (initramfs appears with bcache0 and
> bcache1 for only one caching device. bcache1 has the two correct
> slaves).
>
>
> With kernel 3.12.9, When booting, with udev info in /var/log/messages,
> there are memory allocation failure for bcache-register messages:
>
>
> Feb 11 17:22:10 minijep kernel: [    3.099025] bio: create slab <bio-1> at 1
> Feb 11 17:22:10 minijep kernel: [    3.452716] bcache:
> bch_journal_replay() journal replay done, 575 keys in 49 entries, seq
> 573572
> Feb 11 17:22:10 minijep kernel: [    3.452777] vmalloc: allocation
> failure: 19327352836 bytes
> Feb 11 17:22:10 minijep kernel: [    3.452780] bcache-register: page
> allocation failure: order:0, mode:0x80d2
> Feb 11 17:22:10 minijep kernel: [    3.452783] CPU: 0 PID: 298 Comm:
> bcache-register Not tainted 3.12.9 #1
> Feb 11 17:22:10 minijep kernel: [    3.452784] Hardware name:
> Micro-Star International Co., Ltd. GT60/MS-16F3, BIOS E16F3IMS.10U
> 01/21/2013
> Feb 11 17:22:10 minijep kernel: [    3.452786]  0000f72000000083
> ffffffff8137e021 0000000000000001 ffffffff810c0864
> Feb 11 17:22:10 minijep kernel: [    3.452789]  ffffffff814fdf94
> ffff880036f65b70 0000000000000018 ffff880036f65be8
> Feb 11 17:22:10 minijep kernel: [    3.452792]  ffff880036f65b88
> ffff880036fc8b20 0000000000000000 0000000000000003
> Feb 11 17:22:10 minijep kernel: [    3.452795] Call Trace:
> Feb 11 17:22:10 minijep kernel: [    3.452804]  [<ffffffff8137e021>] ?
> dump_stack+0x41/0x51
> Feb 11 17:22:10 minijep kernel: [    3.452808]  [<ffffffff810c0864>] ?
> warn_alloc_failed+0x118/0x12c
> Feb 11 17:22:10 minijep kernel: [    3.452814]  [<ffffffff810e7134>] ?
> __vmalloc_node_range+0x1cd/0x1de
> Feb 11 17:22:10 minijep kernel: [    3.452817]  [<ffffffff810e7171>] ?
> __vmalloc_node+0x2c/0x31
> Feb 11 17:22:10 minijep kernel: [    3.452827]  [<ffffffffa01ebd1c>] ?
> bcache_device_init+0x81/0x241 [bcache]
> Feb 11 17:22:10 minijep kernel: [    3.452832]  [<ffffffff810e71ab>] ?
> vzalloc+0x21/0x22
> Feb 11 17:22:10 minijep kernel: [    3.452839]  [<ffffffffa01ebd1c>] ?
> bcache_device_init+0x81/0x241 [bcache]
> Feb 11 17:22:10 minijep kernel: [    3.452845]  [<ffffffffa01ec05e>] ?
> flash_dev_run+0x7d/0x12b [bcache]
> Feb 11 17:22:10 minijep kernel: [    3.452854]  [<ffffffffa01ed88b>] ?
> run_cache_set+0x5c4/0x695 [bcache]
> Feb 11 17:22:10 minijep kernel: [    3.452859]  [<ffffffffa01eee47>] ?
> register_bcache+0x10a0/0x12d9 [bcache]
> Feb 11 17:22:10 minijep kernel: [    3.452863]  [<ffffffff810f0f15>] ?
> alloc_pages_current+0xef/0x109
> Feb 11 17:22:10 minijep kernel: [    3.452867]  [<ffffffff81159855>] ?
> sysfs_write_file+0xcf/0x103
> Feb 11 17:22:10 minijep kernel: [    3.452871]  [<ffffffff81106a23>] ?
> vfs_write+0xa8/0x10b
> Feb 11 17:22:10 minijep kernel: [    3.452874]  [<ffffffff8110705e>] ?
> SyS_write+0x41/0x74
> Feb 11 17:22:10 minijep kernel: [    3.452878]  [<ffffffff81386ca2>] ?
> system_call_fastpath+0x16/0x1b
> Feb 11 17:22:10 minijep kernel: [    3.452880] Mem-Info:
> Feb 11 17:22:10 minijep kernel: [    3.452881] Node 0 DMA per-cpu:
> Feb 11 17:22:10 minijep kernel: [    3.452883] CPU    0: hi:    0,
> btch:   1 usd:   0
> Feb 11 17:22:10 minijep kernel: [    3.452884] CPU    1: hi:    0,
> btch:   1 usd:   0
> Feb 11 17:22:10 minijep kernel: [    3.452886] CPU    2: hi:    0,
> btch:   1 usd:   0
> Feb 11 17:22:10 minijep kernel: [    3.452887] CPU    3: hi:    0,
> btch:   1 usd:   0
> Feb 11 17:22:10 minijep kernel: [    3.452888] CPU    4: hi:    0,
> btch:   1 usd:   0
> Feb 11 17:22:10 minijep kernel: [    3.452889] CPU    5: hi:    0,
> btch:   1 usd:   0
> Feb 11 17:22:10 minijep kernel: [    3.452890] CPU    6: hi:    0,
> btch:   1 usd:   0
> Feb 11 17:22:10 minijep kernel: [    3.452892] CPU    7: hi:    0,
> btch:   1 usd:   0
>
>
> --
> --
> Salutacions...Josep
> --
>
>
> --
> --
> Salutacions...Josep
> --



-- 
--
Salutacions...Josep
--
