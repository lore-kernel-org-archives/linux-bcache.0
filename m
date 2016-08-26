From: =?UTF-8?Q?Marcin_Miros=c5=82aw?= <marcin@mejor.pl>
Subject: Re: [bcachefs][tier] kernel BUG at drivers/md/bcache/super.c:1561!
 after double changing state of device
Date: Fri, 26 Aug 2016 11:00:03 +0200
Message-ID: <9d7942f4-4e8b-92b5-20de-5c7bec07f902@mejor.pl>
References: <d29af387-c549-345d-974a-ee21047978ad@mejor.pl>
 <ca2d4c8e-37bc-bc63-3153-3a089c54ccc4@mejor.pl>
 <a38921be-e827-d227-6e86-3713f42db09c@mejor.pl>
 <3bfada34-3dd7-8e28-036a-8c027848f90d@mejor.pl>
 <20160826021029.upgpx4iji2opabjw@kmo-pixel>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Return-path: <linux-bcache-owner@vger.kernel.org>
Received: from jowisz.mejor.pl ([81.4.120.72]:58694 "EHLO jowisz.mejor.pl"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752104AbcHZJEA (ORCPT <rfc822;linux-bcache@vger.kernel.org>);
        Fri, 26 Aug 2016 05:04:00 -0400
In-Reply-To: <20160826021029.upgpx4iji2opabjw@kmo-pixel>
Sender: linux-bcache-owner@vger.kernel.org
List-Id: linux-bcache@vger.kernel.org
To: Kent Overstreet <kent.overstreet@gmail.com>
Cc: linux-bcache@vger.kernel.org

W dniu 26.08.2016 o 04:10, Kent Overstreet pisze:
> On Thu, Aug 25, 2016 at 02:03:33PM +0200, Marcin Mirosław wrote:
>> https://lwn.net/Articles/655183/ :
>> "Caveat: don't try to use tiering and checksumming or compression at the
>> same time yet, the read path needs to be reworked to handle both at the
>> same time."
>>
>> Is it sill valid?
> 
> No, I did do that read path reworking, they should work.
> 
> However, I haven't been focusing on or exercising the multi device stuff in
> quite awhile - my main priority has been making single device filesystems rock
> solid and finishing off compression and such.
> 
> Tiering ought to work, but can you hold off on exercising anything else? e.g.
> the active/RO transition stuff - I'm going to have to spend a fair amount of
> time digging into that code and figuring out what makes sense when the time
> comes.

Ok, I'll focuse on one disk bcachefs.


> The checksum error is highly concerning though - that was related to messing
> with cache0/state, correct? I think Christopher is using tiering with
> checksumming enabled, can you confirm?

Yes, I only did echo "readonly", next "active" to >state. It was enough
to get BUG in kern.log.

Marcin
