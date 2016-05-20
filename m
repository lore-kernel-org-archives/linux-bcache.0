From: Martin McClure <martin.mcclure@gemtalksystems.com>
Subject: Re: bcachefs with cache device and backing device
Date: Thu, 19 May 2016 18:18:46 -0700
Message-ID: <573E65F6.9090405@gemtalksystems.com>
References: <573532E2.1040201@gemtalksystems.com>
 <20160513043603.GA1407@kmo-pixel> <573BD789.9030406@gemtalksystems.com>
 <20160518040103.GA13870@moria.home.lan>
 <1463547999.21115.1@mail.cooperteam.net>
 <20160518054124.GA1354@moria.home.lan> <573E5D24.604@gemtalksystems.com>
 <1463705056.3733.2@mail.cooperteam.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-bcache-owner@vger.kernel.org>
Received: from 50-240-19-49-static.hfc.comcastbusiness.net ([50.240.19.49]:42161
	"EHLO office-ns.gemtalksystems.com" rhost-flags-OK-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S1754063AbcETBSr (ORCPT
	<rfc822;linux-bcache@vger.kernel.org>);
	Thu, 19 May 2016 21:18:47 -0400
In-Reply-To: <1463705056.3733.2@mail.cooperteam.net>
Sender: linux-bcache-owner@vger.kernel.org
List-Id: linux-bcache@vger.kernel.org
To: Christopher James Halse Rogers <chris@cooperteam.net>
Cc: Kent Overstreet <kent.overstreet@gmail.com>, linux-bcache@vger.kernel.org

On 05/19/2016 05:44 PM, Christopher James Halse Rogers wrote:
>>
>>   bcache format --tier 0 --bucket=512k --cache_mode=writeback \
>>       -C /dev/nvme0n1 \
>>       --tier 1 -C /dev/sdd1
>>
>>   echo /dev/sdd1 > /sys/fs/bcache/register
>>   echo /dev/nvme0n1 > /sys/fs/bcache/register
> 
> You should be able to remove these steps, I think?

Yes, I don't seem to need those.

> 
>>
>>   mount -t bcache /dev/nvme0n1:/dev/sdd1 /mnt/whatever
> 
> If you've pre-registered, you should be able to just
> mount -t bcache /dev/nvme0n1 /mnt/whatever
> or, entirely equivalently:
> mount -t bcache /dev/sdd1 /mnt/whatever
> 

Yes. Looks like I need to *either* explicitly pre-register the devices
*or* specify them both in the mount command.

Thanks for the clarification.

The option that I'm going with for now is:

  bcache format --tier 0 --bucket=512k --cache_mode=writeback \
      -C /dev/nvme0n1 \
      --tier 1 -C /dev/sdd1

  mount -t bcache /dev/nvme0n1:/dev/sdd1 /mnt/whatever

since that shows me both devices in the output of "mount", reminding me
and anyone else trying to figure out what's going on with this machine
that both devices are involved in this filesystem.

Regards,

-Martin
