Return-Path: <SRS0=Zhg3=B3=vger.kernel.org=linux-bcache-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E63DFC433DF
	for <linux-bcache@archiver.kernel.org>; Mon, 17 Aug 2020 12:06:08 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B6D842072E
	for <linux-bcache@archiver.kernel.org>; Mon, 17 Aug 2020 12:06:08 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726457AbgHQMGI (ORCPT
        <rfc822;linux-bcache@archiver.kernel.org>);
        Mon, 17 Aug 2020 08:06:08 -0400
Received: from mx2.suse.de ([195.135.220.15]:53300 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726203AbgHQMGH (ORCPT <rfc822;linux-bcache@vger.kernel.org>);
        Mon, 17 Aug 2020 08:06:07 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id 8DF75AFF1
        for <linux-bcache@vger.kernel.org>; Mon, 17 Aug 2020 12:06:31 +0000 (UTC)
From:   Coly Li <colyli@suse.de>
To:     linux-bcache@vger.kernel.org
Cc:     Coly Li <colyli@suse.de>
Subject: [PATCH 0/8] bcache-tools patches for large bucket size incompat feature 
Date:   Mon, 17 Aug 2020 20:05:50 +0800
Message-Id: <20200817120558.4491-1-colyli@suse.de>
X-Mailer: git-send-email 2.26.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-bcache-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-bcache.vger.kernel.org>
X-Mailing-List: linux-bcache@vger.kernel.org

Hi folks,

This is the user space bcache-tools patches to support large bucket size
incompat features. With these patches, large_bucket feature will be set
automatically if bucket size > 16MB by "bcache make -C " command. Also
all feature sets strings can be displayed by "bcache show " command.

Now the version numbers are upgraded, "bcache make" command will create
cache device with version number 5, and backing device with version
number 6. All kernel support get merged in Linux v5.9 already, now the
user space support follows up.

Coly Li
---

Coly Li (8):
  bcache-tools: add struct cache_sb_disk into bcache.h
  bcache-tools: bitwise.h: more swap bitwise for different CPU endians
  bcache-tools: list.h: only define offsetof() when it is undefined
  bcache-tools: add to_cache_sb() and to_cache_sb_disk()
  bcache-tools: define separated super block for in-memory and on-disk
    format
  bcache-tools: upgrade super block versions for feature sets
  bcache-tools: add large_bucket incompat feature
  bcache-tools: add print_cache_set_supported_feature_sets() in lib.c

 Makefile            |   4 +-
 bcache-super-show.c |  24 ++++--
 bcache.c            |  15 +++-
 bcache.h            | 194 ++++++++++++++++++++++++++++++++++++++------
 bitwise.h           |  10 +++
 features.c          |  74 +++++++++++++++++
 features.h          |   8 ++
 lib.c               | 160 ++++++++++++++++++++++++++++++++----
 lib.h               |   8 +-
 list.h              |   2 +
 make.c              |  70 ++++++----------
 probe-bcache.c      |   8 +-
 12 files changed, 472 insertions(+), 105 deletions(-)
 create mode 100644 features.c
 create mode 100644 features.h

-- 
2.26.2

