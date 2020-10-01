Return-Path: <SRS0=Ei6X=DI=vger.kernel.org=linux-bcache-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B4C72C4727C
	for <linux-bcache@archiver.kernel.org>; Thu,  1 Oct 2020 06:51:07 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 7774021481
	for <linux-bcache@archiver.kernel.org>; Thu,  1 Oct 2020 06:51:07 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725878AbgJAGvG (ORCPT
        <rfc822;linux-bcache@archiver.kernel.org>);
        Thu, 1 Oct 2020 02:51:06 -0400
Received: from mx2.suse.de ([195.135.220.15]:33368 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725892AbgJAGvF (ORCPT <rfc822;linux-bcache@vger.kernel.org>);
        Thu, 1 Oct 2020 02:51:05 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id 01AF9ABBE;
        Thu,  1 Oct 2020 06:51:04 +0000 (UTC)
From:   Coly Li <colyli@suse.de>
To:     axboe@kernel.dk
Cc:     linux-bcache@vger.kernel.org, linux-block@vger.kernel.org,
        Coly Li <colyli@suse.de>
Subject: [PATCH 00/15] bcache patches for Linux v5.10 
Date:   Thu,  1 Oct 2020 14:50:41 +0800
Message-Id: <20201001065056.24411-1-colyli@suse.de>
X-Mailer: git-send-email 2.26.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-bcache.vger.kernel.org>
X-Mailing-List: linux-bcache@vger.kernel.org

Hi Jens,

This is the first wave bcache patches for Linux v5.10. In this period
most of the changes from Qinglang Miao and me are code cleanup and
simplification. And we have a good fix is from our new contributor
Dongsheng Yang,
- bcache: check c->root with IS_ERR_OR_NULL() in mca_reserve() 

Please take them for Linux v5.10. Thank you in advance.

Coly Li
---

Coly Li (13):
  bcache: share register sysfs with async register
  bcache: remove 'int n' from parameter list of bch_bucket_alloc_set()
  bcache: explicitly make cache_set only have single cache
  bcache: remove for_each_cache()
  bcache: add set_uuid in struct cache_set
  bcache: only use block_bytes() on struct cache
  bcache: remove useless alloc_bucket_pages()
  bcache: remove useless bucket_pages()
  bcache: only use bucket_bytes() on struct cache
  bcache: don't check seq numbers in register_cache_set()
  bcache: remove can_attach_cache()
  bcache: check and set sync status on cache's in-memory super block
  bcache: remove embedded struct cache_sb from struct cache_set

Dongsheng Yang (1):
  bcache: check c->root with IS_ERR_OR_NULL() in mca_reserve()

Qinglang Miao (1):
  bcache: Convert to DEFINE_SHOW_ATTRIBUTE

 drivers/md/bcache/alloc.c     |  60 ++++-----
 drivers/md/bcache/bcache.h    |  29 ++--
 drivers/md/bcache/btree.c     | 146 ++++++++++----------
 drivers/md/bcache/btree.h     |   2 +-
 drivers/md/bcache/closure.c   |  16 +--
 drivers/md/bcache/debug.c     |  10 +-
 drivers/md/bcache/extents.c   |   6 +-
 drivers/md/bcache/features.c  |   4 +-
 drivers/md/bcache/io.c        |   2 +-
 drivers/md/bcache/journal.c   | 246 ++++++++++++++++------------------
 drivers/md/bcache/movinggc.c  |  58 ++++----
 drivers/md/bcache/request.c   |   6 +-
 drivers/md/bcache/super.c     | 244 +++++++++++++--------------------
 drivers/md/bcache/sysfs.c     |  10 +-
 drivers/md/bcache/writeback.c |   2 +-
 include/trace/events/bcache.h |   4 +-
 16 files changed, 363 insertions(+), 482 deletions(-)

-- 
2.26.2

