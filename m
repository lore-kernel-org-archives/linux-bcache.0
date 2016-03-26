From: Sebastian Roesner <sroesner-kernelorg@roesner-online.de>
Subject: Re: [BUG] NULL pointer in raid1_make_request passed to bio_trim when
 adding md as bcache caching dev
Date: Sat, 26 Mar 2016 19:38:55 +0100
Message-ID: <56F6D73F.7020305@roesner-online.de>
References: <56F4058B.1030309@roesner-online.de>
 <alpine.LRH.2.11.1603250126110.13440@mail.ewheeler.net>
 <alpine.LRH.2.11.1603250416030.13440@mail.ewheeler.net>
 <56F54712.6090202@roesner-online.de>
 <alpine.LRH.2.11.1603251954220.13440@mail.ewheeler.net>
 <alpine.LRH.2.11.1603252117250.13440@mail.ewheeler.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-bcache-owner@vger.kernel.org>
Received: from euler.f0o.de ([85.88.6.196]:33764 "EHLO mail.f0o.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752255AbcCZSjJ (ORCPT <rfc822;linux-bcache@vger.kernel.org>);
	Sat, 26 Mar 2016 14:39:09 -0400
In-Reply-To: <alpine.LRH.2.11.1603252117250.13440@mail.ewheeler.net>
Sender: linux-bcache-owner@vger.kernel.org
List-Id: linux-bcache@vger.kernel.org
To: Eric Wheeler <bcache@lists.ewheeler.net>
Cc: linux-bcache@vger.kernel.org

Hi Eric,

[other lists removed intentionally]

> This could be an upstream problem.

I tried to reproduce it on a test system with the same kernel with new 
created superblocks, there everything worked fine. Also after setting 
dev.cache.discard to yes.

Then I copied the complete partitions from the productive system and got 
the same bug there.

Long story short: It seems to be caused by some data in the the 
cache-device superblock. So even if it's an upstream problem, it's 
somehow caused by data in my superblock.

It can be found here: https://www.f0o.de/~sroesner/bcache-superblock.bz2

Maybe you can reproduce it, for testing I created a degraded raid on 
only one 500G partition and tried to register it to cause the bug.

Sebastian
