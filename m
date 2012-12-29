From: Pim van den Berg <pim.vandenberg-IXGSG4U2CCrz+pZb47iToQ@public.gmane.org>
Subject: Re: mkfs crash
Date: Sat, 29 Dec 2012 12:53:04 +0100
Message-ID: <50DED9A0.40002@nethuis.nl>
References: <50DC3977.2080209@nethuis.nl> <20121228043144.GC10411@moria.home.lan>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-bcache-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20121228043144.GC10411-jC9Py7bek1znysI04z7BkA@public.gmane.org>
Sender: linux-bcache-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Kent Overstreet <koverstreet-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Cc: linux-bcache-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-bcache@vger.kernel.org

On 12/28/2012 05:31 AM, Kent Overstreet wrote:
> That is _odd_. I'm scratching my head over what could possibly have
> gone wrong _there_. bch_mark_sectors_bypassed() doesn't do much, I
> think the only thing that _could_ go wrong is derefing a bad pointer
> but if either of the pointers it derefs are bad things should've
> exploded earlier.
>
> Maybe I'm blind but I'm also not seeing what exactly the kernel is
> complaining about - no null pointer deref, no BUG(), no oops, just a
> bunch of backtraces. That's kind of bizzare.
>
> Send me your .config, maybe you've got something flipped off.
>
> Might be worth building a kernel with a bunch of debug stuff turned
> on - slab debugging for sure.
>
> I may have to try and replicate it on my end. At least it's something
> that happens reliably...


Yesterday I compiled a new kernel (3.2.35, bcache v3.2.28-384-gcafb412,
grsecurity-2.9.1-3.2.35-201212271951) to give it another try. I turned
on slab debugging. The same problem again.

But when I look at my syslog, I see there is something wrong with the
previous logfile. Because syslog was logrotated a while ago, I got my
information from /var/log/messages which doesn't contain all of the logging.

This is wat I see now (full log:
http://pommi.nethuis.nl/storage/software/bcache/log/mkfs-crash2.log):

[  775.832304] PAX: From 127.0.0.6: refcount overflow detected in:
mkfs.ext4:3311, uid/euid: 0/0
[  775.832345] CPU 0
[  775.832362] Pid: 3311, comm: mkfs.ext4 Not tainted 3.2.35-kvm
#3                  /DH67CF
[  775.832402] RIP: 0010:[<ffffffff813fa7e2>]  [<ffffffff813fa7e2>]
bch_mark_sectors_bypassed+0x1a/0x35
[  775.832446] RSP: 0018:ffff880203f95bf8  EFLAGS: 00000a06
[  775.832467] RAX: ffff880203888010 RBX: ffff8802038a6278 RCX:
0000000000011200
[  775.832491] RDX: 2000000000000000 RSI: 00000000007fffff RDI:
ffff8802038a6278
[  775.832515] RBP: ffff880203f95bf8 R08: 000000000000e95e R09:
ffff8802038ab560
[  775.832539] R10: 000000000000e910 R11: ffff880203f95c78 R12:
ffff880203888000
[  775.832563] R13: ffff880202b00000 R14: ffff880203f95c68 R15:
0000000000000000
[  775.832588] FS:  00006ada56e84760(0000) GS:ffff88021fa00000(0000)
knlGS:0000000000000000
[  775.832624] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[  775.832646] CR2: 0000000000d0a628 CR3: 0000000202bbf000 CR4:
00000000000406f0
[  775.832670] DR0: 0000000000000000 DR1: 0000000000000000 DR2:
0000000000000000
[  775.832694] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7:
0000000000000400
[  775.832718] Process mkfs.ext4 (pid: 3311, threadinfo
ffff8802120e5cf0, task ffff8802120e5800)
[  775.832755] Stack:
[  775.832770]  ffff880203f95c48 ffffffff813f1ef4 00000010810b5574
ffff8802038af000
[  775.832809]  ffff880203f95c48 ffff8802038a6278 ffff880203888000
ffff8802038a62d8
[  775.832852]  ffff880203f95c68 ffff880203f95c58 ffff880203f95ca8
ffffffff813f30f8
[  775.834245] Call Trace:
[  775.834265]  [<ffffffff813f1ef4>] check_should_skip+0x31f/0x335
[  775.834288]  [<ffffffff813f30f8>] request_write+0x7d/0x267
[  775.834310]  [<ffffffff813f33e0>] cached_dev_make_request+0xfe/0x1ad
[  775.834335]  [<ffffffff8128041f>] generic_make_request+0x17c/0x1d2
[  775.834358]  [<ffffffff81280545>] submit_bio+0xd0/0xdb
[  775.834380]  [<ffffffff81286061>] blkdev_issue_discard+0x158/0x1a7
[  775.834403]  [<ffffffff812866df>] blkdev_ioctl+0x2f7/0x69c
[  775.834427]  [<ffffffff8111a790>] block_ioctl+0x32/0x36
[  775.834448]  [<ffffffff810ffd6e>] do_vfs_ioctl+0x5aa/0x5fa
[  775.834472]  [<ffffffff810e1a2d>] ? cache_free_debugcheck+0x7e/0x1ec
[  775.834495]  [<ffffffff810ffe00>] sys_ioctl+0x42/0x65
[  775.834517]  [<ffffffff81566fb6>] system_call_fastpath+0x18/0x1d
[  775.834538] Code: 60 01 00 00 71 09 f0 ff 88 60 01 00 00 cd 04 c9 c3
55 48 8b 47 30 48 89 e5 f0 01 b0 64 52 00 00 71 09 f0 29 b0 64 52 00 00
cd 04 <48> 8b 87 10 01 00 00 f0 01 b0 64 01 00 00 71 09 f0 29 b0 64 01
[  775.834649] Call Trace:
[  775.834666]  [<ffffffff813f1ef4>] check_should_skip+0x31f/0x335
[  775.834689]  [<ffffffff813f30f8>] request_write+0x7d/0x267
[  775.834711]  [<ffffffff813f33e0>] cached_dev_make_request+0xfe/0x1ad
[  775.834734]  [<ffffffff8128041f>] generic_make_request+0x17c/0x1d2
[  775.834757]  [<ffffffff81280545>] submit_bio+0xd0/0xdb
[  775.834779]  [<ffffffff81286061>] blkdev_issue_discard+0x158/0x1a7
[  775.834801]  [<ffffffff812866df>] blkdev_ioctl+0x2f7/0x69c
[  775.834823]  [<ffffffff8111a790>] block_ioctl+0x32/0x36
[  775.834845]  [<ffffffff810ffd6e>] do_vfs_ioctl+0x5aa/0x5fa
[  775.834867]  [<ffffffff810e1a2d>] ? cache_free_debugcheck+0x7e/0x1ec
[  775.834890]  [<ffffffff810ffe00>] sys_ioctl+0x42/0x65
[  775.834911]  [<ffffffff81566fb6>] system_call_fastpath+0x18/0x1d

So it starts with PAX, detecting a refcount overflow, and makes
mkfs.ext4 crash. The question now is, is it a grsecurity/pax bug, a
bcache bug, or is it a combination of things?

My .config:
http://pommi.nethuis.nl/storage/software/bcache/log/config-3.2.35-kvm

I patched the linux kernel in the following order:
1. bcache v3.2.28-384-gcafb412
2. grsecurity-2.9.1-3.2.35-201212271951
3. http://pommi.nethuis.nl/storage/software/bcache/bcache-grsecurity.patch

-- 
Regards,
Pim
