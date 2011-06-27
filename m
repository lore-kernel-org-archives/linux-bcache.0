From: Kent Overstreet <kent.overstreet-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: kernel exception after attach cache to backing device
Date: Mon, 27 Jun 2011 12:57:19 -0700
Message-ID: <4E08E09F.2090103@gmail.com>
References: <loom.20110625T163725-978@post.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-bcache-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <loom.20110625T163725-978-eS7Uydv5nfjZ+VzJOa5vwg@public.gmane.org>
Sender: linux-bcache-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Gary Chen <twsoaring-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: linux-bcache-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-bcache@vger.kernel.org

The version in that git repository is old; I've got another version with 
many bug fixes. I ought to have a new version up soon (I have to rebase 
onto a vanilla kernel) - unfortunately, the on disk format is in flux at 
the moment, so it's probably a bad time to try it out for anything but 
testing.

(If you're feeling really adventurous, the on disk format changes won't 
require you to reformat the backing device; you can always detach the 
cache device so migrating shouldn't be hard. But keep in mind the 
barrier issue mentioned in the wiki still exists - bcache won't support 
barriers until it's in a kernel with stable pages for writeback and we 
add data checksumming for the journal).

I'm hoping to be done with the on disk format changes in around a month. 
Sorry you had to trip over some bugs... I think I'm going to try and 
figure out a way to rebase my code from the internal tree to vanilla 
2.6.34 so I can do it more often).

