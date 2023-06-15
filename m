Return-Path: <linux-bcache-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 70115EB64DB
	for <linux-bcache@archiver.kernel.org>; Thu, 15 Jun 2023 12:13:38 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238580AbjFOMNg (ORCPT <rfc822;linux-bcache@archiver.kernel.org>);
        Thu, 15 Jun 2023 08:13:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56454 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239559AbjFOMNf (ORCPT
        <rfc822;linux-bcache@vger.kernel.org>);
        Thu, 15 Jun 2023 08:13:35 -0400
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.220.29])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D81881BC3;
        Thu, 15 Jun 2023 05:13:34 -0700 (PDT)
Received: from relay2.suse.de (relay2.suse.de [149.44.160.134])
        by smtp-out2.suse.de (Postfix) with ESMTP id 936FE1FE0C;
        Thu, 15 Jun 2023 12:13:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1686831213; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding;
        bh=S4EdmZLJruCwHfmNVvX19xwk7LK+x+Z9KMVI+FWJp7w=;
        b=bh8XRfwtFegWjrPbY969z/AW+zRQsiJwmQqiJ0INKQRpA/gxXhUSOPpKk0g9kzKMImPKjS
        Bo77JeJdKDemkzRszuhJGIuftZ5WDalHQo8g9fZihYQrg5Qw1uOVgBs4UGtaE9gQG1pmrM
        nwzcZq4KJ3E8uyHH0NTHqLPpYdMrBlM=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1686831213;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding;
        bh=S4EdmZLJruCwHfmNVvX19xwk7LK+x+Z9KMVI+FWJp7w=;
        b=bGOGjMfZl3/Ots9oL5ejrXkUwX2nAVnvYLFCifdGvo3fdHYNid4cYijfzkyWO0vNSuY/X4
        crS7v5btuvsNKQDA==
Received: from localhost.localdomain (colyli.tcp.ovpn1.nue.suse.de [10.163.16.22])
        by relay2.suse.de (Postfix) with ESMTP id C6E0C2C141;
        Thu, 15 Jun 2023 12:13:31 +0000 (UTC)
From:   Coly Li <colyli@suse.de>
To:     axboe@kernel.dk
Cc:     linux-bcache@vger.kernel.org, linux-block@vger.kernel.org,
        Coly Li <colyli@suse.de>
Subject: [PATCH 0/6] bcache-next 20230615
Date:   Thu, 15 Jun 2023 20:12:17 +0800
Message-Id: <20230615121223.22502-1-colyli@suse.de>
X-Mailer: git-send-email 2.35.3
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-bcache.vger.kernel.org>
X-Mailing-List: linux-bcache@vger.kernel.org

Hi Jens,

I start to follow Song Liu's -next style to submit bcache patches to
you. This series are minor fixes I tested for a while, and generated
based on top of the for-6.5/block branch from linux-block tree.

The patch from Mingzhe Zou fixes a race in bcache initializaiton time,
rested patches from Andrea, Thomas, Zheng and Ye are code cleanup and
good to have them in.

Please consider taking them, and thank you in advance.

Coly Li 
---

Andrea Tomassetti (1):
  bcache: Remove dead references to cache_readaheads

Mingzhe Zou (1):
  bcache: fixup btree_cache_wait list damage

Thomas Weißschuh (1):
  bcache: make kobj_type structures constant

Zheng Wang (2):
  bcache: Remove some unnecessary NULL point check for the return value
    of __bch_btree_node_alloc-related pointer
  bcache: Fix __bch_btree_node_alloc to make the failure behavior
    consistent

ye xingchen (1):
  bcache: Convert to use sysfs_emit()/sysfs_emit_at() APIs

 Documentation/admin-guide/bcache.rst |  3 ---
 drivers/md/bcache/bcache.h           | 10 ++++-----
 drivers/md/bcache/btree.c            | 25 +++++++++++++++-------
 drivers/md/bcache/btree.h            |  1 +
 drivers/md/bcache/stats.h            |  1 -
 drivers/md/bcache/super.c            |  4 ++--
 drivers/md/bcache/sysfs.c            | 31 ++++++++++++++--------------
 drivers/md/bcache/sysfs.h            |  2 +-
 drivers/md/bcache/writeback.c        | 10 +++++++++
 9 files changed, 52 insertions(+), 35 deletions(-)

-- 
2.35.3

