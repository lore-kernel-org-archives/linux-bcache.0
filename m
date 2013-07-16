From: Kent Overstreet <kmo-PEzghdH756F8UrSeD/g0lQ@public.gmane.org>
Subject: [GIT PULL] Bcache fixes for 3.11
Date: Tue, 16 Jul 2013 14:12:21 -0700
Message-ID: <20130716211221.GD27000@kmo-pixel>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-bcache-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
Sender: linux-bcache-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org
Cc: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-bcache-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-bcache@vger.kernel.org

Hey Jens - I've been busy torture testing and chasing bugs, here's the
fruits of my labors. These are all fairly small fixes, some of them
quite important:

The following changes since commit 8e51e414a3c6d92ef2cc41720c67342a8e2c0bf7:

  bcache: Use standard utility code (2013-07-01 14:43:53 -0700)

are available in the git repository at:

  git://evilpiepirate.org/~kent/linux-bcache.git bcache-for-3.11

for you to fetch changes up to 79826c35eb99cd3c0873b8396f45fa26c87fb0b0:

  bcache: Allocation kthread fixes (2013-07-12 00:22:49 -0700)

----------------------------------------------------------------
Dan Carpenter (1):
      bcache: check for allocation failures

Kent Overstreet (7):
      bcache: Fix a dumb race
      bcache: Advertise that flushes are supported
      bcache: Fix a sysfs splat on shutdown
      bcache: Shutdown fix
      bcache: Journal replay fix
      bcache: Fix GC_SECTORS_USED() calculation
      bcache: Allocation kthread fixes

 drivers/md/bcache/alloc.c   | 18 ++++++++----------
 drivers/md/bcache/bcache.h  |  5 +----
 drivers/md/bcache/btree.c   |  4 +++-
 drivers/md/bcache/closure.c |  6 ++++--
 drivers/md/bcache/journal.c |  7 ++++++-
 drivers/md/bcache/request.c |  8 +++++++-
 drivers/md/bcache/super.c   | 42 ++++++++++++++++++++++++++++++------------
 drivers/md/bcache/sysfs.c   |  2 ++
 8 files changed, 61 insertions(+), 31 deletions(-)
