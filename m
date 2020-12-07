Return-Path: <linux-bcache-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-11.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_GIT autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 082E3C4361B
	for <linux-bcache@archiver.kernel.org>; Mon,  7 Dec 2020 16:41:13 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id BF45F206C1
	for <linux-bcache@archiver.kernel.org>; Mon,  7 Dec 2020 16:41:12 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727274AbgLGQka (ORCPT
        <rfc822;linux-bcache@archiver.kernel.org>);
        Mon, 7 Dec 2020 11:40:30 -0500
Received: from mx2.suse.de ([195.135.220.15]:55982 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726938AbgLGQka (ORCPT <rfc822;linux-bcache@vger.kernel.org>);
        Mon, 7 Dec 2020 11:40:30 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id 15060AD21;
        Mon,  7 Dec 2020 16:39:49 +0000 (UTC)
From:   Coly Li <colyli@suse.de>
To:     axboe@kernel.dk
Cc:     linux-bcache@vger.kernel.org, linux-block@vger.kernel.org,
        Coly Li <colyli@suse.de>
Subject: [PATCH 0/1] bcache: first wave for Linux v5.11 
Date:   Tue,  8 Dec 2020 00:39:14 +0800
Message-Id: <20201207163915.126877-1-colyli@suse.de>
X-Mailer: git-send-email 2.26.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-bcache.vger.kernel.org>
X-Mailing-List: linux-bcache@vger.kernel.org

Hi Jens,

The first wave bcache change for Linux v5.11 is quite silent. Most of
the development is not ready for this merge window. The only change in
this submission is from Dongsheng Yang, this is his second contribution
which catches a very implict bug and provides a fix. The patch runs on
his environment for a while and takes effect.

Please take it for v5.11. Thank you in advance.

Coly Li
---
Dongsheng Yang (1):
  bcache: fix race between setting bdev state to none and new write
    request direct to backing

 drivers/md/bcache/super.c     | 9 ---------
 drivers/md/bcache/writeback.c | 9 +++++++++
 2 files changed, 9 insertions(+), 9 deletions(-)

-- 
2.26.2

