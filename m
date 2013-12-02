From: Thierry De Leeuw <deleeuw.thierry@gmail.com>
Subject: /dev/bcache* missing after reboot
Date: Mon, 2 Dec 2013 23:36:47 +0100
Message-ID: <9FA7630E-7DC4-4F45-B5E1-FFFB511EFA8B@gmail.com>
Mime-Version: 1.0 (1.0)
Content-Type: text/plain;
	charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-bcache-owner@vger.kernel.org>
Received: from mail-wi0-f181.google.com ([209.85.212.181]:42233 "EHLO
	mail-wi0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752190Ab3LBWgw (ORCPT
	<rfc822;linux-bcache@vger.kernel.org>);
	Mon, 2 Dec 2013 17:36:52 -0500
Received: by mail-wi0-f181.google.com with SMTP id hq4so5638473wib.14
        for <linux-bcache@vger.kernel.org>; Mon, 02 Dec 2013 14:36:51 -0800 (PST)
Received: from [192.168.1.190] (77.109.97.14.adsl.dyn.edpnet.net. [77.109.97.14])
        by mx.google.com with ESMTPSA id s20sm127026031wib.1.2013.12.02.14.36.50
        for <linux-bcache@vger.kernel.org>
        (version=TLSv1 cipher=ECDHE-RSA-RC4-SHA bits=128/128);
        Mon, 02 Dec 2013 14:36:50 -0800 (PST)
Sender: linux-bcache-owner@vger.kernel.org
List-Id: linux-bcache@vger.kernel.org
To: linux-bcache@vger.kernel.org

Hi,

Running Linux 3.12.1. I have disk /dev/sda2 with LVM that has, amongst
other, lvHome as a bcache device, and the cache resides on /dev/sdb1

My PC hung and I had to do a forced shutdown.

Now the /dev/bcache0 (and so on) do not appear anymore.

The LVM is available (I can see /dev/mapper/vgData_lvHome), when I do a
bcache-super-show /dev/mapper/vgData_lvHome I get
sb.magic ok
ssb.first_sector 8 [match]
sb.csum xxxxx [match]
ssb.version 1 [backing device]

dev.label (empty)
dev.uuid xxxxx
dev.sector_per_block 8
dev.sector_per_bucket 1024
dev.data.first_sector 16
dev.data.cache_mode 1 [writeback]
dev.data.cache_state 2 [dirty]

cset.uuid yyyyyyy (note that it matches the entry in /sys/fs/bcache)

similar stuff for the other logical volumes so looks like the header is ok.

dmesg reports only the following entries about bcache
bcache: bch_journal_replay() journal replay done, 46 keys in 17 entries seq
973143
bcache: register_cache() registered cache sdb1

note that the same replay message is reported at each reboot.

/dev/block has no bcache* entries

looking at /sys/fs/bcache/yyyyyy
what seems suspicious to me is that the cache_available_percent is at 100
and dirty data is at 0 is it because it is not "connnected" to the backing
devices?

What can I do now to recover from this situation/help providing you
information to determine the problem and hav my disk back?

Thanks!

Thierry
