From: Eric Wheeler <bcache@lists.ewheeler.net>
Subject: Re: [PULL] bcache: based on for-4.10/block, multiple updates
Date: Wed, 14 Dec 2016 17:50:02 -0800 (PST)
Message-ID: <alpine.LRH.2.11.1612141747470.31582@mail.ewheeler.net>
References: <alpine.LRH.2.11.1610262037160.24191@mail.ewheeler.net> <5160da7c-e38e-1527-2b09-2ca240df57c3@kernel.dk> <alpine.LRH.2.11.1610291826250.4080@mail.ewheeler.net> <20161030140050.q6ywphi3by6yoczc@kmo-pixel> <6bda49c5-5ed8-939f-aab3-faa9c8127ff0@kernel.dk>
 <alpine.LRH.2.11.1612061145430.13402@mail.ewheeler.net>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-bcache-owner@vger.kernel.org>
Received: from mx.ewheeler.net ([66.155.3.69]:35964 "EHLO mail.ewheeler.net"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S932218AbcLOBuW (ORCPT <rfc822;linux-bcache@vger.kernel.org>);
        Wed, 14 Dec 2016 20:50:22 -0500
In-Reply-To: <alpine.LRH.2.11.1612061145430.13402@mail.ewheeler.net>
Sender: linux-bcache-owner@vger.kernel.org
List-Id: linux-bcache@vger.kernel.org
To: Jens Axboe <axboe@kernel.dk>
Cc: Kent Overstreet <kent.overstreet@gmail.com>, linux-bcache@vger.kernel.org, dave@stgolabs.net, linux-kernel@vger.kernel.org, Kai Krakow <kai@kaishome.de>, Wido den Hollander <wido@widodh.nl>, Emmanuel Florac <eflorac@intellique.com>, Hans van den Bogert <hansbogert@gmail.com>, "Jens-U. Mozdzen" <jmozdzen@nde.ag>

Hi Jens,

I know you're busy, so when you get a moment:

I've not yet seen your ack/nack on this yet and I want to make sure it 
gets in before the merge window closes for v4.10.  I rebased it on 
for-4.10/block as you asked so its tested and ready to go as of 12/6 
unless you see something that I've missed.

Thanks!

-Eric

--
Eric Wheeler

On Tue, 6 Dec 2016, Eric Wheeler wrote:

> Hello Jens,
> 
> Please pull for 4.10:
> 
> Thank you!
> 
> This pull request is based on the git.kernel.dk for-4.10/block branch:
> 
> The following changes since commit 333ba053d145d6f9152f6b0311a345b876f0fed1:
> 
>   lightnvm: transform target get/set bad block (2016-11-29 12:12:51 -0700)
> 
> are available in the git repository at:
> 
>   https://bitbucket.org/ewheelerinc/linux.git for-4.10-block-bcache-updates
> 
> for you to fetch changes up to 951c0a8cc489aca1c68d80e5aaa576cd7e511191:
> 
>   bcache: partition support: add 16 minors per bcacheN device (2016-12-06 10:13:24 -0800)
> 
> ----------------------------------------------------------------
> Eric Wheeler (4):
>       bcache: introduce per-process ioprio-based bypass/writeback hints
>       bcache: documentation for ioprio cache hinting
>       bcache: update bio->bi_opf bypass/writeback REQ_ flag hints
>       bcache: partition support: add 16 minors per bcacheN device
> 
> Kent Overstreet (1):
>       bcache: Make gc wakeup sane, remove set_task_state()
> 
>  Documentation/bcache.txt      | 80 +++++++++++++++++++++++++++++++++++++++++++
>  drivers/md/bcache/bcache.h    |  7 ++--
>  drivers/md/bcache/btree.c     | 39 +++++++++++----------
>  drivers/md/bcache/btree.h     |  3 +-
>  drivers/md/bcache/request.c   | 31 +++++++++++++++--
>  drivers/md/bcache/super.c     |  7 +++-
>  drivers/md/bcache/sysfs.c     | 71 ++++++++++++++++++++++++++++++++++++++
>  drivers/md/bcache/writeback.c |  8 +++++
>  drivers/md/bcache/writeback.h | 27 ++++++++++++++-
>  9 files changed, 245 insertions(+), 28 deletions(-)
> --
> To unsubscribe from this list: send the line "unsubscribe linux-bcache" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
