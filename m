From: Kent Overstreet <kmo@daterainc.com>
Subject: Re: bcache_writebac task 100% CPU
Date: Mon, 19 May 2014 09:55:50 -0700
Message-ID: <20140519165550.GD2276@kmo>
References: <53786E02.8060300@rolffokkens.nl>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-bcache-owner@vger.kernel.org>
Received: from mail-pb0-f46.google.com ([209.85.160.46]:32773 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932574AbaESQzx (ORCPT
	<rfc822;linux-bcache@vger.kernel.org>);
	Mon, 19 May 2014 12:55:53 -0400
Received: by mail-pb0-f46.google.com with SMTP id rq2so6120106pbb.19
        for <linux-bcache@vger.kernel.org>; Mon, 19 May 2014 09:55:53 -0700 (PDT)
Content-Disposition: inline
In-Reply-To: <53786E02.8060300@rolffokkens.nl>
Sender: linux-bcache-owner@vger.kernel.org
List-Id: linux-bcache@vger.kernel.org
To: Rolf Fokkens <rolf@rolffokkens.nl>
Cc: linux-bcache@vger.kernel.org

On Sun, May 18, 2014 at 10:23:30AM +0200, Rolf Fokkens wrote:
> Sometimes bcache_writebac task consumes 100% CPU during normal operation, but after a while (like a minute) this drops to normal.
> 
> It can be triggered in a reproducable fashion on my system by:
> 
> echo 0 > /sys/block/bcache0/bcache/writeback_percent
> 
> After this bcache_writebac starts to burn CPU cycles, and it never seems to stop doing so. changing the writeback_percent value back to 25 doesn't change anything.
> 
> Apart from a busy CPU there appear to be no problem (e.g. no "task bcache_writebac:286 blocked for more than 120 seconds" messages).

...Changing it back to 25% doesn't do anything? _that_ is odd...

Can you send me the output of writeback_rate_debug? Check it once before you've
done anything, when things are working normally (after a fresh boot when
writeback_percent is nonzero, probably), then grab it again after you've set
writeback_percent to 0 and then back to 25, when it's still spinning.

There seems to be two separate bugs here, the one I'm particularly concerned
about is why setting writeback_percent back to 25 doesn't restore the old
behaviour.

Also, what kernel are you running?
