From: Maciej Piechotka <uzytkownik2@gmail.com>
Subject: Re: bcache hangs on suspend when cache device is attached
Date: Tue, 19 Apr 2016 21:00:31 +0000 (UTC)
Message-ID: <loom.20160419T225909-455@post.gmane.org>
References: <loom.20160415T174321-594@post.gmane.org> <alpine.LRH.2.11.1604171807510.16630@mail.ewheeler.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-bcache-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:60034 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932834AbcDSVAx (ORCPT <rfc822;linux-bcache@vger.kernel.org>);
	Tue, 19 Apr 2016 17:00:53 -0400
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <glbd-linux-bcache@m.gmane.org>)
	id 1asclM-0003c0-5Y
	for linux-bcache@vger.kernel.org; Tue, 19 Apr 2016 23:00:48 +0200
Received: from thunderhill.nvidia.com ([216.228.112.22])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-bcache@vger.kernel.org>; Tue, 19 Apr 2016 23:00:48 +0200
Received: from uzytkownik2 by thunderhill.nvidia.com with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-bcache@vger.kernel.org>; Tue, 19 Apr 2016 23:00:48 +0200
Sender: linux-bcache-owner@vger.kernel.org
List-Id: linux-bcache@vger.kernel.org
To: linux-bcache@vger.kernel.org

Eric Wheeler <bcache <at> lists.ewheeler.net> writes:

> 
> Interesting.  Can you collect the dmesg output as it suspends/resumes via 
> serial or something other means?
> 

I'll try to capture the output today.
