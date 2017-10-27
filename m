From: Eric Wheeler <bcache@lists.ewheeler.net>
Subject: Re: [PATCHv4] bcache: only permit to recovery read error when cache
 device is clean
Date: Fri, 27 Oct 2017 21:13:57 +0000 (UTC)
Message-ID: <alpine.LRH.2.11.1710272111120.24585@mail.ewheeler.net>
References: <20171016180428.123657-1-colyli@suse.de> <alpine.LRH.2.11.1710271955340.24585@mail.ewheeler.net> <CAJ+L6qeSP6OLkaNBs1N0=D5=4hz3wDa2UcZfRSKHUM_rxZFpTQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-bcache-owner@vger.kernel.org>
Received: from mx.ewheeler.net ([66.155.3.69]:55536 "EHLO mail.ewheeler.net"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1750781AbdJ0VN7 (ORCPT <rfc822;linux-bcache@vger.kernel.org>);
        Fri, 27 Oct 2017 17:13:59 -0400
In-Reply-To: <CAJ+L6qeSP6OLkaNBs1N0=D5=4hz3wDa2UcZfRSKHUM_rxZFpTQ@mail.gmail.com>
Sender: linux-bcache-owner@vger.kernel.org
List-Id: linux-bcache@vger.kernel.org
To: Michael Lyle <mlyle@lyle.org>
Cc: Coly Li <colyli@suse.de>, linux-bcache@vger.kernel.org, linux-block@vger.kernel.org, Kent Overstreet <kent.overstreet@gmail.com>, Nix <nix@esperi.org.uk>, Kai Krakow <hurikhan77@gmail.com>, Junhui Tang <tang.junhui@zte.com.cn>, stable@vger.kernel.org

On Fri, 27 Oct 2017, Michael Lyle wrote:

> On Fri, Oct 27, 2017 at 12:57 PM, Eric Wheeler
> <bcache@lists.ewheeler.net> wrote:
> > Can this be relaxed to only error when the key failing to read is dirty?
> > The liklihood of a 100% clean cache in writeback on a busy system seems
> > unlikely.
> >
> > Can KEY_DIRTY facilitate this?
> 
> Don't we only have the metadata to know if the key is dirty on the
> cache if we have the cache device? ;)

Certainly if this is for removal or a missing cache (perhaps I missed 
that).

However, I thought this was just a recovery on an IO error where the disk 
might be mostly dead--but partly alive!

Of course if the metadata lookup fails subsequently, then you would need 
to fall back to the dc->has_dirty flag.

--
Eric Wheeler



> 
> Mike
> --
> To unsubscribe from this list: send the line "unsubscribe linux-bcache" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
