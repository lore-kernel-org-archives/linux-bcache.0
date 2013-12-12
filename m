From: Jason Warr <jason@warr.net>
Subject: Found an interesting device
Date: Thu, 12 Dec 2013 09:22:49 -0600
Message-ID: <52A9D4C9.7020801@warr.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-bcache-owner@vger.kernel.org>
Received: from smtprelay0202.hostedemail.com ([216.40.44.202]:36459 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751358Ab3LLPWv (ORCPT
	<rfc822;linux-bcache@vger.kernel.org>);
	Thu, 12 Dec 2013 10:22:51 -0500
Received: from filter.hostedemail.com (ff-bigip1 [10.5.19.254])
	by smtprelay02.hostedemail.com (Postfix) with ESMTP id 6814C12BCF3
	for <linux-bcache@vger.kernel.org>; Thu, 12 Dec 2013 15:22:50 +0000 (UTC)
Received: from atlas.themelon.org (cpe-173-172-11-43.tx.res.rr.com [173.172.11.43])
	(Authenticated sender: jason@warr.net)
	by omf01.hostedemail.com (Postfix) with ESMTPA
	for <linux-bcache@vger.kernel.org>; Thu, 12 Dec 2013 15:22:49 +0000 (UTC)
Sender: linux-bcache-owner@vger.kernel.org
List-Id: linux-bcache@vger.kernel.org
To: "linux-bcache@vger.kernel.org" <linux-bcache@vger.kernel.org>

Some of you may be interested in this PCIe card:

http://www.addonics.com/products/ad4mspx2.php

I just received a couple of them and have done basic functionality
testing.  No bcache yet but that is what they are intended for.  The
controller is a Marvell 88SE9230 connected via an x2 link.

03:00.0 SATA controller: Marvell Technology Group Ltd. 88SE9230 PCIe
SATA 6Gb/s Controller (rev 10)
                LnkCap: Port #0, Speed 5GT/s, Width x2, ASPM L0s L1,
Latency L0 <512ns, L1 <64us
                        ClockPM- Surprise- LLActRep- BwNot-
                LnkCtl: ASPM Disabled; RCB 64 bytes Disabled- Retrain-
CommClk+
                        ExtSynch- ClockPM- AutWidDis- BWInt- AutBWInt-
                LnkSta: Speed 5GT/s, Width x2, TrErr- Train- SlotClk+
DLActive- BWMgmt- ABWMgmt--
        Kernel driver in use: ahci
        Kernel modules: ahci

[8:0:0:0]    disk    ATA      MKNSSDAT120GB-DX 521A  /dev/sde
[9:0:0:0]    disk    ATA      MKNSSDAT120GB-DX 507A  /dev/sdf

So you are theoretically limited to less than 1GB/s across PCIe but for
caching purposes I'm more interested in IOPS than raw bandwidth
anyways.  Using "dd if=/dev/zero of=/dev/sdX bs=1M oflag=direct" I am
seeing ~380MB/s per device on 2 Mushkin MKNSSDAT120GB-DX concurrently. 
Not the greatest test but it does show that they work OK.  I am getting
Fedora 20 installed the way I want it and then the real testing will begin.