On 06/25/11 07:41, Gary Chen wrote:
> Hi all,
> I cloned the whole git kernel of bcache, after building, installing and followed
> the steps:
>
>    make-bcache -B /dev/sdb
>    make-bcache -C -w2k -b1M -j64 /dev/sdc
>
>    echo /dev/sdb>  /sys/fs/bcache/register
>
>    echo /dev/sdc>  /sys/fs/bcache/register
>
>    mkfs.ext4 /dev/bcache0
>    mount /dev/bcache0 /mnt
>
>    echo<UUID>  >  /sys/block/sdb/bcache/attach
>
> Then I tried to copy some files into backing device, it will always ended up
> with the following exception.
>
> Did I miss anything?
>
> Thanks in advance!
>
> [  338.484902] bcache: invalidating existing data
> [  338.485867] bcache: journal replay done, 0 keys in 0 entries
> [  338.486000] bcache: loaded cache device sdc
> [  370.746292] EXT4-fs (bcache0): mounted filesystem with ordered data mode
> [  455.012810] bcache: Caching sdb, inserted new UUID
> [  759.001294] BUG: unable to handle kernel paging request at f81cdf14
> [  759.001306] IP: [<c12447d6>] bio_insert+0x486/0x840
> [  759.001335] *pde = 3641b067 *pte = 00000000
> [  759.001340] Oops: 0002 [#1] SMP
> [  759.001345] last sysfs file:
> /sys/fs/bcache/55c83915-531d-4855-807c-2db26d742a11/tree_depth
> [  759.001354] Modules linked in: binfmt_misc snd_intel8x0 snd_ac97_codec
> ac97_bus snd_pcm snd_seq_midi snd_rawmidi snd_seq_midi_event snd_seq snd_timer
> snd_seq_device ppdev parport_pc joydev snd psmouse serio_raw soundcore
> snd_page_alloc i2c_piix4 lp parport usbhid hid ahci e1000
> [  759.001374]
> [  759.001380] Pid: 1624, comm: jbd2/bcache0-8 Not tainted 2.6.34-bcache #2
> /VirtualBox
> [  759.001385] EIP: 0060:[<c12447d6>] EFLAGS: 00010282 CPU: 0
> [  759.001390] EIP is at bio_insert+0x486/0x840
> [  759.001394] EAX: 00000000 EBX: ef89f120 ECX: f81cdf10 EDX: ef86b800
> [  759.001399] ESI: 00001df1 EDI: 00000000 EBP: ee1d3d2c ESP: ee1d3c8c
> [  759.001403]  DS: 007b ES: 007b FS: 00d8 GS: 00e0 SS: 0068
> [  759.001408] Process jbd2/bcache0-8 (pid: 1624, ti=ee1d2000 task=f43d26a0
> task.ti=ee1d2000)
> [  759.001412] Stack:
> [  759.001416]  ef89f130 00000000 0000000b ee1d3cd8 000000e2 e6902299 f43d26a0
> ef87a2e4
> [  759.001423]<0>  ef87a25c 00179836 00000000 f432ce80 ef87a264 00ef89f1
> 00000000 f6e86000
> [  759.001430]<0>  ffffffff ee1d3d2c ef89f130 00000000 00000008 f6e865a8
> f6e86000 ef87a210
> [  759.001437] Call Trace:
> [  759.001449]  [<c1249f5d>] ? bcache_make_request+0x2ed/0x5c0
> [  759.001455]  [<c103be1a>] ? update_curr+0x17a/0x350
> [  759.001462]  [<c1229d38>] ? generic_make_request+0x368/0x510
> [  759.001467]  [<c10357a2>] ? resched_task+0x22/0x70
> [  759.001474]  [<c1043c8a>] ? try_to_wake_up+0xba/0x430
> [  759.001479]  [<c1229f5a>] ? submit_bio+0x7a/0x110
> [  759.001485]  [<c1131de0>] ? bio_alloc_bioset+0x40/0xc0
> [  759.001491]  [<c112cfcf>] ? submit_bh+0xdf/0x110
> [  759.001497]  [<c112da49>] ? sync_dirty_buffer+0x49/0xd0
> [  759.001503]  [<c11c8b8c>] ? jbd2_journal_update_superblock+0x8c/0x140
> [  759.001510]  [<c11c3572>] ? jbd2_journal_commit_transaction+0xe82/0x10f0
> [  759.001515]  [<c1035b06>] ? hrtick_update+0x36/0x40
> [  759.001521]  [<c103c763>] ? dequeue_task_fair+0x43/0x50
> [  759.001526]  [<c1001e0e>] ? __switch_to+0xbe/0x170
> [  759.001542]  [<c1029928>] ? default_spin_lock_flags+0x8/0x10
> [  759.001552]  [<c14bdf1f>] ? _raw_spin_lock_irqsave+0x2f/0x50
> [  759.001556]  [<c1057bdb>] ? lock_timer_base.clone.50+0x2b/0x50
> [  759.001558]  [<c1057f22>] ? try_to_del_timer_sync+0x72/0xc0
> [  759.001561]  [<c11c7e7f>] ? kjournald2+0x8f/0x1c0
> [  759.001564]  [<c10663e0>] ? autoremove_wake_function+0x0/0x50
> [  759.001566]  [<c11c7df0>] ? kjournald2+0x0/0x1c0
> [  759.001568]  [<c1066024>] ? kthread+0x74/0x80
> [  759.001571]  [<c1065fb0>] ? kthread+0x0/0x80
> [  759.001573]  [<c100353e>] ? kernel_thread_helper+0x6/0x10
> [  759.001574] Code: ff 8b 7d 98 0f b6 8d 68 ff ff ff 0f ad fe d3 ef f6 c1 20 74
> 04 89 fe 31 ff 89 75 d0 8b 4d d0 89 7d d4 c1 e1 04 03 8a 30 01 00 00<3e>  ff 41
> 04 8b 53 14 83 c0 01 89 c7 c1 ff 1f c1 ea 1c 83 e2 07
> [  759.001595] EIP: [<c12447d6>] bio_insert+0x486/0x840 SS:ESP 0068:ee1d3c8c
> [  759.001599] CR2: 00000000f81cdf14
> [  759.001601] ---[ end trace 2e15f07eadf04a6e ]---
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-bcache" in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
