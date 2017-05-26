From: Coly Li <i@coly.li>
Subject: Re: [PATCH] bcache: inherit underlying queue limits for bcachedrivers
Date: Sat, 27 May 2017 03:08:11 +0800
Message-ID: <3e05ffff-5e36-490d-ed43-cdd1fc2cf58b@coly.li>
References: <201705261717062736400@zte.com.cn>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Return-path: <linux-bcache-owner@vger.kernel.org>
Received: from server.coly.li ([162.144.45.48]:46994 "EHLO server.coly.li"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S932334AbdEZTIl (ORCPT <rfc822;linux-bcache@vger.kernel.org>);
        Fri, 26 May 2017 15:08:41 -0400
In-Reply-To: <201705261717062736400@zte.com.cn>
Sender: linux-bcache-owner@vger.kernel.org
List-Id: linux-bcache@vger.kernel.org
To: tang.junhui@zte.com.cn
Cc: bcache@lists.ewheeler.net, linux-bcache@vger.kernel.org, kent.overstreet@gmail.com

On 2017/5/26 下午5:17, tang.junhui@zte.com.cn wrote:
> Hello Coly,
> 
> 
> ＞ bcache_device_init() already does something overlapped with
> 
> ＞ blk_queue_stack_limits(), which means your patch introduces redundant
> 
> ＞ code execution. Also blk_queue_stack_limits() may fail, so if you do
> 
> ＞ want to add this function call, you also need to check the return value
> 
> ＞ and handle the failure condition.
> 
> Queue Limits are assigned to default value in bcache_device_init(), and then
> 
> updated by inheriting underlying driver in blk_queue_stack_limits(), so
> I think
> 
> there is no redundant or contradiction between them.
> 
> blk_queue_stack_limits() is defined as a void function, so we have no
> need to 
> 
> check the return value.
> 

blk_queue_stack_limits() is wrapper of blk_stack_limits(). If you look
into blk_stack_limits() you will find the redundant code I meant, as
well as the return value I suggested to check.


> 
> ＞ Currently I don't see benefit from this patch. It is probably I miss
> 
>  something from your patch, please correct me if you think so.
> 
> Please consider this scenario: Bcache driver show a large max_sectors_kb,
> 
> then upper layer would merger seqention IOs to make the size of BIO as
> bigger 
> 
> as near to max_sectors_kb. But actually, bcache driver can not send this
> BIO to 
> 
> underlying driver, and have to split the big IO to smaller ones. 
> 
> I think these are useless work.

Oh, maybe I know what you mean.
It is very rare for the above scenario. Maybe I am wrong, but could you
please provide a real example for the above situation ?

Thanks.

-- 
Coly Li
