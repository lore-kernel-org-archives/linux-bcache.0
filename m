From: "Paul B. Henson" <henson@acm.org>
Subject: Re: stable bcache-tools?
Date: Sun, 24 Nov 2013 12:46:37 -0800
Message-ID: <20131124204637.GJ5195@bender.unx.csupomona.edu>
References: <002001cee7f2$0868a260$1939e720$@acm.org>
 <20131124010537.GF20624@moria.home.lan>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-bcache-owner@vger.kernel.org>
Received: from mail-pb0-f41.google.com ([209.85.160.41]:51753 "EHLO
	mail-pb0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752486Ab3KXUql (ORCPT
	<rfc822;linux-bcache@vger.kernel.org>);
	Sun, 24 Nov 2013 15:46:41 -0500
Received: by mail-pb0-f41.google.com with SMTP id jt11so4356568pbb.28
        for <linux-bcache@vger.kernel.org>; Sun, 24 Nov 2013 12:46:41 -0800 (PST)
Content-Disposition: inline
In-Reply-To: <20131124010537.GF20624@moria.home.lan>
Sender: linux-bcache-owner@vger.kernel.org
List-Id: linux-bcache@vger.kernel.org
To: Kent Overstreet <kmo@daterainc.com>
Cc: linux-bcache@vger.kernel.org

On Sat, Nov 23, 2013 at 05:05:37PM -0800, Kent Overstreet wrote:

> The current git head should be completely fine for production usage -
> there's not really anything complicated enough (save the udev stuff,
> maybe) to merit tagging a specific version as stable. I suppose
> distributions could use some kind of hint that useful changes have gone
> in and they should package a new version - anything in particular you
> want there?

No, it's just that my distribution, Gentoo, only has the option of a
stale snapshot from months ago or a live build that just pulls git head.
In general, I just like stable software to have tagged releases, so
distributions can ship the same stuff. The maintainer of mcelog, for
example, doesn't tag releases, and expects distributions to just grab
whatever's there the day they package, so there's really no continuity
between distributions as far as what you end up with. There doesn't even
need to be a tarball packaged or anything, just a simple tag in git
identifying a "release" so distributions can package it.

Thanks...
