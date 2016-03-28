From: Pradeep Jindal <praddyjindal@gmail.com>
Subject: Re: 84% -> 60% cache hit ratio for same workflow, different conf
Date: Tue, 29 Mar 2016 01:40:07 +0530
Message-ID: <CANEjr_T+vkUN-b89u9NsFa4bVnBvL9rz9G4s7Q+9zdc_5fwuNw@mail.gmail.com>
References: <CANEjr_S08oB9=3zcmBJktKTHH=NQwad95o2mfsxAeTPTgmL2YQ@mail.gmail.com>
	<20160328191723.GA15859@suse.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-bcache-owner@vger.kernel.org>
Received: from mail-ig0-f170.google.com ([209.85.213.170]:35624 "EHLO
	mail-ig0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751593AbcC1UKI (ORCPT
	<rfc822;linux-bcache@vger.kernel.org>);
	Mon, 28 Mar 2016 16:10:08 -0400
Received: by mail-ig0-f170.google.com with SMTP id cl4so60483046igb.0
        for <linux-bcache@vger.kernel.org>; Mon, 28 Mar 2016 13:10:08 -0700 (PDT)
In-Reply-To: <20160328191723.GA15859@suse.cz>
Sender: linux-bcache-owner@vger.kernel.org
List-Id: linux-bcache@vger.kernel.org
To: Vojtech Pavlik <vojtech@suse.com>
Cc: linux-bcache@vger.kernel.org

Didn't quite get it, could you please elaborate?

- Pradeep Jindal


On Tue, Mar 29, 2016 at 12:47 AM, Vojtech Pavlik <vojtech@suse.com> wrote:
> On Mon, Mar 28, 2016 at 11:47:08PM +0530, Pradeep Jindal wrote:
>> Hi,
>>
>> I am facing a weird problem, I earlier had a configuration wherein my
>> backing device was a logical volume (LVM) backed by 3 software RAID0
>> arrays having 2x1TB disks each, so totally 6TB of storage for backing
>> device and 300GB logical volume (LVM) backed by SSD as a caching
>> device. Both were configured as a cache set and I was getting around
>> 84% cache hit ratio.
>>
>> Now, I have changed the backing device to a bare (no LVM, no raid) 6TB
>> disk while everything else stays same (caching device on LVM, 300GB)
>> and for exactly same workload I am only getting 58-60% cache hit
>> ratio.
>>
>> I am confused, what could be the reason?
>
> Full stripe size writes are configured according to the backing device,
> for example.
>
> --
> Vojtech Pavlik
> Director SuSE Labs
