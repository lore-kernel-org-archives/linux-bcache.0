From: Daniel J Blueman <daniel@quora.org>
Subject: bcache writeback threads blocked
Date: Thu, 13 Mar 2014 18:35:41 +0800
Message-ID: <CAMVG2suZrnzGF+WS7sFx0xJMNTLRcBpcQMozKgxyU5_VaeP+OQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-bcache-owner@vger.kernel.org>
Received: from mail-ob0-f175.google.com ([209.85.214.175]:52694 "EHLO
	mail-ob0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753499AbaCMKfm (ORCPT
	<rfc822;linux-bcache@vger.kernel.org>);
	Thu, 13 Mar 2014 06:35:42 -0400
Received: by mail-ob0-f175.google.com with SMTP id uy5so805495obc.6
        for <linux-bcache@vger.kernel.org>; Thu, 13 Mar 2014 03:35:42 -0700 (PDT)
Sender: linux-bcache-owner@vger.kernel.org
List-Id: linux-bcache@vger.kernel.org
To: linux-bcache@vger.kernel.org
Cc: kent.overstreet@gmail.com

I'm seeing bcache writeback threads sleep uninterruptably for
significant periods on 3.13.6 [1], on a NFS fileserver with 1-2
clients, exporting a 2TB BTRFS filesystem with a write-through bcache
overlaid from a 50GB SSD partition. The workload is low-depth and
light (kernel builds, git activity).

Would any information help, or is this a known issue?

Many thanks; bcache is indeed a superb mechanism.

Daniel

-- [1]

INFO: task :bcache_writebac345 blocked for more than 120 seconds.
      Not tainted 3.13.6-031306-generic #201403070154
"echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
bcache_writebac D ffffffff818114c0     0   345      2 0x00000000
 ffff8804050bdea8 0000000000000002 ffff8804050bde58 ffff8804050bdfd8
 0000000000014440 0000000000014440 ffff8804095a0000 ffff880405445fc0
 0000000000000282 ffff880404d426c0 ffff8804038a0000 ffffffffa0099380
Call Trace:
 [<ffffffffa0099380>] ? write_dirty+0xc0/0xc0 [bcache]
 [<ffffffff81747679>] schedule+0x29/0x70
 [<ffffffff8108e424>] kthread+0xa4/0xe0
 [<ffffffff8108e380>] ? flush_kthread_worker+0xb0/0xb0
 [<ffffffff8175403c>] ret_from_fork+0x7c/0xb0
 [<ffffffff8108e380>] ? flush_kthread_worker+0xb0/0xb0
-- 
Daniel J Blueman
