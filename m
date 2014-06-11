From: Nik Martin <nik.martin@gmail.com>
Subject: INFO: task bcache_writebac:1582 blocked for more than 120 seconds
Date: Wed, 11 Jun 2014 09:48:20 -0500
Message-ID: <CADUHXCchuOVOY7vKzo8OnFmJhQWz6=RyJvhrwJm3y_N300mC8w@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-bcache-owner@vger.kernel.org>
Received: from mail-wi0-f175.google.com ([209.85.212.175]:43898 "EHLO
	mail-wi0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751965AbaFKOso (ORCPT
	<rfc822;linux-bcache@vger.kernel.org>);
	Wed, 11 Jun 2014 10:48:44 -0400
Received: by mail-wi0-f175.google.com with SMTP id f8so8146727wiw.14
        for <linux-bcache@vger.kernel.org>; Wed, 11 Jun 2014 07:48:41 -0700 (PDT)
Sender: linux-bcache-owner@vger.kernel.org
List-Id: linux-bcache@vger.kernel.org
To: linux-bcache@vger.kernel.org

I have been running bcache in writeback mode for a while, and had an
unclean shutdown due to a power outage.  Machine rebooted, did an
fsck, everything seemed ok, I had a few corrupt files that were open
when the shutdown happened, but no major deal.  Then, I started
getting hung tasks:

INFO: task bcache_writebac:1582 blocked for more than 120 seconds.
[ 1322.829907]       Tainted: P           O 3.14.6-201406110805nik-deb-dirty #1
[ 1322.829910] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs"
disables this message.
[ 1322.829913] bcache_writebac D ffff8800b84db608     0  1582      2 0x00000000
[ 1322.829920]  ffff8800b84db1f0 0000000000000046 0000000000012e40
ffff880233d53230
[ 1322.829927]  0000000000012e40 ffff88023067bfd8 0000000000012e40
ffff8800b84db1f0
[ 1322.829933]  0000000000000000 ffff880230611bc0 ffff880233bc0000
ffffffff813568a0
[ 1322.829939] Call Trace:
[ 1322.829950]  [<ffffffff813568a0>] ? write_dirty+0xc0/0xc0
[ 1322.829958]  [<ffffffff8106b475>] ? kthread+0x95/0xe0
[ 1322.829963]  [<ffffffff81070000>] ? put_cred_rcu+0xa0/0xc0
[ 1322.829969]  [<ffffffff8106b3e0>] ? flush_kthread_worker+0x80/0x80
[ 1322.829976]  [<ffffffff8149147c>] ? ret_from_fork+0x7c/0xb0
[ 1322.829981]  [<ffffffff8106b3e0>] ? flush_kthread_worker+0x80/0x80

As you may notice, I'm on mainline kernel 3.14.6, which I built myself
thinking the issue could just be a bug in the version I'm running.  I
rebooted after building and installing, and the hung tasks came back 2
minutes after boot.

How can I disable bcache for now?  The instructions to install it a
pretty clear, but disabling it isn't.
