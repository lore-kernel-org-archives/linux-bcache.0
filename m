From: Eric Wheeler <bcache@lists.ewheeler.net>
Subject: [PULL] bcache updates based on git.kernel.dk/linux-block:for-next
Date: Thu, 25 May 2017 19:10:14 +0000 (UTC)
Message-ID: <alpine.LRH.2.11.1705251853530.19359@mail.ewheeler.net>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-bcache-owner@vger.kernel.org>
Received: from mx.ewheeler.net ([66.155.3.69]:55946 "EHLO mail.ewheeler.net"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S935251AbdEYTKR (ORCPT <rfc822;linux-bcache@vger.kernel.org>);
        Thu, 25 May 2017 15:10:17 -0400
Sender: linux-bcache-owner@vger.kernel.org
List-Id: linux-bcache@vger.kernel.org
To: Jens Axboe <axboe@kernel.dk>
Cc: linux-bcache@vger.kernel.org, Jan Kara <jack@suse.cz>, stable@vger.kernel.org, "tang.junhui" <tang.junhui@zte.com.cn>, Kent Overstreet <kent.overstreet@gmail.com>, Coly Li <colyli@suse.de>, Stefan Bader <stefan.bader@canonical.com>, Liang Chen <liangchen.linux@gmail.com>, nix@esperi.org.uk

Hi Jens,

Please pull these updates and bugfixes from the bcache community when you 
have a minute.  If you need a rebase against something else then please 
let me know and I would be happy to update for you.

Thank you for your help!



The following changes since commit 0789bd7bdb5bd036fe3df96c19528f46127a0160:

  Merge branch 'for-linus' into for-next (2017-05-10 07:40:47 -0600)

are available in the git repository at:

  https://bitbucket.org/ewheelerinc/linux.git bcache-updates-linux-block-for-next

for you to fetch changes up to 8a02c3d571b895931db7a2700f05d8c70a7c6cb2:

  bcache: update bio->bi_opf bypass/writeback REQ_ flag hints (2017-05-11 12:29:08 -0700)

----------------------------------------------------------------
Jan Kara (1):
      bcache: Fix leak of bdev reference

Liang Chen (1):
      bcache: explicitly destory mutex while exiting

tang.junhui (4):
      bcache: fix sequential large write IO bypass
      bcache: do not subtract sectors_to_gc for bypassed IO
      bcache: fix wrong cache_misses statistics
      bcache: fix calling ida_simple_remove() with incorrect minor

Eric Wheeler (3):
      bcache: introduce bcache sysfs entries for ioprio-based bypass/writeback hints
      bcache: documentation for sysfs entries describing bcache cache hinting
      bcache: update bio->bi_opf bypass/writeback REQ_ flag hints


 Documentation/bcache.txt      | 80 ++++++++++++++++++++++++++++++++++++++++
 drivers/md/bcache/bcache.h    |  3 ++
 drivers/md/bcache/request.c   | 45 +++++++++++++++++-----
 drivers/md/bcache/super.c     | 18 ++++++---
 drivers/md/bcache/sysfs.c     | 71 +++++++++++++++++++++++++++++++++++
 drivers/md/bcache/writeback.c |  8 ++++
 drivers/md/bcache/writeback.h | 27 +++++++++++++-
 7 files changed, 236 insertions(+), 16 deletions(-)
