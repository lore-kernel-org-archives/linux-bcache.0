From: Coly Li <i@coly.li>
Subject: Re: [PATCH 2/2] bcache: fix calling
 ida_simple_remove()withincorrectminor
Date: Tue, 9 May 2017 12:27:21 +0800
Message-ID: <282b9498-2599-e5cc-35bf-2fa286397e6e@coly.li>
References: <201705090918130663236@zte.com.cn>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Return-path: <linux-bcache-owner@vger.kernel.org>
Received: from server.coly.li ([162.144.45.48]:59136 "EHLO server.coly.li"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750909AbdEIE12 (ORCPT <rfc822;linux-bcache@vger.kernel.org>);
        Tue, 9 May 2017 00:27:28 -0400
In-Reply-To: <201705090918130663236@zte.com.cn>
Sender: linux-bcache-owner@vger.kernel.org
List-Id: linux-bcache@vger.kernel.org
To: tang.junhui@zte.com.cn
Cc: kent.overstreet@gmail.com, linux-bcache@vger.kernel.org

On 2017/5/9 上午9:18, tang.junhui@zte.com.cn wrote:
> Hello Coly,
> 
> 
> Your catch is nice:
> 
> 
> ＞ if you call ida_simple_get() like this,
> 
> ＞ 
> 
> ＞ minor = ida_simple_get(&bcache_minor, 0, BCACHE_TO_IDA_MONIRS(MINORMASK
> 
> ＞ + 1), GFP_KERNEL);
> 
> ＞ 
> 
> ＞ The overflow should be removed.
> 
> 
> But I think it is better to modified it as:
> 
> minor = ida_simple_get(&bcache_minor, 0, BCACHE_TO_IDA_MONIRS(MINORMASK)
> 
> + 1, GFP_KERNEL);
> 

Sure, they are same, just use the way you want.

> 
> Though this issue is not introduced by this patch, I would like to fix
> it togother 

Thank you!

> 
> in this patch, I will send a new patch later If you don't have any
> question any more.

Yes please, I don't have comment any more.


-- 
Coly Li
