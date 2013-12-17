From: eb <eab@gmx.ch>
Subject: bcache/btrfs interaction causing warnings
Date: Tue, 17 Dec 2013 18:50:10 +0100
Message-ID: <CAFvEZVHrfjWM=gxr1hjqQV-KASqBRe4sACxM_XMgDbv3eE4fiw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-bcache-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.17.21]:62441 "EHLO mout.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753453Ab3LQRud (ORCPT <rfc822;linux-bcache@vger.kernel.org>);
	Tue, 17 Dec 2013 12:50:33 -0500
Received: from mail-pb0-f48.google.com ([209.85.160.48]) by mail.gmx.com
 (mrgmx101) with ESMTPSA (Nemesis) id 0MWPOI-1W0EpW03MQ-00Xdyt for
 <linux-bcache@vger.kernel.org>; Tue, 17 Dec 2013 18:50:32 +0100
Received: by mail-pb0-f48.google.com with SMTP id md12so7273340pbc.35
        for <linux-bcache@vger.kernel.org>; Tue, 17 Dec 2013 09:50:30 -0800 (PST)
Sender: linux-bcache-owner@vger.kernel.org
List-Id: linux-bcache@vger.kernel.org
To: linux-bcache@vger.kernel.org

I've recently setup a system (Kernel 3.12.5-1-ARCH) which is layered as follows:

/dev/sdb3 - cache0 (80 GB Intel SSD)
/dev/sdc1 - backing device (2 TB WD HDD)

sdb3+sdc1 => /dev/bcache0

On /dev/bcache0, there's a btrfs filesystem with 2 subvolumes, mounted
as / and /home. What's been bothering me are the following entries in
my kernel log:

[13811.845540] incomplete page write in btrfs with offset 1536 and length 2560
[13870.326639] incomplete page write in btrfs with offset 3072 and length 1024

The offset/length values are always either 1536/2560 or 3072/1024,
they sum up nicely to 4K. There are 607 of those in there as I am
writing this (well, 651 now :)), the machine has been up 18 hours and
been under no particular I/O strain (it's a desktop).

Trying to fix this, I unattached the cache (still using /dev/bcache0,
but without /dev/sdb3 attached), causing these errors to disappear. As
soon as I re-attached /dev/sdb3 they started again, so I am fairly
sure it's an unfavorable interaction between bcache and btrfs.

Is this something I should be worried about (they're only emitted with
KERN_INFO) or just an alignment problem? The underlying HDD is using
4K-Sectors, while the block_size of bcache seems to be 512, could that
be the issue here?

I've also encountered incomplete reads and a few csum errors, but I
have not been able to trigger these regularly.

Any advice is appreciated,

- eb

PS: I've only sent this to the bcache list so far, if this is a
concern for btrfs, let me know and I will take it there. However,
without the cache enabled, it seems to run without a hitch.
