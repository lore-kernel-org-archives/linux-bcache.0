From: Eric Wheeler <bcache@lists.ewheeler.net>
Subject: Re: bcache stability patches: Now mainlined!
Date: Wed, 24 Feb 2016 07:34:12 +0000 (UTC)
Message-ID: <alpine.LRH.2.11.1602240719080.32077@mail.ewheeler.net>
References: <CAO2mnow-HG_0pnDVFGfU0e+hPXfT=zMTrdemwiv=pxgJ+m4o2w@mail.gmail.com> <alpine.LRH.2.11.1512291807510.30746@mail.ewheeler.net> <56841B8B.6070306@kernel.dk> <20151231031500.GA8265@kmo-pixel> <5684A030.1040306@kernel.dk>
 <alpine.LRH.2.11.1602240626110.32077@mail.ewheeler.net> <56CD5443.8030609@profihost.ag>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-bcache-owner@vger.kernel.org>
Received: from mx.ewheeler.net ([71.19.153.34]:36754 "EHLO mail.ewheeler.net"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752047AbcBXHeV (ORCPT <rfc822;linux-bcache@vger.kernel.org>);
	Wed, 24 Feb 2016 02:34:21 -0500
In-Reply-To: <56CD5443.8030609@profihost.ag>
Sender: linux-bcache-owner@vger.kernel.org
List-Id: linux-bcache@vger.kernel.org
To: Stefan Priebe - Profihost AG <s.priebe@profihost.ag>
Cc: Kent Overstreet <kent.overstreet@gmail.com>, Jens Axboe <axboe@kernel.dk>, Al Viro <viro@zeniv.linux.org.uk>, Denis Bychkov <manover@gmail.com>, g2p.code@gmail.com, Jiri Kosina <jkosina@suse.com>, Joshua Schmid <jschmid@suse.com>, linux-bcache@vger.kernel.org, stefan.bader@canonical.com, Takashi Iwai <tiwai@suse.de>, Vojtech Pavlik <vojtech@suse.com>, Zheng Liu <gnehzuil.liu@gmail.com>, Zheng Liu <wenqing.lz@taobao.com>

On Wed, 24 Feb 2016, Stefan Priebe - Profihost AG wrote:
> Am 24.02.2016 um 07:45 schrieb Eric Wheeler:
> > I would like to thank everyone involved in getting these patches 
> > mainlined.  Bcache should now be stable on the following releases:
> > 
> > 	mainline: 4.5-rc1 (and later)
> > 	longterm: 4.1.18
> > 	longterm: 3.18.27
> 
> the new longterm 4.4.2 should also contain them all.

I agree, it should, but it doesn't appear to:

https://git.kernel.org/cgit/linux/kernel/git/stable/linux-stable.git/log/?id=refs/tags/v4.4.2

# git log --grep="bcache:" --oneline | head
532eb52 bcache: remove driver private bio splitting code
9ea18f8 Merge branch 'for-3.19/drivers' of git://git.kernel.dk/linux-block
aae4933 md/bcache: use generic io stats accounting functions to simplify 
  io stat accounting d429a36 Merge branch 'for-3.17/drivers' of 
  git://git.kernel.dk/linux-block
[...]

Maybe in 4.4.3 after GKH merges the Cc: stable@ tagged commits.
  
It does, however, have the bio splitting code removal in 532eb52, which 
earlier releases do not.

-Eric

> > 
> > Please test on your favorite branch and let us know how it goes.
> > 
> > For those working from another branch, please see:
> > 	git log 2ef9ccbf~1..627ccd20
> > 
> > and cherry-pick with
> > 	git cherry-pick 2ef9ccbf~1..627ccd20
> > 
> > 
> > Cheers,	
> > 
> > 
> > --
> > Eric Wheeler
> > Linux since 1996!  
> > 
> > 
> > --
> > To unsubscribe from this list: send the line "unsubscribe linux-bcache" in
> > the body of a message to majordomo@vger.kernel.org
> > More majordomo info at  http://vger.kernel.org/majordomo-info.html
> > 
> 





--
Eric Wheeler, President           eWheeler, Inc. dba Global Linux Security
888-LINUX26 (888-546-8926)        Fax: 503-716-3878           PO Box 25107
www.GlobalLinuxSecurity.pro       Linux since 1996!     Portland, OR 97298
