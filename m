From: tang.junhui@zte.com.cn
Subject: Re: [for-416 PATCH v2] bcache: fix writeback target calculation
Date: Wed, 3 Jan 2018 01:20:07 +0800
Message-ID: <1514913607-22144-1-git-send-email-tang.junhui@zte.com.cn>
Return-path: <linux-bcache-owner@vger.kernel.org>
Received: from out1.zte.com.cn ([202.103.147.172]:42110 "EHLO mxct.zte.com.cn"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751149AbeACGxG (ORCPT <rfc822;linux-bcache@vger.kernel.org>);
        Wed, 3 Jan 2018 01:53:06 -0500
Sender: linux-bcache-owner@vger.kernel.org
List-Id: linux-bcache@vger.kernel.org
To: mlyle@lyle.org
Cc: linux-bcache@vger.kernel.org, linux-block@vger.kernel.org, tang.junhui@zte.com.cn

From: Tang Junhui <tang.junhui@zte.com.cn>

When I saw the code "int64_t error = dirty - cache_dirty_target", I was 
totally lost, I will try my best to get out. 
And this patch dependent on your earlier patch(PI controller), did that
patch have applied to upstreams branch? I searched in 4.14 branch, 
and did not find it.

> drivers/md/bcache/writeback.c | 38 ++++++++++++++++++++++++++++++--------    
> 1 file changed, 30 insertions(+), 8 deletions(-)                             
>                                                                              
>diff --git a/drivers/md/bcache/writeback.c b/drivers/md/bcache/writeback.c    
>index 56a37884ca8b..be2840ad02d4 100644                                       
>--- a/drivers/md/bcache/writeback.c                                           
>+++ b/drivers/md/bcache/writeback.c                                           
>@@ -26,16 +26,28 @@ static void __update_writeback_rate(struct cached_dev *dc)
>                 bcache_flash_devs_sectors_dirty(c);                          
>     uint64_t cache_dirty_target =                                            
>         div_u64(cache_sectors * dc->writeback_percent, 100);                 
>-    int64_t target = div64_u64(cache_dirty_target * bdev_sectors(dc->bdev),  
>-                   c->cached_dev_sectors);                                   
>+                                                                             
>+    /*                                                                       
>+     * 16384 is chosen here as something that each backing device should     
>+     * be a reasonable fraction of the share, and to not blow up until       
>+     * individual backing devices are a petabyte.                            
>+     */                                                                      
>+    uint32_t bdev_share_per16k =                                             
>+        div64_u64(16384 * bdev_sectors(dc->bdev),                            
>+                c->cached_dev_sectors);                                      
>                                                                              
>     /*                                                                       
>      * PI controller:                                                        
>      * Figures out the amount that should be written per second.             
>      *                                                                       
>      * First, the error (number of sectors that are dirty beyond our         
>-     * target) is calculated.  The error is accumulated (numerically         
>-     * integrated).                                                          
>+     * target) is calculated.                                                
>+     *                                                                       
>+     * Unfortunately we don't know the exact share of dirty data for         
>+     * each backing device; therefore the error is adjusted for this         
>+     * backing disk's share of the overall error based on size.              
>+     *                                                                       
>+     * The error is accumulated (numerically integrated).                    
>      *                                                                       
>      * Then, the proportional value and integral value are scaled            
>      * based on configured values.  These are stored as inverses to  
>              
>@@ -50,12 +62,22 @@ static void __update_writeback_rate(struct cached_dev *dc)
>      * variations in usage like the p term.                                  
>      */                                                                      
>     int64_t dirty = bcache_dev_sectors_dirty(&dc->disk);                     
>-    int64_t error = dirty - target;                                          
>-    int64_t proportional_scaled =                                            
>-        div_s64(error, dc->writeback_rate_p_term_inverse);                   
>-    int64_t integral_scaled;                                                 
>+    int64_t error = dirty - cache_dirty_target;                              
>+    int64_t proportional_scaled, integral_scaled;                            
>     uint32_t new_rate;                                                       
>                                                                              
>+    /*                                                                       
>+     * Ensure even with large device size disparities that we still          
>+     * writeback at least some.                                              
>+     */                                                                      
>+    if (bdev_share_per16k < 1)                                               
>+        bdev_share_per16k = 1;                                               
>+                                                                             
>+    target = div_s64(error * bdev_share_per16k, 16384)                       
>+                                                                             
>+    proportional_scaled = div_s64(error,                                     
>+            dc->writeback_rate_p_term_inverse);                              
>+                                                                             
>     if ((error < 0 && dc->writeback_rate_integral > 0) ||                    
>         (error > 0 && time_before64(local_clock(),                           
>              dc->writeback_rate.next + NSEC_PER_MSEC))) {                    
>--                                                                            
>2.14.1                                                                        

Thanks,
Tang Junhui
