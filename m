From: David Mohr <david@mcbf.net>
Subject: Re: bcache-tools ITP
Date: Wed, 17 Sep 2014 16:35:59 -0600
Message-ID: <0ecf62b8d8b1632a283805e759954c65@de.mcbf.net>
References: <20140530155757.GU2893@mal.justgohome.co.uk>
 <175f4ae1c88f5506984eb3a1673829a5@de.mcbf.net>
 <20140715111552.GA17765@mal.justgohome.co.uk>
 <20140917115538.GW29881@mal.justgohome.co.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-bcache-owner@vger.kernel.org>
Received: from seeker.mcbf.net ([109.239.49.157]:42054 "EHLO seeker.mcbf.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751292AbaIQXRj (ORCPT <rfc822;linux-bcache@vger.kernel.org>);
	Wed, 17 Sep 2014 19:17:39 -0400
In-Reply-To: <20140917115538.GW29881@mal.justgohome.co.uk>
Sender: linux-bcache-owner@vger.kernel.org
List-Id: linux-bcache@vger.kernel.org
To: Robie Basak <robie.basak@ubuntu.com>
Cc: 708132@bugs.debian.org, linux-bcache@vger.kernel.org, Gabriel de Perthuis <g2p.code+debian@gmail.com>, James Page <james.page@canonical.com>, B.Zeimetz@conova.com

About the licensing & copyright: I emailed Gabriel and Kent Overstreet 
on 2014-06-02 but did not get a reply. I admit though that I didn't 
follow up afterwards.

On 2014-09-17 05:55, Robie Basak wrote:

As far as I know this is the status of the git trees:

> 1) http://evilpiepirate.org/git/bcache-tools.git

Original sources, no changes in a while.

> 2) git://github.com/g2p/bcache-tools.git

First clone by Gabriel, contains work and bugfixes to the bcache-tools 
userland and some initial Debian packaging.

> 3) git://github.com/squisher/bcache-tools.git

My work on Debian packaging. I set Vcs-Git to g2p's version instead of 
mine because that seems to be the most active upstream repository. I 
thought this was relevant for uscan, but obviously I was wrong (as was 
pointed out on mentors.debian.net).

> 4) git://github.com/basak/bcache-tools.git

> Vcs-Git points to 2 (g2p). I also noted that the github branches seem 
> to
> contain commits to the upstream source, too, that aren't present in the
> "upstream" repository (1).

I thought that (1) is historic at this point and considered (2) the 
upstream. I did not verify that though.

I would suggest to co-maintain the package on 
https://alioth.debian.org/projects/collab-maint

> I think it would be easiest to upload, since I think it's good to go 
> and
> this will at least result in a definitive packaging state that we can
> work from.

Fine by me.

> In the meantime, I think branch 3 contained everything, so I cloned 
> that
> one to add my two commits. To keep Vcs-Git correct g2p should pull my
> commits, or else we can change Vcs-Git.

Right, see above.

> So in summary:
> 
> 1) Define and agree maintainers.

I'd like to get my feet wet and co-maintain, if you're interested.

> 2) g2p to pull my commits, or we agree to change Vcs-Git, or we drop
> Vcs-Git for now.

I'd say point it at 3) or at collab-maint, if that's where the packaging 
ends up being.

> 3) Upload. Either my colleague (James Page) can do it as he's already
> reviewed the packaging itself, or someone else. Let me know if there 
> are
> any objections to James uploading.

Bernd Zeimetz, I added him to the CC, was willing to sponsor the package 
once it was ready. But since he has been pretty busy recently, I don't 
think he'll object to James uploading. I definitely don't; it'd be 
awesome to get this finally into the official repository!

> 4) Sort out which trees are canonical upstream and packaging branches,
> and push all commits to those places.

I very much agree.

~David
