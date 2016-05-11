From: Marc MERLIN <marc@merlins.org>
Subject: Re: scrub backing device
Date: Wed, 11 May 2016 16:57:48 -0700
Message-ID: <20160511235748.GR18290@merlins.org>
References: <CACHiF8Bm9i=m-nCVv2MnSFVDcgmnOzSytzYo0gzjkfp0u8Y52A@mail.gmail.com>
 <alpine.LRH.2.11.1605101814280.22680@mx.ewheeler.net>
 <CACHiF8AdwiO3FKV9=sNrFMom8pb1DiUzXAdvb4ze+k+U0N_-1g@mail.gmail.com>
 <alpine.LRH.2.11.1605111212540.22680@mx.ewheeler.net>
 <E3BCB47C-9466-4B3F-8AE2-DC7183B3B08D@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-bcache-owner@vger.kernel.org>
Received: from magic.merlins.org ([209.81.13.136]:37043 "EHLO
	mail1.merlins.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751434AbcELAZp (ORCPT
	<rfc822;linux-bcache@vger.kernel.org>);
	Wed, 11 May 2016 20:25:45 -0400
Content-Disposition: inline
In-Reply-To: <E3BCB47C-9466-4B3F-8AE2-DC7183B3B08D@gmail.com>
Sender: linux-bcache-owner@vger.kernel.org
List-Id: linux-bcache@vger.kernel.org
To: ching <lsching17@gmail.com>
Cc: Eric Wheeler <bcache@lists.ewheeler.net>, linux-bcache@vger.kernel.org

On Thu, May 12, 2016 at 07:34:26AM +0800, ching wrote:
> for example https://btrfs.wiki.kernel.org/index.php/Manpage/btrfs-scrub
 
btrfs scrub is designed to make sure all the blocks and checksums are
consistent.
Ching makes a good point that it would be helpful to have a way to
access the underlying backing device directly to ensure it is
consistent.

I think currently you can use dmsetup with an offset to get the real
filesystem past the bcache header, mount that read only somewhere and
scrub that.
Not ideal because scrub will not be able to fix issues that are fixable,
but at least it should report errors.

Would that work?

Marc

> On May 12, 2016 3:13:22 AM GMT+08:00, Eric Wheeler <bcache@lists.ewheeler.net> wrote:
> >On Wed, 11 May 2016, ching lu wrote:
> >
> >> The read cache prevent the program to scrub the backing device
> >directly.
> >> 
> >> if a few bits flipped in the backing device, the cache may still
> >> return healthy data for a while.
> >> 
> >> Must i remove cache device before scrubbing?
> >
> >What do you mean by scrub?
> >
> >--
> >Eric Wheeler
> >
> >> 
> >> 
> >> On Wed, May 11, 2016 at 9:15 AM, Eric Wheeler
> ><bcache@lists.ewheeler.net> wrote:
> >> > On Fri, 29 Apr 2016, ching lu wrote:
> >> >
> >> >> Hello,
> >> >>
> >> >> i want to develop a script to perform data scrubbing periodically.
> >> >
> >> > I think you want to set dirty_percent to 0 and
> >cache_mode=writethrough.
> >> > Then wait a long time for dirty_percent to actually reach 0.
> >> >
> >> > --
> >> > Eric Wheeler
> >> >
> >> >
> >> >>
> >> >> For my use case, i think it is meaningless to scrub cached data.
> >> >>
> >> >> If i change the cache mode to "none", will it turn off the read
> >cache too?
> >> >>
> >> >> Furthermore, will this invalidate cached data? (i do not want to
> >"warm
> >> >> up" the cache again after the scrubbing)
> >> >>
> >> >> Thanks in advance,
> >> >> c
> >> >> --
> >> >> To unsubscribe from this list: send the line "unsubscribe
> >linux-bcache" in
> >> >> the body of a message to majordomo@vger.kernel.org
> >> >> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> >> >>
> >> --
> >> To unsubscribe from this list: send the line "unsubscribe
> >linux-bcache" in
> >> the body of a message to majordomo@vger.kernel.org
> >> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> >> 
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-bcache" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 

-- 
"A mouse is a device used to point at the xterm you want to type in" - A.S.R.
Microsoft is to operating systems ....
                                      .... what McDonalds is to gourmet cooking
Home page: http://marc.merlins.org/                         | PGP 1024R/763BE901
