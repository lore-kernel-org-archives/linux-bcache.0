From: Damien Robert <damien.olivier.robert@gmail.com>
Subject: clearing inconsistent bcache state
Date: Tue, 2 Dec 2014 23:18:48 +0100
Message-ID: <20141202221848.GB14759@mithrim>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-bcache-owner@vger.kernel.org>
Received: from mail-wg0-f42.google.com ([74.125.82.42]:38766 "EHLO
	mail-wg0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933286AbaLBWSx (ORCPT
	<rfc822;linux-bcache@vger.kernel.org>);
	Tue, 2 Dec 2014 17:18:53 -0500
Received: by mail-wg0-f42.google.com with SMTP id z12so18299773wgg.1
        for <linux-bcache@vger.kernel.org>; Tue, 02 Dec 2014 14:18:52 -0800 (PST)
Received: from mithrim (LAubervilliers-656-1-193-56.w193-252.abo.wanadoo.fr. [193.252.61.56])
        by mx.google.com with ESMTPSA id m6sm24993947wix.10.2014.12.02.14.18.51
        for <linux-bcache@vger.kernel.org>
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 02 Dec 2014 14:18:51 -0800 (PST)
Content-Disposition: inline
Sender: linux-bcache-owner@vger.kernel.org
List-Id: linux-bcache@vger.kernel.org
To: linux-bcache@vger.kernel.org

I had enabled bcache on writeback, but once when booting my laptop I got
the following error message
error on ...: corrupted btree at bucket ... disabling caching

Since I was on a plane I just forced bcache to continue by doing
  echo 1 > bcache/running

Amazingly the backing device recovered without problem
(the power of btrfs, I even checked with btrfs scrub); probably there was
not a lot of dirty data.

So I'd like to enable bcache caching again (even if there was an error
previously, all my data is backuped to several other computers so I can
afford to lose it).

I recreated my caching device again with make-bcache -B (after cleaning up
the signature so it would accept to run), and attached the device to the
backing device again.

The problem is that it detect that the backing device was uncleanly cut
away from its caching device, and 'state' is inconsistent:

Mithrim /sys/block/bcache0/bcache $ sudo bcache-super-show /dev/sda3
sb.magic                ok
sb.first_sector         8 [match]
sb.csum                 9694497C61198C4 [match]
sb.version              1 [backing device]

dev.label               (empty)
dev.uuid                56e8d6b3-9a68-4df3-8f4a-dfbf535a9575
dev.sectors_per_block   1
dev.sectors_per_bucket  1024
dev.data.first_sector   16
dev.data.cache_mode     1 [writeback]
dev.data.cache_state    3 [inconsistent]

cset.uuid               b67e71bc-8b3d-43c5-9048-c3b182cc77ec

Of course this disable all effective caching, as seen in the stats or in
the caching device bcache/written which are all 0.

So I have two questions:
1) was there a better way to recover from the corrupted btree than forcing
   the backing device to run without the cache?
2) Is there a way to tell bcache to put the backing device back in a consistent
   state so that caching get enabled again?
   [I would like not to format it again via a make-bcache -B, my data is
   backuped but reinstalling the laptop and transfering the data back is
   annoying]

Thanks!

-- 
Damien Robert
http://www.normalesup.org/~robert/pro
