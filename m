From: Kent Overstreet <kmo-PEzghdH756F8UrSeD/g0lQ@public.gmane.org>
Subject: [GIT PULL] bcache fixes for 3.11
Date: Wed, 14 Aug 2013 15:59:04 -0700
Message-ID: <20130814225904.GA6427@kmo-pixel>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-bcache-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
Sender: linux-bcache-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jens Axboe <axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org>
Cc: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-bcache-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-bcache@vger.kernel.org

Jens, here's the latest bcache fixes. Some urgent stuff in here:


The following changes since commit 79826c35eb99cd3c0873b8396f45fa26c87fb0b0:

  bcache: Allocation kthread fixes (2013-07-12 00:22:49 -0700)

are available in the git repository at:

  git://evilpiepirate.org/~kent/linux-bcache.git bcache-for-3.11

for you to fetch changes up to 0434a516e99ee51ac2d0dfa71b2f56c89ac5db05:

  bcache: Fix a flush/fua performance bug (2013-08-14 15:44:51 -0700)

----------------------------------------------------------------
Gabriel de Perthuis (1):
      bcache: Strip endline when writing the label through sysfs

Geert Uytterhoeven (1):
      bcache: Correct printf()-style format length modifier

Kent Overstreet (4):
      bcache: Fix a dumb journal discard bug
      bcache: Fix for when no journal entries are found
      bcache: Fix a writeback performance regression
      bcache: Fix a flush/fua performance bug

 drivers/md/bcache/bcache.h    |  7 +++----
 drivers/md/bcache/btree.c     |  2 +-
 drivers/md/bcache/journal.c   | 33 ++++++++++++++++++++-------------
 drivers/md/bcache/sysfs.c     |  9 +++++++--
 drivers/md/bcache/util.c      | 11 ++++++++++-
 drivers/md/bcache/util.h      | 12 +++++++++---
 drivers/md/bcache/writeback.c | 37 ++++++++++++++++++-------------------
 7 files changed, 68 insertions(+), 43 deletions(-)
