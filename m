From: Dongyang Zhan <zdyzztq@gmail.com>
Subject: Potential Memory Leak Bug in register_bcache() in Linux 5.6.0
Date: Thu, 28 May 2020 10:13:21 +0800
Message-ID: <CAFSR4cuk8oXCYNCT7Tjoufv4bQQrEFSyZnOG0jTi-SqNKCd-xQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-bcache-owner@vger.kernel.org>
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40964 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725849AbgE1CN3 (ORCPT
        <rfc822;linux-bcache@vger.kernel.org>);
        Wed, 27 May 2020 22:13:29 -0400
Received: from mail-io1-xd32.google.com (mail-io1-xd32.google.com [IPv6:2607:f8b0:4864:20::d32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 226B5C05BD1E
        for <linux-bcache@vger.kernel.org>; Wed, 27 May 2020 19:13:29 -0700 (PDT)
Received: by mail-io1-xd32.google.com with SMTP id c8so7967185iob.6
        for <linux-bcache@vger.kernel.org>; Wed, 27 May 2020 19:13:29 -0700 (PDT)
Sender: linux-bcache-owner@vger.kernel.org
List-Id: linux-bcache@vger.kernel.org
To: colyli@suse.de, kent.overstreet@gmail.com
Cc: linux-bcache@vger.kernel.org

Hi,

My name is Dongyang Zhan, I am a security researcher.
Currently, I found a potential memory leak bug in register_bcache() of
drivers/md/bcache/super.c.
The allocated memory regions dc and ca will not be released when
register_cache() or register_bdev() fails.
I hope you can help me to confirm this bug.

The source code and comments are as follows.
https://elixir.bootlin.com/linux/v5.6/source/drivers/md/bcache/super.c#L2253

static ssize_t register_bcache(struct kobject *k, struct kobj_attribute *attr,
      const char *buffer, size_t size)
{
...
struct cached_dev *dc = kzalloc(sizeof(*dc), GFP_KERNEL);
if (!dc)
    goto out_put_sb_page;

mutex_lock(&bch_register_lock);
ret = register_bdev(sb, sb_disk, bdev, dc);
mutex_unlock(&bch_register_lock);
/* blkdev_put() will be called in cached_dev_free() */
if (ret < 0)
    goto out_free_sb; // If ret <0, dc will not be released.
} else {
struct cache *ca = kzalloc(sizeof(*ca), GFP_KERNEL);

if (!ca)
    goto out_put_sb_page;

/* blkdev_put() will be called in bch_cache_release() */
if (register_cache(sb, sb_disk, bdev, ca) != 0)
    goto out_free_sb; // If it fails , ca will not be released.

out_put_sb_page:
put_page(virt_to_page(sb_disk));
out_blkdev_put:
blkdev_put(bdev, FMODE_READ | FMODE_WRITE | FMODE_EXCL);
out_free_sb:
kfree(sb);
out_free_path:
kfree(path);
path = NULL;
out_module_put:
module_put(THIS_MODULE);
out:
pr_info("error %s: %s", path?path:"", err);
return ret;
}
