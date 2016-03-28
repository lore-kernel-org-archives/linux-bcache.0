From: Pradeep Jindal <praddyjindal@gmail.com>
Subject: Re: 84% -> 60% cache hit ratio for same workflow, different conf
Date: Tue, 29 Mar 2016 01:56:30 +0530
Message-ID: <CANEjr_R3csk=C=_9FQ-odgF70FD5imivqh2QBWk=17Z7wR21Sg@mail.gmail.com>
References: <CANEjr_S08oB9=3zcmBJktKTHH=NQwad95o2mfsxAeTPTgmL2YQ@mail.gmail.com>
	<20160328191723.GA15859@suse.cz>
	<CANEjr_Tspy0hyNgTQwL38X0jvcNUon_g2HMyoqZFQS+7e2qKow@mail.gmail.com>
	<20160328201907.GA20296@suse.cz>
	<CANEjr_TWKkUB54rYOr84UmKXrGeJdN7c2z5Z-QerwNRT1Lz-9Q@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-bcache-owner@vger.kernel.org>
Received: from mail-ig0-f180.google.com ([209.85.213.180]:34446 "EHLO
	mail-ig0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751281AbcC1U0b (ORCPT
	<rfc822;linux-bcache@vger.kernel.org>);
	Mon, 28 Mar 2016 16:26:31 -0400
Received: by mail-ig0-f180.google.com with SMTP id av4so61579027igc.1
        for <linux-bcache@vger.kernel.org>; Mon, 28 Mar 2016 13:26:31 -0700 (PDT)
In-Reply-To: <CANEjr_TWKkUB54rYOr84UmKXrGeJdN7c2z5Z-QerwNRT1Lz-9Q@mail.gmail.com>
Sender: linux-bcache-owner@vger.kernel.org
List-Id: linux-bcache@vger.kernel.org
To: Vojtech Pavlik <vojtech@suse.com>
Cc: linux-bcache@vger.kernel.org

I am using writearound cache mode and have xfs on bcache device
- Pradeep Jindal


On Tue, Mar 29, 2016 at 1:52 AM, Pradeep Jindal <praddyjindal@gmail.com> wrote:
> But in my new configuration backing device is a bare disk, no LVM, caching
> device is on LVM though.
>
> On Mar 29, 2016 1:49 AM, "Vojtech Pavlik" <vojtech@suse.com> wrote:
>>
>> On Tue, Mar 29, 2016 at 01:35:32AM +0530, Pradeep Jindal wrote:
>>
>> > > > I am facing a weird problem, I earlier had a configuration wherein
>> > > > my
>> > > > backing device was a logical volume (LVM) backed by 3 software RAID0
>> > > > arrays having 2x1TB disks each, so totally 6TB of storage for
>> > > > backing
>> > > > device and 300GB logical volume (LVM) backed by SSD as a caching
>> > > > device. Both were configured as a cache set and I was getting around
>> > > > 84% cache hit ratio.
>> > > >
>> > > > Now, I have changed the backing device to a bare (no LVM, no raid)
>> > > > 6TB
>> > > > disk while everything else stays same (caching device on LVM, 300GB)
>> > > > and for exactly same workload I am only getting 58-60% cache hit
>> > > > ratio.
>> > > >
>> > > > I am confused, what could be the reason?
>> > >
>> > > Full stripe size writes are configured according to the backing
>> > > device,
>> > > for example.
>>
>> > Didn't quite get it, could you please elaborate?
>>
>> Backing devices that advertise a stripe size cause bcache to enable a
>> mode where it tries to always write a full stripe to the backing
>> devices, hence changing behavior of the cache.
>>
>> --
>> Vojtech Pavlik
>> Director SuSE Labs
