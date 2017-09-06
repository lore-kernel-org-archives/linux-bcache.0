From: Coly Li <colyli@suse.de>
Subject: [PATCH 00/13] bcache: fixes and update for 4.14
Date: Wed,  6 Sep 2017 14:25:50 +0800
Message-ID: <20170906062602.50497-1-colyli@suse.de>
Return-path: <linux-block-owner@vger.kernel.org>
Sender: linux-block-owner@vger.kernel.org
To: linux-bcache@vger.kernel.org, linux-block@vger.kernel.org, axboe@kernel.dk
Cc: bcache@lists.ewheeler.net, Coly Li <colyli@suse.de>
List-Id: linux-bcache@vger.kernel.org

Hi Jens,

Here are 12 patchs for bcache fixes and updates, most of them were posted
by Eric Wheeler in 4.13 merge window, but delayed due to lack of code
review.

The following patches are reviewed or acked by peer developers,
	0001-bcache-Fix-leak-of-bdev-reference.patch
	0002-bcache-fix-sequential-large-write-IO-bypass.patch
	0003-bcache-do-not-subtract-sectors_to_gc-for-bypassed-IO.patch
	0004-bcache-Don-t-reinvent-the-wheel-but-use-existing-lli.patch
	0005-bcache-gc-does-not-work-when-triggering-by-manual-co.patch
	0006-bcache-correct-cache_dirty_target-in-__update_writeb.patch
	0007-bcache-Correct-return-value-for-sysfs-attach-errors.patch
	0008-bcache-increase-the-number-of-open-buckets.patch
	0009-bcache-fix-for-gc-and-write-back-race.patch
	0010-bcache-silence-static-checker-warning.patch
	0011-bcache-Update-continue_at-documentation.patch
	0012-bcache-fix-bch_hprint-crash-and-improve-output.patch
You may consider to pick them up if no other comments come up, especially
0012-bcache-fix-bch_hprint-crash-and-improve-output.patch which fixes a
potential serious security issue as author declears.

I do basic test on the whole patch set, bcache works and behaves as
expected. For futher bcache bug reports, I will follow up them.

There are some other patches which does not pass my test currently,
once they are fixed and reviewed by peer developers I will send them
to you for 4.14 merge window.

Thanks in advance.

Coly Li
