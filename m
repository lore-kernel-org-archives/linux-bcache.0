From: Eric Wheeler <bcache@lists.ewheeler.net>
Subject: Re: [PATCH] bcache: inherit underlying queue limits for
 bcachedrivers
Date: Fri, 26 May 2017 20:46:25 +0000 (UTC)
Message-ID: <alpine.LRH.2.11.1705262044190.19359@mail.ewheeler.net>
References: <201705261717062736400@zte.com.cn> <3e05ffff-5e36-490d-ed43-cdd1fc2cf58b@coly.li>
Mime-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="1641074820-1439828461-1495831585=:19359"
Return-path: <linux-bcache-owner@vger.kernel.org>
Received: from mx.ewheeler.net ([66.155.3.69]:46094 "EHLO mail.ewheeler.net"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S944936AbdEZUq1 (ORCPT <rfc822;linux-bcache@vger.kernel.org>);
        Fri, 26 May 2017 16:46:27 -0400
In-Reply-To: <3e05ffff-5e36-490d-ed43-cdd1fc2cf58b@coly.li>
Sender: linux-bcache-owner@vger.kernel.org
List-Id: linux-bcache@vger.kernel.org
To: Coly Li <i@coly.li>
Cc: tang.junhui@zte.com.cn, linux-bcache@vger.kernel.org, kent.overstreet@gmail.com

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

--1641074820-1439828461-1495831585=:19359
Content-Type: TEXT/PLAIN; charset=utf-8
Content-Transfer-Encoding: 8BIT

On Sat, 27 May 2017, Coly Li wrote:

> On 2017/5/26 下午5:17, tang.junhui@zte.com.cn wrote:
> > Hello Coly,
> > 
> > 
> > ＞ bcache_device_init() already does something overlapped with
> > 
> > ＞ blk_queue_stack_limits(), which means your patch introduces redundant
> > 
> > ＞ code execution. Also blk_queue_stack_limits() may fail, so if you do
> > 
> > ＞ want to add this function call, you also need to check the return value
> > 
> > ＞ and handle the failure condition.
> > 
> > Queue Limits are assigned to default value in bcache_device_init(), and then
> > 
> > updated by inheriting underlying driver in blk_queue_stack_limits(), so
> > I think
> > 
> > there is no redundant or contradiction between them.
> > 
> > blk_queue_stack_limits() is defined as a void function, so we have no
> > need to 
> > 
> > check the return value.
> > 
> 
> blk_queue_stack_limits() is wrapper of blk_stack_limits(). If you look
> into blk_stack_limits() you will find the redundant code I meant, as
> well as the return value I suggested to check.
> 
> 
> > 
> > ＞ Currently I don't see benefit from this patch. It is probably I miss
> > 
> >  something from your patch, please correct me if you think so.
> > 
> > Please consider this scenario: Bcache driver show a large max_sectors_kb,
> > 
> > then upper layer would merger seqention IOs to make the size of BIO as
> > bigger 
> > 
> > as near to max_sectors_kb. But actually, bcache driver can not send this
> > BIO to 
> > 
> > underlying driver, and have to split the big IO to smaller ones. 
> > 
> > I think these are useless work.
> 
> Oh, maybe I know what you mean.
> It is very rare for the above scenario. Maybe I am wrong, but could you
> please provide a real example for the above situation ?

What stacking considerations should be made about the caching device vs. 
backing device here?

Would you choose the minimum of both device stacking values?  

Does blk_(queue_)stack_limits already handle this by checking the blockdev 
references held by the bcache device?

--
Eric Wheeler


> 
> Thanks.
> 
> -- 
> Coly Li
> 
--1641074820-1439828461-1495831585=:19359--
