From: Martin McClure <martin.mcclure@gemtalksystems.com>
Subject: Re: bcachefs with cache device and backing device
Date: Thu, 19 May 2016 17:41:08 -0700
Message-ID: <573E5D24.604@gemtalksystems.com>
References: <573532E2.1040201@gemtalksystems.com>
 <20160513043603.GA1407@kmo-pixel> <573BD789.9030406@gemtalksystems.com>
 <20160518040103.GA13870@moria.home.lan>
 <1463547999.21115.1@mail.cooperteam.net>
 <20160518054124.GA1354@moria.home.lan>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Return-path: <linux-bcache-owner@vger.kernel.org>
Received: from 50-240-19-49-static.hfc.comcastbusiness.net ([50.240.19.49]:42158
	"EHLO office-ns.gemtalksystems.com" rhost-flags-OK-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S1754988AbcETAlL (ORCPT
	<rfc822;linux-bcache@vger.kernel.org>);
	Thu, 19 May 2016 20:41:11 -0400
In-Reply-To: <20160518054124.GA1354@moria.home.lan>
Sender: linux-bcache-owner@vger.kernel.org
List-Id: linux-bcache@vger.kernel.org
To: Kent Overstreet <kent.overstreet@gmail.com>, Christopher James Halse Rogers <chris@cooperteam.net>
Cc: linux-bcache@vger.kernel.org

On 05/17/2016 10:41 PM, Kent Overstreet wrote:
> Actually, I just tested and mounting multile devices directly _does_ work - you
> just pass a colon separated list of devices to mount:
> 
> mount -t bcache /dev/sdb:/dev/sdc /mnt
> 
> I could have sworn this was broken, but worked just now...

This works for me. Thanks for the feedback!

For any others wanting to walk this path in the near future, here's the
entire sequence that is working for me (as of kernel and tools pulled on
2016-05-13):

  bcache format --tier 0 --bucket=512k --cache_mode=writeback \
      -C /dev/nvme0n1 \
      --tier 1 -C /dev/sdd1

  echo /dev/sdd1 > /sys/fs/bcache/register
  echo /dev/nvme0n1 > /sys/fs/bcache/register
  mount -t bcache /dev/nvme0n1:/dev/sdd1 /mnt/whatever

Regards,

-Martin
