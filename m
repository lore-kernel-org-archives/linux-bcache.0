From: Ming Lin <mlin@kernel.org>
Subject: Re: crash: kernel bug in bch_generic_make_request
Date: Fri, 31 Jul 2015 00:15:41 -0700
Message-ID: <1438326941.26596.8.camel@hasee>
References: <20150727123616.Horde.QmkKAZrQpCm25D6aq4ZAhJY@www3.nde.ag>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-bcache-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.136]:52356 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750947AbbGaHPo (ORCPT <rfc822;linux-bcache@vger.kernel.org>);
	Fri, 31 Jul 2015 03:15:44 -0400
In-Reply-To: <20150727123616.Horde.QmkKAZrQpCm25D6aq4ZAhJY@www3.nde.ag>
Sender: linux-bcache-owner@vger.kernel.org
List-Id: linux-bcache@vger.kernel.org
To: "Jens-U. Mozdzen" <jmozdzen@nde.ag>
Cc: linux-bcache@vger.kernel.org

On Mon, 2015-07-27 at 12:36 +0200, Jens-U. Mozdzen wrote:
> 
> - bcache bucket size is 512k, tree_depth is 1
> 
> - setup details:
> 
> -- md RAID6 "data" via seven 1 TB physical disks ("blockdev --getsz"  
> reports 9767605760 512byte blocks, approx 5 TB)
> 
> -- md RAID1 "cache" via two 128 GB SSDs ("blockdev --getsz" reports  
> 249936512 512byte blocks, approx 125 GB)
> 
> -- "bcache0" made from "data" and "cache"
> 
> -- LVM via single physical volume "bcache0"
> 
> -- many LVs create with older kernel
> 
> -- DRBD on top of each LV. This server is always primary, no  
> "fail-over" to a different node!
> 
> -- file system (to be) created on the DRBD devices

I tried setup DRBD on 2 VMs(qemu-kvm), but couldn't reproduce it.

Could you write a script to show how you setup all
these(bcache/RAID/LVM/DRBD)?
