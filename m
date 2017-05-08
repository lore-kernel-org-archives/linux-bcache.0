From: Coly Li <i@coly.li>
Subject: Re: [PATCH 1/2] bcache: name bcache devices in an ordered sequence
 asbcache0, bcache1
Date: Mon, 8 May 2017 23:26:10 +0800
Message-ID: <dbdf1cc4-ed10-63a6-cab5-6828f9cade0e@coly.li>
References: <201705081239441539415@zte.com.cn>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Return-path: <linux-bcache-owner@vger.kernel.org>
Received: from server.coly.li ([162.144.45.48]:56964 "EHLO server.coly.li"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1755428AbdEHP0V (ORCPT <rfc822;linux-bcache@vger.kernel.org>);
        Mon, 8 May 2017 11:26:21 -0400
In-Reply-To: <201705081239441539415@zte.com.cn>
Sender: linux-bcache-owner@vger.kernel.org
List-Id: linux-bcache@vger.kernel.org
To: tang.junhui@zte.com.cn
Cc: kent.overstreet@gmail.com, linux-bcache@vger.kernel.org

On 2017/5/8 下午12:39, tang.junhui@zte.com.cn wrote:
> Hello Li
> 
> 
> ＞ ＞ From: "tang.junhui" ＜tang.junhui@zte.com.cn＞
> 
> ＞ ＞ 
> 
> ＞ ＞ Currently, names of bcache devices displayed as bcache0, bcache16,
> 
> ＞ ＞ bcache32, etc. This patch changes their names as bcache0, bcache1,
> 
> ＞ ＞ bcache2, etc.
> 
> ＞ ＞ 
> 
> ＞ ＞ Signed-off-by: tang.junhui ＜tang.junhui@zte.com.cn＞
> 
> ＞ ＞ ---
> 
> ＞ ＞  drivers/md/bcache/super.c | 2 +-
> 
> ＞ ＞  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> ＞ ＞ 
> 
> ＞ ＞ diff --git a/drivers/md/bcache/super.c b/drivers/md/bcache/super.c
> 
> ＞ ＞ index 3a19cbc..867d9a9 100644
> 
> ＞ ＞ --- a/drivers/md/bcache/super.c
> 
> ＞ ＞ +++ b/drivers/md/bcache/super.c
> 
> ＞ ＞ @@ -793,7 +793,7 @@ static int bcache_device_init(struct
> bcache_device *d, unsigned block_size,
> 
> ＞ ＞      }
> 
> ＞ ＞  
> 
> ＞ ＞      set_capacity(d-＞disk, sectors);
> 
> ＞ ＞ -    snprintf(d-＞disk-＞disk_name, DISK_NAME_LEN, "bcache%i", minor);
> 
> ＞ ＞ +    snprintf(d-＞disk-＞disk_name, DISK_NAME_LEN, "bcache%i",
> minor / BCACHE_MINORS);
> 
> ＞ ＞  
> 
> ＞ ＞      d-＞disk-＞major        = bcache_major;
> 
> ＞ ＞      d-＞disk-＞first_minor    = minor;
> 
> ＞ ＞ 
> 
> ＞   
> 
> ＞ Can I understand that the next patch just revert this modification ? If
> 
> ＞ yes, I suggest to combine these 2 patch into one.
> 
> 
> This patch changes bcache devices names from bcache0, bcache16, ... to
> bcache0, bcache1, ...
> 
> and the other patch fix leakage of minor numbers, they are different issues.

Yes, they might be two different issue. But this patch set only has two
patches, and the first patch is reverted in second patch, it does not
make sense to me.

Coly


-- 
Coly Li
