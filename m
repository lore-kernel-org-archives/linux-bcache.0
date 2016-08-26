From: Kent Overstreet <kent.overstreet@gmail.com>
Subject: Re: [bcachefs][tier] kernel BUG at drivers/md/bcache/super.c:1561!
 after double changing state of device
Date: Thu, 25 Aug 2016 18:10:29 -0800
Message-ID: <20160826021029.upgpx4iji2opabjw@kmo-pixel>
References: <d29af387-c549-345d-974a-ee21047978ad@mejor.pl>
 <ca2d4c8e-37bc-bc63-3153-3a089c54ccc4@mejor.pl>
 <a38921be-e827-d227-6e86-3713f42db09c@mejor.pl>
 <3bfada34-3dd7-8e28-036a-8c027848f90d@mejor.pl>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Return-path: <linux-bcache-owner@vger.kernel.org>
Received: from mail-pf0-f172.google.com ([209.85.192.172]:36582 "EHLO
        mail-pf0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751393AbcHZCKq (ORCPT
        <rfc822;linux-bcache@vger.kernel.org>);
        Thu, 25 Aug 2016 22:10:46 -0400
Received: by mail-pf0-f172.google.com with SMTP id h186so23221052pfg.3
        for <linux-bcache@vger.kernel.org>; Thu, 25 Aug 2016 19:10:33 -0700 (PDT)
Content-Disposition: inline
In-Reply-To: <3bfada34-3dd7-8e28-036a-8c027848f90d@mejor.pl>
Sender: linux-bcache-owner@vger.kernel.org
List-Id: linux-bcache@vger.kernel.org
To: Marcin =?utf-8?B?TWlyb3PFgmF3?= <marcin@mejor.pl>, chris@cooperteam.net
Cc: linux-bcache@vger.kernel.org

On Thu, Aug 25, 2016 at 02:03:33PM +0200, Marcin Mirosław wrote:
> https://lwn.net/Articles/655183/ :
> "Caveat: don't try to use tiering and checksumming or compression at the
> same time yet, the read path needs to be reworked to handle both at the
> same time."
> 
> Is it sill valid?

No, I did do that read path reworking, they should work.

However, I haven't been focusing on or exercising the multi device stuff in
quite awhile - my main priority has been making single device filesystems rock
solid and finishing off compression and such.

Tiering ought to work, but can you hold off on exercising anything else? e.g.
the active/RO transition stuff - I'm going to have to spend a fair amount of
time digging into that code and figuring out what makes sense when the time
comes.

The checksum error is highly concerning though - that was related to messing
with cache0/state, correct? I think Christopher is using tiering with
checksumming enabled, can you confirm?
