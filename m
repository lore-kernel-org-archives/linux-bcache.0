From: Ronald van Zantvoort <ronald@pcextreme.nl>
Subject: obsolete option freelist_percent in documentation / question
Date: Mon, 17 Aug 2015 11:01:31 +0200
Message-ID: <55D1A2EB.3030603@pcextreme.nl>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-bcache-owner@vger.kernel.org>
Received: from support.pcextreme.nl ([109.72.87.231]:45547 "EHLO
	support.pcextreme.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751331AbbHQJHT (ORCPT
	<rfc822;linux-bcache@vger.kernel.org>);
	Mon, 17 Aug 2015 05:07:19 -0400
Received: from ox.pcextreme.nl (ox01.pcextreme.nl [IPv6:2a00:f10:101::6f7b:25:143])
	by support.pcextreme.nl (Postfix) with ESMTPS id 3129F2C2EF
	for <linux-bcache@vger.kernel.org>; Mon, 17 Aug 2015 11:01:32 +0200 (CEST)
Received: from lianxiang.the-loeki.net (unknown [IPv6:2001:980:7936:0:6267:20ff:fea9:3b9c])
	by ox.pcextreme.nl (Postfix) with ESMTPSA id EC85F540100
	for <linux-bcache@vger.kernel.org>; Mon, 17 Aug 2015 11:01:31 +0200 (CEST)
Sender: linux-bcache-owner@vger.kernel.org
List-Id: linux-bcache@vger.kernel.org
To: "linux-bcache@vger.kernel.org" <linux-bcache@vger.kernel.org>

Hi all,


https://www.kernel.org/doc/Documentation/bcache.txt reports

freelist_percent
   Size of the freelist as a percentage of nbuckets. Can be written to to
   increase the number of buckets kept on the freelist, which lets you
   artificially reduce the size of the cache at runtime. Mostly for testing
   purposes (i.e. testing how different size caches affect your hit 
rate), but
   since buckets are discarded when they move on to the freelist will 
also make
   the SSD's garbage collection easier by effectively giving it more 
reserved
   space.


However, on dec. 17, 2013, the allocator reserves got reworked and this 
option disappeared.

We're currently rolling out bcache on a number of older Intel SSD's 
which are notoriously bad on the GC part; they practically *need* a big 
chunk of reserved space to function properly.

Of course we could go with a HPA or a smaller partition, but it'd be 
much more elegant to do this from within bcache itself; so is this still 
possible , now that this option obviously no longer exists, and if so, how?

Thanks in advance!

Ronald
