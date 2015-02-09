From: Kai Krakow <hurikhan77@gmail.com>
Subject: Modifying readahead value
Date: Mon, 09 Feb 2015 20:27:56 +0100
Message-ID: <saenqb-jh8.ln1@hurikhan77.spdns.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7Bit
Return-path: <linux-bcache-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:60228 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933715AbbBIT2G (ORCPT <rfc822;linux-bcache@vger.kernel.org>);
	Mon, 9 Feb 2015 14:28:06 -0500
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <glbd-linux-bcache@m.gmane.org>)
	id 1YKu02-0000Vy-Q6
	for linux-bcache@vger.kernel.org; Mon, 09 Feb 2015 20:28:02 +0100
Received: from ip18864262.dynamic.kabel-deutschland.de ([24.134.66.98])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-bcache@vger.kernel.org>; Mon, 09 Feb 2015 20:28:02 +0100
Received: from hurikhan77 by ip18864262.dynamic.kabel-deutschland.de with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-bcache@vger.kernel.org>; Mon, 09 Feb 2015 20:28:02 +0100
Sender: linux-bcache-owner@vger.kernel.org
List-Id: linux-bcache@vger.kernel.org
To: linux-bcache@vger.kernel.org

Hello!

I wonder if it makes sense to modify the /sys/fs/bcache/*/bdev*/readahead 
value. By default, it is zero, meaning: no readahead.

What are use cases of this? What are sensible values for it? Does it depend 
on the underlying filesystem the cache is attached to? (in my case, btrfs)

I didn't find any useful information about it. Only something vague like 
"not needed if bcache is on SSD" by combining different texts on the same 
subject. The only one documented information about it is that higher values 
may increase cache miss rate (well, that makes sense).

-- 
Replies to list only preferred.
