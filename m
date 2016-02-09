From: Kai Krakow <hurikhan77@gmail.com>
Subject: Re: How to use multiple backing devices
Date: Tue, 9 Feb 2016 08:38:47 +0100
Message-ID: <20160209083847.0cff87c6@jupiter.sol.kaishome.de>
References: <87oabq8p81.fsf@vostro.rath.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-bcache-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:52461 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752778AbcBIHjf (ORCPT <rfc822;linux-bcache@vger.kernel.org>);
	Tue, 9 Feb 2016 02:39:35 -0500
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <glbd-linux-bcache@m.gmane.org>)
	id 1aT2tY-0004tS-PD
	for linux-bcache@vger.kernel.org; Tue, 09 Feb 2016 08:39:32 +0100
Received: from ip5f5ae057.dynamic.kabel-deutschland.de ([95.90.224.87])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-bcache@vger.kernel.org>; Tue, 09 Feb 2016 08:39:32 +0100
Received: from hurikhan77 by ip5f5ae057.dynamic.kabel-deutschland.de with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-bcache@vger.kernel.org>; Tue, 09 Feb 2016 08:39:32 +0100
Sender: linux-bcache-owner@vger.kernel.org
List-Id: linux-bcache@vger.kernel.org
To: linux-bcache@vger.kernel.org

Am Mon, 08 Feb 2016 20:47:10 -0800
schrieb Nikolaus Rath <Nikolaus@rath.org>:

> Hello,
> 
> If I'm understanding Documentation/bcache.txt correctly, I should be
> able to use one SSD to cache multiple spinning disks.
> 
> However, I'm at a loss of how to set this up in practice. I believe I
> need to do
> 
>   make-bcache -B /dev/sda  # spinning rust
>   make-bcache -B /dev/sdb  # spinning rust 
>   make-bcache -C /dev/sdc  # ssd
> 
> and then something like
> 
>   echo <CSET-UUID> > /sys/block/bcacheX/bcache/attach
> 
> 
> But what do I have to put for X, and what for CSET-UUID? I believe for
> at least one of those values I will have two options (because there
> are two backing devices).

Create it in one go:

make-bcache -C /dev/sdc -B /dev/sd{a,b}

It will take away the hassle. Everything should be setup now.

But if you want to do it manually: you have to run "echo" twice - for
each X (the backing devices). CSET-UUID comes from /sys/fs/bcache where
you will find a UUID per each bcache caching device, which is just one
for your case.

-- 
Regards,
Kai

Replies to list-only preferred.
