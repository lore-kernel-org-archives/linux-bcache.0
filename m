From: Christopher James Halse Rogers <chris@cooperteam.net>
Subject: Re: [bcachefs][tier] kernel BUG at drivers/md/bcache/super.c:1561!
 after double changing state of device
Date: Fri, 26 Aug 2016 12:17:17 +1000
Message-ID: <1472177837.31787.3@mail.cooperteam.net>
References: <d29af387-c549-345d-974a-ee21047978ad@mejor.pl>
        <ca2d4c8e-37bc-bc63-3153-3a089c54ccc4@mejor.pl>
        <a38921be-e827-d227-6e86-3713f42db09c@mejor.pl>
        <3bfada34-3dd7-8e28-036a-8c027848f90d@mejor.pl>
        <20160826021029.upgpx4iji2opabjw@kmo-pixel>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-2; format=flowed
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-bcache-owner@vger.kernel.org>
Received: from mail.cooperteam.net ([150.101.105.211]:47712 "EHLO
        mail.cooperteam.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751972AbcHZCRV (ORCPT
        <rfc822;linux-bcache@vger.kernel.org>);
        Thu, 25 Aug 2016 22:17:21 -0400
Received: from [192.168.188.40] (unknown [192.168.1.1])
        (using TLSv1 with cipher ECDHE-ECDSA-AES256-SHA (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: chris)
        by mail.cooperteam.net (Postfix) with ESMTPSA id 3C55E75FB30
        for <linux-bcache@vger.kernel.org>; Fri, 26 Aug 2016 12:17:18 +1000 (AEST)
In-Reply-To: <20160826021029.upgpx4iji2opabjw@kmo-pixel>
Sender: linux-bcache-owner@vger.kernel.org
List-Id: linux-bcache@vger.kernel.org
To: linux-bcache@vger.kernel.org



On Fri, Aug 26, 2016 at 12:10 PM, Kent Overstreet=20
<kent.overstreet@gmail.com> wrote:
> On Thu, Aug 25, 2016 at 02:03:33PM +0200, Marcin Miros=C5=82aw wrote:
>>  https://lwn.net/Articles/655183/ :
>>  "Caveat: don't try to use tiering and checksumming or compression=20
>> at the
>>  same time yet, the read path needs to be reworked to handle both at=20
>> the
>>  same time."
>>=20
>>  Is it sill valid?
>=20
> No, I did do that read path reworking, they should work.
>=20
> However, I haven't been focusing on or exercising the multi device=20
> stuff in
> quite awhile - my main priority has been making single device=20
> filesystems rock
> solid and finishing off compression and such.
>=20
> Tiering ought to work, but can you hold off on exercising anything=20
> else? e.g.
> the active/RO transition stuff - I'm going to have to spend a fair=20
> amount of
> time digging into that code and figuring out what makes sense when=20
> the time
> comes.
>=20
> The checksum error is highly concerning though - that was related to=20
> messing
> with cache0/state, correct? I think Christopher is using tiering with
> checksumming enabled, can you confirm?

Yup. I've got two tiered filesystems; one nvme in front of two HDDs=20
with crc32 checksums, and one regular SSD in front of a HDD with crc32=20
and lz4 compression.

Neither have had significant problems.
=
