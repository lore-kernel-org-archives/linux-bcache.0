From: Pavel Goran <via-bcache@pvgoran.name>
Subject: Re: cannot attach backing device, wipefs does not fix it
Date: Wed, 18 Jun 2014 23:01:48 +0700
Message-ID: <1297031660.20140618230148@pvgoran.name>
References: <loom.20140618T173307-560@post.gmane.org>
Reply-To: Pavel Goran <via-bcache@pvgoran.name>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-bcache-owner@vger.kernel.org>
Received: from pvgoran2.xen.prgmr.com ([71.19.149.48]:34785 "EHLO
	v2.pvgoran.name" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751783AbaFRQCX (ORCPT
	<rfc822;linux-bcache@vger.kernel.org>);
	Wed, 18 Jun 2014 12:02:23 -0400
In-Reply-To: <loom.20140618T173307-560@post.gmane.org>
Sender: linux-bcache-owner@vger.kernel.org
List-Id: linux-bcache@vger.kernel.org
To: linux-bcache@vger.kernel.org

Hello Erik,

Wednesday, June 18, 2014, 10:38:55 PM, you wrote:

> Hi, ubuntu 14.04, and a 5TB RAID (sdc) partitioned into two 2.5TB partitions
> (sdc1 and sdc2) with parted to be used as backing devices, 

> /dev/sdc2 attaches fine

> problem with sdc1:

> # make-bcache -B /dev/sdc1
> Device /dev/sdc1 already has a non-bcache superblock, remove it using wipefs
> and wipefs -a

> # wipefs /dev/sdc1
> wipefs: WARNING: /dev/sdc1: appears to contain 'dos' partition table

> # wipefs -a /dev/sdc1
> wipefs: WARNING: /dev/sdc1: appears to contain 'dos' partition table

Did you try wipefs -a -f /dev/sdc1 ?

If that fails, just erase the first few MB of the device with zeroes:

dd if=/dev/zero of=/dev/sdc1 bs=1M count=10

Pavel Goran
  
