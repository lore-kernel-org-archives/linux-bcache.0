From: Vojtech Pavlik <vojtech@suse.com>
Subject: Re: 84% -> 60% cache hit ratio for same workflow, different conf
Date: Mon, 28 Mar 2016 22:19:07 +0200
Message-ID: <20160328201907.GA20296@suse.cz>
References: <CANEjr_S08oB9=3zcmBJktKTHH=NQwad95o2mfsxAeTPTgmL2YQ@mail.gmail.com>
 <20160328191723.GA15859@suse.cz>
 <CANEjr_Tspy0hyNgTQwL38X0jvcNUon_g2HMyoqZFQS+7e2qKow@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-bcache-owner@vger.kernel.org>
Received: from jablonecka.jablonka.cz ([91.219.244.36]:36125 "EHLO
	jablonecka.jablonka.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751281AbcC1UTJ (ORCPT
	<rfc822;linux-bcache@vger.kernel.org>);
	Mon, 28 Mar 2016 16:19:09 -0400
Content-Disposition: inline
In-Reply-To: <CANEjr_Tspy0hyNgTQwL38X0jvcNUon_g2HMyoqZFQS+7e2qKow@mail.gmail.com>
Sender: linux-bcache-owner@vger.kernel.org
List-Id: linux-bcache@vger.kernel.org
To: Pradeep Jindal <praddyjindal@gmail.com>
Cc: linux-bcache@vger.kernel.org

On Tue, Mar 29, 2016 at 01:35:32AM +0530, Pradeep Jindal wrote:

> > > I am facing a weird problem, I earlier had a configuration wherein my
> > > backing device was a logical volume (LVM) backed by 3 software RAID0
> > > arrays having 2x1TB disks each, so totally 6TB of storage for backing
> > > device and 300GB logical volume (LVM) backed by SSD as a caching
> > > device. Both were configured as a cache set and I was getting around
> > > 84% cache hit ratio.
> > >
> > > Now, I have changed the backing device to a bare (no LVM, no raid) 6TB
> > > disk while everything else stays same (caching device on LVM, 300GB)
> > > and for exactly same workload I am only getting 58-60% cache hit
> > > ratio.
> > >
> > > I am confused, what could be the reason?
> >
> > Full stripe size writes are configured according to the backing device,
> > for example.

> Didn't quite get it, could you please elaborate?

Backing devices that advertise a stripe size cause bcache to enable a
mode where it tries to always write a full stripe to the backing
devices, hence changing behavior of the cache.

-- 
Vojtech Pavlik
Director SuSE Labs
