From: Kent Overstreet <koverstreet-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Subject: [GIT PULL] Bcache fixes for 3.10
Date: Wed, 15 May 2013 00:53:02 -0700
Message-ID: <20130515075302.GA26662@moria.home.lan>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-bcache-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
Sender: linux-bcache-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org
Cc: linux-bcache-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-bcache@vger.kernel.org

Jens - couple more bcache patches. Bug fixes and a doc update.

The following changes since commit f50efd2fdbd9b35b11f5778ed85beb764184bda9:

  Merge branch 'bcache-for-upstream' of http://evilpiepirate.org/git/linux-bcache into for-3.10/drivers (2013-05-01 09:23:05 +0200)

are available in the git repository at:


  http://evilpiepirate.org/git/linux-bcache.git bcache-for-upstream

for you to fetch changes up to f59fce847fc8483508b5028c24e2b1e00523dd88:

  bcache: Fix error handling in init code (2013-05-15 00:48:14 -0700)

----------------------------------------------------------------
Emil Goode (1):
      bcache: Fix incompatible pointer type warning

Gabriel (1):
      bcache: clarify free/available/unused space

Kent Overstreet (1):
      bcache: Fix error handling in init code

Paul Bolle (1):
      bcache: drop "select CLOSURES"

 Documentation/bcache.txt      |   12 ++-
 drivers/md/bcache/Kconfig     |    1 -
 drivers/md/bcache/bcache.h    |    2 +-
 drivers/md/bcache/stats.c     |   34 ++++----
 drivers/md/bcache/super.c     |  185 ++++++++++++++++++-----------------------
 drivers/md/bcache/writeback.c |    2 +-
 6 files changed, 109 insertions(+), 127 deletions(-)
