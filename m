From: Kent Overstreet <kmo-PEzghdH756F8UrSeD/g0lQ@public.gmane.org>
Subject: [GIT PULL] Bcache fix for 3.11
Date: Mon, 26 Aug 2013 14:45:26 -0700
Message-ID: <20130826214526.GB2798@kmo-pixel>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-bcache-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
Sender: linux-bcache-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jens Axboe <axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org>
Cc: linux-bcache-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-bcache@vger.kernel.org

Last writeback fix had a brown paper bag bug in it. The fix for that is
a one liner though:

The following changes since commit 9df79a37eeb7ee89dc56aeed3051be676369359a:

  bcache: Fix a flush/fua performance bug (2013-08-19 15:30:45 -0700)

are available in the git repository at:

  git://evilpiepirate.org/~kent/linux-bcache.git bcache-for-3.11

for you to fetch changes up to 174c1412939888ffedc4da02b375bc579af2a93c:

  bcache: Fix a dumb CPU spinning bug in writeback (2013-08-23 16:30:22 -0700)

----------------------------------------------------------------
Kent Overstreet (1):
      bcache: Fix a dumb CPU spinning bug in writeback

 drivers/md/bcache/writeback.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)
