From: Maciej Piechotka <uzytkownik2@gmail.com>
Subject: bcache hangs on suspend when cache device is attached
Date: Fri, 15 Apr 2016 15:45:49 +0000 (UTC)
Message-ID: <loom.20160415T174321-594@post.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-bcache-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:43838 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751993AbcDQCPO (ORCPT <rfc822;linux-bcache@vger.kernel.org>);
	Sat, 16 Apr 2016 22:15:14 -0400
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <glbd-linux-bcache@m.gmane.org>)
	id 1arcEq-00061q-P7
	for linux-bcache@vger.kernel.org; Sun, 17 Apr 2016 04:15:05 +0200
Received: from c-50-168-49-114.hsd1.ca.comcast.net ([50.168.49.114])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-bcache@vger.kernel.org>; Sun, 17 Apr 2016 04:15:04 +0200
Received: from uzytkownik2 by c-50-168-49-114.hsd1.ca.comcast.net with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-bcache@vger.kernel.org>; Sun, 17 Apr 2016 04:15:04 +0200
Sender: linux-bcache-owner@vger.kernel.org
List-Id: linux-bcache@vger.kernel.org
To: linux-bcache@vger.kernel.org

Hi,

My system hangs during suspend when cache device is attached. If I detach it
before suspending it works fine. Is this a known bug?

Maciej
