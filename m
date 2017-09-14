From: Coly Li <i@coly.li>
Subject: Re: SSD usage for bcache - Read and Writeback
Date: Thu, 14 Sep 2017 09:58:25 +0200
Message-ID: <51852c79-bee0-19c3-92d8-6044f3e3e2a7@coly.li>
References: <CAD7b65Ly7rEVyShjD=1NBsYBMiyQGXuzKv0h2Ys5KN=ghTJcaA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Return-path: <linux-bcache-owner@vger.kernel.org>
Received: from server.coly.li ([162.144.45.48]:36032 "EHLO server.coly.li"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751433AbdINH6e (ORCPT <rfc822;linux-bcache@vger.kernel.org>);
        Thu, 14 Sep 2017 03:58:34 -0400
In-Reply-To: <CAD7b65Ly7rEVyShjD=1NBsYBMiyQGXuzKv0h2Ys5KN=ghTJcaA@mail.gmail.com>
Content-Language: en-US
Sender: linux-bcache-owner@vger.kernel.org
List-Id: linux-bcache@vger.kernel.org
To: FERNANDO FREDIANI <fernando.frediani@upx.com>, linux-bcache@vger.kernel.org

On 2017/9/11 下午4:04, FERNANDO FREDIANI wrote:
> Hi folks
> 
> In Bcache people normally use a single SSD for both Read and Write
> cache. This seems to work pretty well, at least for the load we have
> been using here.
> 
> However in other environments, specially on ZFS people tend to suggest
> to use dedicated SSDs for Write (ZIL) and for Read (L2ARC). Some say
> that performance will be much better in this way and mainly say they
> have different wearing levels.
> The issue now a days is that SSDs for Write Cache (or Writeback) don't
> need to have much space available (8GB normally is more than enough),
> just enough for the time until data is committed to the pool (or
> slower disks) so it is hard to find a suitable SSD to dedicate to this
> propose only without overprovisioning that part.
> On the top of that newer SSDs have changed a lot in recent times using
> different types of memory technologies which tend to be much durable.
> 
> Given that I personally see that using a single SSD for both Write and
> Read cache, in any scenarios doesn't impose any significant loss to
> the storage, given you use new technology SSDs and that you will
> hardly saturate it most of the time. Does anyone agree or disagree
> with that ?

Hi Fernando,

If there is any real performance number, it will be much easier to
response this idea. What confuses me is, if user reads a data block
which is just written to SSD, what is the benefit for the separated SSDs.

Yes I agree with you that some times a single SSD as cache device is
inefficient. Multiple cache device on bcache is a not-implemented yet
feature as I know.

Thanks.

-- 
Coly Li
