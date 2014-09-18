From: Rolf Fokkens <rolf@rolffokkens.nl>
Subject: Re: bcache-tools ITP
Date: Thu, 18 Sep 2014 19:26:10 +0200
Message-ID: <9A9BFB33-EFAC-48AC-BEEE-1FE9D9DB4552@rolffokkens.nl>
References: <20140530155757.GU2893@mal.justgohome.co.uk> <175f4ae1c88f5506984eb3a1673829a5@de.mcbf.net> <20140715111552.GA17765@mal.justgohome.co.uk> <20140917115538.GW29881@mal.justgohome.co.uk> <0ecf62b8d8b1632a283805e759954c65@de.mcbf.net>
Mime-Version: 1.0 (1.0)
Content-Type: text/plain;
	charset=us-ascii
Content-Transfer-Encoding: 8BIT
Return-path: <linux-bcache-owner@vger.kernel.org>
Received: from mail-we0-f176.google.com ([74.125.82.176]:44007 "EHLO
	mail-we0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756669AbaIRR0Q convert rfc822-to-8bit (ORCPT
	<rfc822;linux-bcache@vger.kernel.org>);
	Thu, 18 Sep 2014 13:26:16 -0400
Received: by mail-we0-f176.google.com with SMTP id q58so1274816wes.35
        for <linux-bcache@vger.kernel.org>; Thu, 18 Sep 2014 10:26:14 -0700 (PDT)
In-Reply-To: <0ecf62b8d8b1632a283805e759954c65@de.mcbf.net>
Sender: linux-bcache-owner@vger.kernel.org
List-Id: linux-bcache@vger.kernel.org
To: David Mohr <david@mcbf.net>
Cc: Robie Basak <robie.basak@ubuntu.com>, "708132@bugs.debian.org" <708132@bugs.debian.org>, "linux-bcache@vger.kernel.org" <linux-bcache@vger.kernel.org>, Gabriel de Perthuis <g2p.code+debian@gmail.com>, James Page <james.page@canonical.com>, "B.Zeimetz@conova.com" <B.Zeimetz@conova.com>

Hi,

For the Fedora package I solely aimed at the (Kent's) evilpiepirate bcache-tools repo. Most development was done in Gabriel's (g2p) repo in preperation of the Fedora package, but that was merged by Kent prior to the Fedora package release.

After that not much has happened in Kent's repo, and te status of that repo is unclear to me.

Rolf

> Op 18 sep. 2014 om 00:35 heeft David Mohr <david@mcbf.net> het volgende geschreven:
> 
> About the licensing & copyright: I emailed Gabriel and Kent Overstreet on 2014-06-02 but did not get a reply. I admit though that I didn't follow up afterwards.
> 
> On 2014-09-17 05:55, Robie Basak wrote:
> 
> As far as I know this is the status of the git trees:
> 
>> 1) http://evilpiepirate.org/git/bcache-tools.git
> 
> Original sources, no changes in a while.
> 
>> 2) git://github.com/g2p/bcache-tools.git
> 
> First clone by Gabriel, contains work and bugfixes to the bcache-tools userland and some initial Debian packaging.
> 
>> 3) git://github.com/squisher/bcache-tools.git
> 
> My work on Debian packaging. I set Vcs-Git to g2p's version instead of mine because that seems to be the most active upstream repository. I thought this was relevant for uscan, but obviously I was wrong (as was pointed out on mentors.debian.net).
> 
>> 4) git://github.com/basak/bcache-tools.git
> 
>> Vcs-Git points to 2 (g2p). I also noted that the github branches seem to
>> contain commits to the upstream source, too, that aren't present in the
>> "upstream" repository (1).
> 
> I thought that (1) is historic at this point and considered (2) the upstream. I did not verify that though.
> 
> I would suggest to co-maintain the package on https://alioth.debian.org/projects/collab-maint
> 
>> I think it would be easiest to upload, since I think it's good to go and
>> this will at least result in a definitive packaging state that we can
>> work from.
> 
> Fine by me.
> 
>> In the meantime, I think branch 3 contained everything, so I cloned that
>> one to add my two commits. To keep Vcs-Git correct g2p should pull my
>> commits, or else we can change Vcs-Git.
> 
> Right, see above.
> 
>> So in summary:
>> 1) Define and agree maintainers.
> 
> I'd like to get my feet wet and co-maintain, if you're interested.
> 
>> 2) g2p to pull my commits, or we agree to change Vcs-Git, or we drop
>> Vcs-Git for now.
> 
> I'd say point it at 3) or at collab-maint, if that's where the packaging ends up being.
> 
>> 3) Upload. Either my colleague (James Page) can do it as he's already
>> reviewed the packaging itself, or someone else. Let me know if there are
>> any objections to James uploading.
> 
> Bernd Zeimetz, I added him to the CC, was willing to sponsor the package once it was ready. But since he has been pretty busy recently, I don't think he'll object to James uploading. I definitely don't; it'd be awesome to get this finally into the official repository!
> 
>> 4) Sort out which trees are canonical upstream and packaging branches,
>> and push all commits to those places.
> 
> I very much agree.
> 
> ~David
> --
> To unsubscribe from this list: send the line "unsubscribe linux-bcache" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
