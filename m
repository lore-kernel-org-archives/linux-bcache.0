From: Eric Wheeler <bcache@lists.ewheeler.net>
Subject: Re: writeback mode behaviour on proper shut down
Date: Tue, 26 Apr 2016 19:57:01 +0000 (UTC)
Message-ID: <alpine.LRH.2.11.1604261953230.21555@mx.ewheeler.net>
References: <CACHiF8AEZ0Ppoa9mzou76o8j5UC-gXyjt25EDvnqq9S-Kk0B8Q@mail.gmail.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-bcache-owner@vger.kernel.org>
Received: from [66.155.3.69] ([66.155.3.69]:52535 "EHLO mx.ewheeler.net"
	rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1751881AbcDZT5U (ORCPT <rfc822;linux-bcache@vger.kernel.org>);
	Tue, 26 Apr 2016 15:57:20 -0400
In-Reply-To: <CACHiF8AEZ0Ppoa9mzou76o8j5UC-gXyjt25EDvnqq9S-Kk0B8Q@mail.gmail.com>
Sender: linux-bcache-owner@vger.kernel.org
List-Id: linux-bcache@vger.kernel.org
To: ching lu <lsching17@gmail.com>
Cc: linux-bcache@vger.kernel.org

On Tue, 26 Apr 2016, ching lu wrote:

> Hi all,
> 
> if i have 1 SSD caching 1 HDD using bcache, the cache mode is writeback
> 
> if the PC shutdown/unmount normally, will all dirty data in the cache
> be flushed to backing device before poweroff?

No, it will remain in the cache.  

> i am afraid that SSD lose data if left without power for a long time.
> e.g. hoilday.

Wouldn't your data be retained if you used the SSD alone?  SSDs should be 
stable in a powered off state unless it is a bad device.  

There exist RAM-based disks that may be volatile, but that is unlikely to 
be your situation.

--
Eric Wheeler

> 
> Thanks in advance,
> C
> --
> To unsubscribe from this list: send the line "unsubscribe linux-bcache" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
