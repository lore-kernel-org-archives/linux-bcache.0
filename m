From: Sam Fulcomer <enotty@brown.edu>
Subject: Re: kernel: INFO: task =?utf-8?b?YmNhY2hlX3dyaXRlYmFjOk5OTg==?= blocked...
Date: Thu, 3 Apr 2014 16:55:45 +0000 (UTC)
Message-ID: <loom.20140403T184559-709@post.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-bcache-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:60163 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752787AbaDCRAI (ORCPT <rfc822;linux-bcache@vger.kernel.org>);
	Thu, 3 Apr 2014 13:00:08 -0400
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <glbd-linux-bcache@m.gmane.org>)
	id 1WVkzl-0006Zo-D0
	for linux-bcache@vger.kernel.org; Thu, 03 Apr 2014 19:00:05 +0200
Received: from 128.148.4.51 ([128.148.4.51])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-bcache@vger.kernel.org>; Thu, 03 Apr 2014 19:00:05 +0200
Received: from enotty by 128.148.4.51 with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-bcache@vger.kernel.org>; Thu, 03 Apr 2014 19:00:05 +0200
Sender: linux-bcache-owner@vger.kernel.org
List-Id: linux-bcache@vger.kernel.org
To: linux-bcache@vger.kernel.org


(in kernel.org 3.13.7)

This appears to be due to bcache_writeback trying to do something it 
shouldn't in writethrough mode. (The default is writeback_running=1, 
even when cache mode is "writethrough").

echo 0 > /sys/block/bcache0/bcache/writeback_running

...appears to fix (workaround) it.
