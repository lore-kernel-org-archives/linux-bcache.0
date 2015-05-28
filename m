From: Pavel Goran <via-bcache@pvgoran.name>
Subject: Re: reading an ex linux bcache disk
Date: Thu, 28 May 2015 15:09:13 +0600
Message-ID: <322068851.20150528150913@pvgoran.name>
References: <5566BEE5.4020108@dodin.org>
Reply-To: Pavel Goran <via-bcache@pvgoran.name>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-bcache-owner@vger.kernel.org>
Received: from pvgoran2.xen.prgmr.com ([71.19.149.48]:46504 "EHLO
	v2.pvgoran.name" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751415AbbE1JOS (ORCPT
	<rfc822;linux-bcache@vger.kernel.org>);
	Thu, 28 May 2015 05:14:18 -0400
In-Reply-To: <5566BEE5.4020108@dodin.org>
Sender: linux-bcache-owner@vger.kernel.org
List-Id: linux-bcache@vger.kernel.org
To: linux-bcache@vger.kernel.org

Hello jdd,

Thursday, May 28, 2015, 1:08:21 PM, you wrote:

> Hello,

> I have the following problem.

> I used bcache on a computer with one hard drive and one small ssd.

> (openSUSE 13.2)

> this computer broke, it do not boot anymore. I could only recover the 
> hard drive that seems perfectly working - I can read all the partitions 
> but the bcache one.

> is there any way to read the bcache partition content? As far as I know, 
> the computer was shut down properly (it broke because somebody walked on 
> it :-).

You  can  access  the  contents  of  the  bcache  volume without using a cache
partition  at all. All you'll need is a kernel that supports bcache and one or
two  commands  from  the  terminal.  I don't have time to go into details, but
probably it will be something like:

echo 1 > /sys/block/sda/sda3/bcache/running

(Taken  from https://wiki.archlinux.org/index.php/Bcache, you may want to look
there   or  at  https://www.kernel.org/doc/Documentation/bcache.txt  for  more
information.)

Pavel Goran
  
