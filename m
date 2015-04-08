From: Kai Krakow <hurikhan77@gmail.com>
Subject: Re: Bcache on btrfs: the perfect setup or the perfect storm?
Date: Wed, 08 Apr 2015 21:02:08 +0200
Message-ID: <hiagvb-l7r.ln1@hurikhan77.spdns.de>
References: <CAK1hC9v9ADdguR+frFPix02U2u-+fuJgaV-cJi0F55fOfeECtg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7Bit
Return-path: <linux-bcache-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:58101 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751651AbbDHTCT (ORCPT <rfc822;linux-bcache@vger.kernel.org>);
	Wed, 8 Apr 2015 15:02:19 -0400
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <glbd-linux-bcache@m.gmane.org>)
	id 1YfvEv-0001J2-FK
	for linux-bcache@vger.kernel.org; Wed, 08 Apr 2015 21:02:17 +0200
Received: from ip18864262.dynamic.kabel-deutschland.de ([24.134.66.98])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-bcache@vger.kernel.org>; Wed, 08 Apr 2015 21:02:17 +0200
Received: from hurikhan77 by ip18864262.dynamic.kabel-deutschland.de with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-bcache@vger.kernel.org>; Wed, 08 Apr 2015 21:02:17 +0200
Sender: linux-bcache-owner@vger.kernel.org
List-Id: linux-bcache@vger.kernel.org
To: linux-bcache@vger.kernel.org

arnaud gaboury <arnaud.gaboury@gmail.com> schrieb:

> I plan to setup Bcache on  Btrfs SSD/HD caching/backing device. The
> box will be a server, but not a production one.
> 
> I know this scheme is not recommended and can be a cause of filesystem
> corruption. But as I like living on the edge, I want to give a try,
> with a tight backup policy.
> 
> Any advice? Any settings that could be worth to avoid future drama?

See my recommendations about partitioning here I just posted:
http://permalink.gmane.org/gmane.linux.kernel.bcache.devel/2865

Take care of the warnings about trimming/enabling discard. I'd at least test 
it if you want to use it before trusting your kitty to it. ;-)

BTW: I'm planning on a similar system tho the plans may well be 1 or 2 years 
in the future and the system is planned to be based off bcache/btrfs. It 
should become a production container-VM host. We'll see. Fallback plan is to 
use a battery-backed RAID controller with CacheCade (SSDs as volume cache).

-- 
Replies to list only preferred.
