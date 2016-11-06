From: Kent Overstreet <kent.overstreet@gmail.com>
Subject: Re: [branch:bcachefs-testing][tier] Massive slow down after some time
Date: Sun, 6 Nov 2016 05:32:19 -0900
Message-ID: <20161106143219.jvstkt7ucjyxhr5p@kmo-pixel>
References: <d61c1210e331ff556a9fd1d14c278a01@mejor.pl>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-bcache-owner@vger.kernel.org>
Received: from mail-pf0-f175.google.com ([209.85.192.175]:35286 "EHLO
        mail-pf0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751830AbcKFOcX (ORCPT
        <rfc822;linux-bcache@vger.kernel.org>);
        Sun, 6 Nov 2016 09:32:23 -0500
Received: by mail-pf0-f175.google.com with SMTP id i88so77234401pfk.2
        for <linux-bcache@vger.kernel.org>; Sun, 06 Nov 2016 06:32:23 -0800 (PST)
Content-Disposition: inline
In-Reply-To: <d61c1210e331ff556a9fd1d14c278a01@mejor.pl>
Sender: linux-bcache-owner@vger.kernel.org
List-Id: linux-bcache@vger.kernel.org
To: Marcin <marcin@mejor.pl>
Cc: linux-bcache@vger.kernel.org

On Sun, Nov 06, 2016 at 03:04:12PM +0100, Marcin wrote:
> Hi!
> I'm trying mentioned branch. I've got tiered bcachefs witch lz4 compresion
> turned on.
> After some times of copying of files into bcachefs I noticed huge slow downa
> of writing. Htop shows that kernel thread bcache_gc consumes a lot of CPU
> and spends a lot of time waiting for I/O. Iostat shows that almost all
> I/Ooperations goes to tier 1. In dmesg I see a couple of repeated messages
> (they appears together, "INFO: task kworker/u8:2:11787 blocked for more than
> 120 seconds." with "INFO: task rsync:11935 blocked for more than 120
> seconds." :

Sounds like tiering isn't freeing up space on tier 0... Can you check
cache0/alloc_debug (assuming cache0 is your tier 0 device) to confirm?

After that, could you hammer on single device mode for awhile? I need to know if
I'm just looking for tiering bugs, or if the btree changes have issues.
