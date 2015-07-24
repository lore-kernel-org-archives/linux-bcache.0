From: Kent Overstreet <kent.overstreet@gmail.com>
Subject: Re: [ANNOUNCE] bcachefs!
Date: Fri, 24 Jul 2015 12:32:52 -0700
Message-ID: <20150724193251.GC1928@kmo-pixel>
References: <20150714005825.GA24027@kmo-pixel>
 <468c161352fd5f77ec371ce256f27e14@de.mcbf.net>
 <55AEBF68.1060008@warr.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-bcache-owner@vger.kernel.org>
Received: from mail-pa0-f45.google.com ([209.85.220.45]:35590 "EHLO
	mail-pa0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754091AbbGXTc4 (ORCPT
	<rfc822;linux-bcache@vger.kernel.org>);
	Fri, 24 Jul 2015 15:32:56 -0400
Received: by pabkd10 with SMTP id kd10so18801407pab.2
        for <linux-bcache@vger.kernel.org>; Fri, 24 Jul 2015 12:32:56 -0700 (PDT)
Content-Disposition: inline
In-Reply-To: <55AEBF68.1060008@warr.net>
Sender: linux-bcache-owner@vger.kernel.org
List-Id: linux-bcache@vger.kernel.org
To: Jason Warr <jason@warr.net>
Cc: David Mohr <david@mcbf.net>, linux-bcache@vger.kernel.org, sviatoslavpestov@gmail.com, mrubin@google.com, adam.berkan@gmail.com, zab@zabbo.net, rickyb@google.com

On Tue, Jul 21, 2015 at 04:53:44PM -0500, Jason Warr wrote:
> 
> 
> On 7/21/2015 1:37 PM, David Mohr wrote:
> >On 2015-07-13 18:58, Kent Overstreet wrote:
> >>Short announcement, because I'm in the process of moving - but I wanted
> >>to get
> >>this out there because the code is up and I think it's reasonably stable
> >>right
> >>now.
> >>
> >>Bcachefs is a posix filesystem that I've been working towards for -
> >>well, quite
> >>awhile now: it's intended as a competitor/replacement for
> >>ext4/xfs/btrfs.
> >>
> >>Current features
> >> - multiple devices
> >> - replication
> >> - tiering
> >> - data checksumming and compression (zlib only; also the code doesn't
> >>work with
> >>   tiering yet)
> >> - most of the normal posix fs features (no fallocate or quotas yet)
> >>
> >>Planned features:
> >> - snapshots!
> >> - erasure coding
> >> - more
> >>
> >>There will be a longer announcement on LKML/linux-fs in the near future
> >>(after
> >>I'm finished moving) - but I'd like to get it a bit more testing from a
> >>wider
> >>audience first, if possible.
> >
> >Hi Kent,
> >
> >one quick question about the roadmap at this point: As far as I understand
> >bcachefs basically integrates bcache features directly in the filesystem.
> >So does this deprecate bcache itself in your opinion? Bcache is obviously
> >still useful for other FS, but I just want to know how things will get
> >maintained in the future.
> >
> It would be rather disappointing if this were the case.  bcache is quite
> useful for backing block devices that have no local filesystem, such as
> devices exported via iSCSI, devices used directly by VMs, etc...

 - bcachefs/bcache2 getting merged is a _long_ way off, and when it does it's
   going to be more of an ext2/ext3 thing - the existing upstream bcache version
   will stay there for the foreseeable future.

 - bcachefs/bcache2 still has all the same functionality bcache has for caching
   other block devices, and exporting thin provisioned block devices - that
   functionality won't be going away any time soon, if ever - so you'll be able
   to migrate to the new bcache code and on disk format without changing
   anything about how you use it.
 
   The "backing device/cached dev" path _might_ eventually get deprecated in
   favor of having bcache manage all the block devices directly and export thin
   provisioned block devices - this is the existing "flash_vol_create"
   functionality.

   Reason being the thin provisioned/fully bcache managed block devices path is
   quite a bit simpler and diverges less from the functionality bcachefs uses -
   and also cache coherency is fundamentally easier with bcache managing all the
   storage so performance should be better too.

   However, if the backing device functionality ever gets removed it's a _long_
   ways off, and I'll be asking for user feedback and making sure the thin
   provisioned/bcache managed block devices functionality works for everyone
   first.
