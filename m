From: Peter <pkozbial@gmail.com>
Subject: SSD failed - can I recover data from HDDs
Date: Sun, 24 May 2015 00:46:33 +0000 (UTC)
Message-ID: <loom.20150524T023926-291@post.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-bcache-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:48603 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751017AbbLKDKI (ORCPT <rfc822;linux-bcache@vger.kernel.org>);
	Thu, 10 Dec 2015 22:10:08 -0500
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <glbd-linux-bcache@m.gmane.org>)
	id 1a7E5t-0003v4-I5
	for linux-bcache@vger.kernel.org; Fri, 11 Dec 2015 04:10:05 +0100
Received: from 108-123-127-34.pools.spcsdns.net ([108-123-127-34.pools.spcsdns.net])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-bcache@vger.kernel.org>; Fri, 11 Dec 2015 04:10:05 +0100
Received: from pkozbial by 108-123-127-34.pools.spcsdns.net with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-bcache@vger.kernel.org>; Fri, 11 Dec 2015 04:10:05 +0100
Sender: linux-bcache-owner@vger.kernel.org
List-Id: linux-bcache@vger.kernel.org
To: linux-bcache@vger.kernel.org

I've set up bcache with one SSD and two HDD (using btrfs). 

Unfortunately after power failure the first SSD partition (root) is
corrupted, the second (swap) and the third (bcache caching) are fine. 

I have two (btrfs formatted) hard drives and would really really love to
have my data recovered from the hard drives (2 x 5TB). Is there any guide
how to do that?

Thank you,
Peter 
