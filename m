From: Coly Li <i@coly.li>
Subject: Re: [PATCH] bcache: initialize stripe_sectors_dirty correctly forthin
 flash device
Date: Thu, 1 Jun 2017 20:00:56 +0800
Message-ID: <497b9a42-af33-279e-6ec1-4de8f09d09cf@coly.li>
References: <201706011957430278550@zte.com.cn>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Return-path: <linux-bcache-owner@vger.kernel.org>
Received: from server.coly.li ([162.144.45.48]:42094 "EHLO server.coly.li"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751062AbdFAMBE (ORCPT <rfc822;linux-bcache@vger.kernel.org>);
        Thu, 1 Jun 2017 08:01:04 -0400
In-Reply-To: <201706011957430278550@zte.com.cn>
Content-Language: en-US
Sender: linux-bcache-owner@vger.kernel.org
List-Id: linux-bcache@vger.kernel.org
To: tang.junhui@zte.com.cn
Cc: kent.overstreet@gmail.com, bcache@lists.ewheeler.net, linux-bcache@vger.kernel.org

On 2017/6/1 下午7:57, tang.junhui@zte.com.cn wrote:
> 
> Hello Coly,
> 
> 
> ＞ Please, please, could you please provide more patch comments, why this
> ＞ is a bug and how things go wrong without your patch, and get fixed with
> ＞ you patch.
> 
> I am sorry for my poor presentation, though I think The best way to 
> 
> communicatebetween us is CODE, but I will try my best to improve 
> 
> the comments in later patch.
> 
> 
> Thanks for your reminding.

I ask for the informative comments because your fix with these patches
are very important IMHO. We do appreciate your effort, more comments
will be perfect.


-- 
Coly Li
