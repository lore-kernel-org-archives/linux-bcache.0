From: "Steinar H. Gunderson" <sgunderson@bigfoot.com>
Subject: bcache refusing to come up again after a crash
Date: Fri, 6 Dec 2013 15:41:17 +0100
Message-ID: <20131206144117.GA24123@samfundet.no>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-bcache-owner@vger.kernel.org>
Received: from cassarossa.samfundet.no ([193.35.52.29]:39912 "EHLO
	cassarossa.samfundet.no" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751237Ab3LFOlS (ORCPT
	<rfc822;linux-bcache@vger.kernel.org>);
	Fri, 6 Dec 2013 09:41:18 -0500
Received: from sesse by cassarossa.samfundet.no with local (Exim 4.80)
	(envelope-from <sesse@samfundet.no>)
	id 1Vowaj-0006YS-Fr
	for linux-bcache@vger.kernel.org; Fri, 06 Dec 2013 15:41:17 +0100
Content-Disposition: inline
Sender: linux-bcache-owner@vger.kernel.org
List-Id: linux-bcache@vger.kernel.org
To: linux-bcache@vger.kernel.org

Hi,

Linux (3.12.0-rc5) hung, and on boot, I can't get the bcache up again:

(initramfs) echo 0 23440891904 cache /dev/cache/metadata /dev/cache/blocks /dev/md1 1024 1 writeback default 4 random_threshold 8 sequential_threshold 512 | dmsetup create cache -u CACHE-0a8bb56fc873c195bf7117af925c7f08
device-mapper: reload ioctl on cache failed: Input/output error
Command failed

The kernel complains with

[  639.189756] attempt to access beyond end of device
[  639.189761] dm-0: rw=0, want=18445688752888627208, limit=1048576
[  639.189764] device-mapper: transaction manager: couldn't open metadata space map
[  639.189767] device-mapper: cache metadata: tm_open_with_sm failed
[  639.283130] device-mapper: table: 254:2: cache: Error creating metadata object
[  639.283134] device-mapper: ioctl: error adding target to table

Is there anything I can do short of nuking the metadata partition
and taking the loss of whatever wasn't written back?

/* Steinar */
-- 
Homepage: http://www.sesse.net/
