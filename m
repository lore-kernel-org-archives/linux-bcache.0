From: Eric Wheeler <bcache@lists.ewheeler.net>
Subject: Re: what happened to the nifty ioprio cache hinting stuff?
Date: Tue, 2 May 2017 17:26:55 +0000 (UTC)
Message-ID: <alpine.LRH.2.11.1705021726500.5014@mail.ewheeler.net>
References: <877f1zil5d.fsf@esperi.org.uk>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-bcache-owner@vger.kernel.org>
Received: from mx.ewheeler.net ([66.155.3.69]:56508 "EHLO mail.ewheeler.net"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1751340AbdEBRd1 (ORCPT <rfc822;linux-bcache@vger.kernel.org>);
        Tue, 2 May 2017 13:33:27 -0400
In-Reply-To: <877f1zil5d.fsf@esperi.org.uk>
Sender: linux-bcache-owner@vger.kernel.org
List-Id: linux-bcache@vger.kernel.org
To: Jens Axboe <axboe@kernel.dk>
Cc: linux-bcache@vger.kernel.org, Kai Krakow <kai@kaishome.de>, Nix <nix@esperi.org.uk>

Hi Jens,

It looks like there are still people interested (excited, even!) in the 
sysfs entries for ioprio cache hinting in bcache.  

If I rebase on for-4.12 or for-next on git.kernel.dk, would you pull it in?

There are a handful of stable patches on the bcache list that I would roll 
up in the same pull.  Please let me know what you would prefer and what I 
can do to make it easy for you.

Thank you for your help!

--
Eric Wheeler

On Tue, 2 May 2017, Nix wrote:
> I found the ioprio cache hinting quite exciting (I know, I'm weird):
> it won't help with writeback or e.g. NFS, but it will certainly let me
> do things like run backups without wearing my SSD out.
> 
> This was in ewheeler's for-4.10-block-bcache-updates branch, but it
> didn't get into 4.10 or 4.11, even while other commits on the same
> branch did :( is it dead? (I mean, it still seems to *apply* to 4.11...)
> 
> -- 
> NULL && (void)
> --
> To unsubscribe from this list: send the line "unsubscribe linux-bcache" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
