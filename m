From: Coly Li <i@coly.li>
Subject: Re: [PATCH] bcache: fix issue of writeback rate at minimum 1 blockper
 second
Date: Fri, 9 Jun 2017 13:06:03 +0800
Message-ID: <cfd2a750-24ac-24bc-d693-51563a900c5f@coly.li>
References: <201706090934251301555@zte.com.cn>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Return-path: <linux-bcache-owner@vger.kernel.org>
Received: from server.coly.li ([162.144.45.48]:44350 "EHLO server.coly.li"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751479AbdFIFGL (ORCPT <rfc822;linux-bcache@vger.kernel.org>);
        Fri, 9 Jun 2017 01:06:11 -0400
In-Reply-To: <201706090934251301555@zte.com.cn>
Content-Language: en-US
Sender: linux-bcache-owner@vger.kernel.org
List-Id: linux-bcache@vger.kernel.org
To: tang.junhui@zte.com.cn
Cc: kent.overstreet@gmail.com, bcache@lists.ewheeler.net, linux-bcache@vger.kernel.org

On 2017/6/9 上午9:34, tang.junhui@zte.com.cn wrote:
> Hello Coly,
> 
> 
> ＞ I feel uncomfortable to the above idea. Is the purpose of this change is
> 
> ＞ to make writeback more efficient with more dirty data ? Or some other
> 
> ＞ reason that you want to make this change?
> 
> 
> This patch fix for Kuba Sztandera's issue：
> 
> "Writeback rate is at minimum 1 block per second"
> 
> Please see more detail at his email,
> 
> or look at this link:
> 
> http://www.spinics.net/lists/linux-bcache/msg04645.html

Yeah, with comments from Eric, I come to understand where the problem
is. Most of people do not follow our bcache mailing list, what they can
see is only patch commit log. If you may add the back ground why this is
a problem and how to fix it, that will be really helpful to many people.

Thanks for your effort :-)

-- 
Coly Li
