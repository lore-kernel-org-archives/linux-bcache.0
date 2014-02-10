From: Gabriel de Perthuis <g2p.code@gmail.com>
Subject: Re: bcache and memory at boot. Bug?
Date: Mon, 10 Feb 2014 11:40:29 +0000 (UTC)
Message-ID: <ldadrd$4a2$1@ger.gmane.org>
References: <CAPBO7TYBMn=oU8K-6EGzw2LofwHPHm742GbzgGYmdbHt5g7sNQ@mail.gmail.
	com> <CAPBO7TbEAf7Bhb-kTFQ00CmBih5CdsXRHeOSf4STxQ+ndy66dQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Return-path: <linux-bcache-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:43929 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752195AbaBJLkz (ORCPT <rfc822;linux-bcache@vger.kernel.org>);
	Mon, 10 Feb 2014 06:40:55 -0500
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <glbd-linux-bcache@m.gmane.org>)
	id 1WCpEL-0003LW-CD
	for linux-bcache@vger.kernel.org; Mon, 10 Feb 2014 12:40:53 +0100
Received: from pro75-5-88-162-203-35.fbx.proxad.net ([88.162.203.35])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-bcache@vger.kernel.org>; Mon, 10 Feb 2014 12:40:53 +0100
Received: from g2p.code by pro75-5-88-162-203-35.fbx.proxad.net with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-bcache@vger.kernel.org>; Mon, 10 Feb 2014 12:40:53 +0100
Sender: linux-bcache-owner@vger.kernel.org
List-Id: linux-bcache@vger.kernel.org
To: linux-bcache@vger.kernel.org

> Hello,
> 
> I am using bcache in my laptop (RAM 32 GiB). I have been using it
> perfectly for a month. ext4 + bcache.
> 
> Yesterday, system did not want do to a normal startup. Messages where
> from udev out of memory (and udevadm killed?) and system was not
> mounting / (/dev/bcache0).
> 
> [    6.823222] bcache-register invoked oom-killer: gfp_mask=0x82d2,
> order=0, oom_score_adj=0

Build your kernel with CONFIG_COMPACTION.  I've added it to the FAQ:
http://bcache.evilpiepirate.org/~kent/bcache/FAQ/
