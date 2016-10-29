From: Kent Overstreet <kent.overstreet@gmail.com>
Subject: Re: Extra write mode to close RAID5 write hole (kind of)
Date: Fri, 28 Oct 2016 16:58:32 -0800
Message-ID: <20161029005832.3iroclcaok7zy5p2@kmo-pixel>
References: <bd0112e0-976a-59e8-94ef-81777f240ffd@pharaoh.uk>
 <20161026223158.GA9283@suse.com>
 <20161028115249.6myzx2ae24n2w4v7@kmo-pixel>
 <6ab21923-caa2-4706-e4dc-83729ff6d111@pharaoh.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-bcache-owner@vger.kernel.org>
Received: from mail-pf0-f175.google.com ([209.85.192.175]:34116 "EHLO
        mail-pf0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S941286AbcJ2A6h (ORCPT
        <rfc822;linux-bcache@vger.kernel.org>);
        Fri, 28 Oct 2016 20:58:37 -0400
Received: by mail-pf0-f175.google.com with SMTP id n85so45429108pfi.1
        for <linux-bcache@vger.kernel.org>; Fri, 28 Oct 2016 17:58:37 -0700 (PDT)
Content-Disposition: inline
In-Reply-To: <6ab21923-caa2-4706-e4dc-83729ff6d111@pharaoh.uk>
Sender: linux-bcache-owner@vger.kernel.org
List-Id: linux-bcache@vger.kernel.org
To: James Pharaoh <james@pharaoh.uk>
Cc: Vojtech Pavlik <vojtech@suse.com>, linux-bcache@vger.kernel.org

On Fri, Oct 28, 2016 at 06:07:21PM +0100, James Pharaoh wrote:
> On 28/10/16 12:52, Kent Overstreet wrote:
> 
> > That's not what the raid 5 hole is. The raid 5 hole comes from the fact that
> > it's not possible to update the p/q blocks atomically with the data blocks, thus
> > there is a point in time when they are _inconsistent_ with the rest of the
> > stripe, and if used will lead to reconstructing incorrect data. There's no way
> > to fix this with just flushes.
> 
> Yes, I understand this, but if the kernel strictly orders writing mdraud
> data blocks before parity ones, then it closes part of the hole, especially
> if I have a "journal" in a higher layer, and of course ensure that this
> journal is reliable.

Ordering cannot help you here. Whichever order you do the writes in, there is a
point in time where the p/q blocks are inconsistent with the data blocks, thus
if you do a reconstruct you will reconstruct incorrect data. Unless you were
writing to the entire stripe, this affects data you were _not_ writing to.

> 
> I also think, however, that by putting bcache /under/ mdraid, and (again)
> ensuring that the bcache layer is reliable, along with the requirement for
> bcache to "journal" all writes, would provide an extremely reliable storage
> layer, even at a very large scale.

What? No, putting bcache under md wouldn't do anything, it couldn't do anything
about the atomicity issue there.

Also - Vojtech - btrfs _is_ subject to the raid5 hole, it would have to be doing
copygc to not be affceted.
