From: Rolf Fokkens <rolf@rolffokkens.nl>
Subject: Re: "device busy" error when registering device
Date: Sat, 6 Sep 2014 07:34:58 +0000 (UTC)
Message-ID: <loom.20140906T092457-907@post.gmane.org>
References: <lqcd46$hvl$1@ger.gmane.org> <53EBC981.1000303@rolffokkens.nl> <53F3FC24.4000200@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-bcache-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:60168 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750849AbaIFHpG (ORCPT <rfc822;linux-bcache@vger.kernel.org>);
	Sat, 6 Sep 2014 03:45:06 -0400
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <glbd-linux-bcache@m.gmane.org>)
	id 1XQAgC-0003go-Ck
	for linux-bcache@vger.kernel.org; Sat, 06 Sep 2014 09:45:04 +0200
Received: from D9787662.cm-3-1b.dynamic.ziggo.nl ([217.120.118.98])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-bcache@vger.kernel.org>; Sat, 06 Sep 2014 09:45:04 +0200
Received: from rolf by D9787662.cm-3-1b.dynamic.ziggo.nl with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-bcache@vger.kernel.org>; Sat, 06 Sep 2014 09:45:04 +0200
Sender: linux-bcache-owner@vger.kernel.org
List-Id: linux-bcache@vger.kernel.org
To: linux-bcache@vger.kernel.org

Ian Pilcher <arequipeno <at> gmail.com> writes:

> I suspect that the most significant difference is that my backing device
> is a partition on a RAID device, rather than the device itself.
> In reality, however, I don't think it's worth spending a lot of time
> figuring out exactly what else is accessing the device.  If I understand
> udev correctly, this sort of "conflict" is an inevitable consequence of
> its asynchronous nature, and helper programs like bcache-register need
> to be robust enough to deal with them.
> 
> (If I'm wrong about this, then I guess this is a udev bug?)
> 
> BTW, this is what the bcache-related dmesg entries look like when I hit
> the conflict with my patches applied:
> 
> > [    1.761932] bcache: bch_journal_replay() journal replay done, 1972
keys in 75 entries, seq 312536
> > [    1.762043] bcache: register_cache() registered cache device sda2
> > [    1.762631] bcache: register_bcache() error opening /dev/md126p5:
device busy
> > [    1.862949] bcache: register_bdev() registered backing device md126p5
> > [    1.864268] bcache: bch_cached_dev_attach() Caching md126p5 as
bcache0 on set fb8d253b-6144-4b48-8ed6-7b1724ed83a7
> > [    3.553053] bcache: register_bcache() error opening /dev/sda2: device
already registered
> > [    4.182180] bcache: register_bcache() error opening /dev/md126p5:
device already registered
> 
> You can see that the backing device is busy when it first tries to
> register it, but it succeeds 1/10th of a second later.  (I'm assuming
> the last two "already registered" messages occur when udev replays
> its events later in the boot process.)

To me your assumption makes sense. I would be good though if Gabriel (bcache
userspace) and/or Kent (bcache kernel) would respond to this.

I'll add some retries to bcache tools (in case of any error) and see if that
works and add a pull request here: https://github.com/g2p/bcache-tools
