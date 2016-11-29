From: Eric Wheeler <bcache@lists.ewheeler.net>
Subject: Re: bcache register fails due to blkid ID_FS_AMBIVALENT
Date: Tue, 29 Nov 2016 13:03:20 -0800 (PST)
Message-ID: <alpine.LRH.2.11.1611291300070.1914@mail.ewheeler.net>
References: <adc6628e-268d-d0fa-e395-bbc65f378570@profihost.ag>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-bcache-owner@vger.kernel.org>
Received: from mx.ewheeler.net ([66.155.3.69]:36340 "EHLO mail.ewheeler.net"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1752706AbcK2VDV (ORCPT <rfc822;linux-bcache@vger.kernel.org>);
        Tue, 29 Nov 2016 16:03:21 -0500
In-Reply-To: <adc6628e-268d-d0fa-e395-bbc65f378570@profihost.ag>
Sender: linux-bcache-owner@vger.kernel.org
List-Id: linux-bcache@vger.kernel.org
To: Stefan Priebe - Profihost AG <s.priebe@profihost.ag>
Cc: "linux-bcache@vger.kernel.org" <linux-bcache@vger.kernel.org>

On Mon, 21 Nov 2016, Stefan Priebe - Profihost AG wrote:

> Hello list,
> 
> one of my bcache devices fails, as the output of blkid from the bdev
> device says:
> # /sbin/blkid -o udev -p /dev/sdg1
> ID_FS_AMBIVALENT=other:bcache other:xfs_external_log
> 
> has anybody an idea how to fix this?

Try this at your own risk:

It looks like you're detecting an XFS volume that used to be on that disk. 
If you can find out where blkid is finding the magic, then you might be 
able to clear the bits. Is XFS running directly on top of bcache?

--
Eric Wheeler

> 
> A manual
> echo /dev/sdg1 >/sys/fs/bcache/register
> 
> works fine.
> 
> Greets,
> Stefan
> --
> To unsubscribe from this list: send the line "unsubscribe linux-bcache" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
