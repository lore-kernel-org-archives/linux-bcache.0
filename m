From: Sam Fulcomer <enotty@brown.edu>
Subject: Re: Issue (as expected) when upgrading from 3.12 to 3.13.7
Date: Thu, 3 Apr 2014 20:39:11 +0000 (UTC)
Message-ID: <loom.20140403T223507-477@post.gmane.org>
References: <lh8t08$1dd$1@ger.gmane.org> <alpine.DEB.2.02.1404031057430.4261@noise.cbg.collabora.co.uk> <533D89DB.2060306@gmail.com> <alpine.DEB.2.02.1404031719310.4261@noise.cbg.collabora.co.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-bcache-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:36112 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753497AbaDCUjZ (ORCPT <rfc822;linux-bcache@vger.kernel.org>);
	Thu, 3 Apr 2014 16:39:25 -0400
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <glbd-linux-bcache@m.gmane.org>)
	id 1WVoPz-0004LG-7c
	for linux-bcache@vger.kernel.org; Thu, 03 Apr 2014 22:39:23 +0200
Received: from 128.148.4.51 ([128.148.4.51])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-bcache@vger.kernel.org>; Thu, 03 Apr 2014 22:39:23 +0200
Received: from enotty by 128.148.4.51 with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-bcache@vger.kernel.org>; Thu, 03 Apr 2014 22:39:23 +0200
Sender: linux-bcache-owner@vger.kernel.org
List-Id: linux-bcache@vger.kernel.org
To: linux-bcache@vger.kernel.org

Vivek Dasmohapatra <vivek <at> collabora.co.uk> writes:

> 
> On Thu, 3 Apr 2014, Francis Moreau wrote:
> 
> > On 04/03/2014 12:02 PM, Vivek Dasmohapatra wrote:
> >> On Sun, 30 Mar 2014, Francis Moreau wrote:
> >>
> >> Hi Francis: A quick question for you if you have the time:
> >> How is the bcache constructed? ie which devices are in it?
> >>
> >
> > sure: I'm using bcache on a very basic setup: no MD or LVM involved.
> > /dev/sda4 (900Mo) is the backing device while /dev/sdb (120G) is the
> > cache device. On top of bcache0 I'm using ext4 and I'm using it as my
> > root device.
> 
> Ok, interesting. I've had some luck tweaking the offset of the backing
> device partition: Some offsets trigger the bug consistently and others
> never seem to, so it seems to be some sort of weird alignment bug.
> 
> 


I'd started a new thread before I realized how to reply to this.

The problem appears to be that bcache_writeback is trying to do
 something it shouldn't when in writethrough  mode 
(bcache_writeback is on by default even for writethrough).

echo 0 > /sys/block/bcache0/bcache/writeback_running

...appears to fix it.
