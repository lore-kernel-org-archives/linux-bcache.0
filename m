From: Michael Lyle <mlyle@lyle.org>
Subject: Re: [PATCH] [PATCH V2] bcache: fix wrong cache_misses statistics
Date: Sun, 29 Oct 2017 22:14:34 -0700
Message-ID: <92c04a1a-ef09-27ec-c006-9ec60e5e9f28@lyle.org>
References: <1509158391-31992-1-git-send-email-tang.junhui@zte.com.cn>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-block-owner@vger.kernel.org>
In-Reply-To: <1509158391-31992-1-git-send-email-tang.junhui@zte.com.cn>
Content-Language: en-US
Sender: linux-block-owner@vger.kernel.org
To: tang.junhui@zte.com.cn, bcache@lists.ewheeler.net, colyli@suse.de
Cc: linux-bcache@vger.kernel.org, linux-block@vger.kernel.org
List-Id: linux-bcache@vger.kernel.org

On 10/27/2017 07:39 PM, tang.junhui@zte.com.cn wrote:
> From: "tang.junhui" <tang.junhui@zte.com.cn>
> 
> Currently, Cache missed IOs are identified by s->cache_miss, but actually,
> there are many situations that missed IOs are not assigned a value for
> s->cache_miss in cached_dev_cache_miss(), for example, a bypassed IO
> (s->iop.bypass = 1), or the cache_bio allocate failed. In these situations,
> it will go to out_put or out_submit, and s->cache_miss is null, which leads
> bch_mark_cache_accounting() to treat this IO as a hit IO.
> 
> Signed-off-by: tang.junhui <tang.junhui@zte.com.cn>

Reviewed-by: Michael Lyle <mlyle@lyle.org>

Applied to my local tree for test.  Thanks!

-mpl
