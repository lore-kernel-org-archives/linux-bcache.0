From: Martin McClure <martin.mcclure@gemtalksystems.com>
Subject: Re: bcachefs with cache device and backing device
Date: Tue, 17 May 2016 19:46:33 -0700
Message-ID: <573BD789.9030406@gemtalksystems.com>
References: <573532E2.1040201@gemtalksystems.com>
 <20160513043603.GA1407@kmo-pixel>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Return-path: <linux-bcache-owner@vger.kernel.org>
Received: from 50-240-19-49-static.hfc.comcastbusiness.net ([50.240.19.49]:42129
	"EHLO office-ns.gemtalksystems.com" rhost-flags-OK-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752400AbcERCqf (ORCPT
	<rfc822;linux-bcache@vger.kernel.org>);
	Tue, 17 May 2016 22:46:35 -0400
In-Reply-To: <20160513043603.GA1407@kmo-pixel>
Sender: linux-bcache-owner@vger.kernel.org
List-Id: linux-bcache@vger.kernel.org
To: Kent Overstreet <kent.overstreet@gmail.com>
Cc: linux-bcache@vger.kernel.org

On 05/12/2016 09:36 PM, Kent Overstreet wrote:
> 
> Yeah - tiering replaces cache/backing devices
> 
> IIRC,
> 
> bcache format --tier 0 -C <SSD> --tier 1 -C <spinning rust>
> 
> (the -C is going to go away at some point)
> 

Had a chance to play with this some more, but still not getting it to
work...

Formatting seems to work, and once I do this:

  echo /dev/sdd1 > /sys/fs/bcache/register
  echo /dev/nvme0n1 > /sys/fs/bcache/register
  echo 1 > /sys/fs/bcache/<set-uuid>/blockdev_volume_create

a /dev/bcache0 has been created. However, if I try to mount it:

  mount -t bcache /dev/bcache0 /mnt

it says:

  mount: No such file or directory

with a return code of 32, which is documented as "mount failure".

At this point I reach the limit of my current understanding, but would
like to understand more.

Thanks,

-Martin
