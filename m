From: David Mohr <david@mcbf.net>
Subject: udev 220 rules broken for bcache
Date: Mon, 01 Jun 2015 09:20:42 -0600
Message-ID: <52ebcffefc58302c14a9c4eff437b421@de.mcbf.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-bcache-owner@vger.kernel.org>
Received: from seeker.mcbf.net ([109.239.49.157]:50508 "EHLO seeker.mcbf.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751340AbbFAPUp (ORCPT <rfc822;linux-bcache@vger.kernel.org>);
	Mon, 1 Jun 2015 11:20:45 -0400
Received: from localhost ([127.0.0.1] helo=de.mcbf.net)
	by seeker.mcbf.net with esmtp (Exim 4.80)
	(envelope-from <david@mcbf.net>)
	id 1YzRW6-00083M-Hj
	for linux-bcache@vger.kernel.org; Mon, 01 Jun 2015 17:20:42 +0200
Sender: linux-bcache-owner@vger.kernel.org
List-Id: linux-bcache@vger.kernel.org
To: Linux Bcache <linux-bcache@vger.kernel.org>

Hi,

just a heads up to other distros that the udev rules broke bcache 
/dev/disk/by-uuid symlinks (and hence booting if the fstab uses UUIDs) 
in v220. The fix is already applied, but afaik not released yet.

The small patch to fix it is at 
https://bugs.debian.org/cgi-bin/bugreport.cgi?bug=787367

~David
