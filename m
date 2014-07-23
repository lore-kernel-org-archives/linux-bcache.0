From: Ian Pilcher <arequipeno@gmail.com>
Subject: Re: RFC: Handle "device busy" error when registering
Date: Tue, 22 Jul 2014 22:43:05 -0500
Message-ID: <lqnb0a$85t$1@ger.gmane.org>
References: <lqcd46$hvl$1@ger.gmane.org> <lqkrss$h1s$1@ger.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-bcache-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:56203 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751143AbaGWDn1 (ORCPT <rfc822;linux-bcache@vger.kernel.org>);
	Tue, 22 Jul 2014 23:43:27 -0400
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <glbd-linux-bcache@m.gmane.org>)
	id 1X9nSa-0005EX-LH
	for linux-bcache@vger.kernel.org; Wed, 23 Jul 2014 05:43:20 +0200
Received: from pool-173-57-185-5.dllstx.fios.verizon.net ([173.57.185.5])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-bcache@vger.kernel.org>; Wed, 23 Jul 2014 05:43:20 +0200
Received: from arequipeno by pool-173-57-185-5.dllstx.fios.verizon.net with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-bcache@vger.kernel.org>; Wed, 23 Jul 2014 05:43:20 +0200
In-Reply-To: <lqkrss$h1s$1@ger.gmane.org>
Sender: linux-bcache-owner@vger.kernel.org
List-Id: linux-bcache@vger.kernel.org
To: linux-bcache@vger.kernel.org

Filed as https://bugzilla.kernel.org/show_bug.cgi?id=80961.

-- 
========================================================================
Ian Pilcher                                         arequipeno@gmail.com
-------- "I grew up before Mark Zuckerberg invented friendship" --------
========================================================================
