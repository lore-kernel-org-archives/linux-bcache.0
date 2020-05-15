From: Coly Li <colyli@suse.de>
Subject: [RFC PATCH 0/4] block layer change necessary for bcache zoned device support
Date: Sat, 16 May 2020 00:31:53 +0800
Message-ID: <20200515163157.72796-1-colyli@suse.de>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <linux-block-owner@vger.kernel.org>
Sender: linux-block-owner@vger.kernel.org
To: linux-block@vger.kernel.org, damien.lemoal@wdc.com, hare@suse.com, hch@lst.de, axboe@kernel.dk
Cc: linux-bcache@vger.kernel.org, Coly Li <colyli@suse.de>
List-Id: linux-bcache@vger.kernel.org

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
