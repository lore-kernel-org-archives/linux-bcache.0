From: Kai Krakow <hurikhan77@gmail.com>
Subject: Re: SSD usage for bcache - Read and Writeback
Date: Thu, 14 Sep 2017 13:43:11 +0200
Message-ID: <20170914134311.25fd67aa@jupiter.sol.kaishome.de>
References: <CAD7b65Ly7rEVyShjD=1NBsYBMiyQGXuzKv0h2Ys5KN=ghTJcaA@mail.gmail.com>
        <51852c79-bee0-19c3-92d8-6044f3e3e2a7@coly.li>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Return-path: <linux-bcache-owner@vger.kernel.org>
Received: from [195.159.176.226] ([195.159.176.226]:52228 "EHLO
        blaine.gmane.org" rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org
        with ESMTP id S1751701AbdINLpN (ORCPT
        <rfc822;linux-bcache@vger.kernel.org>);
        Thu, 14 Sep 2017 07:45:13 -0400
Received: from list by blaine.gmane.org with local (Exim 4.84_2)
        (envelope-from <glbd-linux-bcache@m.gmane.org>)
        id 1dsSZr-0007fD-HT
        for linux-bcache@vger.kernel.org; Thu, 14 Sep 2017 13:45:03 +0200
Sender: linux-bcache-owner@vger.kernel.org
List-Id: linux-bcache@vger.kernel.org
To: linux-bcache@vger.kernel.org

Am Thu, 14 Sep 2017 09:58:25 +0200
schrieb Coly Li <i@coly.li>:

> On 2017/9/11 下午4:04, FERNANDO FREDIANI wrote:
> > Hi folks
> > 
> > In Bcache people normally use a single SSD for both Read and Write
> > cache. This seems to work pretty well, at least for the load we have
> > been using here.
> > 
> > However in other environments, specially on ZFS people tend to
> > suggest to use dedicated SSDs for Write (ZIL) and for Read (L2ARC).
> > Some say that performance will be much better in this way and
> > mainly say they have different wearing levels.
> > The issue now a days is that SSDs for Write Cache (or Writeback)
> > don't need to have much space available (8GB normally is more than
> > enough), just enough for the time until data is committed to the
> > pool (or slower disks) so it is hard to find a suitable SSD to
> > dedicate to this propose only without overprovisioning that part.
> > On the top of that newer SSDs have changed a lot in recent times
> > using different types of memory technologies which tend to be much
> > durable.
> > 
> > Given that I personally see that using a single SSD for both Write
> > and Read cache, in any scenarios doesn't impose any significant
> > loss to the storage, given you use new technology SSDs and that you
> > will hardly saturate it most of the time. Does anyone agree or
> > disagree with that ?  
> 
> If there is any real performance number, it will be much easier to
> response this idea. What confuses me is, if user reads a data block
> which is just written to SSD, what is the benefit for the separated
> SSDs.
> 
> Yes I agree with you that some times a single SSD as cache device is
> inefficient. Multiple cache device on bcache is a not-implemented yet
> feature as I know.

Does bcache support more that one cache device in a cset? If yes, the
best idea would be if one could implement to define one as read-mostly,
and another ssd as write-mostly.

This would make a non-strict policy which allows reading from the other
device if the block is already there, or writing to the read-mostly
device to update data in cache. Thoughts?


-- 
Regards,
Kai

Replies to list-only preferred.
