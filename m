From: Christopher James Halse Rogers <chris@cooperteam.net>
Subject: Re: How to create bcachefs?
Date: Thu, 25 Aug 2016 10:03:07 +1000
Message-ID: <1472083387.31787.0@mail.cooperteam.net>
References: <e6d5ceae4a7dd53daf2667e25b76539b@mejor.pl>
        <20160824065212.fzs2nk3rg7z7iudb@kmo-pixel>
        <f92c1177-565d-47a1-b3ad-1876774003d4@mejor.pl>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Return-path: <linux-bcache-owner@vger.kernel.org>
Received: from mail.cooperteam.net ([150.101.105.211]:58062 "EHLO
        mail.cooperteam.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1757086AbcHYGi3 (ORCPT
        <rfc822;linux-bcache@vger.kernel.org>);
        Thu, 25 Aug 2016 02:38:29 -0400
In-Reply-To: <f92c1177-565d-47a1-b3ad-1876774003d4@mejor.pl>
Sender: linux-bcache-owner@vger.kernel.org
List-Id: linux-bcache@vger.kernel.org
To: marcin@mejor.pl
Cc: linux-bcache@vger.kernel.org

On Thu, Aug 25, 2016 at 7:21 AM, marcin@mejor.pl wrote:
> W dniu 24.08.2016 o 08:52, Kent Overstreet pisze:
> [...]
> 
> Hi!
>> Hey, sorry for the long delay, been sick past several days.
> 
> I was afraid that I'm asking to easy question:) And I hope everything 
> is
> fine with you now!
> 
> 
>> The way arguments
>> were passed to bcache format was a holdover from old style 
>> make-bcache, and
>> didn't make much sense for bcachefs - -C was used for all devices, 
>> and --tier
>> specifies fast devices and slow devices.
>> 
>> I finally got around to redoing the option parsing so we don't need 
>> the -C
>> argument today - update your bcache tools, and the command you want 
>> is now:
>> 
>> bcache format --tier 0 /dev/sde1 --tier 1 /dev/sdd1
>> 
>> (assuming sde1 is your fast device and sdd1 is your slow device).
> 
> Does it means that cache is unavailable and only tiering will be in 
> bcachefs?
> And... How to mount tiered FS? When I pass one device in mount I'm 
> getting:
>  bcache: bch_open_as_blockdevs() register_cache_set err insufficient 
> devices

Tiering gets you all the advantages of caching, plus you can (with some 
effort) have the combined filesystem size be the sum of the SSD + HDD 
capacities, rather than the capacity be determined solely by the 
capacity of the slow tier (this is not currently the case for bcachefs).

To mount a tiered FS you can either pass all the relevant devices to 
mount, like:
    mount -t bcache /dev/sda:/dev/sdb:/dev/sdc /mountpoint
(I haven't tested this recently) or ensure that all the relevant 
devices have been registered with bcache, like so:
    echo /dev/sda | sudo tee /sys/fs/bcache/register_quiet
    echo /dev/sdb | sudo tee /sys/fs/bcache/register_quiet
    echo /dev/sdc | sudo tee /sys/fs/bcache/register_quiet
    mount -t bcache /dev/sdb /mountpoint
(you can use any member of the set as the device to mount in this case).
