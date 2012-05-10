From: Kent Overstreet <kent.overstreet-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: Error related to bcache volume as PV
Date: Wed, 9 May 2012 22:56:03 -0400
Message-ID: <CAC7rs0u2Srxr+LevQEY8N-HX7KqpPnT8iPzVAo1REyqcjraERg@mail.gmail.com>
References: <CAB7K1hH8YPVXXQfOvLyGNpwDDBZAHUykGTM3+1PYGW0OoWAVMA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-bcache-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CAB7K1hH8YPVXXQfOvLyGNpwDDBZAHUykGTM3+1PYGW0OoWAVMA-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-bcache-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: David Rhodes Clymer <david-LEGOU7lN1jbY0TyS/+Ba5Q@public.gmane.org>
Cc: linux-bcache-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-bcache@vger.kernel.org

That I haven't seen before. I'll see if I can reproduce it.

On Mon, May 7, 2012 at 1:27 PM, David Rhodes Clymer
<david-LEGOU7lN1jbY0TyS/+Ba5Q@public.gmane.org> wrote:
> When I modify my /etc/lvm.conf and add bcache as a allowed device typ=
e:
>
> types =3D [ "bcache", 16 ]
>
> bcache is definitely in /proc/devices:
>
> root@zapazoid:~# cat /proc/devices |grep bcache
> 253 bcache
>
> Now, when I attempt a pvscan or pvcreate:
>
> [ =A0287.781024] bio: create slab <bio-1> at 1
> [ =A0287.824983] bcache: btree_journal_read() done
> [ =A0287.833084] bcache: btree_check() done
> [ =A0287.833087] bcache: journal replay done, 0 keys in 1 entries, se=
q 4-4
> [ =A0287.833144] bcache: registered cache device sdb1
> [ =A0427.970797] bcache: Caching sda2 as bcache0 on set
> c6e304cc-e9d4-4d8d-85ae-d76e081e2bc3
> [ =A0446.637876] ------------[ cut here ]------------
> [ =A0446.638002] kernel BUG at fs/direct-io.c:647!
> [ =A0446.638071] invalid opcode: 0000 [#1] SMP
> [ =A0446.638207] Modules linked in: [last unloaded: scsi_wait_scan]
> [ =A0446.638358]
> [ =A0446.638424] Pid: 2292, comm: pvscan Not tainted 3.2.0+ #3 BIOSTA=
R
> Group A780L3G/A780L3G
> [ =A0446.638623] EIP: 0060:[<c1134d0f>] EFLAGS: 00010246 CPU: 5
> [ =A0446.638651] EIP is at dio_send_cur_page+0x48f/0x4b0
> [ =A0446.638651] EAX: 00000000 EBX: f42b6a00 ECX: 0000000c EDX: 00000=
000
> [ =A0446.638651] ESI: f48a1d30 EDI: 00000001 EBP: f48a1c84 ESP: f48a1=
c50
> [ =A0446.638651] =A0DS: 007b ES: 007b FS: 00d8 GS: 0033 SS: 0068
> [ =A0446.638651] Process pvscan (pid: 2292, ti=3Df48a0000 task=3Df4a6=
eca0
> task.ti=3Df48a0000)
> [ =A0446.638651] Stack:
> [ =A0446.638651] =A000000001 f42b6a40 f48a1c74 f48a1db8 f31c2080 f31c=
2000
> f48a1db8 074440e0
> [ =A0446.638651] =A000000000 0000000c 440e0000 00000074 f48a1db8 f48a=
1dfc
> c1135b47 f48a1db8
> [ =A0446.638651] =A000000000 f4a6ef20 f48a1db8 f48a1d30 00033a80 f42b=
6a40
> 01a82d40 440e0000
> [ =A0446.638651] Call Trace:
>
> [ =A0446.638651] =A0[<c1135b47>] __blockdev_direct_IO+0x7b7/0x1870
> [ =A0446.638651] =A0[<c1132830>] ? block_llseek+0x100/0x100
> [ =A0446.638651] =A0[<c11333d0>] blkdev_direct_IO+0x60/0x70
> [ =A0446.638651] =A0[<c1132830>] ? block_llseek+0x100/0x100
> [ =A0446.638651] =A0[<c10bf4d4>] generic_file_aio_read+0x6e4/0x750
> [ =A0446.638651] =A0[<c1105654>] do_sync_read+0xa4/0xe0
> [ =A0446.638651] =A0[<c11056f3>] ? rw_verify_area+0x63/0x110
> [ =A0446.638651] =A0[<c16b4974>] ? mutex_lock+0x14/0x40
> [ =A0446.638651] =A0[<c1105d67>] vfs_read+0x97/0x160
> [ =A0446.638651] =A0[<c1292f54>] ? copy_to_user+0x34/0x120
> [ =A0446.638651] =A0[<c11055b0>] ? do_sync_write+0xe0/0xe0
> [ =A0446.638651] =A0[<c1105efd>] sys_read+0x3d/0x70
> [ =A0446.638651] =A0[<c16b5b29>] syscall_call+0x7/0xb
> [ =A0446.638651] Code: f2 89 d8 e8 74 f7 ff ff 85 ff 0f 44 f8 8b 43 3=
0
> 85 c0 75 d0 8b 75 e0 85 ff c7 46 24 00 00 00 00 0f 85 b1 fd ff ff e9
> c3 fe ff ff <0f> 0b eb fe 0f 0b eb fe 89 d8 e8 02 2a f9 ff 84 c0 0f 8=
5
> 7d fd
> [ =A0446.638651] EIP: [<c1134d0f>] dio_send_cur_page+0x48f/0x4b0 SS:E=
SP
> 0068:f48a1c50
> [ =A0446.643626] ---[ end trace 667269d0635b2635 ]---
>
>
> I'm running the latest version of bcache available, that I know of:
>
> root@zapazoid:/usr/src/linux-bcache# git log --format=3Dshort -n1
> commit f750663315afd8645badea86f4760092a137f990
> Author: Kent Overstreet <koverstreet-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
>
> =A0 =A0closures: Export do_closure_timer_init()
>
>
> This is with 32bit kernel/userland.
>
> -davidc
> --
> To unsubscribe from this list: send the line "unsubscribe linux-bcach=
e" in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at =A0http://vger.kernel.org/majordomo-info.html
