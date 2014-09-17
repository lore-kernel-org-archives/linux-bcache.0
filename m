From: Robie Basak <robie.basak@ubuntu.com>
Subject: Re: bcache-tools ITP
Date: Wed, 17 Sep 2014 12:55:38 +0100
Message-ID: <20140917115538.GW29881@mal.justgohome.co.uk>
References: <20140530155757.GU2893@mal.justgohome.co.uk>
 <175f4ae1c88f5506984eb3a1673829a5@de.mcbf.net>
 <20140715111552.GA17765@mal.justgohome.co.uk>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="jozmn01XJZjDjM3N"
Return-path: <linux-bcache-owner@vger.kernel.org>
Received: from youngberry.canonical.com ([91.189.89.112]:33275 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754244AbaIQLzl (ORCPT
	<rfc822;linux-bcache@vger.kernel.org>);
	Wed, 17 Sep 2014 07:55:41 -0400
Content-Disposition: inline
In-Reply-To: <20140715111552.GA17765@mal.justgohome.co.uk>
Sender: linux-bcache-owner@vger.kernel.org
List-Id: linux-bcache@vger.kernel.org
To: 708132@bugs.debian.org, linux-bcache@vger.kernel.org
Cc: Gabriel de Perthuis <g2p.code+debian@gmail.com>, David Mohr <david@mcbf.net>, James Page <james.page@canonical.com>


--jozmn01XJZjDjM3N
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

I have some progress to report. I also think that this is ready to
upload, though we should sort out a couple of things first.

I've added the bcache list (this is the Debian packaging bug) since
there is a question about some of these commits that seem to be relevant
to upstream but aren't in the upstream branch.

I've done some (functional only) testing of bcache itself with a
colleague, and we haven't seen any major issues.

I think the packaging is good to go, though I've added a removal of one
extraneous file and updated debian/copyright. This is in
github.com/basak/bcache-tools. I haven't submitted any pull requests to
avoid confusion (see below).

A colleague (James Page) is a DD and is prepared to upload, provided
that we all agree on who will maintain the package first. I'm happy to
step up. Who else does?

I found following all the various git trees confusing, and think we
should resolve this soon after upload. There are three git trees I'm
aware of, and I've added a fourth:

1) http://evilpiepirate.org/git/bcache-tools.git
2) git://github.com/g2p/bcache-tools.git
3) git://github.com/squisher/bcache-tools.git
4) git://github.com/basak/bcache-tools.git

Vcs-Git points to 2 (g2p). I also noted that the github branches seem to
contain commits to the upstream source, too, that aren't present in the
"upstream" repository (1).

Can we define which the canonical upstream source tree is, please, and
where the canonical Debian packaging branch should be? Then we can work
on pushing the changes back to the right places, rather than having
scattered branches all over the place. I noticed some changes to the
upstream source that don't appear to be in branch 1, for example.

I think it would be easiest to upload, since I think it's good to go and
this will at least result in a definitive packaging state that we can
work from.

In the meantime, I think branch 3 contained everything, so I cloned that
one to add my two commits. To keep Vcs-Git correct g2p should pull my
commits, or else we can change Vcs-Git.

So in summary:

1) Define and agree maintainers.
2) g2p to pull my commits, or we agree to change Vcs-Git, or we drop
Vcs-Git for now.
3) Upload. Either my colleague (James Page) can do it as he's already
reviewed the packaging itself, or someone else. Let me know if there are
any objections to James uploading.
4) Sort out which trees are canonical upstream and packaging branches,
and push all commits to those places.

In the meantime, I'll upload to Ubuntu as I can do that straight away
and we're quite close to release now. I hope that we can get Debian
straightened out soon.

Robie

--jozmn01XJZjDjM3N
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBCgAGBQJUGXa6AAoJEOVkucJ1vdUuiK0QAINleheDt2yjSVGTdBdxo80p
EpQl5RarCaw6nTMZeHAFt8nRdhclf0B36a5+Pn0qWDyKs6hje5S2pQ1rY04kj1Yn
gNjBiBOKShyS+nqS/C9ED9n/2ZymSvdBO+RsYcVI/94NBTJVnClb36Q7cUzpOARP
ZcdIh2otu7Yf8RB3UTvgW29jHRezQNiaRO1dHdEipkKgpDbI+7C/YNad/pyiGfPY
9Y9B80YIQAlHAB/9dMAQAI7coTxb4pRJfsXAF7s8uKGo4Z0VDZjCJWeaetxwkoM3
HQ0rrL/3kECUgju5Yt9OqfaNdOgYs6gZ99wGXexAYitokXYofTQYX71rw22eGThs
oK27VNTF6VZzG0N38MZ3N6Utu+TvM1z9uhf6PkbnO2IvDR8Jyxi53ji+TgDgwmX0
jaRuzMwykfWAfxUG/sS0VbCbi1TzIJWEl2bTDHePJKrI7GZPgTHucGyfAiA6u38x
79okeqVL4honGJ+ZFIlyG4+Xaw6qwFNQ/WFMQWOXAK1snzzwHHkmQhdZYVC2Aklf
PPxIUE+oj991c6BL7z8LhQPubGU3LOR2UGi2EKXltw3z6FkDO7Ay3YJ+j560Ybpf
NNhFe08kt3RL4Nk5i/7dLPL7Y+WuEbKYsRlXURO4Fye3iz67qyFfM4aGBDpJeuAf
BMs8D4HyfOZKsuyJLpwC
=1PDS
-----END PGP SIGNATURE-----

--jozmn01XJZjDjM3N--
