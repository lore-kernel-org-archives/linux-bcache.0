Return-Path: <SRS0=ltqC=AQ=vger.kernel.org=linux-bcache-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B3AA8C433E0
	for <linux-bcache@archiver.kernel.org>; Sun,  5 Jul 2020 16:04:48 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 8AFF920737
	for <linux-bcache@archiver.kernel.org>; Sun,  5 Jul 2020 16:04:48 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727843AbgGEQEr (ORCPT
        <rfc822;linux-bcache@archiver.kernel.org>);
        Sun, 5 Jul 2020 12:04:47 -0400
Received: from mx2.suse.de ([195.135.220.15]:39480 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727822AbgGEQEr (ORCPT <rfc822;linux-bcache@vger.kernel.org>);
        Sun, 5 Jul 2020 12:04:47 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id 76ED5ACFE;
        Sun,  5 Jul 2020 16:04:46 +0000 (UTC)
From:   Coly Li <colyli@suse.de>
To:     linux-bcache@vger.kernel.org
Cc:     linux-block@vger.kernel.org, Coly Li <colyli@suse.de>
Subject: [RFC PATCH 0/4] bcache-tools: changes for large bucket size 
Date:   Mon,  6 Jul 2020 00:04:36 +0800
Message-ID: <20200705160440.5801-1-colyli@suse.de>
X-Mailer: git-send-email 2.26.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-bcache-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-bcache.vger.kernel.org>
X-Mailing-List: linux-bcache@vger.kernel.org
Message-ID: <20200705160436.A8AEgJoLxrjsgusncEi-TWhSzuPKn8b0SLtIf2ya-io@z>

These are user space tools changes necessary for bcache large bucket
size. When setting bucket size with '-u' larger than 16MB for cache
device, BCACHE_SB_VERSION_CDEV_WITH_FEATURES will be set automatically.
Otherwise, the new added members in super block won't be touched.

Coly Li
---
Coly Li (4):
  bcache-tools: comments offset for members of struct cache_sb
  struct_offset: print offset of each member of the on-disk data
    structure
  bcache-tools: The new super block version
    BCACHE_SB_VERSION_BDEV_WITH_FEATURES
  bcache-tools: add large_bucket incompat feature

 Makefile        |   6 +-
 bcache.h        | 153 ++++++++++++++++++++++++++++++++++++++----------
 features.c      |  24 ++++++++
 lib.c           |  24 ++++++++
 lib.h           |   2 +
 make.c          |  36 ++++++++----
 struct_offset.c |  63 ++++++++++++++++++++
 7 files changed, 265 insertions(+), 43 deletions(-)
 create mode 100644 features.c
 create mode 100644 struct_offset.c

-- 
2.26.2

