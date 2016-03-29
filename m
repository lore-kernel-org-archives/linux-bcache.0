From: Pradeep Jindal <praddyjindal@gmail.com>
Subject: Re: 84% -> 60% cache hit ratio for same workflow, different conf
Date: Tue, 29 Mar 2016 11:32:31 +0530
Message-ID: <CANEjr_QxDn9tac-Py3MGHXzUgCHZoaQiu3Eb4VFtJUdMryYrWQ@mail.gmail.com>
References: <CANEjr_S08oB9=3zcmBJktKTHH=NQwad95o2mfsxAeTPTgmL2YQ@mail.gmail.com>
	<20160328191723.GA15859@suse.cz>
	<CANEjr_Tspy0hyNgTQwL38X0jvcNUon_g2HMyoqZFQS+7e2qKow@mail.gmail.com>
	<20160328201907.GA20296@suse.cz>
	<CANEjr_TWKkUB54rYOr84UmKXrGeJdN7c2z5Z-QerwNRT1Lz-9Q@mail.gmail.com>
	<CANEjr_R3csk=C=_9FQ-odgF70FD5imivqh2QBWk=17Z7wR21Sg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-bcache-owner@vger.kernel.org>
Received: from mail-ig0-f172.google.com ([209.85.213.172]:36382 "EHLO
	mail-ig0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752030AbcC2GCc (ORCPT
	<rfc822;linux-bcache@vger.kernel.org>);
	Tue, 29 Mar 2016 02:02:32 -0400
Received: by mail-ig0-f172.google.com with SMTP id nk17so68629256igb.1
        for <linux-bcache@vger.kernel.org>; Mon, 28 Mar 2016 23:02:31 -0700 (PDT)
In-Reply-To: <CANEjr_R3csk=C=_9FQ-odgF70FD5imivqh2QBWk=17Z7wR21Sg@mail.gmail.com>
Sender: linux-bcache-owner@vger.kernel.org
List-Id: linux-bcache@vger.kernel.org
To: Vojtech Pavlik <vojtech@suse.com>
Cc: linux-bcache@vger.kernel.org

On my new configuration the bset unwritten key bytes are non-zero
whereas on older config that is zero:

btree nodes:            1192
written sets:           2377
unwritten sets:         1186
written key bytes:      204048256
unwritten key bytes:    115448
floats:                 68721067953
failed:                 367

What does that indicate?

Also, could you please clarify on how advertising stripe size would
affect writearound cache mode?
- Pradeep Jindal


On Tue, Mar 29, 2016 at 1:56 AM, Pradeep Jindal <praddyjindal@gmail.com> wrote:
> I am using writearound cache mode and have xfs on bcache device
> - Pradeep Jindal
>
>
> On Tue, Mar 29, 2016 at 1:52 AM, Pradeep Jindal <praddyjindal@gmail.com> wrote:
>> But in my new configuration backing device is a bare disk, no LVM, caching
>> device is on LVM though.
>>
>> On Mar 29, 2016 1:49 AM, "Vojtech Pavlik" <vojtech@suse.com> wrote:
>>>
>>> On Tue, Mar 29, 2016 at 01:35:32AM +0530, Pradeep Jindal wrote:
>>>
>>> > > > I am facing a weird problem, I earlier had a configuration wherein
>>> > > > my
>>> > > > backing device was a logical volume (LVM) backed by 3 software RAID0
>>> > > > arrays having 2x1TB disks each, so totally 6TB of storage for
>>> > > > backing
>>> > > > device and 300GB logical volume (LVM) backed by SSD as a caching
>>> > > > device. Both were configured as a cache set and I was getting around
>>> > > > 84% cache hit ratio.
>>> > > >
>>> > > > Now, I have changed the backing device to a bare (no LVM, no raid)
>>> > > > 6TB
>>> > > > disk while everything else stays same (caching device on LVM, 300GB)
>>> > > > and for exactly same workload I am only getting 58-60% cache hit
>>> > > > ratio.
>>> > > >
>>> > > > I am confused, what could be the reason?
>>> > >
>>> > > Full stripe size writes are configured according to the backing
>>> > > device,
>>> > > for example.
>>>
>>> > Didn't quite get it, could you please elaborate?
>>>
>>> Backing devices that advertise a stripe size cause bcache to enable a
>>> mode where it tries to always write a full stripe to the backing
>>> devices, hence changing behavior of the cache.
>>>
>>> --
>>> Vojtech Pavlik
>>> Director SuSE Labs
