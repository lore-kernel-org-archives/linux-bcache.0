From: Max Kutsevol <max@kutsevol.com>
Subject: Re: bcache deadlock with /dev/ramX + partition
Date: Fri, 21 Feb 2014 17:08:20 +0000 (UTC)
Message-ID: <loom.20140221T180753-160@post.gmane.org>
References: <alpine.DEB.2.02.1402201818410.14562@noise.cbg.collabora.co.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-bcache-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:56831 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755212AbaBURKI (ORCPT <rfc822;linux-bcache@vger.kernel.org>);
	Fri, 21 Feb 2014 12:10:08 -0500
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <glbd-linux-bcache@m.gmane.org>)
	id 1WGtbv-0000pK-GR
	for linux-bcache@vger.kernel.org; Fri, 21 Feb 2014 18:10:03 +0100
Received: from 169-135-146-194.user.iteam.ua ([194.146.135.169])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-bcache@vger.kernel.org>; Fri, 21 Feb 2014 18:10:03 +0100
Received: from max by 169-135-146-194.user.iteam.ua with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-bcache@vger.kernel.org>; Fri, 21 Feb 2014 18:10:03 +0100
Sender: linux-bcache-owner@vger.kernel.org
List-Id: linux-bcache@vger.kernel.org
To: linux-bcache@vger.kernel.org

Hello.

Try this patch: http://evilpiepirate.org/git/linux-bcache.git/commit/?
h=bcache-for-3.14&id=947174476701fbc84ea8c7ec9664270f9d80b076
