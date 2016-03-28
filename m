From: Pradeep Jindal <praddyjindal@gmail.com>
Subject: Re: 84% -> 60% cache hit ratio for same workflow, different conf
Date: Tue, 29 Mar 2016 01:52:56 +0530
Message-ID: <CANEjr_STvKRa+HobUiGHhq-_0egW5b_=OhA6HXDg=bCAQNAagQ@mail.gmail.com>
References: <CANEjr_S08oB9=3zcmBJktKTHH=NQwad95o2mfsxAeTPTgmL2YQ@mail.gmail.com>
	<20160328191723.GA15859@suse.cz>
	<CANEjr_Tspy0hyNgTQwL38X0jvcNUon_g2HMyoqZFQS+7e2qKow@mail.gmail.com>
	<20160328201907.GA20296@suse.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-bcache-owner@vger.kernel.org>
Received: from mail-ig0-f170.google.com ([209.85.213.170]:35440 "EHLO
	mail-ig0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751281AbcC1UW5 (ORCPT
	<rfc822;linux-bcache@vger.kernel.org>);
	Mon, 28 Mar 2016 16:22:57 -0400
Received: by mail-ig0-f170.google.com with SMTP id cl4so60724060igb.0
        for <linux-bcache@vger.kernel.org>; Mon, 28 Mar 2016 13:22:57 -0700 (PDT)
In-Reply-To: <20160328201907.GA20296@suse.cz>
Sender: linux-bcache-owner@vger.kernel.org
List-Id: linux-bcache@vger.kernel.org
To: Vojtech Pavlik <vojtech@suse.com>
Cc: linux-bcache@vger.kernel.org

But in my new configuration backing device is a bare disk, no LVM,
caching device is on LVM though.

- Pradeep Jindal


On Tue, Mar 29, 2016 at 1:49 AM, Vojtech Pavlik <vojtech@suse.com> wrote:
> On Tue, Mar 29, 2016 at 01:35:32AM +0530, Pradeep Jindal wrote:
>
>> > > I am facing a weird problem, I earlier had a configuration wherein my
>> > > backing device was a logical volume (LVM) backed by 3 software RAID0
>> > > arrays having 2x1TB disks each, so totally 6TB of storage for backing
>> > > device and 300GB logical volume (LVM) backed by SSD as a caching
>> > > device. Both were configured as a cache set and I was getting around
>> > > 84% cache hit ratio.
>> > >
>> > > Now, I have changed the backing device to a bare (no LVM, no raid) 6TB
>> > > disk while everything else stays same (caching device on LVM, 300GB)
>> > > and for exactly same workload I am only getting 58-60% cache hit
>> > > ratio.
>> > >
>> > > I am confused, what could be the reason?
>> >
>> > Full stripe size writes are configured according to the backing device,
>> > for example.
>
>> Didn't quite get it, could you please elaborate?
>
> Backing devices that advertise a stripe size cause bcache to enable a
> mode where it tries to always write a full stripe to the backing
> devices, hence changing behavior of the cache.
>
> --
> Vojtech Pavlik
> Director SuSE Labs
