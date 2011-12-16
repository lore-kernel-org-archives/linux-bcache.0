From: David Rhodes Clymer <david-LEGOU7lN1jbY0TyS/+Ba5Q@public.gmane.org>
Subject: bcache lockup
Date: Fri, 16 Dec 2011 12:41:49 -0500
Message-ID: <CAB7K1hG7mYqGhrn1Uy9D0DGPJJVK8T0QOX8O26BXgcJHLxZESA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-bcache-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-bcache-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-bcache-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-bcache@vger.kernel.org

I was just playing around with bcache, and set up an LV as the backing
store for the cache:

make-bcache -C -b512K /dev/sdb && echo /dev/sdb > /sys/fs/bcache/register
make-bcache -B /dev/mapper/zapazoid-bacachetest && echo
/dev/mapper-bacachetest > /sys/fs/bcache/register

echo $CACHE_UUID > /sys/block/dm-11/bcache/attach

mkfs.ext4 /dev/bcache0
mount /dev/bcache0 /mnt
scp hercules.vistashare.net:/mnt/data/backups/2011-12-10-scylla-incr.tar.bz2*
/mnt/

And there it hangs:

[78411.767785] bcache: Caching dm-11, inserted new UUID
4fb485fd-25b0-4e6a-8a57-cb3889f984be
[78601.490591] EXT4-fs (bcache0): mounted filesystem with ordered data
mode. Opts: (null)
[78962.976149] INFO: task jbd2/bcache0-8:22301 blocked for more than
120 seconds.
[78962.976158] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs"
disables this message.
[78962.976165] jbd2/bcache0-8  D 00000000     0 22301      2 0x00000000
[78962.976176]  f2690e50 00000046 00000000 00000000 00000000 00000000
00000000 31b5d000
[78962.976193]  00000000 c14aa500 f2690ffc c14aa500 f2690e50 c14aa500
c14aa500 00000001
[78962.976208]  00000000 00000000 f2cb60c0 f2cb60c0 00000000 f2cb60c0
c10380ee 00000002
[78962.976221] Call Trace:
[78962.976239]  [<c10380ee>] ? load_balance+0x60/0x58a
[78962.976282]  [<f833ca94>] ?
jbd2_journal_commit_transaction+0x17e/0xf36 [jbd2]
[78962.976295]  [<c100b769>] ? __switch_to+0x6f/0xe2
[78962.976305]  [<c12c00df>] ? __schedule+0x58d/0x5b4
[78962.976316]  [<c105115a>] ? wake_up_bit+0x56/0x56
[78962.976324]  [<c102c141>] ? __wake_up_common+0x34/0x5a
[78962.976332]  [<c104562e>] ? lock_timer_base+0x19/0x34
[78962.976341]  [<c1045a5f>] ? try_to_del_timer_sync+0x5c/0x63
[78962.976364]  [<f8340dec>] ? kjournald2+0x9e/0x1c7 [jbd2]
[78962.976373]  [<c105115a>] ? wake_up_bit+0x56/0x56
[78962.976390]  [<f8340d4e>] ? commit_timeout+0x5/0x5 [jbd2]
[78962.976400]  [<c1050e10>] ? kthread+0x63/0x68
[78962.976409]  [<c1050dad>] ? kthread_worker_fn+0x114/0x114
[78962.976418]  [<c12c6ebe>] ? kernel_thread_helper+0x6/0x10

Is there any reason bcache would not work with LVM in particular, or
did I do something else that was silly?

-davidc
