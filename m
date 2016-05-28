From: Eric Wheeler <bcache@lists.ewheeler.net>
Subject: Re: bcachefs: can bcachefs export block devices?
Date: Fri, 27 May 2016 19:45:32 -0700 (PDT)
Message-ID: <alpine.LRH.2.11.1605271927020.9562@mail.ewheeler.net>
References: <alpine.LRH.2.11.1605251440480.24690@mx.ewheeler.net> <20160525225113.GA20180@kmo-pixel>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-bcache-owner@vger.kernel.org>
Received: from mx.ewheeler.net ([66.155.3.69]:34987 "EHLO mail.ewheeler.net"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752739AbcE1Cpi (ORCPT <rfc822;linux-bcache@vger.kernel.org>);
	Fri, 27 May 2016 22:45:38 -0400
In-Reply-To: <20160525225113.GA20180@kmo-pixel>
Sender: linux-bcache-owner@vger.kernel.org
List-Id: linux-bcache@vger.kernel.org
To: Kent Overstreet <kent.overstreet@gmail.com>
Cc: linux-bcache@vger.kernel.org

> On Wed, May 25, 2016 at 02:47:29PM -0700, Eric Wheeler wrote:
> > Does bcachefs's implementation reuse and update the existing 
> > bcache code such that the block device driver inherits the bcachefs 
> > improvements?  I understand the cache superblock changed, maybe the cached 
> > dev super too.
> 
> Yes, all of the existing functionality is still there (though some of it's
> broken at the moment because I haven't been running those tests; if you're
> interested in using bcache-dev for the old style caching (there are performance
> and robustness improvements) it wouldn't take me long to get it working again).

I can test that once its working.  Would it use the same bcachefs tools 
for formatting superblocks?

Relatedly, can you point out the best place to abstract cachemeta-v1 vs. 
cachemeta-v2 for simultaneous use?  Could it be just a bunch of function 
pointers in the cachedev struct and assignment during initialization for 
v1/v2?  Have the call arguments changed? What functions would need 
abstractions (the smallest v1/v2 intersection)?

> > Can bcachefs provide /dev/bcacheN devices without loop.ko?  
> > 
> > If so, are these simply filesystem objects (files)?
> 
> The way it works is the first 4096 inode numbers are owned by the block device
> interface - inodes in that range are for either cached devices or thin
> provisioned volumes. The filesystem code owns inode numbers >= 4096.
> 
> So while blockdev volumes/cached data do have inodes, they're not reachable via
> the filesystem because there will never be dirents that point to them (also,
> they use a different inode type with extra fields for the UUID/label).

Thats a neat implementation.  Would creating a dirent for such an inode 
expose the block device with the same size and content (and ordering) if 
if the inode were compatable?  Would the blockdev be block-size aligned 
versus the file or might the file have an alignment requirement?

I'm particularly excited about this as a precursor to snapshot support, 
especially if udev could help produce something like this:

  /dev/disk/by-path/bcache-mydiskfile -> /dev/bcacheN
  /dev/disk/by-path/bcache-mydisksnap -> /dev/bcacheN+1


--
Eric Wheeler

On Wed, 25 May 2016, Kent Overstreet wrote:

> 
> However - there isn't anything preventing us from writing a bit of new code and
> hooking it up to an ioctl or sysfs interface to say "look up this path and
> create a block device for that file". The only remotely tricky bit would be
> pagecache cache coherency, but I think you get the new block device to just use
> the same address_space (pagecache cache for an inode) as the filesystem inode.
> 
> So, probably doable in ~100 lines of code or so.
> --
> To unsubscribe from this list: send the line "unsubscribe linux-bcache" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
