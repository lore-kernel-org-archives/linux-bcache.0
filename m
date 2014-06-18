From: Erik =?utf-8?b?SGplbG3DpXM=?= <erik.hjelmas@gmail.com>
Subject: cannot attach backing device, wipefs does not fix it
Date: Wed, 18 Jun 2014 15:38:55 +0000 (UTC)
Message-ID: <loom.20140618T173307-560@post.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-bcache-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:59782 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751352AbaFRPpF (ORCPT <rfc822;linux-bcache@vger.kernel.org>);
	Wed, 18 Jun 2014 11:45:05 -0400
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <glbd-linux-bcache@m.gmane.org>)
	id 1WxI2q-0000P4-0F
	for linux-bcache@vger.kernel.org; Wed, 18 Jun 2014 17:45:04 +0200
Received: from ws-216.ansatt.hig.no ([128.39.243.216])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-bcache@vger.kernel.org>; Wed, 18 Jun 2014 17:45:04 +0200
Received: from erik.hjelmas by ws-216.ansatt.hig.no with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-bcache@vger.kernel.org>; Wed, 18 Jun 2014 17:45:04 +0200
Sender: linux-bcache-owner@vger.kernel.org
List-Id: linux-bcache@vger.kernel.org
To: linux-bcache@vger.kernel.org

Hi, ubuntu 14.04, and a 5TB RAID (sdc) partitioned into two 2.5TB partitions
(sdc1 and sdc2) with parted to be used as backing devices, 

/dev/sdc2 attaches fine

problem with sdc1:

# make-bcache -B /dev/sdc1
Device /dev/sdc1 already has a non-bcache superblock, remove it using wipefs
and wipefs -a

# wipefs /dev/sdc1
wipefs: WARNING: /dev/sdc1: appears to contain 'dos' partition table

# wipefs -a /dev/sdc1
wipefs: WARNING: /dev/sdc1: appears to contain 'dos' partition table

# make-bcache -B /dev/sdc1
Device /dev/sdc1 already has a non-bcache superblock, remove it using wipefs
and wipefs -a

In other words, Im unable to attach sdc1

any help greatly appreciated!

/Erik
