From: Eric Wheeler <bcache@lists.ewheeler.net>
Subject: [PULL] bcache: multiple updates
Date: Thu, 27 Oct 2016 16:27:43 -0700 (PDT)
Message-ID: <alpine.LRH.2.11.1610262037160.24191@mail.ewheeler.net>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-bcache-owner@vger.kernel.org>
Received: from mx.ewheeler.net ([66.155.3.69]:51364 "EHLO mail.ewheeler.net"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S933978AbcJ0X1q (ORCPT <rfc822;linux-bcache@vger.kernel.org>);
        Thu, 27 Oct 2016 19:27:46 -0400
Sender: linux-bcache-owner@vger.kernel.org
List-Id: linux-bcache@vger.kernel.org
To: Jens Axboe <axboe@kernel.dk>
Cc: linux-bcache@vger.kernel.org, Kent Overstreet <kent.overstreet@gmail.com>, Kai Krakow <kai@kaishome.de>, Wido den Hollander <wido@widodh.nl>

Hi Jens,

Please pull this v4.9-rc2 based series of bcache updates for v4.9-rc3:
(You may disregard the previous -rc1-based request.)

  git pull https://bitbucket.org/ewheelerinc/linux.git v4.9-rc2-bcache-updates

Thank you!

--
Eric Wheeler

]# git log --oneline v4.9-rc2..HEAD
bd532a6 bcache: partition support: add 16 minors per bcacheN device
3312845 bcache: Make gc wakeup sane, remove set_task_state()
6bb7f1e bcache: update bio->bi_opf bypass/writeback REQ_ flag hints
3d58a09 bcache: documentation for ioprio cache hinting
2e8884b bcache: introduce per-process ioprio-based bypass/writeback hints

]# git diff --stat v4.9-rc2
 Documentation/bcache.txt      | 80 ++++++++++++++++++++++++++++++++++++++++
 drivers/md/bcache/bcache.h    |  7 +++-
 drivers/md/bcache/btree.c     | 39 ++++++++++----------
 drivers/md/bcache/btree.h     |  3 +-
 drivers/md/bcache/request.c   | 31 ++++++++++++++--
 drivers/md/bcache/super.c     |  7 +++-
 drivers/md/bcache/sysfs.c     | 71 +++++++++++++++++++++++++++++++++++
 drivers/md/bcache/writeback.c |  8 ++++
 drivers/md/bcache/writeback.h | 26 ++++++++++++-
 9 files changed, 244 insertions(+), 28 deletions(-)
