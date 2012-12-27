From: Pim van den Berg <pim.vandenberg-IXGSG4U2CCrz+pZb47iToQ@public.gmane.org>
Subject: mkfs crash
Date: Thu, 27 Dec 2012 13:05:11 +0100
Message-ID: <50DC3977.2080209@nethuis.nl>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-bcache-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-bcache-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-bcache-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-bcache@vger.kernel.org

Hi,

I'm successfully using bcache on 1 partition of my system for a while
now. The SSD is split in 2 partitions to be able to enable bcache on
another partition too.

The first partition is setup like this:
/dev/md3 (mdadm, RAID1, bcache backing device)
- /dev/bcache0

I tried to setup the second partition like this:
/dev/md4 (mdadm, RAID1)
- /dev/dm-0 (luks, bcache backing device)
  - /dev/bcache3

All goes well until I try to create an ext4 (or ext3) filesystem on it.
The mkfs command crashes and couple of 1000 lines show up in my syslog
(the full log is over here:
http://pommi.nethuis.nl/storage/software/bcache/log/mkfs-crash.log):

[1631972.332656] bcache: Caching dm-0 as bcache3 on set
6bc79688-a6e0-4c21-8f44-59b0083b8169
[1631983.772362] CPU 0
[1631983.772380] Pid: 28707, comm: mkfs.ext4 Not tainted 3.2.33-kvm
#1                  /DH67CF
[1631983.772420] RIP: 0010:[<ffffffff813f91ca>]  [<ffffffff813f91ca>]
bch_mark_sectors_bypassed+0x1a/0x35
[1631983.772465] RSP: 0018:ffff880165cadbf8  EFLAGS: 00000a06
[1631983.772486] RAX: ffff8801128e0010 RBX: ffff880165fd0318 RCX:
ffff880165cadc30
[1631983.772521] RDX: 2000000000000000 RSI: 00000000007fffff RDI:
ffff880165fd0318
[1631983.772556] RBP: ffff880165cadbf8 R08: ffff88021e802be0 R09:
00000000ffffff02
[1631983.772592] R10: 00000000ffffff01 R11: ffff880165cadc78 R12:
ffff8801128e0000
[1631983.772627] R13: ffff880118450000 R14: ffff880165cadc68 R15:
0000000000000000
[1631983.772662] FS:  000067d4ad65e760(0000) GS:ffff88021fa00000(0000)
knlGS:0000000000000000
[1631983.772699] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[1631983.772722] CR2: 0000000001958908 CR3: 0000000163c68000 CR4:
00000000000406f0
[1631983.772757] DR0: 0000000000000000 DR1: 0000000000000000 DR2:
0000000000000000
[1631983.772792] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7:
0000000000000400
[1631983.772827] Process mkfs.ext4 (pid: 28707, threadinfo
ffff880133edacf0, task ffff880133eda800)
[1631983.772880]  ffff880165cadc48 ffffffff813f08dc 0000001065cadc48
ffff880163fe0000
[1631983.772919]  ffff8801128e0000 ffff880165fd0318 ffff8801128e0000
ffff880165fd0378
[1631983.772957]  ffff880165cadc68 ffff880165cadc58 ffff880165cadca8
ffffffff813f1ae0
[1631983.773015]  [<ffffffff813f08dc>] check_should_skip+0x31f/0x335
[1631983.773039]  [<ffffffff813f1ae0>] request_write+0x7d/0x267
[1631983.773061]  [<ffffffff813f1dc8>] cached_dev_make_request+0xfe/0x1ad
[1631983.773087]  [<ffffffff8127edff>] generic_make_request+0x17c/0x1d2
[1631983.773110]  [<ffffffff8127ef25>] submit_bio+0xd0/0xdb
[1631983.773133]  [<ffffffff81284a3d>] blkdev_issue_discard+0x158/0x1a7
[1631983.773156]  [<ffffffff812850bb>] blkdev_ioctl+0x2f7/0x69c
[1631983.773180]  [<ffffffff811191f8>] block_ioctl+0x32/0x36
[1631983.773203]  [<ffffffff810fe7e2>] do_vfs_ioctl+0x5aa/0x5fa
[1631983.773226]  [<ffffffff810fe874>] sys_ioctl+0x42/0x65
[1631983.773250]  [<ffffffff815657b6>] system_call_fastpath+0x18/0x1d
[1631983.773384] Call Trace:
[1631983.773401]  [<ffffffff813f08dc>] check_should_skip+0x31f/0x335
[1631983.773424]  [<ffffffff813f1ae0>] request_write+0x7d/0x267
[1631983.773447]  [<ffffffff813f1dc8>] cached_dev_make_request+0xfe/0x1ad
[1631983.773470]  [<ffffffff8127edff>] generic_make_request+0x17c/0x1d2
[1631983.773499]  [<ffffffff8127ef25>] submit_bio+0xd0/0xdb
[1631983.773520]  [<ffffffff81284a3d>] blkdev_issue_discard+0x158/0x1a7
[1631983.773544]  [<ffffffff812850bb>] blkdev_ioctl+0x2f7/0x69c
[1631983.773567]  [<ffffffff811191f8>] block_ioctl+0x32/0x36
[1631983.773590]  [<ffffffff810fe7e2>] do_vfs_ioctl+0x5aa/0x5fa
[1631983.773613]  [<ffffffff810fe874>] sys_ioctl+0x42/0x65
[1631983.773635]  [<ffffffff815657b6>] system_call_fastpath+0x18/0x1d

I'm using the 3.2.33 Linux kernel with
grsecurity-2.9.1-3.2.33-201211072000 and bcache v3.2.28-384-gcafb412.

I've tried to set it up this way multiple times but I hit the same
problem each time. Because I'm successfully running bcache on a mdadm
device, I thought there was an issue with the luks part. So I tested
this part with a USB thumb drive as a backing device:

/dev/sdd
- /dev/dm-0 (luks, bcache backing device)
  - /dev/bcache1

In this case the bcache device worked without a problem. As you can see
in the stacktrace, bch_mark_sectors_bypassed (a piece of bcache code)
causes the crash. Do you know what is going wrong here?

-- 
Regards,
Pim
