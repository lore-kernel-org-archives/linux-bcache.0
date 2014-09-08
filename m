From: Greg KH <greg@kroah.com>
Subject: Re: [GIT PULL] bcache changes for 3.17
Date: Mon, 8 Sep 2014 08:27:24 -0700
Message-ID: <20140908152724.GB32677@kroah.com>
References: <20140805043346.GF541@moria.home.lan>
 <53E10D48.1010700@kernel.dk>
 <53E7251B.3080305@kieser.ca>
 <540966BA.9030106@gmail.com>
 <20140905214532.GA30221@kroah.com>
 <540A44A3.5060502@kieser.ca>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-bcache-owner@vger.kernel.org>
Received: from out4-smtp.messagingengine.com ([66.111.4.28]:48480 "EHLO
	out4-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753421AbaIHPcy (ORCPT
	<rfc822;linux-bcache@vger.kernel.org>);
	Mon, 8 Sep 2014 11:32:54 -0400
Received: from compute6.internal (compute6.nyi.internal [10.202.2.46])
	by gateway2.nyi.internal (Postfix) with ESMTP id D1E1120ABE
	for <linux-bcache@vger.kernel.org>; Mon,  8 Sep 2014 11:27:25 -0400 (EDT)
Content-Disposition: inline
In-Reply-To: <540A44A3.5060502@kieser.ca>
Sender: linux-bcache-owner@vger.kernel.org
List-Id: linux-bcache@vger.kernel.org
To: Peter Kieser <peter@kieser.ca>
Cc: Francis Moreau <francis.moro@gmail.com>, Jens Axboe <axboe@kernel.dk>, Kent Overstreet <kmo@daterainc.com>, linux-kernel@vger.kernel.org, linux-bcache@vger.kernel.org, stable <stable@vger.kernel.org>

On Fri, Sep 05, 2014 at 04:17:55PM -0700, Peter Kieser wrote:
> 
> On 2014-09-05 2:45 PM, Greg KH wrote:
> >Just because a maintainer/developer doesn't want to do anything for the
> >stable kernel releases does_NOT_  mean the code is
> >"unstable/expreimental" at all.
> 
> These are more bcache-ate-my-data unstable bugs. It's standard practice to
> backport fixes that cause instability/data corruption to a 'stable' release
> (otherwise, why would it be named 'stable')?

That's fine, but it has nothing to do with what sounded like someone
wanting to go back and mark an older kernel feature as "unsupported".

greg k-h
