From: NTS <ntshad0w@wp.pl>
Subject: Re: Dirty and cleaning of dirty data
Date: Thu, 22 May 2014 01:31:51 +0000 (UTC)
Message-ID: <loom.20140522T032815-582@post.gmane.org>
References: <52661722.2050404@profihost.ag>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-bcache-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:42817 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751532AbaEVCFI (ORCPT <rfc822;linux-bcache@vger.kernel.org>);
	Wed, 21 May 2014 22:05:08 -0400
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <glbd-linux-bcache@m.gmane.org>)
	id 1WnINT-0000WV-NC
	for linux-bcache@vger.kernel.org; Thu, 22 May 2014 04:05:05 +0200
Received: from 89-78-70-121.dynamic.chello.pl ([89.78.70.121])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-bcache@vger.kernel.org>; Thu, 22 May 2014 04:05:03 +0200
Received: from ntshad0w by 89-78-70-121.dynamic.chello.pl with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-bcache@vger.kernel.org>; Thu, 22 May 2014 04:05:03 +0200
Sender: linux-bcache-owner@vger.kernel.org
List-Id: linux-bcache@vger.kernel.org
To: linux-bcache@vger.kernel.org

Stefan Priebe - Profihost AG <s.priebe@...> writes:

> 
> Hi,
> 
> while having a system under heavystress - i was seeing the following:
> 
> Dirty Data on SSD: 35GB data
> Writes to sata disk mostly 0-4mb/s
> 
> Why does bcache not start to clean this data to get free ssd space?
> 
> Right now the system is pretty slow as the caching device is very dirty.
> 
> Stefan
> 

hi mate,

do U solve that problem?
I'm testing bcache and now have same problem and don't know how to solve
it... so how to speed up (100x-400x times!!!!)

any idea how to speed up that dirty cache cleaning now and in the future?

regards
NTS
