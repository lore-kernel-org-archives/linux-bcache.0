From: "Paul B. Henson" <henson@acm.org>
Subject: register_bcache() error opening /dev/md2: bad block/bucket size
Date: Fri, 29 Nov 2013 19:37:36 -0800
Message-ID: <20131130033736.GF5195@bender.unx.csupomona.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-bcache-owner@vger.kernel.org>
Received: from mail-pd0-f170.google.com ([209.85.192.170]:53705 "EHLO
	mail-pd0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751729Ab3K3Dhl (ORCPT
	<rfc822;linux-bcache@vger.kernel.org>);
	Fri, 29 Nov 2013 22:37:41 -0500
Received: by mail-pd0-f170.google.com with SMTP id g10so14842729pdj.1
        for <linux-bcache@vger.kernel.org>; Fri, 29 Nov 2013 19:37:40 -0800 (PST)
Received: from bender.unx.csupomona.edu (bender.iitsys.csupomona.edu. [134.71.250.134])
        by mx.google.com with ESMTPSA id yh1sm105545157pbc.21.2013.11.29.19.37.38
        for <linux-bcache@vger.kernel.org>
        (version=TLSv1 cipher=ECDHE-RSA-RC4-SHA bits=128/128);
        Fri, 29 Nov 2013 19:37:39 -0800 (PST)
Content-Disposition: inline
Sender: linux-bcache-owner@vger.kernel.org
List-Id: linux-bcache@vger.kernel.org
To: linux-bcache@vger.kernel.org

I'm trying to set up a mirror of two Samsung 840 Pro 256GB SSDs as a
cache device. Per their specs, the page size is 8k, and the erase block
size is 1024k, so I created the cache device as:

make-bcache --wipe-bcache -b 1024k -w 8k -C /dev/md2

With a bucket size equal to the erase block, and a block size equal to
the page size. The documentation on block size wasn't really clear, but
I believe it's supposed to equal the ssd page size, ie, the minimum io
size for the device.

However, when trying to register this cache device, it fails with:

bcache: register_bcache() error opening /dev/md2: Bad block/bucket size

Looking at the code:

                err = "Bad block/bucket size";
                if (!is_power_of_2(sb->block_size) ||
                    sb->block_size > PAGE_SECTORS ||
                    !is_power_of_2(sb->bucket_size) ||
                    sb->bucket_size < PAGE_SECTORS)
                        goto err;

and given PAGE_SIZE = 4096 and PAGE_SECTORS = 8, it's complaining that my
cache device block size of 8k is greater than the page size of 4k. I guess
I could create my cache device with a block size of 4k to make it work, but
that seems inefficient as it does not match the page size. What's this
limitation about? Can it be changed? Are SSD's with a > 4k page size just
poor choices for a cache device?

Thanks...
