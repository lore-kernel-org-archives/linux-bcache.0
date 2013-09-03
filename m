From: Kent Overstreet <kmo-PEzghdH756F8UrSeD/g0lQ@public.gmane.org>
Subject: [GIT PULL] Bcache fixes
Date: Tue, 3 Sep 2013 13:48:09 -0700
Message-ID: <20130903204809.GC11778@moria.home.lan>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-bcache-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
Sender: linux-bcache-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jens Axboe <axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org>
Cc: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-bcache-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-bcache@vger.kernel.org

Jens, here's the latest bcache fixes.

The last one of these fixes a (really difficult to trigger) data
corruption bug - I was waiting until the user who was able to reproduce
it had tested it to send this pull out, that's the most serious fix in
this pull.

The following changes since commit 79826c35eb99cd3c0873b8396f45fa26c87fb0b0:

  bcache: Allocation kthread fixes (2013-07-12 00:22:49 -0700)

are available in the git repository at:

  git://evilpiepirate.org/~kent/linux-bcache.git bcache-for-3.11

for you to fetch changes up to bef0ef06a9fe34b08177b67d3213dceab29d3abe:

  bcache: Fix for handling overlapping extents when reading in a btree node (2013-09-03 13:42:35 -0700)

----------------------------------------------------------------
Gabriel de Perthuis (1):
      bcache: Strip endline when writing the label through sysfs

Geert Uytterhoeven (1):
      bcache: Correct printf()-style format length modifier

Kent Overstreet (7):
      bcache: Fix a dumb journal discard bug
      bcache: Fix for when no journal entries are found
      bcache: Fix a writeback performance regression
      bcache: Fix a flush/fua performance bug
      bcache: Fix a dumb CPU spinning bug in writeback
      bcache: Fix a shrinker deadlock
      bcache: Fix for handling overlapping extents when reading in a btree node

 drivers/md/bcache/bcache.h    |  7 +++----
 drivers/md/bcache/bset.c      | 39 ++++++++++++++++++++++++++++-----------
 drivers/md/bcache/btree.c     |  4 ++--
 drivers/md/bcache/journal.c   | 33 ++++++++++++++++++++-------------
 drivers/md/bcache/sysfs.c     |  9 +++++++--
 drivers/md/bcache/util.c      | 11 ++++++++++-
 drivers/md/bcache/util.h      | 12 +++++++++---
 drivers/md/bcache/writeback.c | 42 ++++++++++++++++++++----------------------
 8 files changed, 99 insertions(+), 58 deletions(-)
