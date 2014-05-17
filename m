From: Pavel Goran <via-bcache@pvgoran.name>
Subject: Re: [PATCH] bcache: fix uninterruptible sleep in writeback thread
Date: Sat, 17 May 2014 05:47:21 +0000 (UTC)
Message-ID: <loom.20140517T073846-450@post.gmane.org>
References: <1398981150-27765-1-git-send-email-sp@daterainc.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-bcache-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:44174 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756293AbaEQFuG (ORCPT <rfc822;linux-bcache@vger.kernel.org>);
	Sat, 17 May 2014 01:50:06 -0400
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <glbd-linux-bcache@m.gmane.org>)
	id 1WlXVU-0000jN-6f
	for linux-bcache@vger.kernel.org; Sat, 17 May 2014 07:50:04 +0200
Received: from l37-193-243-154.novotelecom.ru ([37.193.243.154])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-bcache@vger.kernel.org>; Sat, 17 May 2014 07:50:04 +0200
Received: from via-bcache by l37-193-243-154.novotelecom.ru with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-bcache@vger.kernel.org>; Sat, 17 May 2014 07:50:04 +0200
Sender: linux-bcache-owner@vger.kernel.org
List-Id: linux-bcache@vger.kernel.org
To: linux-bcache@vger.kernel.org

Slava Pestov <sp <at> datera.io> writes:

> There were two issues here:
> 
> - writeback thread did not start until the device first became dirty
> - writeback thread used uninterruptible sleep once running
> 
> Without this patch I see kernel warnings printed and a load average of
> 1.52 after booting my test VM. With this patch the warnings are gone and
> the load average is near 0.00 as expected.

Uninterruptible sleep is indeed fixed (as well as the annoying "blocked for
more than 120 seconds" message), but with this patch, I have the following
problem. If I run a bcache device with no cache attached, the kernel hangs
when I try to reboot. It prints a long stack trace that takes all screen
space and I can't see what is above it.

If a cache is attached to the bcache device, rebooting works fine. Without
the patch, rebooting works both with and without attached cache.
