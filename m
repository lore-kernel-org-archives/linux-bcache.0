From: Emmanuel Florac <eflorac@intellique.com>
Subject: bcache and load average
Date: Fri, 15 May 2015 18:50:32 +0200
Message-ID: <20150515185032.6b129595@harpe.intellique.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-bcache-owner@vger.kernel.org>
Received: from smtpfb1-g21.free.fr ([212.27.42.9]:46744 "EHLO
	smtpfb1-g21.free.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753443AbbEOQud (ORCPT
	<rfc822;linux-bcache@vger.kernel.org>);
	Fri, 15 May 2015 12:50:33 -0400
Received: from smtp5-g21.free.fr (smtp5-g21.free.fr [212.27.42.5])
	by smtpfb1-g21.free.fr (Postfix) with ESMTP id 8F6D17943CB
	for <linux-bcache@vger.kernel.org>; Fri, 15 May 2015 18:50:29 +0200 (CEST)
Received: from harpe.intellique.com (unknown [82.225.196.72])
	by smtp5-g21.free.fr (Postfix) with ESMTP id F2047D480CD
	for <linux-bcache@vger.kernel.org>; Fri, 15 May 2015 18:46:35 +0200 (CEST)
Sender: linux-bcache-owner@vger.kernel.org
List-Id: linux-bcache@vger.kernel.org
To: linux-bcache@vger.kernel.org


Hi everyone,

Going through various forum messages and bug reports (for
Debian: https://lists.debian.org/debian-kernel/2015/03/msg00060.html for
Arch: https://bugs.archlinux.org/task/38843 for some other distro:
https://groups.google.com/forum/#!msg/esos-users/NXp8tG7sVE8/QXZyPdZ2saIJ
) it looks like the bcache_writeback kernel thread, being in
uninterruptible sleep, keeps the load average at 1.0 (or maybe more)
always. Could you please confirm this ?


 - this behaviour should be described in the bcache documentation
   because it feels to me (and many other) like a true gotcha. It's
   apparently completely undocumented. A "CAVEATS" section at the
   bottom of bcache.txt in the kernel Documentation explaining this
   would be nice, what do you think?

 - Is there any way around this? Some people seem to grow uneasy (maybe
   irrationnally) having a constant load on an otherwise unused system
   (I know that a sleeping thread actually does nothing, but many 
   system administrators can't wrap their head around this idea). 

I've tried some advice I've found on the web, like switching to
writethrough and "echo 0 > /sys/block/bcache0/bcache/writeback_running"
but to absolutely no effect.

Any advice and idea is welcome :)

-- 
------------------------------------------------------------------------
Emmanuel Florac     |   Direction technique
                    |   Intellique
                    |	<eflorac@intellique.com>
                    |   +33 1 78 94 84 02
------------------------------------------------------------------------
