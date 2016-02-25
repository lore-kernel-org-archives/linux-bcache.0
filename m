From: Marc MERLIN <marc@merlins.org>
Subject: bcache: register_cache() error opening sdh2: cannot allocate memory => BUG NULL pointer
Date: Wed, 24 Feb 2016 22:18:21 -0800
Message-ID: <20160225061821.GB15421@merlins.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-bcache-owner@vger.kernel.org>
Received: from magic.merlins.org ([209.81.13.136]:38144 "EHLO
	mail1.merlins.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752104AbcBYGSZ (ORCPT
	<rfc822;linux-bcache@vger.kernel.org>);
	Thu, 25 Feb 2016 01:18:25 -0500
Received: from merlin by mail1.merlins.org with local (Exim 4.80 #2)
	id 1aYpFl-0002bQ-VQ by authid <merlin>
	for <linux-bcache@vger.kernel.org>; Wed, 24 Feb 2016 22:18:22 -0800
Content-Disposition: inline
Sender: linux-bcache-owner@vger.kernel.org
List-Id: linux-bcache@vger.kernel.org
To: linux-bcache@vger.kernel.org

I understand I have an underlying memory problem, but could bcache handle
memory issues and not crash on null pointer?

gargamel:/sys/block/md5/bcache# echo /dev/sdh2 > /sys/fs/bcache/register
gave:
bcache: register_cache() error opening sdh2: cannot allocate memory
BUG: unable to handle kernel NULL pointer dereference at 00000000000009b8
IP: [<ffffffffc05a7e8d>] cache_set_flush+0x102/0x15c [bcache]
PGD 120dff067 PUD 1119a3067 PMD 0 
Oops: 0000 [#1] SMP 
Modules linked in: veth ip6table_filter ip6_tables
(...)
CPU: 4 PID: 3371 Comm: kworker/4:3 Not tainted 4.4.2-amd64-i915-volpreempt-20160213bc1 #3
Hardware name: System manufacturer System Product Name/P8H67-M PRO, BIOS 3904 04/27/2013
Workqueue: events cache_set_flush [bcache]
task: ffff88020d5dc280 ti: ffff88020b6f8000 task.ti: ffff88020b6f8000
RIP: 0010:[<ffffffffc05a7e8d>]  [<ffffffffc05a7e8d>] cache_set_flush+0x102/0x15c [bcache]

Thanks,
Marc
-- 
"A mouse is a device used to point at the xterm you want to type in" - A.S.R.
Microsoft is to operating systems ....
                                      .... what McDonalds is to gourmet cooking
Home page: http://marc.merlins.org/  
