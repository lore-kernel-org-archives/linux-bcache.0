From: Christopher James Halse Rogers <chris@cooperteam.net>
Subject: Re: bcachefs with cache device and backing device
Date: Fri, 20 May 2016 10:44:16 +1000
Message-ID: <1463705056.3733.2@mail.cooperteam.net>
References: <573532E2.1040201@gemtalksystems.com>
	<20160513043603.GA1407@kmo-pixel> <573BD789.9030406@gemtalksystems.com>
	<20160518040103.GA13870@moria.home.lan>
	<1463547999.21115.1@mail.cooperteam.net>
	<20160518054124.GA1354@moria.home.lan> <573E5D24.604@gemtalksystems.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Return-path: <linux-bcache-owner@vger.kernel.org>
Received: from mail.cooperteam.net ([150.101.105.211]:50600 "EHLO
	mail.cooperteam.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754790AbcETAoV (ORCPT
	<rfc822;linux-bcache@vger.kernel.org>);
	Thu, 19 May 2016 20:44:21 -0400
In-Reply-To: <573E5D24.604@gemtalksystems.com>
Sender: linux-bcache-owner@vger.kernel.org
List-Id: linux-bcache@vger.kernel.org
To: Martin McClure <martin.mcclure@gemtalksystems.com>
Cc: Kent Overstreet <kent.overstreet@gmail.com>, linux-bcache@vger.kernel.org

On Fri, May 20, 2016 at 10:41 AM, Martin McClure 
<martin.mcclure@gemtalksystems.com> wrote:
> On 05/17/2016 10:41 PM, Kent Overstreet wrote:
>>  Actually, I just tested and mounting multile devices directly 
>> _does_ work - you
>>  just pass a colon separated list of devices to mount:
>> 
>>  mount -t bcache /dev/sdb:/dev/sdc /mnt
>> 
>>  I could have sworn this was broken, but worked just now...
> 
> This works for me. Thanks for the feedback!
> 
> For any others wanting to walk this path in the near future, here's 
> the
> entire sequence that is working for me (as of kernel and tools pulled 
> on
> 2016-05-13):
> 
>   bcache format --tier 0 --bucket=512k --cache_mode=writeback \
>       -C /dev/nvme0n1 \
>       --tier 1 -C /dev/sdd1
> 
>   echo /dev/sdd1 > /sys/fs/bcache/register
>   echo /dev/nvme0n1 > /sys/fs/bcache/register

You should be able to remove these steps, I think?

> 
>   mount -t bcache /dev/nvme0n1:/dev/sdd1 /mnt/whatever

If you've pre-registered, you should be able to just
mount -t bcache /dev/nvme0n1 /mnt/whatever
or, entirely equivalently:
mount -t bcache /dev/sdd1 /mnt/whatever
