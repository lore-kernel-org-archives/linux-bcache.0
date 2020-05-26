Return-Path: <SRS0=nvKS=7I=vger.kernel.org=linux-bcache-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AB2F3C433DF
	for <linux-bcache@archiver.kernel.org>; Tue, 26 May 2020 15:59:38 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 8EAC02075F
	for <linux-bcache@archiver.kernel.org>; Tue, 26 May 2020 15:59:38 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729102AbgEZP7i (ORCPT
        <rfc822;linux-bcache@archiver.kernel.org>);
        Tue, 26 May 2020 11:59:38 -0400
Received: from mx2.suse.de ([195.135.220.15]:45908 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727862AbgEZP7h (ORCPT <rfc822;linux-bcache@vger.kernel.org>);
        Tue, 26 May 2020 11:59:37 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id 03CCCAD17;
        Tue, 26 May 2020 15:59:38 +0000 (UTC)
From:   Coly Li <colyli@suse.de>
To:     axboe@kernel.dk
Cc:     linux-bcache@vger.kernel.org, linux-block@vger.kernel.org,
        Coly Li <colyli@suse.de>
Subject: [PATCH 0/5] bcache patches for Linux-5.8 
Date:   Tue, 26 May 2020 23:59:23 +0800
Message-ID: <20200526155928.32036-1-colyli@suse.de>
X-Mailer: git-send-email 2.25.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-bcache-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-bcache.vger.kernel.org>
X-Mailing-List: linux-bcache@vger.kernel.org
Message-ID: <20200526155923.21UJguUb_jbKKVZbl4JQ1996h8KMh5he58OEz0KXji4@z>

Hi Jens,

This is the bcache patches for Linux v5.8.

Patches from Colin Ian King and Joe Perches are sent again for v5.8
merge windows. The first patch from me is to fix a refcount underflow
issue when stopping a pending backing device without created bcache
device. The last two patches from me is for an experiment sysfs
interface to register bcache devices in asynchronous way, to avoid
the udevd timeout issue which I tried before.

Please take them for v5.8, and thank you in advance.

Coly Li
---

Colin Ian King (1):
  bcache: remove redundant variables i and n

Coly Li (3):
  bcache: fix refcount underflow in bcache_device_free()
  bcache: asynchronous devices registration
  bcache: configure the asynchronous registertion to be experimental

Joe Perches (1):
  bcache: Convert pr_<level> uses to a more typical style

 drivers/md/bcache/Kconfig     |   9 ++
 drivers/md/bcache/bcache.h    |   2 +-
 drivers/md/bcache/bset.c      |   6 +-
 drivers/md/bcache/btree.c     |  16 +--
 drivers/md/bcache/extents.c   |  12 +-
 drivers/md/bcache/io.c        |   8 +-
 drivers/md/bcache/journal.c   |  34 ++---
 drivers/md/bcache/request.c   |   6 +-
 drivers/md/bcache/super.c     | 234 +++++++++++++++++++++++++---------
 drivers/md/bcache/sysfs.c     |   8 +-
 drivers/md/bcache/writeback.c |   6 +-
 11 files changed, 228 insertions(+), 113 deletions(-)

-- 
2.25.0

