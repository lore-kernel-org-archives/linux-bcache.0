From: Christopher James Halse Rogers <chris@cooperteam.net>
Subject: Re: How to create bcachefs?
Date: Fri, 26 Aug 2016 11:06:50 +1000
Message-ID: <1472173610.31787.2@mail.cooperteam.net>
References: <e6d5ceae4a7dd53daf2667e25b76539b@mejor.pl>
        <20160824065212.fzs2nk3rg7z7iudb@kmo-pixel>
        <f92c1177-565d-47a1-b3ad-1876774003d4@mejor.pl>
        <1472083387.31787.0@mail.cooperteam.net>
        <2f1e41df-3f3e-0115-e21b-2f1fb2148934@mejor.pl>
        <1472123394.15072.7@mail.cooperteam.net>
        <13f3920b-638f-bf04-40ec-7cece2c34b78@mejor.pl>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-bcache-owner@vger.kernel.org>
Received: from mail.cooperteam.net ([150.101.105.211]:47080 "EHLO
        mail.cooperteam.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752541AbcHZBG6 (ORCPT
        <rfc822;linux-bcache@vger.kernel.org>);
        Thu, 25 Aug 2016 21:06:58 -0400
In-Reply-To: <13f3920b-638f-bf04-40ec-7cece2c34b78@mejor.pl>
Sender: linux-bcache-owner@vger.kernel.org
List-Id: linux-bcache@vger.kernel.org
To: Marcin =?UTF-8?b?TWlyb3PFgmF3?= <marcin@mejor.pl>
Cc: linux-bcache@vger.kernel.org



On Thu, Aug 25, 2016 at 10:11 PM, Marcin Miros=C5=82aw <marcin@mejor.pl>=20
wrote:
> W dniu 25.08.2016 o 13:09, Christopher James Halse Rogers pisze:
>>=20
>>=20
>>  On Thu, Aug 25, 2016 at 7:21 PM, Marcin Miros=C3=85=E2=80=9Aaw=20
>> <marcin@mejor.pl> wrote:
>>>  W dniu 25.08.2016 o 02:03, Christopher James Halse Rogers pisze:
>>>=20
>>>  Hi!
>>>=20
>>>>   On Thu, Aug 25, 2016 at 7:21 AM, marcin@mejor.pl wrote:
>>>  [...]
>>>>>   Does it means that cache is unavailable and only tiering will=20
>>>>> be in
>>>>>   bcachefs?
>>>>>   And... How to mount tiered FS? When I pass one device in mount=20
>>>>> I'm
>>>>>   getting:
>>>>>    bcache: bch_open_as_blockdevs() register_cache_set err=20
>>>>> insufficient
>>>>>   devices
>>>>=20
>>>>   Tiering gets you all the advantages of caching, plus you can=20
>>>> (with some
>>>>   effort) have the combined filesystem size be the sum of the SSD=20
>>>> + HDD
>>>>   capacities, rather than the capacity be determined solely by the
>>>>   capacity of the slow tier (this is not currently the case for
>>>>  bcachefs).
>>>=20
>>>  I think that cacheing has at least such advantages over tiering:
>>>  - allow fast read and write to files compressed with slow alghoritm
>>>  (gzip)
>>=20
>>  I think this is getting into =C4=81=E2=82=AC=C5=93what should we call t=
his=20
>> thing=C4=81=E2=82=AC=C2=9D
>>  arguments. A naive cache is just going to promote the gzipped data=20
>> to
>>  the fast storage. On the other end, there's nothing much preventing=20
>> a
>>  sophisticated tiering system from compressing/decompressing as a=20
>> part of
>>  tier demotion/promotion.
>=20
> When (de|re)compressing would be part of demotion or promotion then I
> agree, cache device doesn't have advantages.

You also don't get (de|re)compression for free in a caching strategy=20
depending on where you put your cache. For example, a traditional=20
bcache cache backing a compressed filesystem will only ever see=20
compressed data.

>=20
>>>  - can be optimized for using SSD drives
>>=20
>>  It's not clear to me how? Tiering and caching are doing the same=20
>> sort of
>>  things.
> I don't know how bcachefs handle SSD drives. SSD are faster in
> sequential write, I'm not sure if it could be achieved using tier
> device. Using cache device on disk format can be different than using=20
> in
> bcachefs and can turn random writes into sequential writes.

I believe you mean *HDDs* are faster in sequential write? This is=20
exactly what tiering gets you - all writes go to the fast, SSD=20
storage=C2=B9, and then data are migrated off to the slower HDD in big,=20
sequential chunks.

=C2=B9: Indeed, IIRC this is the only dataloss bug I've found in bcachefs -=
=20
I wrote too much data too fast, the migration from tier 0 to tier 1=20
couldn't keep up, and tier 0 filled up to the point where it could no=20
longer write necessary journal entries, resulting in the filesystem=20
being unmountable.
=
