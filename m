From: tang.junhui@zte.com.cn
Subject: Re: [PATCH v1 03/10] bcache: reduce cache_set devices iteration by devices_max_used
Date: Thu, 4 Jan 2018 03:14:38 +0800
Message-ID: <1515006878-7375-1-git-send-email-tang.junhui@zte.com.cn>
Return-path: <linux-bcache-owner@vger.kernel.org>
Received: from out1.zte.com.cn ([202.103.147.172]:34234 "EHLO mxct.zte.com.cn"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751294AbeADIrh (ORCPT <rfc822;linux-bcache@vger.kernel.org>);
        Thu, 4 Jan 2018 03:47:37 -0500
Sender: linux-bcache-owner@vger.kernel.org
List-Id: linux-bcache@vger.kernel.org
To: colyli@suse.de
Cc: mlyle@lyle.org, linux-bcache@vger.kernel.org, linux-block@vger.kernel.org, tang.junhui@zte.com.cn

From: Tang Junhui <tang.junhui@zte.com.cn>

LGTM.

Reviewed-by: Tang Junhui <tang.junhui@zte.com.cn>

>Member devices of struct cache_set is used to reference all attached                              
>bcache devices to this cache set. If it is treated as array of pointers,                          
>size of devices[] is indicated by member nr_uuids of struct cache_set.                            
>                                                                                                  
>nr_uuids is calculated in drivers/md/super.c:bch_cache_set_alloc(),                               
>    bucket_bytes(c) / sizeof(struct uuid_entry)                                                   
>Bucket size is determined by user space tool "make-bcache", by default it                         
>is 1024 sectors (defined in bcache-tools/make-bcache.c:main()). So default                        
>nr_uuids value is 4096 from the above calculation.                                                
>                                                                                                  
>Every time when bcache code iterates bcache devices of a cache set, all                           
>the 4096 pointers are checked even only 1 bcache device is attached to the                        
>cache set, that's a wast of time and unncessary.                                                  
>                                                                                                  
>This patch adds a member devices_max_used to struct cache_set. Its value                          
>is 1 + the maximum used index of devices[] in a cache set. When iterating                         
>all valid bcache devices of a cache set, use c->devices_max_used in                               
>for-loop may reduce a lot of useless checking.                                                    
>                                                                                                  
>Personally, my motivation of this patch is not for performance, I use it                          
>in bcache debugging, which helps me to narrow down the scape to check                             
>valid bcached devices of a cache set.                                                             
>                                                                                                  
>Signed-off-by: Coly Li <colyli@suse.de>                                                           
>---                                                                                               
> drivers/md/bcache/bcache.h    | 1 +                                                              
> drivers/md/bcache/btree.c     | 2 +-                                                             
> drivers/md/bcache/super.c     | 9 ++++++---                                                      
> drivers/md/bcache/writeback.h | 2 +-                                                             
> 4 files changed, 9 insertions(+), 5 deletions(-)                                                 
>                                                                                                  
>diff --git a/drivers/md/bcache/bcache.h b/drivers/md/bcache/bcache.h                              
>index 843877e017e1..83c569942bd0 100644                                                           
>--- a/drivers/md/bcache/bcache.h                                                                  
>+++ b/drivers/md/bcache/bcache.h                                                                  
>@@ -488,6 +488,7 @@ struct cache_set {                                                            
>     int            caches_loaded;                                                                
>                                                                                                  
>     struct bcache_device    **devices;                                                           
>+    unsigned        devices_max_used;                                                            
>     struct list_head    cached_devs;                                                             
>     uint64_t        cached_dev_sectors;                                                          
>     struct closure        caching;                                                               
>diff --git a/drivers/md/bcache/btree.c b/drivers/md/bcache/btree.c                                
>index 81e8dc3dbe5e..bf0d7978bc3d 100644                                                           
>--- a/drivers/md/bcache/btree.c                                                                   
>+++ b/drivers/md/bcache/btree.c                                                                   
>@@ -1678,7 +1678,7 @@ static void bch_btree_gc_finish(struct cache_set *c)                        
>                                                                                                  
>     /* don't reclaim buckets to which writeback keys point */                                    
>     rcu_read_lock();                                                                             
>-    for (i = 0; i < c->nr_uuids; i++) {                                                          
>+    for (i = 0; i < c->devices_max_used; i++) {                                                  
>         struct bcache_device *d = c->devices[i];                                                 
>         struct cached_dev *dc;                                                                   
>         struct keybuf_key *w, *n;                                                                
>diff --git a/drivers/md/bcache/super.c b/drivers/md/bcache/super.c                                
>index b4d28928dec5..064efd869017 100644                                                           
>--- a/drivers/md/bcache/super.c                                                                   
>+++ b/drivers/md/bcache/super.c                                                                   
>@@ -721,6 +721,9 @@ static void bcache_device_attach(struct bcache_device *d, struct cache_set *c,
>     d->c = c;                                                                                    
>     c->devices[id] = d;                                                                          
>                                                                                                  
>+    if (id >= c->devices_max_used)                                                               
>+        c->devices_max_used = id + 1;                                                            
>+                                                                                                 
>     closure_get(&c->caching);                                                                    
> }                                                                                                
>                                                                                                  
>@@ -1261,7 +1264,7 @@ static int flash_devs_run(struct cache_set *c)                              
>     struct uuid_entry *u;                                                                        
>                                                                                                  
>     for (u = c->uuids;                                                                           
>-         u < c->uuids + c->nr_uuids && !ret;                                                     
>+         u < c->uuids + c->devices_max_used && !ret;                                             
>          u++)                                                                                    
>         if (UUID_FLASH_ONLY(u))                                                                  
>             ret = flash_dev_run(c, u);                                                           
>@@ -1427,7 +1430,7 @@ static void __cache_set_unregister(struct closure *cl)                      
>                                                                                                  
>     mutex_lock(&bch_register_lock);                                                              
>                                                                                                  
>-    for (i = 0; i < c->nr_uuids; i++)                                                            
>+    for (i = 0; i < c->devices_max_used; i++)                                                    
>         if (c->devices[i]) {                                                                     
>             if (!UUID_FLASH_ONLY(&c->uuids[i]) &&                                                
>                 test_bit(CACHE_SET_UNREGISTERING, &c->flags)) {                                  
>@@ -1490,7 +1493,7 @@ struct cache_set *bch_cache_set_alloc(struct cache_sb *sb)                  
>     c->bucket_bits        = ilog2(sb->bucket_size);                                              
>     c->block_bits        = ilog2(sb->block_size);                                                
>     c->nr_uuids        = bucket_bytes(c) / sizeof(struct uuid_entry);                            
>-                                                                                                 
>+    c->devices_max_used    = 0;                                                                  
>     c->btree_pages        = bucket_pages(c);                                                     
>     if (c->btree_pages > BTREE_MAX_PAGES)                                                        
>         c->btree_pages = max_t(int, c->btree_pages / 4,                                          
>diff --git a/drivers/md/bcache/writeback.h b/drivers/md/bcache/writeback.h                        
>index a9e3ffb4b03c..1d284f3d0363 100644                                                           
>--- a/drivers/md/bcache/writeback.h                                                               
>+++ b/drivers/md/bcache/writeback.h                                                               
>@@ -21,7 +21,7 @@ static inline uint64_t  bcache_flash_devs_sectors_dirty(struct cache_set *c)    
>                                                                                                  
>     mutex_lock(&bch_register_lock);                                                              
>                                                                                                  
>-    for (i = 0; i < c->nr_uuids; i++) {                                                          
>+    for (i = 0; i < c->devices_max_used; i++) {                                                  
>         struct bcache_device *d = c->devices[i];                                                 
>                                                                                                  
>         if (!d || !UUID_FLASH_ONLY(&c->uuids[i]))                                                
>--                                                                                                
>2.15.1                                                                                            


Thanks,
Tang Junhui
