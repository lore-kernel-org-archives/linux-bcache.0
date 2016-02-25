From: Eric Wheeler <bcache@lists.ewheeler.net>
Subject: Re: bcache: register_cache() error opening sdh2: cannot allocate
 memory => BUG NULL pointer
Date: Thu, 25 Feb 2016 07:29:36 +0000 (UTC)
Message-ID: <alpine.LRH.2.11.1602250727120.3635@mail.ewheeler.net>
References: <20160225061821.GB15421@merlins.org>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-bcache-owner@vger.kernel.org>
Received: from mx.ewheeler.net ([71.19.153.34]:39101 "EHLO mail.ewheeler.net"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1756834AbcBYH3i (ORCPT <rfc822;linux-bcache@vger.kernel.org>);
	Thu, 25 Feb 2016 02:29:38 -0500
In-Reply-To: <20160225061821.GB15421@merlins.org>
Sender: linux-bcache-owner@vger.kernel.org
List-Id: linux-bcache@vger.kernel.org
To: Marc MERLIN <marc@merlins.org>
Cc: linux-bcache@vger.kernel.org

On Wed, 24 Feb 2016, Marc MERLIN wrote:

> I understand I have an underlying memory problem, but could bcache handle
> memory issues and not crash on null pointer?

Try this patch.  It adds some error handling:

=======================================================================================
diff --git a/drivers/md/bcache/super.c b/drivers/md/bcache/super.c
index a542b58..5d95816 100644
--- a/drivers/md/bcache/super.c
+++ b/drivers/md/bcache/super.c
@@ -1829,11 +1829,12 @@ static int cache_alloc(struct cache_sb *sb, struct cache *ca)
 	return 0;
 }
 
-static void register_cache(struct cache_sb *sb, struct page *sb_page,
+static int register_cache(struct cache_sb *sb, struct page *sb_page,
 				struct block_device *bdev, struct cache *ca)
 {
 	char name[BDEVNAME_SIZE];
-	const char *err = "cannot allocate memory";
+	const char *err = NULL; 
+	int ret = 0;
 
 	memcpy(&ca->sb, sb, sizeof(struct cache_sb));
 	ca->bdev = bdev;
@@ -1848,27 +1849,34 @@ static void register_cache(struct cache_sb *sb, struct page *sb_page,
 	if (blk_queue_discard(bdev_get_queue(ca->bdev)))
 		ca->discard = CACHE_DISCARD(&ca->sb);
 
-	if (cache_alloc(sb, ca) != 0)
+	if ((ret = cache_alloc(sb, ca)) != 0) 
 		goto err;
 
-	err = "error creating kobject";
-	if (kobject_add(&ca->kobj, &part_to_dev(bdev->bd_part)->kobj, "bcache"))
-		goto err;
+	if (kobject_add(&ca->kobj, &part_to_dev(bdev->bd_part)->kobj, "bcache")) {
+		err = "error calling kobject_add";
+		ret = -ENOMEM;
+		goto out;
+	}
 
 	mutex_lock(&bch_register_lock);
 	err = register_cache_set(ca);
 	mutex_unlock(&bch_register_lock);
 
-	if (err)
-		goto err;
-
+	if (err) {
+		ret = -ENODEV;
+		goto out;
+	}
+	
 	pr_info("registered cache device %s", bdevname(bdev, name));
+
 out:
 	kobject_put(&ca->kobj);
-	return;
+
 err:
-	pr_notice("error opening %s: %s", bdevname(bdev, name), err);
-	goto out;
+	if (err)
+		pr_notice("error opening %s: %s", bdevname(bdev, name), err);
+
+	return ret;
 }
 
 /* Global interfaces/init */
@@ -1964,7 +1972,8 @@ static ssize_t register_bcache(struct kobject *k, struct kobj_attribute *attr,
 		if (!ca)
 			goto err_close;
 
-		register_cache(sb, sb_page, bdev, ca);
+		if (register_cache(sb, sb_page, bdev, ca) != 0)
+			goto err_close;
 	}
 out:
 	if (sb_page)
===================================================================


-Eric


> 
> gargamel:/sys/block/md5/bcache# echo /dev/sdh2 > /sys/fs/bcache/register
> gave:
> bcache: register_cache() error opening sdh2: cannot allocate memory
> BUG: unable to handle kernel NULL pointer dereference at 00000000000009b8
> IP: [<ffffffffc05a7e8d>] cache_set_flush+0x102/0x15c [bcache]
> PGD 120dff067 PUD 1119a3067 PMD 0 
> Oops: 0000 [#1] SMP 
> Modules linked in: veth ip6table_filter ip6_tables
> (...)
> CPU: 4 PID: 3371 Comm: kworker/4:3 Not tainted 4.4.2-amd64-i915-volpreempt-20160213bc1 #3
> Hardware name: System manufacturer System Product Name/P8H67-M PRO, BIOS 3904 04/27/2013
> Workqueue: events cache_set_flush [bcache]
> task: ffff88020d5dc280 ti: ffff88020b6f8000 task.ti: ffff88020b6f8000
> RIP: 0010:[<ffffffffc05a7e8d>]  [<ffffffffc05a7e8d>] cache_set_flush+0x102/0x15c [bcache]
> 
> Thanks,
> Marc
> -- 
> "A mouse is a device used to point at the xterm you want to type in" - A.S.R.
> Microsoft is to operating systems ....
>                                       .... what McDonalds is to gourmet cooking
> Home page: http://marc.merlins.org/  
> --
> To unsubscribe from this list: send the line "unsubscribe linux-bcache" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
