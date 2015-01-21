From: "Stephen R. van den Berg" <srb@cuci.nl>
Subject: 3.18.3 + latest bcache-dev
Date: Wed, 21 Jan 2015 02:24:24 +0100
Message-ID: <20150121012424.GB5533@cuci.nl>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-bcache-owner@vger.kernel.org>
Received: from aristoteles.cuci.nl ([212.125.128.18]:49414 "EHLO
	aristoteles.cuci.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752451AbbAUBYZ (ORCPT
	<rfc822;linux-bcache@vger.kernel.org>);
	Tue, 20 Jan 2015 20:24:25 -0500
Content-Disposition: inline
Sender: linux-bcache-owner@vger.kernel.org
List-Id: linux-bcache@vger.kernel.org
To: linux-bcache@vger.kernel.org

I have:
16GB RAM
16GB SSD swap
5 x 6TB HDD bcache backing storage
2 x 490GB SSD bcache cache (Crucial M550, 4KB block, 2M bucket size)
writeback and trim enabled on bcache.
I used the latestbcache tools from git.

On the backing storage, I created a BTRFS using nossd and notrim.

Now, whenever I boot, I end up with exactly 4 bcache_writebac
processes pegged at  99 or 100% CPU.  This is on an octocore cpu.
top shows it as 50% system time.  The four processes are marked as R,
but I cannot trace them.

Even after waiting for several minutes, the cpu load does not come down.
The mounted volume simply seems to work, though.

Any ideas?
-- 
Stephen.
