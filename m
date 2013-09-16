From: Hubert Kempkensteffen <hubert-39zlLzowylnAQEp6PLVxx6xOck334EZe@public.gmane.org>
Subject: Bcache hangs with Debian 7 (Wheezy), sync does not come back
Date: Mon, 16 Sep 2013 13:07:49 +0000 (UTC)
Message-ID: <loom.20130916T150548-751@post.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-bcache-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-bcache-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-bcache-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-bcache@vger.kernel.org

Sorry for my English.
But my Bcache depends on if I have many  Copy files.
I have tested it on two computers with me and
i have the problem with kernel 3.10.10, 3.10.11,3.10.12,3.11 and 3.11.1.

My Bcache-Tools are from git:
git clone http://evilpiepirate.org/git/bcache-tools.git
cd bcache-tools
make
make install

My Test:
||make-bcache -C /dev/sda4 -B /dev/sdb1
mkfs.ext4 -L Data /dev/bcache0
mkdir x
mount /dev/bcache0 x
rsync -avr --progress --delete /usr/src ./x/
sync

First, rsync copies the files very quickly then to be getting slower,
that goes to halt!
I give in another console "sync" here, not the command returns.
I can take the computer will not reboot with "init 6".


Example dmesg output kernel 3.10.12
dmesg | grep bcache
[    4.431850] bcache: bch_journal_replay() journal replay done, 13 keys
in 11 entries, seq 6203
[    4.431975] bcache: register_cache() registered cache device sda4
[    5.380055] bcache: register_bdev() registered backing device sdb1
[    5.382439] bcache: bch_cached_dev_attach() Caching sdb1 as bcache0
on set 44f04bd1-328d-4b8d-a971-ebd32197b07c
[ 3517.143767] EXT4-fs (bcache0): recovery complete
[ 3517.155432] EXT4-fs (bcache0): mounted filesystem with ordered data
mode. Opts: (null)


dmesg shows me after a certain time:

[ 3517.143767] EXT4-fs (bcache0): recovery complete
[ 3517.155432] EXT4-fs (bcache0): mounted filesystem with ordered data
mode. Opts: (null)
[ 3744.242908] EXT4-fs error (device sda1): ext4_iget:4208: inode
#32719: comm rsync: bogus i_mode (76640)
[ 3744.242916] Aborting journal on device sda1-8.
[ 3744.242988] EXT4-fs (sda1): Remounting filesystem read-only
[ 3744.259389] EXT4-fs error (device sda1): ext4_lookup:1437: inode
#31591: comm rsync: deleted inode referenced: 32720
[ 3782.918890] EXT4-fs error (device sda1): ext4_lookup:1437: inode
#659725: comm rsync: deleted inode referenced: 659856
[ 3782.919452] EXT4-fs error (device sda1): ext4_iget:4025: inode
#659853: comm rsync: bad extra_isize (35984 != 256)
[ 3782.919709] EXT4-fs error (device sda1): ext4_lookup:1437: inode
#659725: comm rsync: deleted inode referenced: 659855
[ 3782.919846] EXT4-fs error (device sda1): ext4_iget:4025: inode
#659854: comm rsync: bad extra_isize (36368 != 256)
[ 3788.408566] EXT4-fs error (device sda1): ext4_iget:4025: inode
#669088: comm rsync: bad extra_isize (11415 != 256)
[ 3788.410341] EXT4-fs error (device sda1): ext4_iget:4025: inode
#669087: comm rsync: bad extra_isize (54310 != 256)
[ 3843.252091] INFO: task sync:28098 blocked for more than 120 seconds.
[ 3843.252098] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs"
disables this message.
[ 3843.252101] sync            D ffff88011f49d790     0 28098    906
0x00000000
[ 3843.252107]  ffff88011f49d790 0000000000000082 ffff88011a8ec140
0000000000044800
[ 3843.252112]  0000000000012ec0 ffff8801128cbfd8 ffff8801128cbfd8
ffff88011f49d790
[ 3843.252116]  ffff8801128cbfd8 ffff88011fd12ec0 ffff88011f49d790
ffff8801128cbda0
[ 3843.252120] Call Trace:
[ 3843.252130]  [<ffffffff810bdffe>] ? __lock_page+0x66/0x66
[ 3843.252137]  [<ffffffff8136c0bf>] ? io_schedule+0x56/0x6d
[ 3843.252141]  [<ffffffff810be005>] ? sleep_on_page+0x7/0xc
[ 3843.252145]  [<ffffffff8136a504>] ? __wait_on_bit+0x3e/0x75
[ 3843.252149]  [<ffffffff810be3c5>] ? find_get_pages_tag+0xe7/0x121
[ 3843.252153]  [<ffffffff810be0b9>] ? wait_on_page_bit+0x6e/0x73
[ 3843.252157]  [<ffffffff810bda10>] ? test_and_clear_bit+0x4/0x7
[ 3843.252163]  [<ffffffff8104fcfc>] ? wake_atomic_t_function+0x21/0x21
[ 3843.252168]  [<ffffffff810be770>] ? filemap_fdatawait_range+0x66/0xfe
[ 3843.252172]  [<ffffffff8136bd5b>] ? __schedule+0x4c5/0x51b
[ 3843.252177]  [<ffffffff81121142>] ? sync_inodes_sb+0x145/0x191
[ 3843.252182]  [<ffffffff81124093>] ? fdatawrite_one_bdev+0xd/0xd
[ 3843.252187]  [<ffffffff81104a4c>] ? iterate_supers+0x63/0xb5
[ 3843.252191]  [<ffffffff811241cc>] ? sys_sync+0x2e/0x81
[ 3843.252197]  [<ffffffff81372012>] ? system_call_fastpath+0x16/0x1b
