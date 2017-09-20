From: Michael Lyle <mlyle@lyle.org>
Subject: Re: [PATCH] bcache: smooth writeback rate control
Date: Wed, 20 Sep 2017 13:48:53 -0700
Message-ID: <CAJ+L6qe0qgpqP3iFiT-BZoMpj3kDt5AN+JAUJF354NqH8B_DSg@mail.gmail.com>
References: <20170920071517.30505-1-mlyle@lyle.org> <8a4425d9-2b86-e7d0-f332-3a7ad6b3f706@coly.li>
 <20170920145038.aq2ogavqufuackgd@kmo-pixel> <1137d210-2fc8-5c23-1498-036aee0c19f2@coly.li>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-bcache-owner@vger.kernel.org>
Received: from mail-qt0-f171.google.com ([209.85.216.171]:49566 "EHLO
        mail-qt0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751408AbdITUsz (ORCPT
        <rfc822;linux-bcache@vger.kernel.org>);
        Wed, 20 Sep 2017 16:48:55 -0400
Received: by mail-qt0-f171.google.com with SMTP id o3so3069258qte.6
        for <linux-bcache@vger.kernel.org>; Wed, 20 Sep 2017 13:48:54 -0700 (PDT)
In-Reply-To: <1137d210-2fc8-5c23-1498-036aee0c19f2@coly.li>
Sender: linux-bcache-owner@vger.kernel.org
List-Id: linux-bcache@vger.kernel.org
To: Coly Li <i@coly.li>
Cc: Kent Overstreet <kent.overstreet@gmail.com>, linux-bcache@vger.kernel.org

On Wed, Sep 20, 2017 at 1:24 PM, Coly Li <i@coly.li> wrote:
> My point is, we should have exact real data to approve this change makes
> things better. Better means a problem gets solved. For this single
> patch, I see description on how the change is made, I don't see what
> exact problem to be solved.

OK.  With this change, my workloads always do fewer IOPs during quiet
times.  It often waits 2.5 seconds, instead of waiting 1 second.  The
utilization is clearly more constant, because when it writes more than
4k, it leaves the disk alone for longer.  Before, you were concerned
that setting the minimum writeback rate above 1 sector would
significantly impact performance, so this variant was chosen to
**always do less I/O**.  It should be fairly evident that it does this
:/  When it writes back a 4k key (the smallest key I get), it behaves
exactly the same and sleeps one second.  When it writes back a longer
key, it waits longer.

My other motivation is-- the writeback behavior is problematic-- right
now it writes at exactly the wrong speed for the IronWolf disks-- it
waits barely long enough for things to go into a power-saving / safe
shutdown mode (unloading the head actuator to the side).  The current
behavior maximizes the number of load/unload cycles that the disk
undergoes.  I don't have proof that this leads to earlier drive
failure, but in general "clunk clunk clunk" is not good.  At least
with this code it will do it half as much, pending further changes to
mitigate this more.

> The P.I controller patch makes sense. But for this single patch, change
> minimum writeback rate from 1 to 8, and next delay timeout from 1 to 2.5
> seconds, I don't see this modification is path towards getting things
> more understandable, before we see real data to approve it.
>
> This is why I said: again, I'd like to see exact data here. Let me
> discuss with Micheal for more details.

What do you want to see, iostat 1 of background writeback with current
code showing it is never doing less than 4k to the backing disks?
Because I have several thousand seconds of that.  If you have any
installation of current bcache you should be able to do just run it
and see.

Mike
