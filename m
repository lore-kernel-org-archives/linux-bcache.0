From: Ian Pilcher <arequipeno@gmail.com>
Subject: Re: "device busy" error when registering device
Date: Mon, 21 Jul 2014 23:46:45 -0500
Message-ID: <lqkqbm$1lt$1@ger.gmane.org>
References: <lqcd46$hvl$1@ger.gmane.org> <CAPBO7TYGDMGUNNJWpjRmrTr5N6i2061Nu4BmbjtFROz=1siCRA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-bcache-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:33667 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750790AbaGVErE (ORCPT <rfc822;linux-bcache@vger.kernel.org>);
	Tue, 22 Jul 2014 00:47:04 -0400
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <glbd-linux-bcache@m.gmane.org>)
	id 1X9Ryd-0007I9-Uy
	for linux-bcache@vger.kernel.org; Tue, 22 Jul 2014 06:46:59 +0200
Received: from pool-173-57-185-5.dllstx.fios.verizon.net ([173.57.185.5])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-bcache@vger.kernel.org>; Tue, 22 Jul 2014 06:46:59 +0200
Received: from arequipeno by pool-173-57-185-5.dllstx.fios.verizon.net with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-bcache@vger.kernel.org>; Tue, 22 Jul 2014 06:46:59 +0200
In-Reply-To: <CAPBO7TYGDMGUNNJWpjRmrTr5N6i2061Nu4BmbjtFROz=1siCRA@mail.gmail.com>
Sender: linux-bcache-owner@vger.kernel.org
List-Id: linux-bcache@vger.kernel.org
To: linux-bcache@vger.kernel.org

On 07/19/2014 02:23 AM, Josep Lladonosa wrote:
> I tracked down the code by adding some variables log and found that
> flash_dev_run is sometimes called with values higher than
> 0x9000000000000000 and makes bcache lock system boot:

This does not appear to have anything to do with the "device busy"
error.  Please don't hijack threads.

Thanks!

-- 
========================================================================
Ian Pilcher                                         arequipeno@gmail.com
-------- "I grew up before Mark Zuckerberg invented friendship" --------
========================================================================
