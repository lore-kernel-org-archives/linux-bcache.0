From: Dan Carpenter <dan.carpenter@oracle.com>
Subject: re: bcache: Fix error handling in init code
Date: Mon, 7 Jul 2014 17:15:37 +0300
Message-ID: <20140707141537.GA15176@mwanda>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-bcache-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:36311 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753451AbaGGOPj (ORCPT
	<rfc822;linux-bcache@vger.kernel.org>);
	Mon, 7 Jul 2014 10:15:39 -0400
Content-Disposition: inline
Sender: linux-bcache-owner@vger.kernel.org
List-Id: linux-bcache@vger.kernel.org
To: koverstreet@google.com
Cc: linux-bcache@vger.kernel.org

Hello Kent Overstreet,

This is a semi-automatic email about new static checker warnings.

The patch f59fce847fc8: "bcache: Fix error handling in init code"
from May 15, 2013, leads to the following Smatch complaint:

drivers/md/bcache/super.c:1088 cached_dev_free()
	 error: we previously assumed 'dc->bdev->bd_disk' could be null (see line 1085)

drivers/md/bcache/super.c
  1084		if (!IS_ERR_OR_NULL(dc->bdev)) {
  1085			if (dc->bdev->bd_disk)
                            ^^^^^^^^^^^^^^^^^
The patch introduces a new check.

  1086				blk_sync_queue(bdev_get_queue(dc->bdev));
  1087	
  1088			blkdev_put(dc->bdev, FMODE_READ|FMODE_WRITE|FMODE_EXCL);

But "dc->bdev->bd_disk" is dereferenced inside the call to blkdev_put().

  1089		}
  1090	

regards,
dan carpenter
