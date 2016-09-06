From: Kent Overstreet <kent.overstreet@gmail.com>
Subject: Re: How well does bcache cope with frequently changing cache device?
Date: Mon, 5 Sep 2016 18:27:32 -0800
Message-ID: <20160906022732.2y4dubiwcfmo6dkz@kmo-pixel>
References: <CAFvQSYTEMFptL92JhbGgKRNEkFFLm5z5nZM1hksSSeon2bX=dA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-bcache-owner@vger.kernel.org>
Received: from mail-pa0-f48.google.com ([209.85.220.48]:33726 "EHLO
        mail-pa0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752345AbcIFC1g (ORCPT
        <rfc822;linux-bcache@vger.kernel.org>);
        Mon, 5 Sep 2016 22:27:36 -0400
Received: by mail-pa0-f48.google.com with SMTP id cm16so18476005pac.0
        for <linux-bcache@vger.kernel.org>; Mon, 05 Sep 2016 19:27:36 -0700 (PDT)
Content-Disposition: inline
In-Reply-To: <CAFvQSYTEMFptL92JhbGgKRNEkFFLm5z5nZM1hksSSeon2bX=dA@mail.gmail.com>
Sender: linux-bcache-owner@vger.kernel.org
List-Id: linux-bcache@vger.kernel.org
To: Clemens Eisserer <linuxhippy@gmail.com>
Cc: linux-bcache@vger.kernel.org

On Sun, Sep 04, 2016 at 07:08:04PM +0200, Clemens Eisserer wrote:
> Hi,
> 
> I am thinking about working with a root-fs on an external disk which
> can be shared amongst different computers.
> For this use-case the internal SSD could be used as caching device,
> speeding up the access to the relativly slow external storage.
> 
> What I wonder is how well bcache can cope with changing caching
> devices? Great would be if bcache could detect when a backing decive
> was used with a different caching device in the meantime and
> automatically invalidate the old/stale caching device - but to keep
> the cache unmodified when this was not the case.
> 
> Is this use-case possible with bcache?

On its own bcache won't automatically invalidate the cached data - once a
backing device is associated with a certain cache, that backing device won't
come online until either the cache device is registered, or you detach it.

So you'll have to write your own scripts to check - "hey, is this backing device
associated with this cache device? if not, detach backing device, reformat cache
device, then attach cache device and backing device".
