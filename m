From: Marc MERLIN <marc@merlins.org>
Subject: Re: scrub backing device
Date: Fri, 13 May 2016 15:10:20 -0700
Message-ID: <20160513221020.GC18290@merlins.org>
References: <CACHiF8Bm9i=m-nCVv2MnSFVDcgmnOzSytzYo0gzjkfp0u8Y52A@mail.gmail.com>
 <alpine.LRH.2.11.1605101814280.22680@mx.ewheeler.net>
 <CACHiF8AdwiO3FKV9=sNrFMom8pb1DiUzXAdvb4ze+k+U0N_-1g@mail.gmail.com>
 <alpine.LRH.2.11.1605111212540.22680@mx.ewheeler.net>
 <E3BCB47C-9466-4B3F-8AE2-DC7183B3B08D@gmail.com>
 <20160511235748.GR18290@merlins.org>
 <89674CAE-8843-40DC-BA2B-3D29919E5859@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-bcache-owner@vger.kernel.org>
Received: from magic.merlins.org ([209.81.13.136]:37263 "EHLO
	mail1.merlins.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753498AbcEMWKb (ORCPT
	<rfc822;linux-bcache@vger.kernel.org>);
	Fri, 13 May 2016 18:10:31 -0400
Content-Disposition: inline
In-Reply-To: <89674CAE-8843-40DC-BA2B-3D29919E5859@gmail.com>
Sender: linux-bcache-owner@vger.kernel.org
List-Id: linux-bcache@vger.kernel.org
To: ching <lsching17@gmail.com>
Cc: Eric Wheeler <bcache@lists.ewheeler.net>, linux-bcache@vger.kernel.org

On Thu, May 12, 2016 at 06:25:27PM +0800, ching wrote:
> it may be a mess that if there is 2 btrfs partition (1 via bcache, 1 via dm) with same UUID appear at the same time.
> 
> https://btrfs.wiki.kernel.org/index.php/Gotchas
> 
> Currently, i think removing cache device would be simpler.

You make a good point, and I agree with your assessment.

Marc
-- 
"A mouse is a device used to point at the xterm you want to type in" - A.S.R.
Microsoft is to operating systems ....
                                      .... what McDonalds is to gourmet cooking
Home page: http://marc.merlins.org/                         | PGP 1024R/763BE901
