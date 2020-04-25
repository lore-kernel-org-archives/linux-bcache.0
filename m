From: Christoph Hellwig <hch@lst.de>
Subject: avoid the ->make_request_fn indirect for blk-mq drivers
Date: Sat, 25 Apr 2020 09:53:33 +0200
Message-ID: <20200425075336.721021-1-hch@lst.de>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <linux-bcache-owner@vger.kernel.org>
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36140 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1725837AbgDYHxl (ORCPT
        <rfc822;linux-bcache@vger.kernel.org>);
        Sat, 25 Apr 2020 03:53:41 -0400
Sender: linux-bcache-owner@vger.kernel.org
List-Id: linux-bcache@vger.kernel.org
To: Jens Axboe <axboe@kernel.dk>
Cc: dm-devel@redhat.com, linux-bcache@vger.kernel.org, linux-block@vger.kernel.org

Hi Jens,

this small series avoids an indirect call for every submitted bio that
eventually ends up being handled by blk-mq drivers.  Let me know what
you think.
