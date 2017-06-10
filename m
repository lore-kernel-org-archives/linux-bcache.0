From: Kai Krakow <hurikhan77@gmail.com>
Subject: Re: disk gone
Date: Sat, 10 Jun 2017 12:17:22 +0200
Message-ID: <20170610121722.124dbfc0@jupiter.sol.kaishome.de>
References: <C081436D-3227-4388-A1DF-9764FB693924@gmail.com>
        <alpine.LRH.2.11.1706090144550.19359@mail.ewheeler.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-bcache-owner@vger.kernel.org>
Received: from [195.159.176.226] ([195.159.176.226]:49584 "EHLO
        blaine.gmane.org" rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org
        with ESMTP id S1751890AbdFJKRd (ORCPT
        <rfc822;linux-bcache@vger.kernel.org>);
        Sat, 10 Jun 2017 06:17:33 -0400
Received: from list by blaine.gmane.org with local (Exim 4.84_2)
        (envelope-from <glbd-linux-bcache@m.gmane.org>)
        id 1dJdSP-0001qU-Dp
        for linux-bcache@vger.kernel.org; Sat, 10 Jun 2017 12:17:25 +0200
Sender: linux-bcache-owner@vger.kernel.org
List-Id: linux-bcache@vger.kernel.org
To: linux-bcache@vger.kernel.org

Am Fri, 9 Jun 2017 01:46:24 +0000 (UTC)
schrieb Eric Wheeler <bcache@lists.ewheeler.net>:

> On Fri, 2 Jun 2017, feng D wrote:
> 
> > hi:
> > 
> > Some time, the online machine will appear disk gone situation,
> > although this is not very common, but we have too many machines, so
> > still will encounter it.
> > 
> > That in the case of disk gone, /sys/block/bcache0/bcache/stop is
> > not found, this case how to delete the bcache0?  
> 
> An interesting question.  Is it still available from the cache device
> in /sys/fs/bcache/* somewhere?  I'm guessing not, but check.
> 
> Do you have a procedure to reproduce this problem
> where /sys/block/bcache0 has been hotplugged into oblivion?

You easily run into the same situation when you stop the device instead
of detaching it. Bcache then doesn't release its cache device and
cannot be stopped/unregistered, because every interface for shutting
bcache down has vanished: It can only be reached through the backing
devices but the bcache interface below those is gone.

I think bcache needs a way to force unregister the cache device...
Otherwise the cache device stays busy and cannot be registered, neither
can any devices be attached again in this state.

-- 
Regards,
Kai

Replies to list-only preferred.
