From: Nix <nix@esperi.org.uk>
Subject: Re: [PATCH] bcache: back to cache all readahead I/Os
Date: Wed, 15 Jan 2020 12:39:29 +0000
Message-ID: <875zhc3ncu.fsf@esperi.org.uk>
References: <20200104065802.113137-1-colyli@suse.de>
        <alpine.LRH.2.11.2001062256450.2074@mx.ewheeler.net>
        <87lfqa2p4s.fsf@esperi.org.uk>
        <5af6593d-b6aa-74a7-0aae-e3c689cebc67@suse.de>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-bcache-owner@vger.kernel.org>
Received: from icebox.esperi.org.uk ([81.187.191.129]:52942 "EHLO
        mail.esperi.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725999AbgAOMjf (ORCPT
        <rfc822;linux-bcache@vger.kernel.org>);
        Wed, 15 Jan 2020 07:39:35 -0500
In-Reply-To: <5af6593d-b6aa-74a7-0aae-e3c689cebc67@suse.de> (Coly Li's message
        of "Wed, 15 Jan 2020 14:21:05 +0800")
Sender: linux-bcache-owner@vger.kernel.org
List-Id: linux-bcache@vger.kernel.org
To: Coly Li <colyli@suse.de>
Cc: Eric Wheeler <bcache@lists.ewheeler.net>, linux-bcache@vger.kernel.org, stable@vger.kernel.org

On 15 Jan 2020, Coly Li stated:

> I have two reports offline and directly to me, one is from an email
> address of github and forwarded to me by Jens, one is from a China local
> storage startup.
>
> The first report complains the desktop-pc benchmark is about 50% down
> and the root cause is located on commit b41c9b0 ("bcache: update
> bio->bi_opf bypass/writeback REQ_ flag hints").
>
> The second report complains their small file workload (mixed read and
> write) has around 20%+ performance drop and the suspicious change is
> also focused on the readahead restriction.
>
> The second reporter verifies this patch and confirms the performance
> issue has gone. I don't know who is the first report so no response so far.

Hah! OK, looks like readahead is frequently-enough useful that caching
it is better than not caching it :) I guess the problem is that if you
don't cache it, it never gets cached at all even if it was useful, so
the next time round you'll end up having to readahead it again :/

One wonders what effect this will have on a bcache-atop-RAID: will we
end up caching whole stripes most of the time?
