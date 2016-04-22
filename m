From: Maciej Piechotka <uzytkownik2@gmail.com>
Subject: Re: bcache hangs on suspend when cache device is attached
Date: Fri, 22 Apr 2016 01:33:40 +0000 (UTC)
Message-ID: <loom.20160422T033159-792@post.gmane.org>
References: <loom.20160415T174321-594@post.gmane.org> <alpine.LRH.2.11.1604171807510.16630@mail.ewheeler.net> <loom.20160419T225909-455@post.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-bcache-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:38642 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751594AbcDVBdz (ORCPT <rfc822;linux-bcache@vger.kernel.org>);
	Thu, 21 Apr 2016 21:33:55 -0400
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <glbd-linux-bcache@m.gmane.org>)
	id 1atPyf-0008Lw-3V
	for linux-bcache@vger.kernel.org; Fri, 22 Apr 2016 03:33:49 +0200
Received: from c-50-168-49-114.hsd1.ca.comcast.net ([50.168.49.114])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-bcache@vger.kernel.org>; Fri, 22 Apr 2016 03:33:49 +0200
Received: from uzytkownik2 by c-50-168-49-114.hsd1.ca.comcast.net with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-bcache@vger.kernel.org>; Fri, 22 Apr 2016 03:33:49 +0200
Sender: linux-bcache-owner@vger.kernel.org
List-Id: linux-bcache@vger.kernel.org
To: linux-bcache@vger.kernel.org

Maciej Piechotka <uzytkownik2 <at> gmail.com> writes:

> 
> Eric Wheeler <bcache <at> lists.ewheeler.net> writes:
> 
> > 
> > Interesting.  Can you collect the dmesg output as it suspends/resumes via 
> > serial or something other means?
> > 
> 
> I'll try to capture the output today.
> 
> 


The USB-to-serial I was using requires firmware which for some reasons in my
setup (luks + lvm + dracut) prevents the whole thing from working - I'm able
to set up serial connection between 2 computers (including getty) but not
loging. I'll try netconsole later on - maybe with better result.
