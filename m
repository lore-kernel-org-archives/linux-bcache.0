From: Kent Overstreet <koverstreet@google.com>
Subject: pull request: bcache fixes
Date: Mon, 8 Apr 2013 13:42:46 -0700
Message-ID: <20130408204246.GG15749@google.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
To: axboe@kernel.dk
Cc: linux-kernel@vger.kernel.org, linux-bcache@vger.kernel.org
List-Id: linux-bcache@vger.kernel.org

Jens, here's the latest bcache fixes. All of it fairly minor:

The following changes since commit 169ef1cf6171d35550fef85645b83b960e241cff:

  bcache: Don't export utility code, prefix with bch_ (2013-03-28 12:50:55 -0600)

are available in the git repository at:

  http://evilpiepirate.org/git/linux-bcache.git bcache-for-upstream

for you to fetch changes up to cef5279735d3f6f0243e626963e6d5c84efade0a:

  bcache: Disable broken btree fuzz tester (2013-04-08 13:33:49 -0700)

----------------------------------------------------------------
Geert Uytterhoeven (1):
      bcache: Add missing #include <linux/prefetch.h>

Kent Overstreet (6):
      bcache: Sparse fixes
      bcache: Use WARN_ONCE() instead of __WARN()
      bcache: Documentation updates
      bcache: Fix a minor memory leak on device teardown
      bcache: Fix a format string overflow
      bcache: Disable broken btree fuzz tester

 Documentation/bcache.txt    |  88 ++++++++++++++++++++++
 drivers/md/bcache/bset.c    |   3 +-
 drivers/md/bcache/btree.c   |   3 +-
 drivers/md/bcache/debug.c   |   8 +-
 drivers/md/bcache/journal.c |   2 +
 drivers/md/bcache/super.c   |   4 +-
 drivers/md/bcache/util.c    | 180 ++++++++++++++++++++++----------------------
 7 files changed, 192 insertions(+), 96 deletions(-)
