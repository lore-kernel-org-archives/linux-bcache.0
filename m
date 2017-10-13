From: Michael Lyle <mlyle@lyle.org>
Subject: [PATCH 00/15] bcache: series of patches for 4.15
Date: Fri, 13 Oct 2017 16:35:27 -0700
Message-ID: <20171013233542.20938-1-mlyle@lyle.org>
Return-path: <linux-bcache-owner@vger.kernel.org>
Received: from mail-pg0-f68.google.com ([74.125.83.68]:56474 "EHLO
        mail-pg0-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751391AbdJMXfy (ORCPT
        <rfc822;linux-bcache@vger.kernel.org>);
        Fri, 13 Oct 2017 19:35:54 -0400
Received: by mail-pg0-f68.google.com with SMTP id m18so2337111pgd.13
        for <linux-bcache@vger.kernel.org>; Fri, 13 Oct 2017 16:35:53 -0700 (PDT)
Sender: linux-bcache-owner@vger.kernel.org
List-Id: linux-bcache@vger.kernel.org
To: linux-bcache@vger.kernel.org, linux-block@vger.kernel.org
Cc: axboe@fb.com

Jens, and everyone:

Here is the current series of work for inclusion in next and for 4.15's
merge window.  We may get some additional fixes, but this is most of the
work we expect.  All have been previously sent to these lists except the
very last one.

There's a lot of small cleanup patches and fixes for race conditions.

Also included is my new rate controller which we've been measuring for
some time, and other related changes to writeback rate management.

Thanks,

Mike

Summaries below:

 MAINTAINERS                   |   4 +-
 drivers/md/bcache/alloc.c     |   5 ++-
 drivers/md/bcache/bcache.h    |  11 +++--
 drivers/md/bcache/closure.h   |   6 +++
 drivers/md/bcache/request.c   |  20 ++++++---
 drivers/md/bcache/super.c     |  40 ++++++++++-------
 drivers/md/bcache/sysfs.c     |  28 +++++++-----
 drivers/md/bcache/util.c      |  10 ++++-
 drivers/md/bcache/util.h      |   4 +-
 drivers/md/bcache/writeback.c | 117 +++++++++++++++++++++++++++++-------------------
 drivers/md/bcache/writeback.h |   4 +-
 11 files changed, 156 insertions(+), 93 deletions(-)

[PATCH 01/15] bcache: Avoid nested function definition
[PATCH 02/15] bcache: check ca->alloc_thread initialized before wake
[PATCH 03/15] bcache: fix a comments typo in bch_alloc_sectors()
[PATCH 04/15] bcache: rewrite multiple partitions support
[PATCH 05/15] bcache: Remove redundant set_capacity
[PATCH 06/15] bcache: update bio->bi_opf bypass/writeback REQ_ flag
[PATCH 07/15] bcache: remove unused parameter
[PATCH 08/15] bcache: don't write back data if reading it failed
[PATCH 09/15] bcache: implement PI controller for writeback rate
[PATCH 10/15] bcache: smooth writeback rate control
[PATCH 11/15] bcache: writeback rate shouldn't artifically clamp
[PATCH 12/15] bcache: rearrange writeback main thread ratelimit
[PATCH 13/15] bcache: safeguard a dangerous addressing in
[PATCH 14/15] bcache: Add Michael Lyle to MAINTAINERS
[PATCH 15/15] bcache: MAINTAINERS: set bcache to MAINTAINED
