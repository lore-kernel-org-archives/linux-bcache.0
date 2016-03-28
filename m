From: Vojtech Pavlik <vojtech@suse.com>
Subject: Re: 84% -> 60% cache hit ratio for same workflow, different conf
Date: Mon, 28 Mar 2016 21:17:23 +0200
Message-ID: <20160328191723.GA15859@suse.cz>
References: <CANEjr_S08oB9=3zcmBJktKTHH=NQwad95o2mfsxAeTPTgmL2YQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-bcache-owner@vger.kernel.org>
Received: from jablonecka.jablonka.cz ([91.219.244.36]:40239 "EHLO
	jablonecka.jablonka.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753567AbcC1TrH (ORCPT
	<rfc822;linux-bcache@vger.kernel.org>);
	Mon, 28 Mar 2016 15:47:07 -0400
Content-Disposition: inline
In-Reply-To: <CANEjr_S08oB9=3zcmBJktKTHH=NQwad95o2mfsxAeTPTgmL2YQ@mail.gmail.com>
Sender: linux-bcache-owner@vger.kernel.org
List-Id: linux-bcache@vger.kernel.org
To: Pradeep Jindal <praddyjindal@gmail.com>
Cc: linux-bcache@vger.kernel.org

On Mon, Mar 28, 2016 at 11:47:08PM +0530, Pradeep Jindal wrote:
> Hi,
> 
> I am facing a weird problem, I earlier had a configuration wherein my
> backing device was a logical volume (LVM) backed by 3 software RAID0
> arrays having 2x1TB disks each, so totally 6TB of storage for backing
> device and 300GB logical volume (LVM) backed by SSD as a caching
> device. Both were configured as a cache set and I was getting around
> 84% cache hit ratio.
> 
> Now, I have changed the backing device to a bare (no LVM, no raid) 6TB
> disk while everything else stays same (caching device on LVM, 300GB)
> and for exactly same workload I am only getting 58-60% cache hit
> ratio.
> 
> I am confused, what could be the reason?

Full stripe size writes are configured according to the backing device,
for example.

-- 
Vojtech Pavlik
Director SuSE Labs
