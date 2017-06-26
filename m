From: Eric Wheeler <bcache@lists.ewheeler.net>
Subject: Re: Add Bcache to an existing Filesystem
Date: Mon, 26 Jun 2017 17:58:02 +0000 (UTC)
Message-ID: <alpine.LRH.2.11.1706261752580.17052@mail.ewheeler.net>
References: <46fc48b2-55db-471f-8318-5e60555e228e@upx.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-bcache-owner@vger.kernel.org>
Received: from mx.ewheeler.net ([66.155.3.69]:35000 "EHLO mail.ewheeler.net"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1751335AbdFZR6D (ORCPT <rfc822;linux-bcache@vger.kernel.org>);
        Mon, 26 Jun 2017 13:58:03 -0400
In-Reply-To: <46fc48b2-55db-471f-8318-5e60555e228e@upx.com>
Sender: linux-bcache-owner@vger.kernel.org
List-Id: linux-bcache@vger.kernel.org
To: FERNANDO FREDIANI <fernando.frediani@upx.com>
Cc: linux-bcache@vger.kernel.org

On Mon, 26 Jun 2017, FERNANDO FREDIANI wrote:

> Hello folks.
> 
> I have been using Bcache in a server in production with pretty good results so
> far.
> 
> Now I am looking to add it also to another server that is suffering from disk
> I/O. However this server in question has a fairly large storage running (circa
> 8TB of used data) and therefore stopping it for a long period becomes
> difficult.
> 
> Question is: Can I add an SSD and Bcache to this server and use it for the
> existing 8TB filesystem ? If so when I run make-bcache -B /dev/sdx1 to create
> the backing device will it not overwrite what is currently on /dev/sdx1 ?


Not officially.  The bcache superblock is in the first 8k of disk (by 
default, but can align the payload) so 8TB would need shifted right 
assuming the right-hand-side has room to grow.

Disclaimer: this could be dangerous, so at your own risk:

While I've not tried this, theoretically you could put dm-linear atop of 
the bcache bdev and prepend some metadata area, using the `--data-offset` 
parameter in make-bcache as the start of your data area.  Be sure to test 
on something non-critical if you go this route and make sure the sector 
math is correct or risk damaging the front of your 8TB volume.  If you go 
this route and it works, please report back with what you did!

--
Eric Wheeler



> 
> Thanks
> Fernando
> --
> To unsubscribe from this list: send the line "unsubscribe linux-bcache" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
