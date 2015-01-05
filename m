From: Michael Goertz <goertzm@gmail.com>
Subject: Re: bcache fails after reboot if discard is enabled
Date: Mon, 5 Jan 2015 00:06:57 +0000 (UTC)
Message-ID: <loom.20150105T010336-763@post.gmane.org>
References: <54A66945.6030403@profihost.ag> <54A66C44.6070505@profihost.ag> <54A819A0.9010501@rolffokkens.nl> <54A843BC.608@profihost.ag>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-bcache-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:49922 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752827AbbAEAKJ (ORCPT <rfc822;linux-bcache@vger.kernel.org>);
	Sun, 4 Jan 2015 19:10:09 -0500
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <glbd-linux-bcache@m.gmane.org>)
	id 1Y7vFE-0005iU-L8
	for linux-bcache@vger.kernel.org; Mon, 05 Jan 2015 01:10:04 +0100
Received: from c-50-184-131-151.hsd1.ca.comcast.net ([50.184.131.151])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-bcache@vger.kernel.org>; Mon, 05 Jan 2015 01:10:04 +0100
Received: from goertzm by c-50-184-131-151.hsd1.ca.comcast.net with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-bcache@vger.kernel.org>; Mon, 05 Jan 2015 01:10:04 +0100
Sender: linux-bcache-owner@vger.kernel.org
List-Id: linux-bcache@vger.kernel.org
To: linux-bcache@vger.kernel.org

Stefan Priebe <s.priebe <at> profihost.ag> writes:

> 
> Hi Rolf,
> Am 03.01.2015 um 17:32 schrieb Rolf Fokkens:
> > I've been using discard for a while, but I ran a few times in serious FS
> > corruptions. After disabling discard bcache was stable again.
> >
> > So far I tributed the corruptions to a low-cost SSD which probably
> > didn't handle discard very well. But this was only an assumptions.
> >
> > I didn't experience specific reboot problems like you describe.
> 
> Reboot just triggers it faster and even fs crashes can occur the errors 
> are just examples.
> 
> I've now disabled discards in my kernel code.
> 
> Kent may you have a look at the 3.18 kernel code regading discards?
> 
> Greets,
> Stefan
> 

I just started using bcache and run into this same issue after a reboot.  I 
was running in writeback mode at the time and run into some FS loss as a 
result.  I don't have back traces since my machine wouldn't boot.  I 
recovered by removing the cache device and forcing the backing device to run 
without it.

I am running Ubuntu 14.04 with the Utopic kernel.  I can provide more 
details of my setup and hardware if that's helpful.

Thanks,
Mike
