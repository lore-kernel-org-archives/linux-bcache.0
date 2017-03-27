From: Kai Krakow <hurikhan77@gmail.com>
Subject: Re: journal replay at each boot problematic?
Date: Mon, 27 Mar 2017 22:51:33 +0200
Message-ID: <20170327225133.4aa977dd@jupiter.sol.kaishome.de>
References: <CAFvQSYSTFPu9yPj-i2E+G53V_Auet8WTQk9q1vAUFQZe=VUWjQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-bcache-owner@vger.kernel.org>
Received: from [195.159.176.226] ([195.159.176.226]:53360 "EHLO
        blaine.gmane.org" rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org
        with ESMTP id S1751801AbdC0Uwr (ORCPT
        <rfc822;linux-bcache@vger.kernel.org>);
        Mon, 27 Mar 2017 16:52:47 -0400
Received: from list by blaine.gmane.org with local (Exim 4.84_2)
        (envelope-from <glbd-linux-bcache@m.gmane.org>)
        id 1csbcC-00014i-C0
        for linux-bcache@vger.kernel.org; Mon, 27 Mar 2017 22:51:48 +0200
Sender: linux-bcache-owner@vger.kernel.org
List-Id: linux-bcache@vger.kernel.org
To: linux-bcache@vger.kernel.org

Am Mon, 27 Mar 2017 13:33:57 +0200
schrieb Clemens Eisserer <linuxhippy@gmail.com>:

> Hi,
> 
> I am using bcache in writeback-mode for a very slow (~100kb/s write
> speed) backing device.
> 
> At each boot I see messages like the following:
> > bcache: bch_journal_replay() journal replay done, 2297 keys in 86
> > entries, seq 71136  
> 
> Are these messages indicating an unclean shutdown / some kind of
> rollback operation - or is it part of "normal" bcache initialization?

As far as the docs tell, bcache is designed to shut down unclean. So
this is expected behavior in write-back mode.

To cleanly detach a bcache, you would need to first put it in
write-through or write-around mode and wait for write-back to finish.
In turn, this mode should also avoid these messages at boot.

-- 
Regards,
Kai

Replies to list-only preferred.
