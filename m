From: Brook Davis <brook.davis-7UrYtyJGsuhBDgjK7y7TUQ@public.gmane.org>
Subject: register extended partition borks kernel
Date: Thu, 02 Aug 2012 12:47:43 -0400
Message-ID: <501AAF2F.2010000@nimboxx.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-bcache-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-bcache-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-bcache-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-bcache@vger.kernel.org

Hi all,

I've been trying (unsuccessfully) to have my bcache device automount on 
boot as a backing store for libvirt to use.

I was trying to use the loop in the bcache initramfs script and found my 
machine was repeatedly hanging.  After some testing, I found this was 
due to bcache blowing up when I echo'd the device node of an extended 
partition to the register sys interface.

Here's what I was doing:

         for i in `ls /dev/sd*`; do
                 echo    $i > /sys/fs/bcache/register_quiet
         done

It hangs on /dev/sda2.  Here's my disk layout for sda:

root@brain:~# fdisk -l /dev/sda

Disk /dev/sda: 1000.2 GB, 1000204886016 bytes
255 heads, 63 sectors/track, 121601 cylinders
Units = cylinders of 16065 * 512 = 8225280 bytes
Sector size (logical/physical): 512 bytes / 512 bytes
I/O size (minimum/optimal): 512 bytes / 512 bytes
Disk identifier: 0x000b0e70

    Device Boot      Start         End      Blocks   Id  System
/dev/sda1   *           1      120559   968381440   83  Linux
/dev/sda2          120559      121602     8378369    5  Extended
/dev/sda5          120559      121602     8378368   82  Linux swap / Solaris

and kernel :

Linux brain 3.5.0-rc6+ #1 SMP Thu Jul 19 16:13:20 EDT 2012 x86_64 x86_64 
x86_64 GNU/Linux

git commit : a29809551cd847e5588c9ebc843eda5cd3736d8e

I found doing this "echo /dev/sda2 > /sys/fs/bcache/register_quiet"  
completely hangs the machine, producing this in my logs:

Aug  2 12:37:12 brain kernel: [  395.881134] INFO: rcu_sched 
self-detected stall on CPU { 3}  (t=6000 jiffies)
Aug  2 12:37:12 brain kernel: [  395.881153] Pid: 1662, comm: bash Not 
tainted 3.5.0-rc6+ #1
Aug  2 12:37:12 brain kernel: [  395.881156] Call Trace:
Aug  2 12:37:12 brain kernel: [  395.881158] <IRQ>  [<ffffffff810e4e96>] 
__rcu_pending+0x216/0x4a0
Aug  2 12:37:12 brain kernel: [  395.881174]  [<ffffffff810a6f30>] ? 
tick_nohz_handler+0xf0/0xf0
Aug  2 12:37:12 brain kernel: [  395.881179]  [<ffffffff810e514c>] 
rcu_pending+0x2c/0x70
Aug  2 12:37:12 brain kernel: [  395.881184]  [<ffffffff810e5991>] 
rcu_check_callbacks+0xa1/0x140
Aug  2 12:37:12 brain kernel: [  395.881189]  [<ffffffff81063578>] 
update_process_times+0x48/0x90
Aug  2 12:37:12 brain kernel: [  395.881193]  [<ffffffff810a6f94>] 
tick_sched_timer+0x64/0xc0
Aug  2 12:37:12 brain kernel: [  395.881197]  [<ffffffff81079a32>] 
__run_hrtimer+0x72/0x1d0
Aug  2 12:37:12 brain kernel: [  395.881203]  [<ffffffff8101b9a9>] ? 
read_tsc+0x9/0x20
Aug  2 12:37:12 brain kernel: [  395.881207]  [<ffffffff8107a263>] 
hrtimer_interrupt+0xe3/0x210
Aug  2 12:37:12 brain kernel: [  395.881212]  [<ffffffff8163d319>] 
smp_apic_timer_interrupt+0x69/0x99
Aug  2 12:37:12 brain kernel: [  395.881219]  [<ffffffff8163c08a>] 
apic_timer_interrupt+0x6a/0x70
Aug  2 12:37:12 brain kernel: [  395.881220] <EOI>  [<ffffffff8130bb43>] 
? radix_tree_lookup_element+0x43/0x90
Aug  2 12:37:12 brain kernel: [  395.881230]  [<ffffffff8130bb9e>] 
radix_tree_lookup_slot+0xe/0x10
Aug  2 12:37:12 brain kernel: [  395.881237]  [<ffffffff8111bf6e>] 
find_get_page+0x1e/0xa0
Aug  2 12:37:12 brain kernel: [  395.881240]  [<ffffffff8111c1e6>] 
find_lock_page+0x26/0x80
Aug  2 12:37:12 brain kernel: [  395.881246]  [<ffffffff811a8704>] ? 
__find_get_block+0xa4/0x210
Aug  2 12:37:12 brain kernel: [  395.881250]  [<ffffffff8111cebf>] 
find_or_create_page+0x3f/0xb0
Aug  2 12:37:12 brain kernel: [  395.881254]  [<ffffffff811a8ef6>] 
__getblk+0xe6/0x280
Aug  2 12:37:12 brain kernel: [  395.881270]  [<ffffffff811a90e3>] 
__bread+0x13/0xa0
Aug  2 12:37:12 brain kernel: [  395.881285]  [<ffffffffa001a5d2>] 
register_bcache+0x192/0xa00 [bcache]
Aug  2 12:37:12 brain kernel: [  395.881292]  [<ffffffff8115d761>] ? 
alloc_pages_current+0xb1/0x120
Aug  2 12:37:12 brain kernel: [  395.881298]  [<ffffffff81308987>] 
kobj_attr_store+0x17/0x20
Aug  2 12:37:12 brain kernel: [  395.881304]  [<ffffffff811e6281>] 
sysfs_write_file+0xd1/0x160
Aug  2 12:37:12 brain kernel: [  395.881311]  [<ffffffff81177c06>] 
vfs_write+0xc6/0x180
Aug  2 12:37:12 brain kernel: [  395.881315]  [<ffffffff81177f21>] 
sys_write+0x51/0x90
Aug  2 12:37:12 brain kernel: [  395.881320]  [<ffffffff8163b5e9>] 
system_call_fastpath+0x16/0x1b



Any thoughts on this ?

What is the correct way to pull bcache devices up prior to mounting, so 
they can be automounted via fstab entries ?

Please let me know if I can provide more / better info.

Thanks,

Brook
