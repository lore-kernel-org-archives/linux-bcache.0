From: Eric Wheeler <bcache@lists.ewheeler.net>
Subject: [PULL] bcache fixes and updates for-4.13
Date: Wed, 28 Jun 2017 23:06:46 +0000 (UTC)
Message-ID: <alpine.LRH.2.11.1706282258100.17052@mail.ewheeler.net>
References: <alpine.LRH.2.11.1705251853530.19359@mail.ewheeler.net>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <stable-owner@vger.kernel.org>
In-Reply-To: <alpine.LRH.2.11.1705251853530.19359@mail.ewheeler.net>
Sender: stable-owner@vger.kernel.org
To: Jens Axboe <axboe@kernel.dk>
Cc: dan.carpenter@oracle.com, tasleson@redhat.com, linux-bcache@vger.kernel.org, linux-block@vger.kernel.org, Jan Kara <jack@suse.cz>, stable@vger.kernel.org, "tang.junhui" <tang.junhui@zte.com.cn>, Kent Overstreet <kent.overstreet@gmail.com>, Coly Li <colyli@suse.de>, Stefan Bader <stefan.bader@canonical.com>, Liang Chen <liangchen.linux@gmail.com>, nix@esperi.org.uk
List-Id: linux-bcache@vger.kernel.org

Hi Jens,

It looks like you're getting ready for 4.13, so here are the bcache 
updates rebased and ready from git.kernel.dk/linux-block for-4.13/block 
This tree builds, boots, and works as expected.  Please pull the new fixes 
and features below.

Thank you for your help!


The following changes since commit f1d4ef7d88832444e8dfeb0e85e19d3b6ecb5011:

  nvmet-rdma: register ib_client to not deadlock in device removal (2017-06-28 08:14:13 -0600)

are available in the git repository at:

  https://bitbucket.org/ewheelerinc/linux.git bcache-updates-linux-block-for-4.13

for you to fetch changes up to 960ce81bdbd46bc7faaeb2f9fcddfea1e48ee388:

  bcache: Update continue_at() documentation (2017-06-28 15:18:02 -0700)

----------------------------------------------------------------
Dan Carpenter (2):
      bcache: silence static checker warning
      bcache: Update continue_at() documentation

Eric Wheeler (3):
      bcache: introduce bcache sysfs entries for ioprio-based bypass/writeback hints
      bcache: documentation for sysfs entries describing bcache cache hinting
      bcache: update bio->bi_opf bypass/writeback REQ_ flag hints

Jan Kara (1):
      bcache: Fix leak of bdev reference

Liang Chen (1):
      bcache: explicitly destory mutex while exiting

Tang Junhui (11):
      bcache: fix sequential large write IO bypass
      bcache: do not subtract sectors_to_gc for bypassed IO
      bcache: fix wrong cache_misses statistics
      bcache: fix calling ida_simple_remove() with incorrect minor
      bcache: initialize stripe_sectors_dirty correctly for thin flash device
      bcache: Subtract dirty sectors of thin flash from cache_sectors in calculating writeback rate
      bcache: update bucket_in_use periodically
      bcache: delete redundant calling set_gc_sectors()
      bcache: fix issue of writeback rate at minimum 1 key per second
      bcache: increase the number of open buckets
      bcache: fix for gc and write-back race

Tony Asleson (1):
      bcache: Correct return value for sysfs attach errors

 Documentation/bcache.txt      | 80 ++++++++++++++++++++++++++++++++++++++++++
 drivers/md/bcache/alloc.c     |  4 ++-
 drivers/md/bcache/bcache.h    |  4 +++
 drivers/md/bcache/btree.c     | 30 ++++++++++++++--
 drivers/md/bcache/closure.h   |  4 ---
 drivers/md/bcache/request.c   | 45 ++++++++++++++++++------
 drivers/md/bcache/super.c     | 26 +++++++++-----
 drivers/md/bcache/sysfs.c     | 75 +++++++++++++++++++++++++++++++++++++--
 drivers/md/bcache/util.c      |  9 ++++-
 drivers/md/bcache/writeback.c | 37 +++++++++++++------
 drivers/md/bcache/writeback.h | 48 +++++++++++++++++++++++--
 11 files changed, 319 insertions(+), 43 deletions(-)
