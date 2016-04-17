From: Eric Wheeler <bcache@lists.ewheeler.net>
Subject: Re: bcache hangs on suspend when cache device is attached
Date: Sun, 17 Apr 2016 18:08:59 +0000 (UTC)
Message-ID: <alpine.LRH.2.11.1604171807510.16630@mail.ewheeler.net>
References: <loom.20160415T174321-594@post.gmane.org>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-bcache-owner@vger.kernel.org>
Received: from [66.155.3.69] ([66.155.3.69]:60411 "EHLO mail.ewheeler.net"
	rhost-flags-FAIL-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
	id S1750730AbcDQSJc (ORCPT <rfc822;linux-bcache@vger.kernel.org>);
	Sun, 17 Apr 2016 14:09:32 -0400
In-Reply-To: <loom.20160415T174321-594@post.gmane.org>
Sender: linux-bcache-owner@vger.kernel.org
List-Id: linux-bcache@vger.kernel.org
To: Maciej Piechotka <uzytkownik2@gmail.com>
Cc: linux-bcache@vger.kernel.org

On Fri, 15 Apr 2016, Maciej Piechotka wrote:

> Hi,
> 
> My system hangs during suspend when cache device is attached. If I detach it
> before suspending it works fine. Is this a known bug?

Interesting.  Can you collect the dmesg output as it suspends/resumes via 
serial or something other means?

--
Eric Wheeler


> 
> Maciej
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-bcache" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
