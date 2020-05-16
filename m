From: Coly Li <colyli@suse.de>
Subject: [RFC PATCH v2 0/4] block layer change necessary for bcache zoned device support
Date: Sat, 16 May 2020 11:54:30 +0800
Message-ID: <20200516035434.82809-1-colyli@suse.de>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <linux-bcache-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:40668 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726247AbgEPDyz (ORCPT <rfc822;linux-bcache@vger.kernel.org>);
        Fri, 15 May 2020 23:54:55 -0400
Sender: linux-bcache-owner@vger.kernel.org
List-Id: linux-bcache@vger.kernel.org
To: linux-block@vger.kernel.org, damien.lemoal@wdc.com, hare@suse.com, hch@lst.de, axboe@kernel.dk
Cc: linux-bcache@vger.kernel.org, kbusch@kernel.org, Coly Li <colyli@suse.de>

Hi folks,

Recently I am working on supprt bcache to be created on zoned devices
e.g. host managed SMR hard drives, then frequent random READ I/Os on
these SMR drives can be accelerated.

To make the bcache code work correctly, there are some small but maybe
important changes of block layer code are necessary.

Thanks for the review comments from Keith Busch, I fix the typo and post
the v2 series for your review and comments.

Thank you all in advance.

Coly Li 
---

Coly Li (4):
  block: change REQ_OP_ZONE_RESET from 6 to 13
  block: block: change REQ_OP_ZONE_RESET_ALL from 8 to 15
  block: remove queue_is_mq restriction from blk_revalidate_disk_zones()
  block: set bi_size to REQ_OP_ZONE_RESET bio

 block/blk-zoned.c         | 6 ++++--
 include/linux/blk_types.h | 8 ++++----
 2 files changed, 8 insertions(+), 6 deletions(-)

-- 
2.25.0
