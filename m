From: Kent Overstreet <kent.overstreet@gmail.com>
Subject: Re: [bcachefs] time of mounting filesystem with high number of dirs
Date: Wed, 7 Sep 2016 13:12:12 -0800
Message-ID: <20160907211212.6pvxo7p5z3v2nvhf@kmo-pixel>
References: <5c0639691edb57d1b63b06effb5283d1@mejor.pl>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-bcache-owner@vger.kernel.org>
Received: from mail-pa0-f65.google.com ([209.85.220.65]:34508 "EHLO
        mail-pa0-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751260AbcIGVMQ (ORCPT
        <rfc822;linux-bcache@vger.kernel.org>);
        Wed, 7 Sep 2016 17:12:16 -0400
Received: by mail-pa0-f65.google.com with SMTP id gi6so1404823pac.1
        for <linux-bcache@vger.kernel.org>; Wed, 07 Sep 2016 14:12:16 -0700 (PDT)
Content-Disposition: inline
In-Reply-To: <5c0639691edb57d1b63b06effb5283d1@mejor.pl>
Sender: linux-bcache-owner@vger.kernel.org
List-Id: linux-bcache@vger.kernel.org
To: Marcin <marcin@mejor.pl>
Cc: linux-bcache@vger.kernel.org

On Wed, Sep 07, 2016 at 10:09:58PM +0200, Marcin wrote:
> Hi!
> I'm aware that performance doesn't have high priority, it's something for
> TODO.
> I created bcachefs on ~10GB partition, copied some files and next I created
> huge number of directories and files. Problem is in the total time needed
> for mounting filesystem.
> # time mount -t bcache /dev/sde1 /mnt/test/
> 
> real    12m20.880s
> user    0m0.000s
> sys     1m18.270s

Oh damn, guess it's time to start working on mount time... I knew this was going
to be an issue sooner or later, but 12 minutes is impressive :)

> I looked at iostat, mounting needs to read from disk 10083588 "kB_read".
> Device has size 10485760kB, so it looks that it reads almost the same amount
> of data as partition size. Maybe mount time can be lower? Maybe there can be
> less reads or reads could be more sequential?

So, right now we're checking i_nlinks on every mount - mainly the dirents
implementation predates the transactional machinery we have now. That's almost
definitely what's taking so long, but I'll send you a patch to confirm later.

It shouldn't take that much work to make the relevant filesystem code
transactional, I'll bump that up on the todo list...
