From: Kent Overstreet <kmo@daterainc.com>
Subject: Re: stable bcache-tools?
Date: Sun, 24 Nov 2013 16:55:59 -0800
Message-ID: <20131125005559.GC9244@kmo-pixel>
References: <002001cee7f2$0868a260$1939e720$@acm.org>
 <20131124010537.GF20624@moria.home.lan>
 <20131124204637.GJ5195@bender.unx.csupomona.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-bcache-owner@vger.kernel.org>
Received: from mail-pd0-f179.google.com ([209.85.192.179]:59218 "EHLO
	mail-pd0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751088Ab3KYAz3 (ORCPT
	<rfc822;linux-bcache@vger.kernel.org>);
	Sun, 24 Nov 2013 19:55:29 -0500
Received: by mail-pd0-f179.google.com with SMTP id r10so4426521pdi.10
        for <linux-bcache@vger.kernel.org>; Sun, 24 Nov 2013 16:55:29 -0800 (PST)
Content-Disposition: inline
In-Reply-To: <20131124204637.GJ5195@bender.unx.csupomona.edu>
Sender: linux-bcache-owner@vger.kernel.org
List-Id: linux-bcache@vger.kernel.org
To: "Paul B. Henson" <henson@acm.org>
Cc: linux-bcache@vger.kernel.org

On Sun, Nov 24, 2013 at 12:46:37PM -0800, Paul B. Henson wrote:
> On Sat, Nov 23, 2013 at 05:05:37PM -0800, Kent Overstreet wrote:
> 
> > The current git head should be completely fine for production usage -
> > there's not really anything complicated enough (save the udev stuff,
> > maybe) to merit tagging a specific version as stable. I suppose
> > distributions could use some kind of hint that useful changes have gone
> > in and they should package a new version - anything in particular you
> > want there?
> 
> No, it's just that my distribution, Gentoo, only has the option of a
> stale snapshot from months ago or a live build that just pulls git head.
> In general, I just like stable software to have tagged releases, so
> distributions can ship the same stuff. The maintainer of mcelog, for
> example, doesn't tag releases, and expects distributions to just grab
> whatever's there the day they package, so there's really no continuity
> between distributions as far as what you end up with. There doesn't even
> need to be a tarball packaged or anything, just a simple tag in git
> identifying a "release" so distributions can package it.

Heh, I see. Ok, I'll tag a release :p

(there really should be some standardized announce mechanism/channel
from packages -> distros. hrm).
