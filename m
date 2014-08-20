From: Ian Pilcher <arequipeno@gmail.com>
Subject: Re: "device busy" error when registering device
Date: Tue, 19 Aug 2014 20:38:44 -0500
Message-ID: <53F3FC24.4000200@gmail.com>
References: <lqcd46$hvl$1@ger.gmane.org> <53EBC981.1000303@rolffokkens.nl>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-bcache-owner@vger.kernel.org>
Received: from mail-oa0-f42.google.com ([209.85.219.42]:51489 "EHLO
	mail-oa0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751738AbaHTBiz (ORCPT
	<rfc822;linux-bcache@vger.kernel.org>);
	Tue, 19 Aug 2014 21:38:55 -0400
Received: by mail-oa0-f42.google.com with SMTP id n16so5867645oag.15
        for <linux-bcache@vger.kernel.org>; Tue, 19 Aug 2014 18:38:55 -0700 (PDT)
In-Reply-To: <53EBC981.1000303@rolffokkens.nl>
Sender: linux-bcache-owner@vger.kernel.org
List-Id: linux-bcache@vger.kernel.org
To: Rolf Fokkens <rolf@rolffokkens.nl>, linux-bcache@vger.kernel.org

On 08/13/2014 03:24 PM, Rolf Fokkens wrote:
> I'm running a very similar setup, but my system boots 100% of the time.
> So it may be useful to find out what's causing the problems at your
> system. You're using Intel RAID and I'm using Linux software RAID. It
> may be relevant, I don't know.

I suspect that the most significant difference is that my backing device
is a partition on a RAID device, rather than the device itself.

In reality, however, I don't think it's worth spending a lot of time
figuring out exactly what else is accessing the device.  If I understand
udev correctly, this sort of "conflict" is an inevitable consequence of
its asynchronous nature, and helper programs like bcache-register need
to be robust enough to deal with them.

(If I'm wrong about this, then I guess this is a udev bug?)

BTW, this is what the bcache-related dmesg entries look like when I hit
the conflict with my patches applied:

> [    1.761932] bcache: bch_journal_replay() journal replay done, 1972 keys in 75 entries, seq 312536
> [    1.762043] bcache: register_cache() registered cache device sda2
> [    1.762631] bcache: register_bcache() error opening /dev/md126p5: device busy
> [    1.862949] bcache: register_bdev() registered backing device md126p5
> [    1.864268] bcache: bch_cached_dev_attach() Caching md126p5 as bcache0 on set fb8d253b-6144-4b48-8ed6-7b1724ed83a7
> [    3.553053] bcache: register_bcache() error opening /dev/sda2: device already registered
> [    4.182180] bcache: register_bcache() error opening /dev/md126p5: device already registered

You can see that the backing device is busy when it first tries to
register it, but it succeeds 1/10th of a second later.  (I'm assuming
the last two "already registered" messages occur when udev replays
its events later in the boot process.)

Thanks!

-- 
========================================================================
Ian Pilcher                                         arequipeno@gmail.com
-------- "I grew up before Mark Zuckerberg invented friendship" --------
========================================================================
