From: Coly Li <i@coly.li>
Subject: Re: [PATCH] bcache: inherit underlying queue limits for bcache
 drivers
Date: Fri, 26 May 2017 00:34:39 +0800
Message-ID: <a9cdf630-32ad-29ae-39c9-8442a0905d97@coly.li>
References: <201705250912040895874@zte.com.cn>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Return-path: <linux-bcache-owner@vger.kernel.org>
Received: from server.coly.li ([162.144.45.48]:42642 "EHLO server.coly.li"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751861AbdEYQfA (ORCPT <rfc822;linux-bcache@vger.kernel.org>);
        Thu, 25 May 2017 12:35:00 -0400
In-Reply-To: <201705250912040895874@zte.com.cn>
Sender: linux-bcache-owner@vger.kernel.org
List-Id: linux-bcache@vger.kernel.org
To: tang.junhui@zte.com.cn, bcache@lists.ewheeler.net
Cc: linux-bcache@vger.kernel.org, kent.overstreet@gmail.com

On 2017/5/25 上午9:12, tang.junhui@zte.com.cn wrote:
> 
> Hello Coly  Eric,
> 
> 
> I find the perfomace is same after testing with `fio` by using 512GB data,
> 
> so 'dd' may be inaccurate, but accutually, I also test it with Ceph
> applicatitangon,
> 
> the performance is also promoted after the modification. So whatever, I
> think
> 
> the bcache devices would better inherit underlying queue limits to show
> the real
> 
> limits to upper layer. You can remove the description of the performace
> promotion
> 
> in the patch since it maybe depend on test scenarios and applications.
> 
> 

Junhui,

bcache_device_init() already does something overlapped with
blk_queue_stack_limits(), which means your patch introduces redundant
code execution. Also blk_queue_stack_limits() may fail, so if you do
want to add this function call, you also need to check the return value
and handle the failure condition.

Currently I don't see benefit from this patch. It is probably I miss
something from your patch, please correct me if you think so.

Thanks.

Coly


> Regards
> 
> Tang Junhui
> 
> 
> ＞＞＞ On 2017/5/23 下午4:14, tang.junhui@zte.com.cn wrote:
> 
> ＞＞＞ ＞ From: "tang.junhui" ＜tang.junhui@zte.com.cn＞
> 
> ＞＞＞ ＞ 
> 
> ＞＞＞ ＞ We'd better let the stacking driver inherit underlying queue
> limits,
> 
> ＞＞＞ ＞ so, we can avoid the unnessary mergering in the top layer, and
> It leads
> 
> ＞＞＞ ＞ a 10% performance promotion in large sequential IO reading
> testing as
> 
> ＞＞＞ ＞ follows:
> 
> ＞＞＞ ＞ 
> 
> ＞＞＞ 
> 
> ＞＞＞ Hi Junhui,
> 
> ＞＞＞ 
> 
> ＞＞＞ I don't get the point why there is unnecessary merging in the upper
> 
> ＞＞＞ layer, and how the unnecessary merging can be avoided by set a
> queue limit.
> 
> ＞＞＞ 
> 
> ＞＞＞ And from the testing, I see total data size is around 21GB which
> is not
> 
> ＞＞＞ convinced enough. Is it possible to use a large enough data size,
> e.g.
> 
> ＞＞＞ 512GB or 1TB ?
> 
> ＞＞
> 
> ＞＞
> 
> ＞＞Please test with `fio` with directio instead of `dd`.  I've seen too
> many 
> 
> ＞＞times where DD is inaccurate for unknown reasons.  
> 
> ＞＞
> 
> ＞＞Also, this should be tested with your cache detached from bcache.
>  If it 
> 
> ＞＞really does improve performance that would be great.
> 
> ＞＞
> 
> ＞＞--
> 
> ＞＞Eric Wheeler
> 
> ＞
> 
> 


-- 
Coly Li
