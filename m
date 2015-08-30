From: Vojtech Pavlik <vojtech@suse.cz>
Subject: Bcache stuck at writeback of a key, consuming 100% CPU, not possible
 to detach
Date: Sun, 30 Aug 2015 10:54:42 +0200
Message-ID: <20150830085442.GA31722@suse.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-bcache-owner@vger.kernel.org>
Received: from jablonecka.jablonka.cz ([91.219.244.36]:51868 "EHLO
	jablonecka.jablonka.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753177AbbH3J1Y (ORCPT
	<rfc822;linux-bcache@vger.kernel.org>);
	Sun, 30 Aug 2015 05:27:24 -0400
Content-Disposition: inline
Sender: linux-bcache-owner@vger.kernel.org
List-Id: linux-bcache@vger.kernel.org
To: kmo@daterainc.com
Cc: linux-bcache@vger.kernel.org

Hello Kent, list,

I have been using bcache for quite a while now. This particular setup is
a 6TB RAID5 mdraid, with a 200 GB SSD for caching, with bcache running
in writeback mode with a fixed low writeback rate and a btrfs filesystem
on top. Currently on kernel 4.1.6.

The system has survived some crashes and some power outages, however
always recovered without visible damage.

btrfs scrub finishes in a couple hours and doesn't report any errors, so
the filesystem data are consistent and readable.

Some months ago, I started observing large latencies when servicing some
I/O requests, these events would come minutes apart and would result in
applications stuck in the D state for tens of seconds.

I started debugging and found out that several factors contributed,
namely I had a large readahead value set up, disabling readahead helped.
The kernel switched to a multiqueue I/O scheduler, which didn't have
request merging, going back to deadline helped. But didn't help enough.

Then I noticed that during those situations where the system was slow, and
processes stuck in D, bcache_writeback CPU usage was soaring all the way to
saturating a core, showing this backtrace, spending time in refill_keybuf_fn():

	NMI backtrace for cpu 6
	CPU: 6 PID: 1743 Comm: bcache_writebac Not tainted 4.1.6-2.gce0123d-desktop #1
	Hardware name: Gigabyte Technology Co., Ltd. Z87MX-D3H/Z87MX-D3H-CF, BIOS F5 08/02/2013
	task: ffff8807ecf32250 ti: ffff8808045c4000 task.ti: ffff8808045c4000
	RIP: 0010:[<ffffffffa0bdf592>]  [<ffffffffa0bdf592>] refill_keybuf_fn+0x12/0x220 [bcache]
	RSP: 0018:ffff8808045c7b68  EFLAGS: 00000292
	RAX: ffffffffa0bdf580 RBX: 0000000000000000 RCX: ffffc900073fb000
	RDX: ffff8807e4d4cca0 RSI: ffff8807fb22e800 RDI: ffff8808045c7db8
	RBP: ffff8808045c7db8 R08: ffff8807ea466000 R09: 0000000000000001
	R10: 0000000000000008 R11: 000007ffffffffff R12: ffff8808045c7db8
	R13: 0000000000000000 R14: 00000000ffffffff R15: ffff8807fb22e8d0
	FS:  0000000000000000(0000) GS:ffff88082f380000(0000) knlGS:0000000000000000
	CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
	CR2: 00007f5c080b4660 CR3: 0000000002e0f000 CR4: 00000000001426e0
	Stack:
	 ffffffffa0bde137 0000000000000000 ffff8807fb22e800 0000000000000000
	 ffff8807fb22e800 ffff8808045c7db8 0000000000000000 ffffffffa0be2120
	 ffff8807ea4a0000 ffffffffa0bdf580 ffffffffa0bdee84 00000001a0bdcfc3
	Call Trace:
	 [<ffffffffa0be2120>] bch_btree_map_keys_recurse+0x50/0x170 [bcache]
	 [<ffffffffa0be21a4>] bch_btree_map_keys_recurse+0xd4/0x170 [bcache]
	 [<ffffffffa0be5207>] bch_btree_map_keys+0x167/0x1c0 [bcache]
	 [<ffffffffa0be5309>] bch_refill_keybuf+0xa9/0x200 [bcache]
	 [<ffffffffa0bf9d3e>] bch_writeback_thread+0x11e/0x430 [bcache]
	 [<ffffffff810876d1>] kthread+0xc1/0xe0
	 [<ffffffff816b07e2>] ret_from_fork+0x42/0x70
	Code: e8 24 e8 ac e0 48 83 c4 08 48 89 d8 5b 5d 41 5c 41 5d 41 5e 41 5f c3 0f 0b 0f 1f 44 00 00 41 55 41 54 55 53 48 89 fd 48 83 ec 18 <48> 8b 77 40 48 8b 5f 38 48 8b 3a 48 8b 0e 48 89 f8 25 ff ff 0f

Changing the configuration to writeback_percent=40 helped. For some
time at least.

When the issue returned, without any further changes to the system, I
started investigating deeper. Since writeback_percent was large, also
the amount of dirty data was large. Before poking deeper, I decided I
want to clear the dirty data entierly. So I set the system to
cache_mode=writethrough and watched the dirty data trickle to the
backing device.

But then it stopped at 2.8G and didn't progress any further. The
bcache_writeback thread was at 100% CPU usage again and system was near
unusable. Reverting to writeback made the system responsive again.

A ftrace shows this in a tight loop over and over again:

	bcache_writebac-1707  [004] ....  1064.836033: bch_btree_iter_next_filter <-bch_btree_map_keys_recurse 
	bcache_writebac-1707  [004] ....  1064.836033: bch_extent_bad <-bch_btree_iter_next_filter 
	bcache_writebac-1707  [004] ....  1064.836033: __bch_extent_invalid <-bch_extent_bad 
	bcache_writebac-1707  [004] ....  1064.836033: __ptr_invalid <-__bch_extent_invalid 
	bcache_writebac-1707  [004] ....  1064.836033: refill_keybuf_fn <-bch_btree_map_keys_recurse 
	bcache_writebac-1707  [004] ....  1064.836033: dirty_pred <-refill_keybuf_fn

A full trace can be found at http://twilight.ucw.cz/trace.bz2 and starts
with a working system, then shows the bad behavior (most of the lines)
and ends with a recovery after writeback mode was enabled again.

I also tried detaching the cache device, however, that resulted in the
same behavior that only was possible to stop by a reboot, since 
bcache was tring to flush the dirty data no matter what.

So my conclusion is that there is an extent on the cache device, that's
declared 'bad' by bcache for some reason, most likely past corruption.
And when bcache_writeback hits it, and has nothing else to work on, 
it immediately returns to it and tries again, with no progress.

I have tried enabling the "expensive debug checks" on the device, but it
didn't show any additional information in the system log when hitting
the bad extents.

Since I need to recover the system from this situation, my current plan
is to copy all the filesystem contents to another media and then rebuild
the bcache setup from scratch.

I consider this a rather serious bug, even though it is most likely
caused by the cache device being corrupted. Any hints?

Best regards,
-- 
Vojtech Pavlik
Director SUSE Labs
