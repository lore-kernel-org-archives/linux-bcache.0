From: Kent Overstreet <kent.overstreet@gmail.com>
Subject: Re: Extra write mode to close RAID5 write hole (kind of)
Date: Fri, 28 Oct 2016 03:59:03 -0800
Message-ID: <20161028115903.acsmc3cfemhxgt52@kmo-pixel>
References: <bd0112e0-976a-59e8-94ef-81777f240ffd@pharaoh.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-bcache-owner@vger.kernel.org>
Received: from mail-pf0-f177.google.com ([209.85.192.177]:35817 "EHLO
        mail-pf0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1755071AbcJ1L7H (ORCPT
        <rfc822;linux-bcache@vger.kernel.org>);
        Fri, 28 Oct 2016 07:59:07 -0400
Received: by mail-pf0-f177.google.com with SMTP id s8so36706343pfj.2
        for <linux-bcache@vger.kernel.org>; Fri, 28 Oct 2016 04:59:07 -0700 (PDT)
Content-Disposition: inline
In-Reply-To: <bd0112e0-976a-59e8-94ef-81777f240ffd@pharaoh.uk>
Sender: linux-bcache-owner@vger.kernel.org
List-Id: linux-bcache@vger.kernel.org
To: James Pharaoh <james@pharaoh.uk>
Cc: linux-bcache@vger.kernel.org

On Wed, Oct 26, 2016 at 04:20:38PM +0100, James Pharaoh wrote:
> Since I want my bcache device to essentially be a "journal", and to close
> the RAID5 write hole, I would prefer to disable this behaviour.
> 
> I propose, therefore, a further write mode, in which data is always written
> to the cache first, and synced, before it is written to the underlying
> device. This could be called "journal" perhaps, or something similar.
> 
> I am optimistic that this would be a relatively small change to the code,
> since it only requires to always choose the cache to write data to first.
> Perhaps the sync behaviour is also more complex, I am not familiar with the
> internals.
> 
> So, does anyone have any idea if this is practical, if it would genuinely
> close the write hole, or any other thoughts?

It's not a crazy idea - bcache already has some stripe awareness code that could
be used as a starting point.

The main thing you'd need to do is ensure that
 - all writes are writeback, not writethrough (as you noted)
 - when the writeback thread is flushing dirty data, only flush entire stripes -
   reading more data into the cache if necessary and marking it dirty, then
   ensure that the entire stripe is marked dirty until the entire stripe is
   flushed.

This would basically be using bcache to do full data journalling.

I'm not going to do the work myself - I'd rather spend my time working on adding
erasure coding to bcachefs - but I could help out if you or someone else wanted
to work on adding this to bcache.
