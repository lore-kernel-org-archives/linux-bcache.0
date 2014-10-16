From: Ian Pilcher <arequipeno@gmail.com>
Subject: Re: initramfs issues with mdraid/bcache-tools/lvm2 on debian wheezy-backports
 3.16
Date: Thu, 16 Oct 2014 17:06:25 -0500
Message-ID: <m1pfh2$ltn$1@ger.gmane.org>
References: <54394FD1.4090708@paivola.fi>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-bcache-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:44022 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752383AbaJPWGn (ORCPT <rfc822;linux-bcache@vger.kernel.org>);
	Thu, 16 Oct 2014 18:06:43 -0400
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <glbd-linux-bcache@m.gmane.org>)
	id 1XetBs-00059d-Ix
	for linux-bcache@vger.kernel.org; Fri, 17 Oct 2014 00:06:36 +0200
Received: from pool-173-57-185-5.dllstx.fios.verizon.net ([173.57.185.5])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-bcache@vger.kernel.org>; Fri, 17 Oct 2014 00:06:36 +0200
Received: from arequipeno by pool-173-57-185-5.dllstx.fios.verizon.net with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-bcache@vger.kernel.org>; Fri, 17 Oct 2014 00:06:36 +0200
In-Reply-To: <54394FD1.4090708@paivola.fi>
Sender: linux-bcache-owner@vger.kernel.org
List-Id: linux-bcache@vger.kernel.org
To: linux-bcache@vger.kernel.org

On 10/11/2014 10:42 AM, Tero Marttila wrote:
> 
> part seems to give (based on udev_log="debug" output): 
> 
> 	write error: Invalid arument
> 
> without any additional info in dmesg.
> 
> However, running the identical command:
> 
> 	/lib/udev/bcache-register /dev/md0
> 
> by hand a short while later from within the initramfs prompts works..
> 

This sounds like the error I reported back in July:

  http://article.gmane.org/gmane.linux.kernel.bcache.devel/2594

-- 
========================================================================
Ian Pilcher                                         arequipeno@gmail.com
-------- "I grew up before Mark Zuckerberg invented friendship" --------
========================================================================
