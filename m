From: David Mohr <david@mcbf.net>
Subject: Re: [ANNOUNCE] bcachefs!
Date: Tue, 21 Jul 2015 12:37:10 -0600
Message-ID: <468c161352fd5f77ec371ce256f27e14@de.mcbf.net>
References: <20150714005825.GA24027@kmo-pixel>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-bcache-owner@vger.kernel.org>
Received: from seeker.mcbf.net ([109.239.49.157]:60331 "EHLO seeker.mcbf.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933262AbbGUS70 (ORCPT <rfc822;linux-bcache@vger.kernel.org>);
	Tue, 21 Jul 2015 14:59:26 -0400
In-Reply-To: <20150714005825.GA24027@kmo-pixel>
Sender: linux-bcache-owner@vger.kernel.org
List-Id: linux-bcache@vger.kernel.org
To: Kent Overstreet <kent.overstreet@gmail.com>
Cc: linux-bcache@vger.kernel.org, sviatoslavpestov@gmail.com, mrubin@google.com, adam.berkan@gmail.com, zab@zabbo.net, rickyb@google.com

On 2015-07-13 18:58, Kent Overstreet wrote:
> Short announcement, because I'm in the process of moving - but I wanted 
> to get
> this out there because the code is up and I think it's reasonably 
> stable right
> now.
> 
> Bcachefs is a posix filesystem that I've been working towards for - 
> well, quite
> awhile now: it's intended as a competitor/replacement for 
> ext4/xfs/btrfs.
> 
> Current features
>  - multiple devices
>  - replication
>  - tiering
>  - data checksumming and compression (zlib only; also the code doesn't 
> work with
>    tiering yet)
>  - most of the normal posix fs features (no fallocate or quotas yet)
> 
> Planned features:
>  - snapshots!
>  - erasure coding
>  - more
> 
> There will be a longer announcement on LKML/linux-fs in the near future 
> (after
> I'm finished moving) - but I'd like to get it a bit more testing from a 
> wider
> audience first, if possible.

Hi Kent,

one quick question about the roadmap at this point: As far as I 
understand bcachefs basically integrates bcache features directly in the 
filesystem. So does this deprecate bcache itself in your opinion? Bcache 
is obviously still useful for other FS, but I just want to know how 
things will get maintained in the future.

I wanted to suggest / possibly start implementing bcache support for the 
debian installer - obviously that only makes sense if I can expect it to 
be in the mainline kernel for the foreseeable future :-).

Thanks,
~David
