From: Kai Krakow <hurikhan77@gmail.com>
Subject: Re: make-bcache bug?
Date: Sun, 14 May 2017 22:00:55 +0200
Message-ID: <20170514220055.2d06210e@jupiter.sol.kaishome.de>
References: <20170514175840.s3l6p4zjxnf2brm6@merlins.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-bcache-owner@vger.kernel.org>
Received: from [195.159.176.226] ([195.159.176.226]:51056 "EHLO
        blaine.gmane.org" rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org
        with ESMTP id S1756812AbdENUBL (ORCPT
        <rfc822;linux-bcache@vger.kernel.org>);
        Sun, 14 May 2017 16:01:11 -0400
Received: from list by blaine.gmane.org with local (Exim 4.84_2)
        (envelope-from <glbd-linux-bcache@m.gmane.org>)
        id 1d9zhO-0003W2-QM
        for linux-bcache@vger.kernel.org; Sun, 14 May 2017 22:01:02 +0200
Sender: linux-bcache-owner@vger.kernel.org
List-Id: linux-bcache@vger.kernel.org
To: linux-bcache@vger.kernel.org

Am Sun, 14 May 2017 10:58:40 -0700
schrieb Marc MERLIN <marc@merlins.org>:

> bcache-tools (1.0.8-2+b1)
> 
> gargamel:~# make-bcache  -C /dev/sde2
> Already a bcache device on /dev/sde2, overwrite with --wipe-bcache
> gargamel:~# make-bcache  --wipe-bcache -C /dev/sde2 
> Device /dev/sde2 already has a non-bcache superblock, remove it using
> wipefs and wipefs -a
> 
> /dev/sde2 is an old bcache I'm reformatting.
> The first message is correct
> The 2nd one is not "/dev/sde2 already has a non-bcache superblock"
> 
> Clearly it can't have a bcache and not a bcache superblock, right?

I don't think that each filesystem puts their superblocks in the same
position. Plus, there are usually backup superblocks across the area.

So you may well see both warnings and both are correct.

Use wipefs, there seems to be an orphan superblock.

-- 
Regards,
Kai

Replies to list-only preferred.
