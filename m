From: tang.junhui@zte.com.cn
Subject: [bug report] bcache stucked when writting jounrnal
Date: Wed, 22 Nov 2017 16:49:45 +0800
Message-ID: <1511340585-24848-1-git-send-email-tang.junhui@zte.com.cn>
Return-path: <linux-bcache-owner@vger.kernel.org>
Received: from mxhk.zte.com.cn ([63.217.80.70]:61932 "EHLO mxhk.zte.com.cn"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751588AbdKVIuC (ORCPT <rfc822;linux-bcache@vger.kernel.org>);
        Wed, 22 Nov 2017 03:50:02 -0500
Sender: linux-bcache-owner@vger.kernel.org
List-Id: linux-bcache@vger.kernel.org
To: colyli@suse.de, mlyle@lyle.org
Cc: linux-bcache@vger.kernel.org, linux-block@vger.kernel.org, tang.junhui@zte.com.cn

From: Tang Junhui <tang.junhui@zte.com.cn>

Hi, everyone:

bcache stucked when reboot system after high load.

root      1704  3.7  0.0   4164   360 ?        D    14:07   0:09 /usr/lib/udev/bcache-register /dev/sdc
[<ffffffffa062d2f5>] closure_sync+0x25/0x90 [bcache]
[<ffffffffa062b481>] bch_btree_set_root+0x1f1/0x250 [bcache]
[<ffffffffa062bcf2>] btree_split+0x632/0x760 [bcache]
[<ffffffffa062c1fb>] bch_btree_insert_recurse+0x3db/0x500 [bcache]
[<ffffffffa062c487>] bch_btree_insert+0x167/0x360 [bcache]
[<ffffffffa062feba>] bch_journal_replay+0x1aa/0x2e0 [bcache]
[<ffffffffa0642b36>] run_cache_set+0x813/0x83e [bcache]
[<ffffffffa063aee3>] register_bcache+0xea3/0x1410 [bcache]
[<ffffffff812e453f>] kobj_attr_store+0xf/0x20
[<ffffffff81246be6>] sysfs_write_file+0xc6/0x140
[<ffffffff811cdbfd>] vfs_write+0xbd/0x1e0
[<ffffffff811ce648>] SyS_write+0x58/0xb0
[<ffffffff816306c9>] system_call_fastpath+0x16/0x1b

root      2097  0.0  0.0      0     0 ?        D    14:08   0:00 [bcache_allocato]
[<ffffffffa062d2f5>] closure_sync+0x25/0x90 [bcache]
[<ffffffffa06387fe>] bch_prio_write+0x23e/0x340 [bcache]
[<ffffffffa0620e50>] bch_allocator_thread+0x340/0x350 [bcache]
[<ffffffff810990bf>] kthread+0xcf/0xe0
[<ffffffff81630618>] ret_from_fork+0x58/0x90

I try to add some debug info to the code, it seems that it always run in
journal_write_unlocked()
	else if (journal_full(&c->journal)) {
		journal_reclaim(c);
		spin_unlock(&c->journal.lock);

		btree_flush_write(c);
		continue_at(cl, journal_write, system_wq);
		return;
	}
the condition of journal_full() always returns true, so the journal 
can not finish all the time.

My code has a little difference with the upstream branch.
Could anyone give me some suggestions?

Thanks,
Tang
