From: Greg KH <gregkh@linuxfoundation.org>
Subject: Re: Urgent fix for 4.15: 62530ed8b1d (bio: ensure __bio_clone_fast
 copies bi_partno)
Date: Tue, 21 Nov 2017 17:45:05 +0100
Message-ID: <20171121164505.GB20401@kroah.com>
References: <CAJ+L6qdy2TQ0K=syErR_OEvAGJF7Cacc_79mnD=SEC=uQTYVpA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-bcache-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:52590 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751154AbdKUQpE (ORCPT
        <rfc822;linux-bcache@vger.kernel.org>);
        Tue, 21 Nov 2017 11:45:04 -0500
Content-Disposition: inline
In-Reply-To: <CAJ+L6qdy2TQ0K=syErR_OEvAGJF7Cacc_79mnD=SEC=uQTYVpA@mail.gmail.com>
Sender: linux-bcache-owner@vger.kernel.org
List-Id: linux-bcache@vger.kernel.org
To: Michael Lyle <mlyle@lyle.org>
Cc: stable <stable@vger.kernel.org>, linux-bcache <linux-bcache@vger.kernel.org>

On Mon, Nov 20, 2017 at 03:47:40PM -0800, Michael Lyle wrote:
> Hi---
> 
> Previously sent to stable was this patch, and it's made it into
> Linus's tree for 4.16.  It's a rather urgent data corruption issue
> that affects at minimum bcache but possibly other block subsystems.
> Several users have lost data.  The issue was introduced in the 4.15
> branch by 74d46992e0d9 ("block: replace bi_bdev with a gendisk pointer
> and partitions index").
> 
> I'd really appreciate anything that can be done to get this into a
> stable 4.15 release soon.

Now queued up, thanks for letting me know.  Normally I wait until a
patch hits a public -rc release before adding it to a stable kernel
release, but if you ever want it ot get there sooner, always feel free
to just email stable@vger with this info and I will try to queue it up
sooner.

thanks,

greg k-h
