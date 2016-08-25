From: =?UTF-8?Q?Marcin_Miros=c5=82aw?= <marcin@mejor.pl>
Subject: Re: How to create bcachefs?
Date: Thu, 25 Aug 2016 11:21:47 +0200
Message-ID: <2f1e41df-3f3e-0115-e21b-2f1fb2148934@mejor.pl>
References: <e6d5ceae4a7dd53daf2667e25b76539b@mejor.pl>
 <20160824065212.fzs2nk3rg7z7iudb@kmo-pixel>
 <f92c1177-565d-47a1-b3ad-1876774003d4@mejor.pl>
 <1472083387.31787.0@mail.cooperteam.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Return-path: <linux-bcache-owner@vger.kernel.org>
Received: from jowisz.mejor.pl ([81.4.120.72]:34439 "EHLO jowisz.mejor.pl"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751540AbcHYJ0V (ORCPT <rfc822;linux-bcache@vger.kernel.org>);
        Thu, 25 Aug 2016 05:26:21 -0400
In-Reply-To: <1472083387.31787.0@mail.cooperteam.net>
Sender: linux-bcache-owner@vger.kernel.org
List-Id: linux-bcache@vger.kernel.org
To: linux-bcache@vger.kernel.org

W dniu 25.08.2016 o 02:03, Christopher James Halse Rogers pisze:

Hi!

> On Thu, Aug 25, 2016 at 7:21 AM, marcin@mejor.pl wrote:
[...]
>> Does it means that cache is unavailable and only tiering will be in
>> bcachefs?
>> And... How to mount tiered FS? When I pass one device in mount I'm
>> getting:
>>  bcache: bch_open_as_blockdevs() register_cache_set err insufficient
>> devices
> 
> Tiering gets you all the advantages of caching, plus you can (with some
> effort) have the combined filesystem size be the sum of the SSD + HDD
> capacities, rather than the capacity be determined solely by the
> capacity of the slow tier (this is not currently the case for bcachefs).

I think that cacheing has at least such advantages over tiering:
- allow fast read and write to files compressed with slow alghoritm (gzip)
- can be optimized for using SSD drives

> To mount a tiered FS you can either pass all the relevant devices to
> mount, like:
>    mount -t bcache /dev/sda:/dev/sdb:/dev/sdc /mountpoint
> (I haven't tested this recently) or ensure that all the relevant devices
> have been registered with bcache, like so:
>    echo /dev/sda | sudo tee /sys/fs/bcache/register_quiet
>    echo /dev/sdb | sudo tee /sys/fs/bcache/register_quiet
>    echo /dev/sdc | sudo tee /sys/fs/bcache/register_quiet
>    mount -t bcache /dev/sdb /mountpoint
> (you can use any member of the set as the device to mount in this case).


Thanks for tip, good to know other way to mount.

Marcin
