Return-Path: <SRS0=M8tx=A4=vger.kernel.org=linux-bcache-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9E3A8C433E2
	for <linux-bcache@archiver.kernel.org>; Fri, 17 Jul 2020 02:42:54 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 85A4A2173E
	for <linux-bcache@archiver.kernel.org>; Fri, 17 Jul 2020 02:42:54 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726442AbgGQCmt (ORCPT
        <rfc822;linux-bcache@archiver.kernel.org>);
        Thu, 16 Jul 2020 22:42:49 -0400
Received: from mx2.suse.de ([195.135.220.15]:42802 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726138AbgGQCmt (ORCPT <rfc822;linux-bcache@vger.kernel.org>);
        Thu, 16 Jul 2020 22:42:49 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id BC51DB70A;
        Fri, 17 Jul 2020 02:42:51 +0000 (UTC)
From:   Coly Li <colyli@suse.de>
To:     axboe@kernel.dk, linux-block@vger.kernel.org
Cc:     martin.petersen@oracle.com, linux-bcache@vger.kernel.org,
        linux-kernel@vger.kernel.org, Coly Li <colyli@suse.de>
Subject: [PATCH v3 0/2] two generic block layer fixes for 5.9
Date:   Fri, 17 Jul 2020 10:42:28 +0800
Message-Id: <20200717024230.33116-1-colyli@suse.de>
X-Mailer: git-send-email 2.26.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-bcache-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-bcache.vger.kernel.org>
X-Mailing-List: linux-bcache@vger.kernel.org

Hi Jens,

These two patches are posted for a while, and have reviewed by several
other developers.

Comparing to previous version, now the discard bio alignment patch can
correctly handles partition offset as Martin suggested. I verify it
with 5.8-rc5 kernel on VMware ESXi 6.5. 

Could you please to take them for Linux v5.9 ?

Thanks in advance.

Coly Li 
---

Coly Li (2):
  block: change REQ_OP_ZONE_RESET and REQ_OP_ZONE_RESET_ALL to be odd
    numbers
  block: improve discard bio alignment in __blkdev_issue_discard()

 block/blk-lib.c           | 31 ++++++++++++++++++++++++++++---
 block/blk.h               | 14 ++++++++++++++
 include/linux/blk_types.h |  8 ++++----
 3 files changed, 46 insertions(+), 7 deletions(-)

-- 
2.26.2

