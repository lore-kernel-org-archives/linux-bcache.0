From: Michael Lyle <mlyle@lyle.org>
Subject: Re: [PATCH v3] bcache: fix writeback target calc on large devices
Date: Fri, 5 Jan 2018 13:20:22 -0800
Message-ID: <e2db589b-6698-df58-a97b-8b78d0762fe8@lyle.org>
References: <20180105211739.27305-1-mlyle@lyle.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-bcache-owner@vger.kernel.org>
Received: from mail-pl0-f47.google.com ([209.85.160.47]:36024 "EHLO
        mail-pl0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752959AbeAEVUY (ORCPT
        <rfc822;linux-bcache@vger.kernel.org>);
        Fri, 5 Jan 2018 16:20:24 -0500
Received: by mail-pl0-f47.google.com with SMTP id b12so3762552plm.3
        for <linux-bcache@vger.kernel.org>; Fri, 05 Jan 2018 13:20:24 -0800 (PST)
In-Reply-To: <20180105211739.27305-1-mlyle@lyle.org>
Content-Language: en-US
Sender: linux-bcache-owner@vger.kernel.org
List-Id: linux-bcache@vger.kernel.org
To: linux-bcache@vger.kernel.org, linux-block@vger.kernel.org

On 01/05/2018 01:17 PM, Michael Lyle wrote:
> Bcache needs to scale the dirty data in the cache over the multiple
> backing disks in order to calculate writeback rates for each.
> The previous code did this by multiplying the target number of dirty
> sectors by the backing device size, and expected it to fit into a
> uint64_t; this blows up on relatively small backing devices.
> 
> The new approach figures out the bdev's share in 16384ths of the overall
> cached data.  This is chosen to cope well when bdevs drastically vary in
> size and to ensure that bcache can cross the petabyte boundary for each
> backing device.
> 
> This has been improved based on Tang Junhui's feedback to ensure that
> every device gets a share of dirty data, no matter how small it is
> compared to the total backing pool.
> 
> Reported-by: Jack Douglas <jack@douglastechnology.co.uk>
> Signed-off-by: Michael Lyle <mlyle@lyle.org>

Commentary:

I don't love this, at all.  It really should be the device's share of
the dirty data, not the device's share of the backing size, that sets
its share of the rate (so that if you have a 100GB cache vol, with a
10GB dirty target, and 5 backing devices of which only 2 are active..
those 2 can use all of the 10GB dirty).  But we lack an appropriate
accountancy mechanism right now so it has to be done this way.

This has seen light test so far-- a lot of single-backing tests, a
couple of 2 and 3 backing device tests.

Mike
