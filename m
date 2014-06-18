From: Erik =?utf-8?b?SGplbG3DpXM=?= <erik.hjelmas@gmail.com>
Subject: Re: cannot attach backing device, wipefs does not fix it
Date: Wed, 18 Jun 2014 17:11:22 +0000 (UTC)
Message-ID: <loom.20140618T185645-94@post.gmane.org>
References: <loom.20140618T173307-560@post.gmane.org> <1297031660.20140618230148@pvgoran.name>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-bcache-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:44714 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751684AbaFRRLm (ORCPT <rfc822;linux-bcache@vger.kernel.org>);
	Wed, 18 Jun 2014 13:11:42 -0400
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <glbd-linux-bcache@m.gmane.org>)
	id 1WxJOe-0000xj-Jt
	for linux-bcache@vger.kernel.org; Wed, 18 Jun 2014 19:11:40 +0200
Received: from ws-216.ansatt.hig.no ([128.39.243.216])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-bcache@vger.kernel.org>; Wed, 18 Jun 2014 19:11:40 +0200
Received: from erik.hjelmas by ws-216.ansatt.hig.no with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-bcache@vger.kernel.org>; Wed, 18 Jun 2014 19:11:40 +0200
Sender: linux-bcache-owner@vger.kernel.org
List-Id: linux-bcache@vger.kernel.org
To: linux-bcache@vger.kernel.org

> > Hi, ubuntu 14.04, and a 5TB RAID (sdc) partitioned into two 2.5TB partitions
> > (sdc1 and sdc2) with parted to be used as backing devices, 
> 
> > /dev/sdc2 attaches fine
> 
> > problem with sdc1:
> 
> > # make-bcache -B /dev/sdc1
> > Device /dev/sdc1 already has a non-bcache superblock, remove it using wipefs
> > and wipefs -a
> 
> > # wipefs /dev/sdc1
> > wipefs: WARNING: /dev/sdc1: appears to contain 'dos' partition table
> 
> > # wipefs -a /dev/sdc1
> > wipefs: WARNING: /dev/sdc1: appears to contain 'dos' partition table
> 
> Did you try wipefs -a -f /dev/sdc1 ?

my wipefs does not have a -f option
 
> If that fails, just erase the first few MB of the device with zeroes:
> 
> dd if=/dev/zero of=/dev/sdc1 bs=1M count=10

I had tried this, but I see now that I copied from /dev/null instead of
/dev/zero and no data got copied :)

so, yes, your suggestion dd if=/dev/zero of=/dev/sdc1 bs=1M count=10 fixed it

thank you Pavel!

/Erik
