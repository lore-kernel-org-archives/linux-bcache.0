From: Christopher James Halse Rogers <chris@cooperteam.net>
Subject: Re: How to create bcachefs?
Date: Thu, 25 Aug 2016 21:09:54 +1000
Message-ID: <1472123394.15072.7@mail.cooperteam.net>
References: <e6d5ceae4a7dd53daf2667e25b76539b@mejor.pl>
        <20160824065212.fzs2nk3rg7z7iudb@kmo-pixel>
        <f92c1177-565d-47a1-b3ad-1876774003d4@mejor.pl>
        <1472083387.31787.0@mail.cooperteam.net>
        <2f1e41df-3f3e-0115-e21b-2f1fb2148934@mejor.pl>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-13; format=flowed
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-bcache-owner@vger.kernel.org>
Received: from mail.cooperteam.net ([150.101.105.211]:34974 "EHLO
        mail.cooperteam.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752567AbcHYLS2 (ORCPT
        <rfc822;linux-bcache@vger.kernel.org>);
        Thu, 25 Aug 2016 07:18:28 -0400
In-Reply-To: <2f1e41df-3f3e-0115-e21b-2f1fb2148934@mejor.pl>
Sender: linux-bcache-owner@vger.kernel.org
List-Id: linux-bcache@vger.kernel.org
To: Marcin =?UTF-8?b?TWlyb3PFgmF3?= <marcin@mejor.pl>
Cc: linux-bcache@vger.kernel.org



On Thu, Aug 25, 2016 at 7:21 PM, Marcin Miros=C5=82aw <marcin@mejor.pl>=20
wrote:
> W dniu 25.08.2016 o 02:03, Christopher James Halse Rogers pisze:
>=20
> Hi!
>=20
>>  On Thu, Aug 25, 2016 at 7:21 AM, marcin@mejor.pl wrote:
> [...]
>>>  Does it means that cache is unavailable and only tiering will be in
>>>  bcachefs?
>>>  And... How to mount tiered FS? When I pass one device in mount I'm
>>>  getting:
>>>   bcache: bch_open_as_blockdevs() register_cache_set err=20
>>> insufficient
>>>  devices
>>=20
>>  Tiering gets you all the advantages of caching, plus you can (with=20
>> some
>>  effort) have the combined filesystem size be the sum of the SSD +=20
>> HDD
>>  capacities, rather than the capacity be determined solely by the
>>  capacity of the slow tier (this is not currently the case for=20
>> bcachefs).
>=20
> I think that cacheing has at least such advantages over tiering:
> - allow fast read and write to files compressed with slow alghoritm=20
> (gzip)

I think this is getting into =E2=80=9Cwhat should we call this thing=E2=80=
=9D=20
arguments. A naive cache is just going to promote the gzipped data to=20
the fast storage. On the other end, there's nothing much preventing a=20
sophisticated tiering system from compressing/decompressing as a part=20
of tier demotion/promotion.

> - can be optimized for using SSD drives

It's not clear to me how? Tiering and caching are doing the same sort=20
of things.
=
