From: Karl Tomlinson <bugs+kernel@karlt.net>
Subject: Re: hang during suspend to RAM when bcache cache device is attached
Date: Fri, 19 May 2017 14:12:28 +1200
Message-ID: <878tltr3w3.fsf@karlt.net>
References: <87pof8rmqb.fsf@karlt.net> <87ziebqhjf.fsf@karlt.net> <alpine.LRH.2.11.1705181701520.19359@mail.ewheeler.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-bcache-owner@vger.kernel.org>
Received: from [195.159.176.226] ([195.159.176.226]:54235 "EHLO
        blaine.gmane.org" rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org
        with ESMTP id S932211AbdESCPP (ORCPT
        <rfc822;linux-bcache@vger.kernel.org>);
        Thu, 18 May 2017 22:15:15 -0400
Received: from list by blaine.gmane.org with local (Exim 4.84_2)
        (envelope-from <glbd-linux-bcache@m.gmane.org>)
        id 1dBXRa-0001sM-32
        for linux-bcache@vger.kernel.org; Fri, 19 May 2017 04:15:06 +0200
In-Reply-To: <alpine.LRH.2.11.1705181701520.19359@mail.ewheeler.net> (Eric Wheeler's message of "Thu, 18 May 2017 17:03:33 +0000 (UTC)")
Sender: linux-bcache-owner@vger.kernel.org
List-Id: linux-bcache@vger.kernel.org
To: linux-bcache@vger.kernel.org

Eric Wheeler writes:

> Try the patch below, this is the only deadlock fix that isn't upstream 
> that I'm aware of.  Your trace above doesn't indicate any bcache 
> functions, so this could be hard to troubleshoot.

Thanks for the suggestion, but I think I've found the real cause.

I wasn't able to reproduce with 4.11.1, which I suspect is due to
https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable.git/commit/drivers/nvme/host/core.c?h=v4.11.1&id=302ad8cc09339ea261eef58a8d5f4a116a8ffda5
which fixes an issue that matches the symptoms I've seen.

The history of that change is
http://lists.infradead.org/pipermail/linux-nvme/2017-March/008593.html
https://patchwork.kernel.org/patch/9589187/
http://lists.infradead.org/pipermail/linux-nvme/2017-January/007617.html

FWIW I was not able to reproduce with a filesystem directly on an
nvme partition, but I guess stacked devices or bcache changed
things enough to trigger.
