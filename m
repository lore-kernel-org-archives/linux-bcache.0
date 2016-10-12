From: Kent Overstreet <kent.overstreet@gmail.com>
Subject: Re: [bcachefs][tier] INFO: task bch_tier_read:21414 blocked for more
 than 120 seconds.
Date: Wed, 12 Oct 2016 04:11:05 -0800
Message-ID: <20161012121105.ym3sed4tgc2vx3dh@kmo-pixel>
References: <ebd2b9da9ab215488fd59797d8d1d67d@mejor.pl>
 <20161012012600.s2cq5ac37hwwrp3e@kmo-pixel>
 <b96021dc-9eaa-ea03-291f-1612d73f49c4@mejor.pl>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Return-path: <linux-bcache-owner@vger.kernel.org>
Received: from mail-pa0-f52.google.com ([209.85.220.52]:32804 "EHLO
        mail-pa0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752053AbcJLMLJ (ORCPT
        <rfc822;linux-bcache@vger.kernel.org>);
        Wed, 12 Oct 2016 08:11:09 -0400
Received: by mail-pa0-f52.google.com with SMTP id vu5so27814685pab.0
        for <linux-bcache@vger.kernel.org>; Wed, 12 Oct 2016 05:11:09 -0700 (PDT)
Content-Disposition: inline
In-Reply-To: <b96021dc-9eaa-ea03-291f-1612d73f49c4@mejor.pl>
Sender: linux-bcache-owner@vger.kernel.org
List-Id: linux-bcache@vger.kernel.org
To: Marcin =?utf-8?B?TWlyb3PFgmF3?= <marcin@mejor.pl>
Cc: linux-bcache@vger.kernel.org

On Wed, Oct 12, 2016 at 01:07:46PM +0200, Marcin Mirosław wrote:
> W dniu 12.10.2016 o 03:26, Kent Overstreet pisze:
> Hi,
> [...]
> > You're not the only one who's seeing this, I've been chasing this bug for the
> > past several days...
> > 
> 
> Is something that can be done on my side to help with it?
> I can add information that tier0 device is a device with short time of
> writing requests - it's a HW controller with RAM. Second bling shot is
> that using btree-node=256k was problematic some time ago:
> http://www.spinics.net/lists/linux-bcache/msg04178.html , maybe this is
> somehow related to the btree-node size?

It turns out it's not a bcache bug - FUA is buggy...

If you want, you could confirm by changing journal_flushes_device() to always
return true - journal.h line 85.

Gonna try and figure out what the actual FUA bug is tomorrow...
