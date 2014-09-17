From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: bcache-tools ITP
Date: Wed, 17 Sep 2014 16:21:14 -0700
Message-ID: <20140917232114.GB17913@birch.djwong.org>
References: <20140530155757.GU2893@mal.justgohome.co.uk>
 <175f4ae1c88f5506984eb3a1673829a5@de.mcbf.net>
 <20140715111552.GA17765@mal.justgohome.co.uk>
 <20140917115538.GW29881@mal.justgohome.co.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-bcache-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:42817 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751463AbaIQXVf (ORCPT
	<rfc822;linux-bcache@vger.kernel.org>);
	Wed, 17 Sep 2014 19:21:35 -0400
Content-Disposition: inline
In-Reply-To: <20140917115538.GW29881@mal.justgohome.co.uk>
Sender: linux-bcache-owner@vger.kernel.org
List-Id: linux-bcache@vger.kernel.org
To: Robie Basak <robie.basak@ubuntu.com>
Cc: 708132@bugs.debian.org, linux-bcache@vger.kernel.org, Gabriel de Perthuis <g2p.code+debian@gmail.com>, David Mohr <david@mcbf.net>, James Page <james.page@canonical.com>

Hi,

If you're interested in the bcache-status[1] tool, I'd be happy to work with
you to get (and keep) it in Debian.  I /think/ it's in the Fedora package.

(afaict the script is not in any of those git trees...)

On Wed, Sep 17, 2014 at 12:55:38PM +0100, Robie Basak wrote:
> I have some progress to report. I also think that this is ready to
> upload, though we should sort out a couple of things first.
> 
> I've added the bcache list (this is the Debian packaging bug) since
> there is a question about some of these commits that seem to be relevant
> to upstream but aren't in the upstream branch.
> 
> I've done some (functional only) testing of bcache itself with a
> colleague, and we haven't seen any major issues.
> 
> I think the packaging is good to go, though I've added a removal of one
> extraneous file and updated debian/copyright. This is in
> github.com/basak/bcache-tools. I haven't submitted any pull requests to
> avoid confusion (see below).
> 
> A colleague (James Page) is a DD and is prepared to upload, provided
> that we all agree on who will maintain the package first. I'm happy to
> step up. Who else does?
> 
> I found following all the various git trees confusing, and think we
> should resolve this soon after upload. There are three git trees I'm
> aware of, and I've added a fourth:
> 
> 1) http://evilpiepirate.org/git/bcache-tools.git
> 2) git://github.com/g2p/bcache-tools.git
> 3) git://github.com/squisher/bcache-tools.git
> 4) git://github.com/basak/bcache-tools.git

I had thought that #2 was the new upstream, but then I haven't paid attention
in a while either.

--D

[1] https://gist.github.com/djwong/6343451

> 
> Vcs-Git points to 2 (g2p). I also noted that the github branches seem to
> contain commits to the upstream source, too, that aren't present in the
> "upstream" repository (1).
> 
> Can we define which the canonical upstream source tree is, please, and
> where the canonical Debian packaging branch should be? Then we can work
> on pushing the changes back to the right places, rather than having
> scattered branches all over the place. I noticed some changes to the
> upstream source that don't appear to be in branch 1, for example.
> 
> I think it would be easiest to upload, since I think it's good to go and
> this will at least result in a definitive packaging state that we can
> work from.
> 
> In the meantime, I think branch 3 contained everything, so I cloned that
> one to add my two commits. To keep Vcs-Git correct g2p should pull my
> commits, or else we can change Vcs-Git.
> 
> So in summary:
> 
> 1) Define and agree maintainers.
> 2) g2p to pull my commits, or we agree to change Vcs-Git, or we drop
> Vcs-Git for now.
> 3) Upload. Either my colleague (James Page) can do it as he's already
> reviewed the packaging itself, or someone else. Let me know if there are
> any objections to James uploading.
> 4) Sort out which trees are canonical upstream and packaging branches,
> and push all commits to those places.
> 
> In the meantime, I'll upload to Ubuntu as I can do that straight away
> and we're quite close to release now. I hope that we can get Debian
> straightened out soon.
> 
> Robie
