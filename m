From: Kent Overstreet <kmo@daterainc.com>
Subject: [GIT PULL] bcache fixes for 3.14
Date: Wed, 29 Jan 2014 13:15:09 -0800
Message-ID: <20140129211509.GA2362@kmo>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-bcache-owner@vger.kernel.org>
Received: from mail-pa0-f43.google.com ([209.85.220.43]:60966 "EHLO
	mail-pa0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752133AbaA2VPM (ORCPT
	<rfc822;linux-bcache@vger.kernel.org>);
	Wed, 29 Jan 2014 16:15:12 -0500
Received: by mail-pa0-f43.google.com with SMTP id rd3so2274874pab.2
        for <linux-bcache@vger.kernel.org>; Wed, 29 Jan 2014 13:15:12 -0800 (PST)
Content-Disposition: inline
Sender: linux-bcache-owner@vger.kernel.org
List-Id: linux-bcache@vger.kernel.org
To: axboe@kernel.dk
Cc: linux-kernel@vger.kernel.org, linux-bcache@vger.kernel.org

Jens, couple small bcache fixes for you:

The following changes since commit 9dd6358a21daf4fc6a5b2b779267a62f0d1d3181:

  bcache: Fix auxiliary search trees for key size > cacheline size (2014-01-08 13:05:15 -0800)

are available in the git repository at:

  git://evilpiepirate.org/~kent/linux-bcache.git bcache-for-3.14

for you to fetch changes up to e3b4825b85eab879b618af6ea18529ca7ab9a64f:

  bcache: bugfix - gc thread now gets woken when cache is full (2014-01-29 13:06:42 -0800)

----------------------------------------------------------------
Darrick J. Wong (1):
      bcache: fix BUG_ON due to integer overflow with GC_SECTORS_USED

Kent Overstreet (1):
      bcache: Minor fixes from kbuild robot

Nicholas Swenson (1):
      bcache: bugfix - gc thread now gets woken when cache is full

 drivers/md/bcache/bcache.h  | 4 +++-
 drivers/md/bcache/bset.c    | 7 +++++--
 drivers/md/bcache/btree.c   | 4 ++--
 drivers/md/bcache/extents.c | 2 +-
 drivers/md/bcache/request.c | 6 +++---
 drivers/md/bcache/sysfs.c   | 2 +-
 6 files changed, 15 insertions(+), 10 deletions(-)
