From: =?UTF-8?Q?Marcin_Miros=c5=82aw?= <marcin@mejor.pl>
Subject: Re: How to create bcachefs?
Date: Thu, 25 Aug 2016 14:11:12 +0200
Message-ID: <13f3920b-638f-bf04-40ec-7cece2c34b78@mejor.pl>
References: <e6d5ceae4a7dd53daf2667e25b76539b@mejor.pl>
 <20160824065212.fzs2nk3rg7z7iudb@kmo-pixel>
 <f92c1177-565d-47a1-b3ad-1876774003d4@mejor.pl>
 <1472083387.31787.0@mail.cooperteam.net>
 <2f1e41df-3f3e-0115-e21b-2f1fb2148934@mejor.pl>
 <1472123394.15072.7@mail.cooperteam.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-13
Content-Transfer-Encoding: 8bit
Return-path: <linux-bcache-owner@vger.kernel.org>
Received: from jowisz.mejor.pl ([81.4.120.72]:44582 "EHLO jowisz.mejor.pl"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1758605AbcHYMSw (ORCPT <rfc822;linux-bcache@vger.kernel.org>);
        Thu, 25 Aug 2016 08:18:52 -0400
In-Reply-To: <1472123394.15072.7@mail.cooperteam.net>
Sender: linux-bcache-owner@vger.kernel.org
List-Id: linux-bcache@vger.kernel.org
To: linux-bcache@vger.kernel.org

W dniu 25.08.2016 o 13:09, Christopher James Halse Rogers pisze:
> 
> 
> On Thu, Aug 25, 2016 at 7:21 PM, Marcin Mirosław <marcin@mejor.pl> wrote:
>> W dniu 25.08.2016 o 02:03, Christopher James Halse Rogers pisze:
>>
>> Hi!
>>
>>>  On Thu, Aug 25, 2016 at 7:21 AM, marcin@mejor.pl wrote:
>> [...]
>>>>  Does it means that cache is unavailable and only tiering will be in
>>>>  bcachefs?
>>>>  And... How to mount tiered FS? When I pass one device in mount I'm
>>>>  getting:
>>>>   bcache: bch_open_as_blockdevs() register_cache_set err insufficient
>>>>  devices
>>>
>>>  Tiering gets you all the advantages of caching, plus you can (with some
>>>  effort) have the combined filesystem size be the sum of the SSD + HDD
>>>  capacities, rather than the capacity be determined solely by the
>>>  capacity of the slow tier (this is not currently the case for
>>> bcachefs).
>>
>> I think that cacheing has at least such advantages over tiering:
>> - allow fast read and write to files compressed with slow alghoritm
>> (gzip)
> 
> I think this is getting into “what should we call this thing”
> arguments. A naive cache is just going to promote the gzipped data to
> the fast storage. On the other end, there's nothing much preventing a
> sophisticated tiering system from compressing/decompressing as a part of
> tier demotion/promotion.

When (de|re)compressing would be part of demotion or promotion then I
agree, cache device doesn't have advantages.

>> - can be optimized for using SSD drives
> 
> It's not clear to me how? Tiering and caching are doing the same sort of
> things.
I don't know how bcachefs handle SSD drives. SSD are faster in
sequential write, I'm not sure if it could be achieved using tier
device. Using cache device on disk format can be different than using in
bcachefs and can turn random writes into sequential writes.

Marcin
