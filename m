From: Eric Wheeler <bcache@lists.ewheeler.net>
Subject: Re: disk gone
Date: Fri, 9 Jun 2017 01:46:24 +0000 (UTC)
Message-ID: <alpine.LRH.2.11.1706090144550.19359@mail.ewheeler.net>
References: <C081436D-3227-4388-A1DF-9764FB693924@gmail.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-bcache-owner@vger.kernel.org>
Received: from mx.ewheeler.net ([66.155.3.69]:35354 "EHLO mail.ewheeler.net"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1751445AbdFIBqZ (ORCPT <rfc822;linux-bcache@vger.kernel.org>);
        Thu, 8 Jun 2017 21:46:25 -0400
In-Reply-To: <C081436D-3227-4388-A1DF-9764FB693924@gmail.com>
Sender: linux-bcache-owner@vger.kernel.org
List-Id: linux-bcache@vger.kernel.org
To: feng D <fengidri@gmail.com>
Cc: linux-bcache@vger.kernel.org

On Fri, 2 Jun 2017, feng D wrote:

> hi:
> 
> Some time, the online machine will appear disk gone situation, although 
> this is not very common, but we have too many machines, so still will 
> encounter it.
> 
> That in the case of disk gone, /sys/block/bcache0/bcache/stop is not 
> found, this case how to delete the bcache0?

An interesting question.  Is it still available from the cache device in 
/sys/fs/bcache/* somewhere?  I'm guessing not, but check.

Do you have a procedure to reproduce this problem where /sys/block/bcache0 
has been hotplugged into oblivion?


--
Eric Wheeler



> 
> There is if it is SSD gone, and how should deal with it?
> 
> We have multiple SATA disks under an SSD.--
> To unsubscribe from this list: send the line "unsubscribe linux-bcache" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
