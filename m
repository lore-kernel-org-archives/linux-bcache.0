From: Michael Lyle <mlyle@lyle.org>
Subject: Re: [PATCHv4] bcache: only permit to recovery read error when cache
 device is clean
Date: Fri, 27 Oct 2017 14:24:53 -0700
Message-ID: <CAJ+L6qdZekS4hTFwXG6oSHuXEuVODW1PRWh3j62RJDMWj9EXgw@mail.gmail.com>
References: <20171016180428.123657-1-colyli@suse.de> <alpine.LRH.2.11.1710271955340.24585@mail.ewheeler.net>
 <CAJ+L6qeSP6OLkaNBs1N0=D5=4hz3wDa2UcZfRSKHUM_rxZFpTQ@mail.gmail.com> <alpine.LRH.2.11.1710272111120.24585@mail.ewheeler.net>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-bcache-owner@vger.kernel.org>
Received: from mail-qt0-f171.google.com ([209.85.216.171]:53378 "EHLO
        mail-qt0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750781AbdJ0VYz (ORCPT
        <rfc822;linux-bcache@vger.kernel.org>);
        Fri, 27 Oct 2017 17:24:55 -0400
Received: by mail-qt0-f171.google.com with SMTP id n61so10067059qte.10
        for <linux-bcache@vger.kernel.org>; Fri, 27 Oct 2017 14:24:55 -0700 (PDT)
In-Reply-To: <alpine.LRH.2.11.1710272111120.24585@mail.ewheeler.net>
Sender: linux-bcache-owner@vger.kernel.org
List-Id: linux-bcache@vger.kernel.org
To: Eric Wheeler <bcache@lists.ewheeler.net>
Cc: Coly Li <colyli@suse.de>, linux-bcache@vger.kernel.org, linux-block@vger.kernel.org, Kent Overstreet <kent.overstreet@gmail.com>, Nix <nix@esperi.org.uk>, Kai Krakow <hurikhan77@gmail.com>, Junhui Tang <tang.junhui@zte.com.cn>, stable@vger.kernel.org

On Fri, Oct 27, 2017 at 2:13 PM, Eric Wheeler <bcache@lists.ewheeler.net> wrote:
[snip]
>> > Can KEY_DIRTY facilitate this?
>>
>> Don't we only have the metadata to know if the key is dirty on the
>> cache if we have the cache device? ;)
>
> Certainly if this is for removal or a missing cache (perhaps I missed
> that).
>
> However, I thought this was just a recovery on an IO error where the disk
> might be mostly dead--but partly alive!
>
> Of course if the metadata lookup fails subsequently, then you would need
> to fall back to the dc->has_dirty flag.

Seems like something that's a lot of effort for little gain.  It'll
only help when A) everything you need isn't dirty, and B) all the
associated btree nodes are in memory.  Since bcache tries to keep 10%
dirty by default, and it's likely to be heavy on filesystem metadata--
I don't know how often this would help anyone in the real world.

Mike
