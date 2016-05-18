From: Christopher James Halse Rogers <chris@cooperteam.net>
Subject: Re: bcachefs with cache device and backing device
Date: Wed, 18 May 2016 15:06:39 +1000
Message-ID: <1463547999.21115.1@mail.cooperteam.net>
References: <573532E2.1040201@gemtalksystems.com>
	<20160513043603.GA1407@kmo-pixel> <573BD789.9030406@gemtalksystems.com>
	<20160518040103.GA13870@moria.home.lan>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Return-path: <linux-bcache-owner@vger.kernel.org>
Received: from mail.cooperteam.net ([150.101.105.211]:37074 "EHLO
	mail.cooperteam.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750760AbcERFMp (ORCPT
	<rfc822;linux-bcache@vger.kernel.org>);
	Wed, 18 May 2016 01:12:45 -0400
In-Reply-To: <20160518040103.GA13870@moria.home.lan>
Sender: linux-bcache-owner@vger.kernel.org
List-Id: linux-bcache@vger.kernel.org
To: Kent Overstreet <kent.overstreet@gmail.com>
Cc: Martin McClure <martin.mcclure@gemtalksystems.com>, linux-bcache@vger.kernel.org

On Wed, May 18, 2016 at 2:01 PM, Kent Overstreet 
<kent.overstreet@gmail.com> wrote:
> On Tue, May 17, 2016 at 07:46:33PM -0700, Martin McClure wrote:
>>  On 05/12/2016 09:36 PM, Kent Overstreet wrote:
>>  >
>>  > Yeah - tiering replaces cache/backing devices
>>  >
>>  > IIRC,
>>  >
>>  > bcache format --tier 0 -C <SSD> --tier 1 -C <spinning rust>
>>  >
>>  > (the -C is going to go away at some point)
>>  >
>> 
>>  Had a chance to play with this some more, but still not getting it 
>> to
>>  work...
>> 
>>  Formatting seems to work, and once I do this:
>> 
>>    echo /dev/sdd1 > /sys/fs/bcache/register
>>    echo /dev/nvme0n1 > /sys/fs/bcache/register
>>    echo 1 > /sys/fs/bcache/<set-uuid>/blockdev_volume_create
>> 
>>  a /dev/bcache0 has been created. However, if I try to mount it:
>> 
>>    mount -t bcache /dev/bcache0 /mnt
>> 
>>  it says:
>> 
>>    mount: No such file or directory
>> 
>>  with a return code of 32, which is documented as "mount failure".
>> 
>>  At this point I reach the limit of my current understanding, but 
>> would
>>  like to understand more.
> 
> The intended mount path for multi device filesystems is currently 
> broken...
> Chris got it working (to my surprise) by - I belive - registering all 
> the
> devices via /sys/fs/bcache/register, and then mounting just one of 
> the block
> devices - Chris, is that correct?

That is indeed correct. Once the volume has all its components 
registered, it can be mounted by any of the block devices.
