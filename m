From: Eric Wheeler <bcache@lists.ewheeler.net>
Subject: [PULL] v4.8-rc2 bcache fixes
Date: Fri, 19 Aug 2016 12:55:14 -0700 (PDT)
Message-ID: <alpine.LRH.2.11.1608182036520.10662@mail.ewheeler.net>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-bcache-owner@vger.kernel.org>
Received: from mx.ewheeler.net ([66.155.3.69]:35368 "EHLO mail.ewheeler.net"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1752435AbcHSTzT (ORCPT <rfc822;linux-bcache@vger.kernel.org>);
        Fri, 19 Aug 2016 15:55:19 -0400
Sender: linux-bcache-owner@vger.kernel.org
List-Id: linux-bcache@vger.kernel.org
To: axboe@kernel.dk
Cc: Kent Overstreet <kent.overstreet@gmail.com>, linux-bcache@vger.kernel.org

Hello Jens,

Please pull this bcache branch based on v4.8-rc2.  These fix one deadlock, 
one use blkdev_put() use counter, and one dmesg output with a better 
pr_err() description.

git pull https://bitbucket.org/ewheelerinc/linux.git v4.8-rc2-bcache-fixes

 drivers/md/bcache/super.c | 14 ++++++++++----
 1 file changed, 10 insertions(+), 4 deletions(-)

9070609 bcache: pr_err: more meaningful error message when nr_stripes is invalid
acc9cf8 bcache: RESERVE_PRIO is too small by one when prio_buckets() is a power of two.
d9dc170 bcache: register_bcache(): call blkdev_put() when cache_alloc() fails

Thank you!


--
Eric Wheeler
