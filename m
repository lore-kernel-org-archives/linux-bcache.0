From: Kent Overstreet <kent.overstreet@gmail.com>
Subject: Re: scrub backing device
Date: Fri, 13 May 2016 14:21:33 -0800
Message-ID: <20160513222133.GA3784@kmo-pixel>
References: <CACHiF8Bm9i=m-nCVv2MnSFVDcgmnOzSytzYo0gzjkfp0u8Y52A@mail.gmail.com>
 <alpine.LRH.2.11.1605101814280.22680@mx.ewheeler.net>
 <CACHiF8AdwiO3FKV9=sNrFMom8pb1DiUzXAdvb4ze+k+U0N_-1g@mail.gmail.com>
 <alpine.LRH.2.11.1605111212540.22680@mx.ewheeler.net>
 <E3BCB47C-9466-4B3F-8AE2-DC7183B3B08D@gmail.com>
 <20160511235748.GR18290@merlins.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-bcache-owner@vger.kernel.org>
Received: from mail-pa0-f68.google.com ([209.85.220.68]:36679 "EHLO
	mail-pa0-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753538AbcEMWVh (ORCPT
	<rfc822;linux-bcache@vger.kernel.org>);
	Fri, 13 May 2016 18:21:37 -0400
Received: by mail-pa0-f68.google.com with SMTP id i5so9394452pag.3
        for <linux-bcache@vger.kernel.org>; Fri, 13 May 2016 15:21:37 -0700 (PDT)
Content-Disposition: inline
In-Reply-To: <20160511235748.GR18290@merlins.org>
Sender: linux-bcache-owner@vger.kernel.org
List-Id: linux-bcache@vger.kernel.org
To: Marc MERLIN <marc@merlins.org>
Cc: ching <lsching17@gmail.com>, Eric Wheeler <bcache@lists.ewheeler.net>, linux-bcache@vger.kernel.org

On Wed, May 11, 2016 at 04:57:48PM -0700, Marc MERLIN wrote:
> On Thu, May 12, 2016 at 07:34:26AM +0800, ching wrote:
> > for example https://btrfs.wiki.kernel.org/index.php/Manpage/btrfs-scrub
>  
> btrfs scrub is designed to make sure all the blocks and checksums are
> consistent.
> Ching makes a good point that it would be helpful to have a way to
> access the underlying backing device directly to ensure it is
> consistent.
> 
> I think currently you can use dmsetup with an offset to get the real
> filesystem past the bcache header, mount that read only somewhere and
> scrub that.
> Not ideal because scrub will not be able to fix issues that are fixable,
> but at least it should report errors.

Look at the verify code in drivers/md/bcache/debug.c, there's a
CONFIG_BCACHE_DEBUG mode where every time it reads clean cached data it reads
the data from the backing device and compares.

But for a scrub though you really want to walk all the _cached_ data, so it'd
take a bit more code than that.
