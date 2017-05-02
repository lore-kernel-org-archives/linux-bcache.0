From: Kai Krakow <hurikhan77@gmail.com>
Subject: Re: what happened to the nifty ioprio cache hinting stuff?
Date: Tue, 2 May 2017 20:15:59 +0200
Message-ID: <20170502201559.5cd65131@jupiter.sol.kaishome.de>
References: <877f1zil5d.fsf@esperi.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-bcache-owner@vger.kernel.org>
Received: from [195.159.176.226] ([195.159.176.226]:44888 "EHLO
        blaine.gmane.org" rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org
        with ESMTP id S1751220AbdEBSQN (ORCPT
        <rfc822;linux-bcache@vger.kernel.org>);
        Tue, 2 May 2017 14:16:13 -0400
Received: from list by blaine.gmane.org with local (Exim 4.84_2)
        (envelope-from <glbd-linux-bcache@m.gmane.org>)
        id 1d5cLB-00051w-9W
        for linux-bcache@vger.kernel.org; Tue, 02 May 2017 20:16:01 +0200
Sender: linux-bcache-owner@vger.kernel.org
List-Id: linux-bcache@vger.kernel.org
To: linux-bcache@vger.kernel.org

Am Tue, 02 May 2017 11:54:38 +0100
schrieb Nix <nix@esperi.org.uk>:

> I found the ioprio cache hinting quite exciting (I know, I'm weird):
> it won't help with writeback or e.g. NFS, but it will certainly let me
> do things like run backups without wearing my SSD out.

I'm certainly waiting for the patches to be upstreamed. Meanwhile, I
stopped the hassle of applying the patches and just resorted to putting
my backups partition into "write-around" mode. It still gets big
improvements in performance and is nice to wear leveling.

> This was in ewheeler's for-4.10-block-bcache-updates branch, but it
> didn't get into 4.10 or 4.11, even while other commits on the same
> branch did :( is it dead? (I mean, it still seems to *apply* to
> 4.11...)

Last time I looked at bitbucket (the only place I found it) to pull the
patches via http, it was horribly slow and even complained that the
repository is too big to be browsed or generate patch sets.

Would it be possible to mirror it somewhere else? Bitbucket is really
slow for me, direct git-clone didn't even work.

I was just trying to pull the branch and rebase it ontop of current
kernels myself because I couldn't apply these patches. But I eventually
gave up due to bitbuckets superior *cough* performance... :-(

Also, I cannot find it on git.kernel.org which would've been an
alternative.

Apparently, Eric's user name seems to be already taken on Github -
maybe that's why it isn't there... (or I cannot find it) ;-)


-- 
Regards,
Kai

Replies to list-only preferred.
