Return-Path: <linux-bcache-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-11.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 03BFEC43470
	for <linux-bcache@archiver.kernel.org>; Sun, 11 Apr 2021 13:43:53 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id CB552611AD
	for <linux-bcache@archiver.kernel.org>; Sun, 11 Apr 2021 13:43:52 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235751AbhDKNoF (ORCPT <rfc822;linux-bcache@archiver.kernel.org>);
        Sun, 11 Apr 2021 09:44:05 -0400
Received: from mx2.suse.de ([195.135.220.15]:47236 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235567AbhDKNn7 (ORCPT <rfc822;linux-bcache@vger.kernel.org>);
        Sun, 11 Apr 2021 09:43:59 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id 06204B0EA;
        Sun, 11 Apr 2021 13:43:31 +0000 (UTC)
From:   Coly Li <colyli@suse.de>
To:     axboe@kernel.dk
Cc:     linux-bcache@vger.kernel.org, linux-block@vger.kernel.org,
        Coly Li <colyli@suse.de>
Subject: [PATCH 0/7] bcache patches for Linux 5.13 -- 1st wave 
Date:   Sun, 11 Apr 2021 21:43:09 +0800
Message-Id: <20210411134316.80274-1-colyli@suse.de>
X-Mailer: git-send-email 2.26.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-bcache.vger.kernel.org>
X-Mailing-List: linux-bcache@vger.kernel.org

Hi Jens,

This is the 1st wave of bcache for Linux v5.13.
All the patches in this submission are all about code cleanup or
minor fixes.

The 2nd wave patches are about the NVDIMM support on bcache which were
held in previous merge window. The refined patches work as expected, and
I am waiting Intel developers to post the update version with the fixes
of the integration testing. Then I will post out the 2nd wave bcache
patches for 5.13 merge window.

Thanks in advance for taking the 1st wave patches.

Coly Li

---
Arnd Bergmann (1):
  md: bcache: avoid -Wempty-body warnings

Bhaskar Chowdhury (1):
  md: bcache: Trivial typo fixes in the file journal.c

Christoph Hellwig (1):
  bcache: remove PTR_CACHE

Coly Li (1):
  bcache: fix a regression of code compiling failure in debug.c

Gustavo A. R. Silva (1):
  bcache: Use 64-bit arithmetic instead of 32-bit

Yang Li (1):
  bcache: use NULL instead of using plain integer as pointer

Zhiqiang Liu (1):
  bcache: reduce redundant code in bch_cached_dev_run()

 drivers/md/bcache/alloc.c     |  5 ++---
 drivers/md/bcache/bcache.h    | 11 ++---------
 drivers/md/bcache/btree.c     |  4 ++--
 drivers/md/bcache/debug.c     |  2 +-
 drivers/md/bcache/extents.c   |  4 ++--
 drivers/md/bcache/features.c  |  2 +-
 drivers/md/bcache/io.c        |  4 ++--
 drivers/md/bcache/journal.c   |  6 +++---
 drivers/md/bcache/super.c     | 25 ++++++++++++-------------
 drivers/md/bcache/util.h      |  2 +-
 drivers/md/bcache/writeback.c | 11 +++++------
 11 files changed, 33 insertions(+), 43 deletions(-)

-- 
2.26.2

