Return-Path: <linux-bcache-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-11.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 27BBBC433E9
	for <linux-bcache@archiver.kernel.org>; Mon,  4 Jan 2021 07:42:29 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 09C9E2076D
	for <linux-bcache@archiver.kernel.org>; Mon,  4 Jan 2021 07:42:29 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726234AbhADHmI (ORCPT
        <rfc822;linux-bcache@archiver.kernel.org>);
        Mon, 4 Jan 2021 02:42:08 -0500
Received: from mx2.suse.de ([195.135.220.15]:40940 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726365AbhADHmI (ORCPT <rfc822;linux-bcache@vger.kernel.org>);
        Mon, 4 Jan 2021 02:42:08 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id 9729BAD11;
        Mon,  4 Jan 2021 07:41:26 +0000 (UTC)
From:   Coly Li <colyli@suse.de>
To:     axboe@kernel.dk
Cc:     linux-bcache@vger.kernel.org, linux-block@vger.kernel.org,
        Coly Li <colyli@suse.de>
Subject: [PATCH 0/5] bcache patches for Linux v5.11-rc3 
Date:   Mon,  4 Jan 2021 15:41:17 +0800
Message-Id: <20210104074122.19759-1-colyli@suse.de>
X-Mailer: git-send-email 2.26.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-bcache.vger.kernel.org>
X-Mailing-List: linux-bcache@vger.kernel.org

Hi Jens,

This series is not planned but necessary. The four patches from me fix
a bcache super block layout issue which was introduced in 5.9 when large
bucket (32MB-1TB size for zoned device) feature firstly introduced.

Previous code has problem on space consumption and checksum calculation.
These four patches improve and fix the problems with on-disk format
consistency. Although now almost no one (except me) uses the large
bucket code now, it should be good to have the fix as soon as possible.

This series also has a patch from Yi Li which avoid a redundant value
assignment in a two-level loop. It is cool if we may have it in 5.11.

User space bcache-tools are updated for the above kernel changes too.
Please take them for 5.11-rc3.

Thanks in advance.

Coly Li
---


Coly Li (4):
  bcache: fix typo from SUUP to SUPP in features.h
  bcache: check unsupported feature sets for bcache register
  bcache: introduce BCH_FEATURE_INCOMPAT_LOG_LARGE_BUCKET_SIZE for large
    bucket
  bcache: set bcache device into read-only mode for
    BCH_FEATURE_INCOMPAT_OBSO_LARGE_BUCKET

Yi Li (1):
  bcache: set pdev_set_uuid before scond loop iteration

 drivers/md/bcache/features.c |  2 +-
 drivers/md/bcache/features.h | 30 ++++++++++++++++----
 drivers/md/bcache/super.c    | 53 +++++++++++++++++++++++++++++++++---
 include/uapi/linux/bcache.h  |  2 +-
 4 files changed, 76 insertions(+), 11 deletions(-)

-- 
2.26.2

