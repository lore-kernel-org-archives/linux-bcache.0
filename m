From: Kai Krakow <hurikhan77@gmail.com>
Subject: Re: SSD usage for bcache - Read and Writeback
Date: Thu, 14 Sep 2017 17:31:12 +0200
Message-ID: <20170914173112.376c03ef@jupiter.sol.kaishome.de>
References: <CAD7b65Ly7rEVyShjD=1NBsYBMiyQGXuzKv0h2Ys5KN=ghTJcaA@mail.gmail.com>
        <51852c79-bee0-19c3-92d8-6044f3e3e2a7@coly.li>
        <4a5bb8a9-3de9-bae9-abea-cfa014c87084@upx.com>
        <ad61e116-e69b-d62e-b4de-f20198d7a3fe@coly.li>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Return-path: <linux-bcache-owner@vger.kernel.org>
Received: from [195.159.176.226] ([195.159.176.226]:33467 "EHLO
        blaine.gmane.org" rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org
        with ESMTP id S1751131AbdINPbW (ORCPT
        <rfc822;linux-bcache@vger.kernel.org>);
        Thu, 14 Sep 2017 11:31:22 -0400
Received: from list by blaine.gmane.org with local (Exim 4.84_2)
        (envelope-from <glbd-linux-bcache@m.gmane.org>)
        id 1dsW6i-00077X-GV
        for linux-bcache@vger.kernel.org; Thu, 14 Sep 2017 17:31:12 +0200
Sender: linux-bcache-owner@vger.kernel.org
List-Id: linux-bcache@vger.kernel.org
To: linux-bcache@vger.kernel.org

Am Thu, 14 Sep 2017 16:45:25 +0200
schrieb Coly Li <i@coly.li>:

> On 2017/9/14 下午3:10, FERNANDO FREDIANI wrote:
> > Hello Coly.
> > 
> > If the users reads a piece of data that is just writen to SSD
> > (unlikely) it should first and in any condition be commited to the
> > permanent storage and then read from there and cached in another
> > area of the SSD. Writaback cache is very volatile and lasts only a
> > few seconds while the data is not yet committed to permanent
> > storage.
> > 
> > In fact multiple device suport is not implemented yet, that's why I
> > am asking it and comparing with other well technology as ZFS.
> >   
> 
> Hi Fernando,
> 
> Do you have some performance number to compare combined and separated
> configurations on ZFS ? If the performance improvement is not from
> adding one more SSD device, I don't why dedicate read/write SSDs may
> help for performance. In my understanding, if any of the SSD has
> spared throughput capability for read or write, mixed them together
> on both SSDs may have better performance number.

I could imagine that one way want to use a fast, more expensive disk as
read cache, while using a smaller SLC SSD as write cache for better
longevity and reliability. Because: When you write cache SSD breaks,
things go really bad. If you read cache breaks: No problem, it just
slows down.

So, in conclusion: The recommendation may not be because of
performance... Better performance may just be a (small) side effect.


> > 
> > On 14/09/2017 04:58, Coly Li wrote:  
> >> On 2017/9/11 下午4:04, FERNANDO FREDIANI wrote:  
>  [...]  
> >> Hi Fernando,
> >>
> >> If there is any real performance number, it will be much easier to
> >> response this idea. What confuses me is, if user reads a data block
> >> which is just written to SSD, what is the benefit for the
> >> separated SSDs.
> >>
> >> Yes I agree with you that some times a single SSD as cache device
> >> is inefficient. Multiple cache device on bcache is a
> >> not-implemented yet feature as I know.
> >>
> >> Thanks.  
> 



-- 
Regards,
Kai

Replies to list-only preferred.
