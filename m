From: Kent Overstreet <kmo@daterainc.com>
Subject: Bcache fixes for stable
Date: Mon, 26 Aug 2013 15:02:49 -0700
Message-ID: <20130826220249.GF2798@kmo-pixel>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <stable-owner@vger.kernel.org>
Content-Disposition: inline
Sender: stable-owner@vger.kernel.org
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: linux-bcache@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-bcache@vger.kernel.org

Two fixes that went into 3.11 should've been marked for stable, but I
screwed up and forgot to mark them.

One of them fixes bugs that appear to being hit in the wild, so please
pull these:

The following changes since commit 0a4b6d4ff200a553951f77f765971cb3e4c91ec0:

  Linux 3.10.9 (2013-08-20 15:40:47 -0700)

are available in the git repository at:

  git://evilpiepirate.org/~kent/linux-bcache.git bcache-for-3.10

for you to fetch changes up to a213846fafcdf52153dfebf8b1671498a72b6285:

  bcache: FUA fixes (2013-08-26 14:56:52 -0700)

----------------------------------------------------------------
Kent Overstreet (1):
      bcache: FUA fixes

Kumar Amit Mehta (1):
      md: bcache: io.c: fix a potential NULL pointer dereference

 drivers/md/bcache/btree.c   | 23 +++++++++++++++++++++--
 drivers/md/bcache/io.c      |  2 ++
 drivers/md/bcache/journal.c |  2 +-
 drivers/md/bcache/request.c | 13 ++++++++++++-
 4 files changed, 36 insertions(+), 4 deletions(-)
