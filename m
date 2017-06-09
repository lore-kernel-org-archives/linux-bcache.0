From: Coly Li <i@coly.li>
Subject: Re: [PATCH] bcache: gc does not work when triggering by manualcommand
Date: Fri, 9 Jun 2017 13:11:41 +0800
Message-ID: <d36c9169-0a60-a0c6-3ac6-5c783176b17f@coly.li>
References: <201706090859585160191@zte.com.cn>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Return-path: <linux-bcache-owner@vger.kernel.org>
Received: from server.coly.li ([162.144.45.48]:44372 "EHLO server.coly.li"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751084AbdFIFLt (ORCPT <rfc822;linux-bcache@vger.kernel.org>);
        Fri, 9 Jun 2017 01:11:49 -0400
In-Reply-To: <201706090859585160191@zte.com.cn>
Content-Language: en-US
Sender: linux-bcache-owner@vger.kernel.org
List-Id: linux-bcache@vger.kernel.org
To: tang.junhui@zte.com.cn
Cc: kent.overstreet@gmail.com, bcache@lists.ewheeler.net, linux-bcache@vger.kernel.org

On 2017/6/9 上午8:59, tang.junhui@zte.com.cn wrote:
> Hello Coly,
> 
> 
> ＞ First we need to know why
> ＞ when writeback cashe is full but sectors_to_gc ＜ 0
> 
> Some times,  the writeback cashe is not full, we just wanna execute 
> 
> this commands to get more available buckets,  but this command
> 
> "echo 1 ＞ trigger_gc" does not works, this is the issue that the patch
> 
> fixed.

Oh I see the point! Yes it's useful.

A question is, this patch changes expected behavior of trigger_gc. This
modification may change I/O load to existing installations. How about
add a new sysfs entry like trigger_gc_force ? And add comments in source
code to explain this change is necessary.

IMHO this is quite an important fix, thanks for your effort :-)

Coly

> 
> 原始邮件
> *发件人：*＜i@coly.li＞;
> *收件人：*唐军辉10074136;＜kent.overstreet@gmail.com＞;
> ＜bcache@lists.ewheeler.net＞;
> *抄送人：*＜linux-bcache@vger.kernel.org＞;
> *日 期 ：*2017年06月08日 23:54
> *主 题 ：**Re: [PATCH] bcache: gc does not work when triggering by
> manualcommand*
> 
> 
> On 2017/6/8 下午2:39, tang.junhui@zte.com.cn wrote:
> ＞ From: Tang Junhui ＜tang.junhui@zte.com.cn＞
> ＞ 
> ＞ I try to execute the following command to trigger gc thread:
> ＞ [root@localhost internal]# echo 1 ＞ trigger_gc
> ＞ But it does not work, I debug the code in gc_should_run(), It works only
> ＞ if in invalidating or sectors_to_gc ＜ 0. So set sectors_to_gc to -1 to
> ＞ meet the condition when we trigger gc by manual command.
> ＞ 
> ＞ Signed-off-by: Tang Junhui ＜tang.junhui@zte.com.cn＞
> 
> This fix may make things more complicated. First we need to know why
> when writeback cashe is full but sectors_to_gc ＜ 0 ? If we don't find
> out the root reason, this fix is not convinced.
> 
> Thanks.
> 
> Coly
> 
> 
> ＞ ---
> ＞  drivers/md/bcache/btree.h | 6 ++++++
> ＞  drivers/md/bcache/sysfs.c | 2 +-
> ＞  2 files changed, 7 insertions(+), 1 deletion(-)
> ＞ 
> ＞ diff --git a/drivers/md/bcache/btree.h b/drivers/md/bcache/btree.h
> ＞ index 9b80417..bab07d4 100644
> ＞ --- a/drivers/md/bcache/btree.h
> ＞ +++ b/drivers/md/bcache/btree.h
> ＞ @@ -263,6 +263,12 @@ static inline void wake_up_gc(struct cache_set *c)
> ＞      wake_up(&c-＞gc_wait);
> ＞  }
> ＞  
> ＞ +static inline void wake_up_gc_force(struct cache_set *c)
> ＞ +{
> ＞ +    atomic_set(&c-＞sectors_to_gc, -1);
> ＞ +    wake_up(&c-＞gc_wait);
> ＞ +}
> ＞ +
> ＞  #define MAP_DONE    0
> ＞  #define MAP_CONTINUE    1
> ＞  
> ＞ diff --git a/drivers/md/bcache/sysfs.c b/drivers/md/bcache/sysfs.c
> ＞ index b3ff57d..5fdb86c 100644
> ＞ --- a/drivers/md/bcache/sysfs.c
> ＞ +++ b/drivers/md/bcache/sysfs.c
> ＞ @@ -615,7 +615,7 @@ STORE(__bch_cache_set)
> ＞      }
> ＞  
> ＞      if (attr == &sysfs_trigger_gc)
> ＞ -        wake_up_gc(c);
> ＞ +        wake_up_gc_force(c);
> ＞  
> ＞      if (attr == &sysfs_prune_cache) {
> ＞          struct shrink_control sc;
> ＞ 
> 
> 
> 


-- 
Coly Li
