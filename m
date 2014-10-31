From: Eddie Chapman <eddie@ehuk.net>
Subject: Reasonably safe to backport 3.15 & 3.17 patches to 3.14?
Date: Fri, 31 Oct 2014 11:24:40 +0000
Message-ID: <54537178.4060402@ehuk.net>
Reply-To: eddie@ehuk.net
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-bcache-owner@vger.kernel.org>
Received: from mail.steelbluetech.co.uk ([109.169.51.66]:23886 "EHLO
	mail.steelbluetech.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756017AbaJaLc3 (ORCPT
	<rfc822;linux-bcache@vger.kernel.org>);
	Fri, 31 Oct 2014 07:32:29 -0400
Received: from [10.0.5.25] (tv.ehuk.net [10.0.5.25])
	by mail.steelbluetech.co.uk (8.13.8/8.13.8) with ESMTP id s9VBOeE5016880
	for <linux-bcache@vger.kernel.org>; Fri, 31 Oct 2014 11:24:40 GMT
Sender: linux-bcache-owner@vger.kernel.org
List-Id: linux-bcache@vger.kernel.org
To: linux-bcache@vger.kernel.org

Hi folks,

I noticed I'm able to apply every one of the 46 bcache patches, from the 
3.15 & 3.17 git pulls Kent submitted to Jens, to my vanilla 3.14.23 
kernel, without any fuziness. See bottom of this mail for output from 
applying the 46 in order.

I see all of them only touch files under drivers/md/bcache, and 
occasionally include/trace/events/bcache.h. So all bcache files.

The result also builds fine without any warnings or errors.

Obviously there's no guarantees in life, but do others here think what 
I'm doing here looks reasonably safe, or is there a big risk that bcache 
will eat my data?


thanks,
Eddie

[root@server linux-3.14]# patch -Np1 -i ../bcpatches/1.patch
patching file drivers/md/bcache/bset.c
[root@server linux-3.14]# patch -Np1 -i ../bcpatches/2.patch
patching file drivers/md/bcache/request.c
[root@server linux-3.14]# patch -Np1 -i ../bcpatches/3.patch
patching file drivers/md/bcache/journal.c
patching file drivers/md/bcache/journal.h
patching file drivers/md/bcache/super.c
[root@server linux-3.14]# patch -Np1 -i ../bcpatches/4.patch
patching file drivers/md/bcache/super.c
[root@server linux-3.14]# patch -Np1 -i ../bcpatches/5.patch
patching file drivers/md/bcache/journal.c
[root@server linux-3.14]# patch -Np1 -i ../bcpatches/6.patch
patching file drivers/md/bcache/journal.c
[root@server linux-3.14]# patch -Np1 -i ../bcpatches/7.patch
patching file drivers/md/bcache/btree.c
[root@server linux-3.14]# patch -Np1 -i ../bcpatches/8.patch
patching file drivers/md/bcache/btree.c
patching file drivers/md/bcache/btree.h
patching file drivers/md/bcache/journal.c
[root@server linux-3.14]# patch -Np1 -i ../bcpatches/9.patch
patching file drivers/md/bcache/super.c
[root@server linux-3.14]# patch -Np1 -i ../bcpatches/10.patch
patching file drivers/md/bcache/bcache.h
patching file drivers/md/bcache/movinggc.c
patching file drivers/md/bcache/request.c
patching file drivers/md/bcache/request.h
patching file drivers/md/bcache/super.c
[root@server linux-3.14]# patch -Np1 -i ../bcpatches/11.patch
patching file drivers/md/bcache/movinggc.c
[root@server linux-3.14]# patch -Np1 -i ../bcpatches/12.patch
patching file drivers/md/bcache/movinggc.c
[root@server linux-3.14]# patch -Np1 -i ../bcpatches/13.patch
patching file drivers/md/bcache/Kconfig
patching file drivers/md/bcache/btree.c
patching file drivers/md/bcache/request.c
patching file drivers/md/bcache/request.h
patching file drivers/md/bcache/stats.c
[root@server linux-3.14]# patch -Np1 -i ../bcpatches/14.patch
patching file drivers/md/bcache/alloc.c
patching file drivers/md/bcache/trace.c
patching file include/trace/events/bcache.h
[root@server linux-3.14]# patch -Np1 -i ../bcpatches/15.patch
patching file drivers/md/bcache/sysfs.c
[root@server linux-3.14]# patch -Np1 -i ../bcpatches/16.patch
patching file drivers/md/bcache/bset.h
patching file drivers/md/bcache/journal.c
[root@server linux-3.14]# patch -Np1 -i ../bcpatches/17.patch
patching file drivers/md/bcache/alloc.c
patching file drivers/md/bcache/bcache.h
patching file drivers/md/bcache/btree.c
patching file drivers/md/bcache/extents.c
[root@server linux-3.14]# patch -Np1 -i ../bcpatches/18.patch
patching file drivers/md/bcache/btree.c
[root@server linux-3.14]# patch -Np1 -i ../bcpatches/19.patch
patching file drivers/md/bcache/btree.c
patching file drivers/md/bcache/btree.h
patching file drivers/md/bcache/journal.c
patching file drivers/md/bcache/super.c
[root@server linux-3.14]# patch -Np1 -i ../bcpatches/20.patch
patching file drivers/md/bcache/bcache.h
patching file drivers/md/bcache/btree.c
patching file drivers/md/bcache/super.c
[root@server linux-3.14]# patch -Np1 -i ../bcpatches/21.patch
patching file drivers/md/bcache/alloc.c
patching file drivers/md/bcache/bcache.h
patching file drivers/md/bcache/btree.c
patching file drivers/md/bcache/btree.h
patching file drivers/md/bcache/super.c
patching file drivers/md/bcache/sysfs.c
[root@server linux-3.14]# patch -Np1 -i ../bcpatches/22.patch
patching file drivers/md/bcache/alloc.c
patching file drivers/md/bcache/bcache.h
patching file drivers/md/bcache/btree.c
patching file drivers/md/bcache/btree.h
patching file drivers/md/bcache/super.c
patching file include/trace/events/bcache.h
[root@server linux-3.14]# patch -Np1 -i ../bcpatches/23.patch
patching file drivers/md/bcache/bcache.h
patching file drivers/md/bcache/btree.c
patching file drivers/md/bcache/extents.c
patching file drivers/md/bcache/super.c
[root@server linux-3.14]# patch -Np1 -i ../bcpatches/24.patch
patching file drivers/md/bcache/extents.c
patching file drivers/md/bcache/sysfs.c
[root@server linux-3.14]# patch -Np1 -i ../bcpatches/25.patch
patching file drivers/md/bcache/super.c
[root@server linux-3.14]# patch -Np1 -i ../bcpatches/26.patch
patching file drivers/md/bcache/extents.c
patching file drivers/md/bcache/extents.h
patching file drivers/md/bcache/journal.c
[root@server linux-3.14]# patch -Np1 -i ../bcpatches/27.patch
patching file drivers/md/bcache/journal.c
[root@server linux-3.14]# patch -Np1 -i ../bcpatches/28.patch
patching file drivers/md/bcache/alloc.c
[root@server linux-3.14]# patch -Np1 -i ../bcpatches/29.patch
patching file drivers/md/bcache/super.c
[root@server linux-3.14]# patch -Np1 -i ../bcpatches/30.patch
patching file drivers/md/bcache/super.c
[root@server linux-3.14]# patch -Np1 -i ../bcpatches/31.patch
patching file drivers/md/bcache/btree.c
patching file drivers/md/bcache/btree.h
patching file drivers/md/bcache/super.c
[root@server linux-3.14]# patch -Np1 -i ../bcpatches/32.patch
patching file drivers/md/bcache/super.c
patching file drivers/md/bcache/writeback.c
patching file drivers/md/bcache/writeback.h
[root@server linux-3.14]# patch -Np1 -i ../bcpatches/33.patch
patching file drivers/md/bcache/btree.c
[root@server linux-3.14]# patch -Np1 -i ../bcpatches/34.patch
patching file drivers/md/bcache/bset.c
patching file drivers/md/bcache/btree.c
[root@server linux-3.14]# patch -Np1 -i ../bcpatches/35.patch
patching file drivers/md/bcache/bset.h
[root@server linux-3.14]# patch -Np1 -i ../bcpatches/36.patch
patching file drivers/md/bcache/request.c
patching file include/trace/events/bcache.h
[root@server linux-3.14]# patch -Np1 -i ../bcpatches/37.patch
patching file drivers/md/bcache/btree.c
patching file include/trace/events/bcache.h
[root@server linux-3.14]# patch -Np1 -i ../bcpatches/38.patch
patching file drivers/md/bcache/journal.c
[root@server linux-3.14]# patch -Np1 -i ../bcpatches/39.patch
patching file drivers/md/bcache/btree.c
[root@server linux-3.14]# patch -Np1 -i ../bcpatches/40.patch
patching file drivers/md/bcache/super.c
[root@server linux-3.14]# patch -Np1 -i ../bcpatches/41.patch
patching file drivers/md/bcache/bcache.h
patching file drivers/md/bcache/super.c
[root@server linux-3.14]# patch -Np1 -i ../bcpatches/42.patch
patching file drivers/md/bcache/super.c
[root@server linux-3.14]# patch -Np1 -i ../bcpatches/43.patch
patching file drivers/md/bcache/btree.c
patching file drivers/md/bcache/btree.h
patching file drivers/md/bcache/super.c
[root@server linux-3.14]# patch -Np1 -i ../bcpatches/44.patch
patching file drivers/md/bcache/util.h
[root@server linux-3.14]# patch -Np1 -i ../bcpatches/45.patch
patching file drivers/md/bcache/super.c
[root@server linux-3.14]# patch -Np1 -i ../bcpatches/46.patch
patching file drivers/md/bcache/super.c
