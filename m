From: Eric Wheeler <bcache@lists.ewheeler.net>
Subject: [PULL v4.9-rc1] bcache: ioprio bypass/writeback hints with
 documentation
Date: Sun, 23 Oct 2016 18:03:12 -0700 (PDT)
Message-ID: <alpine.LRH.2.11.1610231750580.24191@mail.ewheeler.net>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-bcache-owner@vger.kernel.org>
Received: from mx.ewheeler.net ([66.155.3.69]:43310 "EHLO mail.ewheeler.net"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1756728AbcJXBDO (ORCPT <rfc822;linux-bcache@vger.kernel.org>);
        Sun, 23 Oct 2016 21:03:14 -0400
Sender: linux-bcache-owner@vger.kernel.org
List-Id: linux-bcache@vger.kernel.org
To: Jens Axboe <axboe@kernel.dk>
Cc: linux-bcache@vger.kernel.org, Kent Overstreet <kent.overstreet@gmail.com>

Hi Jens,

Please pull for v4.9:

git pull https://bitbucket.org/ewheelerinc/linux.git v4.9-rc1-bcache-sysfs-ioprio

0c25a9b bcache: documentation for ioprio cache hinting
676766a bcache: introduce per-process ioprio-based bypass/writeback hints

 Documentation/bcache.txt      | 80 ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
 drivers/md/bcache/bcache.h    |  3 +++
 drivers/md/bcache/request.c   | 24 ++++++++++++++++++++++++
 drivers/md/bcache/sysfs.c     | 71 +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
 drivers/md/bcache/writeback.c |  8 ++++++++
 drivers/md/bcache/writeback.h | 24 ++++++++++++++++++++++++
 6 files changed, 210 insertions(+)

Thank you!

--
Eric Wheeler
