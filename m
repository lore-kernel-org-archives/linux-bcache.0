From: Coly Li <colyli@suse.de>
Subject: Re: Potential Memory Leak Bug in register_bcache() in Linux 5.6.0
Date: Thu, 28 May 2020 16:28:49 +0800
Message-ID: <6f792a72-0c7f-53d5-76c9-0867f26ed310@suse.de>
References: <CAFSR4cuk8oXCYNCT7Tjoufv4bQQrEFSyZnOG0jTi-SqNKCd-xQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Return-path: <linux-bcache-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:41392 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726878AbgE1I24 (ORCPT <rfc822;linux-bcache@vger.kernel.org>);
        Thu, 28 May 2020 04:28:56 -0400
In-Reply-To: <CAFSR4cuk8oXCYNCT7Tjoufv4bQQrEFSyZnOG0jTi-SqNKCd-xQ@mail.gmail.com>
Content-Language: en-US
Sender: linux-bcache-owner@vger.kernel.org
List-Id: linux-bcache@vger.kernel.org
To: Dongyang Zhan <zdyzztq@gmail.com>
Cc: kent.overstreet@gmail.com, linux-bcache@vger.kernel.org

On 2020/5/28 10:13, Dongyang Zhan wrote:
> Hi,
> 
> My name is Dongyang Zhan, I am a security researcher.
> Currently, I found a potential memory leak bug in register_bcache() of
> drivers/md/bcache/super.c.
> The allocated memory regions dc and ca will not be released when
> register_cache() or register_bdev() fails.
> I hope you can help me to confirm this bug.
> 

By a quick glance, I feel dc is OK, but ca is a bit suspicious. Normally
ca is freed when kobject_put(&ca->kobj) makes the refcount reach 0. But
if cache_alloc() fails in register_cache(), it seems ca is forgotten to
release.

Do you have any suggestion to fix ?

Thanks for the information.

Coly Li



> The source code and comments are as follows.
> https://elixir.bootlin.com/linux/v5.6/source/drivers/md/bcache/super.c#L2253
> 
> static ssize_t register_bcache(struct kobject *k, struct kobj_attribute *attr,
>       const char *buffer, size_t size)
> {
> ...
> struct cached_dev *dc = kzalloc(sizeof(*dc), GFP_KERNEL);
> if (!dc)
>     goto out_put_sb_page;
> 
> mutex_lock(&bch_register_lock);
> ret = register_bdev(sb, sb_disk, bdev, dc);
> mutex_unlock(&bch_register_lock);
> /* blkdev_put() will be called in cached_dev_free() */
> if (ret < 0)
>     goto out_free_sb; // If ret <0, dc will not be released.
> } else {
> struct cache *ca = kzalloc(sizeof(*ca), GFP_KERNEL);
> 
> if (!ca)
>     goto out_put_sb_page;
> 
> /* blkdev_put() will be called in bch_cache_release() */
> if (register_cache(sb, sb_disk, bdev, ca) != 0)
>     goto out_free_sb; // If it fails , ca will not be released.
> 
> out_put_sb_page:
> put_page(virt_to_page(sb_disk));
> out_blkdev_put:
> blkdev_put(bdev, FMODE_READ | FMODE_WRITE | FMODE_EXCL);
> out_free_sb:
> kfree(sb);
> out_free_path:
> kfree(path);
> path = NULL;
> out_module_put:
> module_put(THIS_MODULE);
> out:
> pr_info("error %s: %s", path?path:"", err);
> return ret;
> }
> 
