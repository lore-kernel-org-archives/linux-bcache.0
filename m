From: David Rhodes Clymer <david-LEGOU7lN1jbY0TyS/+Ba5Q@public.gmane.org>
Subject: Error related to bcache volume as PV
Date: Mon, 7 May 2012 13:27:59 -0400
Message-ID: <CAB7K1hH8YPVXXQfOvLyGNpwDDBZAHUykGTM3+1PYGW0OoWAVMA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-bcache-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-bcache-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-bcache-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-bcache@vger.kernel.org

When I modify my /etc/lvm.conf and add bcache as a allowed device type:

types = [ "bcache", 16 ]

bcache is definitely in /proc/devices:

root@zapazoid:~# cat /proc/devices |grep bcache
253 bcache

Now, when I attempt a pvscan or pvcreate:

[  287.781024] bio: create slab <bio-1> at 1
[  287.824983] bcache: btree_journal_read() done
[  287.833084] bcache: btree_check() done
[  287.833087] bcache: journal replay done, 0 keys in 1 entries, seq 4-4
[  287.833144] bcache: registered cache device sdb1
[  427.970797] bcache: Caching sda2 as bcache0 on set
c6e304cc-e9d4-4d8d-85ae-d76e081e2bc3
[  446.637876] ------------[ cut here ]------------
[  446.638002] kernel BUG at fs/direct-io.c:647!
[  446.638071] invalid opcode: 0000 [#1] SMP
[  446.638207] Modules linked in: [last unloaded: scsi_wait_scan]
[  446.638358]
[  446.638424] Pid: 2292, comm: pvscan Not tainted 3.2.0+ #3 BIOSTAR
Group A780L3G/A780L3G
[  446.638623] EIP: 0060:[<c1134d0f>] EFLAGS: 00010246 CPU: 5
[  446.638651] EIP is at dio_send_cur_page+0x48f/0x4b0
[  446.638651] EAX: 00000000 EBX: f42b6a00 ECX: 0000000c EDX: 00000000
[  446.638651] ESI: f48a1d30 EDI: 00000001 EBP: f48a1c84 ESP: f48a1c50
[  446.638651]  DS: 007b ES: 007b FS: 00d8 GS: 0033 SS: 0068
[  446.638651] Process pvscan (pid: 2292, ti=f48a0000 task=f4a6eca0
task.ti=f48a0000)
[  446.638651] Stack:
[  446.638651]  00000001 f42b6a40 f48a1c74 f48a1db8 f31c2080 f31c2000
f48a1db8 074440e0
[  446.638651]  00000000 0000000c 440e0000 00000074 f48a1db8 f48a1dfc
c1135b47 f48a1db8
[  446.638651]  00000000 f4a6ef20 f48a1db8 f48a1d30 00033a80 f42b6a40
01a82d40 440e0000
[  446.638651] Call Trace:

[  446.638651]  [<c1135b47>] __blockdev_direct_IO+0x7b7/0x1870
[  446.638651]  [<c1132830>] ? block_llseek+0x100/0x100
[  446.638651]  [<c11333d0>] blkdev_direct_IO+0x60/0x70
[  446.638651]  [<c1132830>] ? block_llseek+0x100/0x100
[  446.638651]  [<c10bf4d4>] generic_file_aio_read+0x6e4/0x750
[  446.638651]  [<c1105654>] do_sync_read+0xa4/0xe0
[  446.638651]  [<c11056f3>] ? rw_verify_area+0x63/0x110
[  446.638651]  [<c16b4974>] ? mutex_lock+0x14/0x40
[  446.638651]  [<c1105d67>] vfs_read+0x97/0x160
[  446.638651]  [<c1292f54>] ? copy_to_user+0x34/0x120
[  446.638651]  [<c11055b0>] ? do_sync_write+0xe0/0xe0
[  446.638651]  [<c1105efd>] sys_read+0x3d/0x70
[  446.638651]  [<c16b5b29>] syscall_call+0x7/0xb
[  446.638651] Code: f2 89 d8 e8 74 f7 ff ff 85 ff 0f 44 f8 8b 43 30
85 c0 75 d0 8b 75 e0 85 ff c7 46 24 00 00 00 00 0f 85 b1 fd ff ff e9
c3 fe ff ff <0f> 0b eb fe 0f 0b eb fe 89 d8 e8 02 2a f9 ff 84 c0 0f 85
7d fd
[  446.638651] EIP: [<c1134d0f>] dio_send_cur_page+0x48f/0x4b0 SS:ESP
0068:f48a1c50
[  446.643626] ---[ end trace 667269d0635b2635 ]---


I'm running the latest version of bcache available, that I know of:

root@zapazoid:/usr/src/linux-bcache# git log --format=short -n1
commit f750663315afd8645badea86f4760092a137f990
Author: Kent Overstreet <koverstreet-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>

    closures: Export do_closure_timer_init()


This is with 32bit kernel/userland.

-davidc
