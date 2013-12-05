From: Kent Overstreet <kmo@daterainc.com>
Subject: Re: md-raid5 with bcache member devices => kernel panic
Date: Thu, 5 Dec 2013 14:52:34 -0800
Message-ID: <20131205225234.GA4054@kmo>
References: <20131205212913.GE1848@teapot>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-bcache-owner@vger.kernel.org>
Received: from mail-pd0-f170.google.com ([209.85.192.170]:54156 "EHLO
	mail-pd0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751699Ab3LEWwj (ORCPT
	<rfc822;linux-bcache@vger.kernel.org>);
	Thu, 5 Dec 2013 17:52:39 -0500
Received: by mail-pd0-f170.google.com with SMTP id g10so25571640pdj.15
        for <linux-bcache@vger.kernel.org>; Thu, 05 Dec 2013 14:52:37 -0800 (PST)
Content-Disposition: inline
In-Reply-To: <20131205212913.GE1848@teapot>
Sender: linux-bcache-owner@vger.kernel.org
List-Id: linux-bcache@vger.kernel.org
To: Matthias Ferdinand <bcache@mfedv.net>, nks@daterainc.com
Cc: linux-bcache@vger.kernel.org

On Thu, Dec 05, 2013 at 10:29:13PM +0100, Matthias Ferdinand wrote:
> Hi,
> 
> I am currently experimenting with bcache. The hardware is rather old:
> Intel Core2 6600, 2.4GHz, 8GB RAM. I intend using it as a KVM host. OS
> is Ubuntu 13.10 amd64.
> 
> SSD: single Intel 530 series 120G (SSDSC2BW120A4), i.e. same cache
> device for all backing devices
> 
> But not only is it rather slow, it reliably (but nondeterministically)
> produces kernel panics. It might panic while copying the first VM image
> (dd_rescue), or during startup of the first VM, while the copy process
> for the second VM image (dd_rescue) is already running.
> 
> Tried with different kernels, all produce the panics:
>   - Ubuntu 3.11.0-13.20
>   - kernel.org 3.12.2
>   - kernel.org 3.13-rc2
> 
> Having so many layers on top of bcache may be stupid, but sure it should
> not panic :-)
> 
> You can find the complete serial console output of those crashing runs
> at http://dl.mfedv.net/md5raid_on_bcache_panic/
> 
> I can't see bcache mentioned in those kernel backtraces - perhaps it's
> not really bcaches fault. (there is a single bcache line in the 3.12.2
> trace, though)

Erk. I thought I was done with these bugs. Nick, do you think you could try and
track this down?

Looking at this:
http://dl.mfedv.net/md5raid_on_bcache_panic/mdraid5_on_bcache_panic_3.12.2.txt

that's a null pointer deref; if Matthias could get the exact line number it
happened on we could tell what variable was null. I _think_ it's *sg because
it's running off the end of the scatterlist; if that's the case (and you should
verify that that is what's happening, then what's going on is bcache is sending
down a bio larger than what the device expects.

Assuming that's the case, the bug would be in bch_bio_max_sectors(), which is in
drivers/md/bcache/io.c. Backstory:

In current kernels, the way the block layer works to do an io, you fill out a
struct bio and pass it down: BUT, the bio is not allowed to be bigger than
whatever the device can do atomically as a single request.

The way this is normally done is a filesystem will add data to a bio, a page at
a time, with bio_add_page() (in fs/bio.c); bio_add_page() checks all the device
constraints and may fail, and then the filesystem sends the bio down and starts
making a new bio.

Anyways, bcache doesn't do things this way, because it's braindead and gets
obscenely complicated when you have stacked block devices - instead, when it
goes to submit a bio it first splits the bio if necessary. That
bch_bio_max_sectors() is supposed to check all the same constraints and
essentially replicate the behaviour of building up a bio with bio_add_page().

Matthias - I'm running bcache on top of a raid6 at home and I've never seen
this, so there's probably something unusual about your setup that's required to
trigger this. Can you help Nick out with reproducing the bug and/or getting him
more information?
