From: "Paul B. Henson" <henson@acm.org>
Subject: RE: register_bcache() error opening /dev/md2: bad block/bucket size
Date: Mon, 2 Dec 2013 15:26:27 -0800
Message-ID: <000401ceefb5$f0aa6160$d1ff2420$@acm.org>
References: <20131130033736.GF5195@bender.unx.csupomona.edu>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-bcache-owner@vger.kernel.org>
Received: from mail-pd0-f182.google.com ([209.85.192.182]:56830 "EHLO
	mail-pd0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751611Ab3LBX0g (ORCPT
	<rfc822;linux-bcache@vger.kernel.org>);
	Mon, 2 Dec 2013 18:26:36 -0500
Received: by mail-pd0-f182.google.com with SMTP id v10so19075141pde.41
        for <linux-bcache@vger.kernel.org>; Mon, 02 Dec 2013 15:26:35 -0800 (PST)
Received: from leela (host-134-71-248-24.allocated.csupomona.edu. [134.71.248.24])
        by mx.google.com with ESMTPSA id de1sm125262891pbc.7.2013.12.02.15.26.33
        for <linux-bcache@vger.kernel.org>
        (version=TLSv1 cipher=ECDHE-RSA-AES128-SHA bits=128/128);
        Mon, 02 Dec 2013 15:26:34 -0800 (PST)
In-Reply-To: <20131130033736.GF5195@bender.unx.csupomona.edu>
Content-Language: en-us
Sender: linux-bcache-owner@vger.kernel.org
List-Id: linux-bcache@vger.kernel.org
To: linux-bcache@vger.kernel.org

Haven't seen much traffic on the list, maybe everybody is still recovering
from turkey comas (at least in the US ;) ).

No thoughts on this issue? Am I misunderstanding the purpose of the -w
argument, is it not intended to align with the SSD page size?

> -----Original Message-----
> From: Paul Henson [mailto:paul.b.henson@gmail.com] On Behalf Of Paul B.
> Henson
> Sent: Friday, November 29, 2013 7:38 PM
> To: linux-bcache@vger.kernel.org
> Subject: register_bcache() error opening /dev/md2: bad block/bucket size
> 
> I'm trying to set up a mirror of two Samsung 840 Pro 256GB SSDs as a
> cache device. Per their specs, the page size is 8k, and the erase block
> size is 1024k, so I created the cache device as:
> 
> make-bcache --wipe-bcache -b 1024k -w 8k -C /dev/md2
> 
> With a bucket size equal to the erase block, and a block size equal to
> the page size. The documentation on block size wasn't really clear, but
> I believe it's supposed to equal the ssd page size, ie, the minimum io
> size for the device.
> 
> However, when trying to register this cache device, it fails with:
> 
> bcache: register_bcache() error opening /dev/md2: Bad block/bucket size
> 
> Looking at the code:
> 
>                 err = "Bad block/bucket size";
>                 if (!is_power_of_2(sb->block_size) ||
>                     sb->block_size > PAGE_SECTORS ||
>                     !is_power_of_2(sb->bucket_size) ||
>                     sb->bucket_size < PAGE_SECTORS)
>                         goto err;
> 
> and given PAGE_SIZE = 4096 and PAGE_SECTORS = 8, it's complaining that my
> cache device block size of 8k is greater than the page size of 4k. I guess
> I could create my cache device with a block size of 4k to make it work,
but
> that seems inefficient as it does not match the page size. What's this
> limitation about? Can it be changed? Are SSD's with a > 4k page size just
> poor choices for a cache device?
> 
> Thanks...
