From: Eric Wheeler <bcache@lists.ewheeler.net>
Subject: Re: bcachefs: can bcachefs export block devices?
Date: Thu, 4 Aug 2016 16:46:58 -0700 (PDT)
Message-ID: <alpine.LRH.2.11.1608041633340.10662@mail.ewheeler.net>
References: <alpine.LRH.2.11.1605251440480.24690@mx.ewheeler.net> <20160525225113.GA20180@kmo-pixel> <alpine.LRH.2.11.1605271927020.9562@mail.ewheeler.net> <20160804060846.GB8042@kmo-pixel>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-bcache-owner@vger.kernel.org>
Received: from mx.ewheeler.net ([66.155.3.69]:58986 "EHLO mail.ewheeler.net"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1758637AbcHDXrd (ORCPT <rfc822;linux-bcache@vger.kernel.org>);
	Thu, 4 Aug 2016 19:47:33 -0400
In-Reply-To: <20160804060846.GB8042@kmo-pixel>
Sender: linux-bcache-owner@vger.kernel.org
List-Id: linux-bcache@vger.kernel.org
To: Kent Overstreet <kent.overstreet@gmail.com>
Cc: linux-bcache@vger.kernel.org

On Wed, 3 Aug 2016, Kent Overstreet wrote:

> On Fri, May 27, 2016 at 07:45:32PM -0700, Eric Wheeler wrote:
> > > On Wed, May 25, 2016 at 02:47:29PM -0700, Eric Wheeler wrote:
> > > > Does bcachefs's implementation reuse and update the existing 
> > > > bcache code such that the block device driver inherits the bcachefs 
> > > > improvements?  I understand the cache superblock changed, maybe the cached 
> > > > dev super too.
> > > 
> > > Yes, all of the existing functionality is still there (though some of it's
> > > broken at the moment because I haven't been running those tests; if you're
> > > interested in using bcache-dev for the old style caching (there are performance
> > > and robustness improvements) it wouldn't take me long to get it working again).
> > 
> > I can test that once its working.  Would it use the same bcachefs tools 
> > for formatting superblocks?
> > 
> > Relatedly, can you point out the best place to abstract cachemeta-v1 vs. 
> > cachemeta-v2 for simultaneous use?  Could it be just a bunch of function 
> > pointers in the cachedev struct and assignment during initialization for 
> > v1/v2?  Have the call arguments changed? What functions would need 
> > abstractions (the smallest v1/v2 intersection)?
> 
> You mean compile a kernel that supports both old and new on disk format?
> 
> Realistically the only way that's going to happen is to completely fork the
> source code, ext2/3/4 style.
> Although that's going to have to happen eventually.

Sure, that makes sense.  At what point would you want to do that rename so 
bcache-dev can be pulled into the kernel tree?
	
> > > > Can bcachefs provide /dev/bcacheN devices without loop.ko?  
> > > > 
> > > > If so, are these simply filesystem objects (files)?
> > > 
> > > The way it works is the first 4096 inode numbers are owned by the block device
> > > interface - inodes in that range are for either cached devices or thin
> > > provisioned volumes. The filesystem code owns inode numbers >= 4096.
> > > 
> > > So while blockdev volumes/cached data do have inodes, they're not reachable via
> > > the filesystem because there will never be dirents that point to them (also,
> > > they use a different inode type with extra fields for the UUID/label).
> > 
> > Thats a neat implementation.  Would creating a dirent for such an inode 
> > expose the block device with the same size and content (and ordering) if 
> > if the inode were compatable?  Would the blockdev be block-size aligned 
> > versus the file or might the file have an alignment requirement?
> 
> What we'd want to do is add an ioctl or something to take a fs inode (a normal
> file, that already has a dirent) and create at runtime a block device for it.

You had mentioned changing on-disk format related to this and NFS support.  
Is that coming along too?

> > I'm particularly excited about this as a precursor to snapshot support, 
> > especially if udev could help produce something like this:
> > 
> >   /dev/disk/by-path/bcache-mydiskfile -> /dev/bcacheN
> >   /dev/disk/by-path/bcache-mydisksnap -> /dev/bcacheN+1
> 
> Not sure what you mean by precursor - that would still require essentially the
> entire snapshots implementation. But yes, once we have snapshots we could do
> that too.

Precursor, as in, export an arbitrary file as a blockdev even if snapshots 
aren't ready yet.  I can start testing in our testbed once files can be 
exported as blocks, whether or not they support snapshots.

Other questions:

Is FIEMAP supported so uncached fils can be read in disk-linear order?  
Hmm, I wonder, what does FIEMAP even mean when the file spreads across 
multiple disks?  Maybe it doesn't apply here.  Really what I'm looking for 
is a way to list which blocks have changed between two snapshots for easy 
incremental backups (eg, `btrfs send`).


I'm excited about checksum support.  If an SSD bitflips, will it fail the 
whole disk, or just report an error and attempt to re-read from another 
volume?  

Right now btrfs/zfs is the only viable checksum filesystem with recovery, 
and there aren't any viable blockdevice checksumming implementations 
(dm-csum didn't take off and the PoC academic example splicing into md 
raid isn't really ready either).


--
Eric Wheeler
