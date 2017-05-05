From: Vojtech Pavlik <vojtech@suse.com>
Subject: Re: Reasoning of exposing queue/rotational=0
Date: Fri, 5 May 2017 21:02:31 +0200
Message-ID: <20170505190231.GA31457@suse.com>
References: <20170504232457.13c269c0@jupiter.sol.kaishome.de>
 <f99de33e-f90e-1492-7561-5a63d6814a9e@coly.li>
 <20170505174438.GA22811@suse.com>
 <20170505202317.68bdbc20@jupiter.sol.kaishome.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-bcache-owner@vger.kernel.org>
Received: from jablonecka.jablonka.cz ([91.219.244.36]:49888 "EHLO
        jablonecka.jablonka.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751028AbdEETCe (ORCPT
        <rfc822;linux-bcache@vger.kernel.org>);
        Fri, 5 May 2017 15:02:34 -0400
Content-Disposition: inline
In-Reply-To: <20170505202317.68bdbc20@jupiter.sol.kaishome.de>
Sender: linux-bcache-owner@vger.kernel.org
List-Id: linux-bcache@vger.kernel.org
To: Kai Krakow <hurikhan77@gmail.com>
Cc: linux-bcache@vger.kernel.org

On Fri, May 05, 2017 at 08:23:17PM +0200, Kai Krakow wrote:
> > I don't think that makes much sense either - the cache device will not
> > be used in the pattern that the exposed bcache device is, so any
> > choice of access patterns by a higher level based on
> > rotational/non-rotational will be messed up anyway.
> > 
> > I think the current behavior (rotational=0) is correct in most cases.
> 
> Well, I don't want to do bikeshedding... But both didn't answer my
> original question of what's the reasoning. Did anyone put thoughts into
> this? 

Originally, rotational=1 is just a flag coming from the
IDE/SCSI/SATA/etc. layers to the OS telling it whether the device is
spinning or not. Without any specific implications as to the behavior of
the device.

It is writable for a reason - not even all flash based devices report
the flag correctly at the hardware level.

Linux uses the flag on the block device (queue) to tell whether seeks
are very expensive compared to linear reads and whether it makes sense
to spend large amounts CPU cycles and memory on reordering.

Btrfs is one user that tries to change the allocation policy and thus
the likelihood of fragmentation and/or long seeks based on whether the
device reports 'rotational'.

However, it actually has three modes at the fs level: 'nossd',
'ssd' and 'ssd_spread', with the last being faster on cheaper SSDs.
There are large differences even between individual SSD profiles. Again,
for a good reason, btrfs has these as mount options that override any
'rotational' hint.

All in all, if you want all the performance available, you need to see
what works best for your workload.

The same applies to i/o schedulers. They're much less dependent on the
underlying device than the workload put on them.

This is not the first time the question comes up.

> Was it arbitrarily chosen? Is rotational=0 just a default that
> bcache didn't bother to explicitly set?

A bcache device performance profile is neither one of a rotational
device, nor one of a SSD.

Sequential reads may be bypassed or not. If not, some parts of it may
be cached, in which case there will be seeks on the backing device even
when there should be none on a real rotational device.

Random reads may be fast if they're hitting cached locations.

Random and sequential writes will be always cached if writeback is
enabled and so there is no point in spending CPU cycles on optimizing
writes.

How much the bcache device will behave like the backing device and how
much like the caching device does depend mainly on the workload and the
size of its working set compared to the size of the cache.

I do not believe that the choice of rotational=0 was arbitrary or a
default. It's simply that bcache changes the access pattern to both the
caching and backing device so much that it no longer resembles a
rotational device's performance profile in any case.

> Answering the last two questions with "yes" would suggest that it should
> be rethought...
> 
> Answering the first with "yes" means I'd like to know more. ;-)

-- 
Vojtech Pavlik
Director SuSE Labs
