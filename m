From: Hubert Kempkensteffen <hubert-39zlLzowylnAQEp6PLVxx6xOck334EZe@public.gmane.org>
Subject: Re: [PATCH] bcache: Possible flush fix
Date: Wed, 18 Sep 2013 17:05:41 +0000 (UTC)
Message-ID: <loom.20130918T185911-803@post.gmane.org>
References: <loom.20130916T150548-751@post.gmane.org> <20130917020316.GC10907@kmo-pixel> <loom.20130917T122135-908@post.gmane.org> <20130917203741.GA32037@kmo-pixel> <loom.20130917T224603-574@post.gmane.org> <20130917214043.GF32037@kmo-pixel>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-bcache-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-bcache-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-bcache-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-bcache@vger.kernel.org

Kent Overstreet <kmo@...> writes:

> 
> Jens suggested that cloning the bio to issue a bare flush might be
> copying some flags we don't want, and at least allocating a new bio
> would be more correct. Worth a shot...
> 
> Signed-off-by: Kent Overstreet <kmo@...>
> ---
> 
> On Tue, Sep 17, 2013 at 08:54:57PM +0000, Hubert Kempkensteffen wrote:
> > Kent Overstreet <kmo <at> ...> writes:
> > Sorry, my english.
> > I have no raid and no LVM. There are both ordinary machines.
> > And I just want to speed up the data disk!
> > 
> > > 
> > > I think this bug requires something else in the stack to trigger, I'm
> > > trying to figure out what the common factor is.
> 
> Can you give this patch a try?
> 
Now he stands. For about an hour, no more file has been copied.
Otherwise, the computer is running normally.

root@server:/mnt# bcache-super-show /dev/sda4
sb.magic		ok
sb.first_sector		8 [match]
sb.csum			35DD4574872CBCCF [match]
sb.version		3 [cache device]

dev.uuid		3bbe60ea-6c90-464f-a443-7f18d7951431
dev.sectors_per_block	1
dev.sectors_per_bucket	1024
dev.cache.first_sector	1024
dev.cache.cache_sectors	66003968
dev.cache.total_sectors	66004992
dev.cache.discard	no
dev.cache.pos		0

cset.uuid		0e8ea8ea-9d8d-4f0e-b01c-b3f437fe3114
root@server:/mnt# bcache-super-show /dev/sdb1
sb.magic		ok
sb.first_sector		8 [match]
sb.csum			C39910AE9C093EBE [match]
sb.version		1 [backing device]

dev.uuid		dff5307a-3994-4396-90d8-410a207f7426
dev.sectors_per_block	1
dev.sectors_per_bucket	1024
dev.data.first_sector	16
dev.data.cache_mode	0 [writethrough]
dev.data.cache_state	1 [clean]

cset.uuid		0e8ea8ea-9d8d-4f0e-b01c-b3f437fe3114
root@server:/mnt# 

dmesg
[ 7923.176147] INFO: task sync:5536 blocked for more than 120 seconds.
[ 7923.176159] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables
this message.
[ 7923.176164] sync            D ffff8800d2a97760     0  5536   8091 0x00000000
[ 7923.176174]  ffff8800d2a97760 0000000000000082 ffff88011fbf4760
ffff8800d7a09b80
[ 7923.176183]  0000000000012dc0 ffff8800aa977fd8 ffff8800aa977fd8
ffff8800d2a97760
[ 7923.176190]  ffff88011b29d8a8 ffff88011fc12dc0 ffff8800d2a97760
ffff8800aa977da0
[ 7923.176197] Call Trace:
[ 7923.176215]  [<ffffffff810b4d16>] ? __lock_page+0x66/0x66
[ 7923.176228]  [<ffffffff813661cd>] ? io_schedule+0x56/0x6c
[ 7923.176236]  [<ffffffff810b4d1d>] ? sleep_on_page+0x7/0xb
[ 7923.176244]  [<ffffffff81364fcf>] ? __wait_on_bit+0x3e/0x75
[ 7923.176252]  [<ffffffff810b50db>] ? find_get_pages_tag+0xe7/0x121
[ 7923.176260]  [<ffffffff810b4dd0>] ? wait_on_page_bit+0x6e/0x73
[ 7923.176269]  [<ffffffff8104b8b5>] ? autoremove_wake_function+0x2a/0x2a
[ 7923.176277]  [<ffffffff810b5485>] ? filemap_fdatawait_range+0x66/0xfe
[ 7923.176287]  [<ffffffff8105356d>] ? should_resched+0x5/0x23
[ 7923.176294]  [<ffffffff8136601e>] ? __wait_for_common+0x108/0x11b
[ 7923.176301]  [<ffffffff810560ca>] ? try_to_wake_up+0x199/0x199
[ 7923.176311]  [<ffffffff8111634f>] ? sync_inodes_sb+0x140/0x18c
[ 7923.176320]  [<ffffffff8111977f>] ? fdatawrite_one_bdev+0xd/0xd
[ 7923.176330]  [<ffffffff810fa42c>] ? iterate_supers+0x63/0xb5
[ 7923.176337]  [<ffffffff811198b8>] ? sys_sync+0x2e/0x81
[ 7923.176347]  [<ffffffff8136bc52>] ? system_call_fastpath+0x16/0x1b
