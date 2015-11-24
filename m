From: Kai Krakow <hurikhan77@gmail.com>
Subject: Re: Btrfs on bcache device: mount options?
Date: Tue, 24 Nov 2015 08:30:32 +0100
Message-ID: <20151124083032.11b858f5@jupiter.sol.kaishome.de>
References: <87mvvk4718.fsf@gmx.de>
	<20151015142945.GA10162@suse.com>
	<871tcvhlff.fsf@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-bcache-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:56994 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752249AbbKXHap (ORCPT <rfc822;linux-bcache@vger.kernel.org>);
	Tue, 24 Nov 2015 02:30:45 -0500
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <glbd-linux-bcache@m.gmane.org>)
	id 1a183m-0002pq-0V
	for linux-bcache@vger.kernel.org; Tue, 24 Nov 2015 08:30:42 +0100
Received: from ip18869d04.dynamic.kabel-deutschland.de ([24.134.157.4])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-bcache@vger.kernel.org>; Tue, 24 Nov 2015 08:30:41 +0100
Received: from hurikhan77 by ip18869d04.dynamic.kabel-deutschland.de with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-bcache@vger.kernel.org>; Tue, 24 Nov 2015 08:30:41 +0100
Sender: linux-bcache-owner@vger.kernel.org
List-Id: linux-bcache@vger.kernel.org
To: linux-bcache@vger.kernel.org

Am Thu, 15 Oct 2015 23:27:32 +0200
schrieb Simon Herter <sim.herter@gmail.com>:

> 
> Vojtech Pavlik writes:
> 
> > On Thu, Oct 15, 2015 at 03:04:35PM +0200, Simon Herter wrote:
> >
> >> I'm using btrfs on a bcache device and I'm a bit confused about
> >> mount options. For example, bcache may (if I understood correctly)
> >> bypass the cache completely for sequential access. So should I use
> >> "ssd" mount option or not? Are there any general recommendations?
> >
> > No, you should not. It modifies the data layout behavior to ignore
> > seek times. These may be present when reading from the backing
> > media.
> 
> Sounds reasonable. A short note on that: _not_ specifying 'ssd' is not
> enough, one has to specify 'nossd' explicitly. Btrfs enables 'ssd'
> automatically by checking /sys/block/bcache0/queue/rotational to be
> zero - which is true. (Though I'm not sure whether bcache got that
> right. One could argue that returning the backing device's rotational
> value would be better, especially to get the defaults right for
> btrfs.)
> 
> > You likely want to enable compression and autodefragmentation, too.
> 
> When I read 'autodefrag' I was worried about my ssd at first, but I
> found some discussion about that on the btrfs mailing list, so that
> seems to be fine. Thanks for the suggestions.

I found that using autodefrag with bcache eats lifetime of your SSD a
lot. I suggest watching your SSD smart stats closely for a while before
turning it permanently on. Autodefrag constantly rewrites even big
files, this is still not optimized in btrfs.

You may better want to individually mark files nocow in btrfs which are
subject to high fragmentation and source of low performance due to
this, like sqlite files, database files, vm images, etc. Such files
usually have their own transaction safety layer anyways - so you do not
really need btrfs transactional cow protection for these.

But I'll look into the nossd option. I wondered about this myself.

Regards,
Kai

-- 
