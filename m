From: Tim Small <tim@buttersideup.com>
Subject: block and bucket sizes
Date: Thu, 13 Aug 2015 11:23:31 +0100
Message-ID: <55CC7023.1010806@buttersideup.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-bcache-owner@vger.kernel.org>
Received: from relay1.allsecuredomains.com ([78.47.251.4]:43003 "EHLO
	relay1.allsecuredomains.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752246AbbHMLAg (ORCPT
	<rfc822;linux-bcache@vger.kernel.org>);
	Thu, 13 Aug 2015 07:00:36 -0400
Received: from [81.174.144.187] (helo=zebedee.buttersideup.com)
	by relay1.allsecuredomains.com with esmtpsa (TLS1.2:DHE_RSA_AES_256_CBC_SHA256:256)
	(Exim 4.80)
	(envelope-from <tim@buttersideup.com>)
	id 1ZPpfY-0008NQ-A7
	for linux-bcache@vger.kernel.org; Thu, 13 Aug 2015 12:23:32 +0200
Received: from [172.19.198.5] (ermintrude.lan [172.19.198.5])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by zebedee.buttersideup.com (Postfix) with ESMTPSA id E51BD6025C
	for <linux-bcache@vger.kernel.org>; Thu, 13 Aug 2015 11:23:31 +0100 (BST)
Sender: linux-bcache-owner@vger.kernel.org
List-Id: linux-bcache@vger.kernel.org
To: linux-bcache@vger.kernel.org

Hi,

I couldn't find much in the way of docs on the block and bucket sizes...

I created a bcache device (md 3 disk RAID5 backing, Intel S3500 cache),
and initially used the default bucket and block sizes.

It looks like flash erase block sizes are now almost universally larger
than the bcache default bucket size, so if this is important (and the
man page says it is), then maybe this needs to be increased?

After a load of googling, I think that for this SSD (which uses
Intel/Micron 20nm MLC), the page size is probably 8 kB, and the erase
block size is probably 256 x 8 kB = 2 MB

http://www.anandtech.com/show/7147/micron-announces-16nm-128gb-mlc-nand-ssds-in-2014

- if on the other hand it uses 128 Gbit parts, then this will be 16 kB
page size, and 8 MB erase block.


So, after playing around a bit, I take it that:

The block size for the backing and cache devices must be the same (are
there any implications e.g. file system compatibility - with block sizes
larger than 4 kB?).

The default bucket size is smaller than the erase block size on this SSD
(and probably most modern SSDs), and I was wondering if the default
should be increased?

I'm assuming most users are going to be getting these parameters "wrong"
- but I'm not sure how much impact this will have on performance and SSD
endurance?  Does this need some sort of wiki -type table with a lookup
between SSD model number and page/block size (which make-bcache could use)?

It'll be a bit of a pain to move everything off my 512 byte block size
backing store, and then recreate it, so should I bother?

Tim.
