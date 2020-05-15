Return-Path: <SRS0=+DzR=65=vger.kernel.org=linux-bcache-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A8FC5C433E0
	for <linux-bcache@archiver.kernel.org>; Fri, 15 May 2020 16:33:45 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 94790206D8
	for <linux-bcache@archiver.kernel.org>; Fri, 15 May 2020 16:33:45 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726188AbgEOQdn (ORCPT
        <rfc822;linux-bcache@archiver.kernel.org>);
        Fri, 15 May 2020 12:33:43 -0400
Received: from mx2.suse.de ([195.135.220.15]:45786 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726168AbgEOQdn (ORCPT <rfc822;linux-bcache@vger.kernel.org>);
        Fri, 15 May 2020 12:33:43 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id AC82EAD65;
        Fri, 15 May 2020 16:33:44 +0000 (UTC)
From:   Coly Li <colyli@suse.de>
To:     linux-block@vger.kernel.org, damien.lemoal@wdc.com, hare@suse.com,
        hch@lst.de, axboe@kernel.dk
Cc:     linux-bcache@vger.kernel.org, Coly Li <colyli@suse.de>
Subject: [RFC PATCH 0/4] block layer change necessary for bcache zoned device support
Date:   Sat, 16 May 2020 00:31:53 +0800
Message-ID: <20200515163157.72796-1-colyli@suse.de>
X-Mailer: git-send-email 2.25.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-bcache-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-bcache.vger.kernel.org>
X-Mailing-List: linux-bcache@vger.kernel.org
Message-ID: <20200515163153._2ptIgX5N-5gGmFFAR7SnSDk0S73o0BQfirCo_wX1cI@z>

Hi folks,

Recently I am working on supprt bcache to be created on zoned devices
e.g. host managed SMR hard drives, then frequent random READ I/Os on
these SMR drives can be accelerated.

To make the bcache code work correctly, there are some small but maybe
important changes of block layer code are necessary. Here I post these
patches for your review and comments.

Thank you all in advance.

Coly Li
---

Coly Li (4):
  block: change REQ_OP_ZONE_RESET from 6 to 13
  block: block: change REQ_OP_ZONE_RESET from 8 to 15
  block: remove queue_is_mq restriction from blk_revalidate_disk_zones()
  block: set bi_size to REQ_OP_ZONE_RESET bio

 block/blk-zoned.c         | 6 ++++--
 include/linux/blk_types.h | 8 ++++----
 2 files changed, 8 insertions(+), 6 deletions(-)

-- 
2.25.0

