From: Kent Overstreet <kent.overstreet@gmail.com>
Subject: Re: bcachefs: can bcachefs export block devices?
Date: Fri, 5 Aug 2016 20:34:38 -0800
Message-ID: <20160806043438.GA579@kmo-pixel>
References: <alpine.LRH.2.11.1605251440480.24690@mx.ewheeler.net>
 <20160525225113.GA20180@kmo-pixel>
 <alpine.LRH.2.11.1605271927020.9562@mail.ewheeler.net>
 <20160804060846.GB8042@kmo-pixel>
 <alpine.LRH.2.11.1608041633340.10662@mail.ewheeler.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-bcache-owner@vger.kernel.org>
Received: from mail-pf0-f177.google.com ([209.85.192.177]:32929 "EHLO
	mail-pf0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750979AbcHFUX7 (ORCPT
	<rfc822;linux-bcache@vger.kernel.org>);
	Sat, 6 Aug 2016 16:23:59 -0400
Received: by mail-pf0-f177.google.com with SMTP id y134so107021835pfg.0
        for <linux-bcache@vger.kernel.org>; Sat, 06 Aug 2016 13:23:58 -0700 (PDT)
Content-Disposition: inline
In-Reply-To: <alpine.LRH.2.11.1608041633340.10662@mail.ewheeler.net>
Sender: linux-bcache-owner@vger.kernel.org
List-Id: linux-bcache@vger.kernel.org
To: Eric Wheeler <bcache@lists.ewheeler.net>
Cc: linux-bcache@vger.kernel.org

On Thu, Aug 04, 2016 at 04:46:58PM -0700, Eric Wheeler wrote:
> On Wed, 3 Aug 2016, Kent Overstreet wrote:
> > On Fri, May 27, 2016 at 07:45:32PM -0700, Eric Wheeler wrote:
> >
> > Realistically the only way that's going to happen is to completely fork the
> > source code, ext2/3/4 style.
> > Although that's going to have to happen eventually.
> 
> Sure, that makes sense.  At what point would you want to do that rename so 
> bcache-dev can be pulled into the kernel tree?

Probably not until after the on disk format is stabilized for good, which isn't
going to be until after snapshots are at least minimally working.

> > > > The way it works is the first 4096 inode numbers are owned by the block device
> > > > interface - inodes in that range are for either cached devices or thin
> > > > provisioned volumes. The filesystem code owns inode numbers >= 4096.
> > > > 
> > > > So while blockdev volumes/cached data do have inodes, they're not reachable via
> > > > the filesystem because there will never be dirents that point to them (also,
> > > > they use a different inode type with extra fields for the UUID/label).
> > > 
> > > Thats a neat implementation.  Would creating a dirent for such an inode 
> > > expose the block device with the same size and content (and ordering) if 
> > > if the inode were compatable?  Would the blockdev be block-size aligned 
> > > versus the file or might the file have an alignment requirement?
> > 
> > What we'd want to do is add an ioctl or something to take a fs inode (a normal
> > file, that already has a dirent) and create at runtime a block device for it.
> 
> You had mentioned changing on-disk format related to this and NFS support.  
> Is that coming along too?

Yeah, the transactions stuff I wrote about on Patreon is for NFS support. I
think I'll be able to do NFS support without an on disk format change, but I
will need an on disk format change at some point.

> 
> > > I'm particularly excited about this as a precursor to snapshot support, 
> > > especially if udev could help produce something like this:
> > > 
> > >   /dev/disk/by-path/bcache-mydiskfile -> /dev/bcacheN
> > >   /dev/disk/by-path/bcache-mydisksnap -> /dev/bcacheN+1
> > 
> > Not sure what you mean by precursor - that would still require essentially the
> > entire snapshots implementation. But yes, once we have snapshots we could do
> > that too.
> 
> Precursor, as in, export an arbitrary file as a blockdev even if snapshots 
> aren't ready yet.  I can start testing in our testbed once files can be 
> exported as blocks, whether or not they support snapshots.

I may have asked this before, but is loopback really not good enough? I thought
performance of the loopback driver had improved recently (I know Christoph was
working on this).

> Other questions:
> 
> Is FIEMAP supported so uncached fils can be read in disk-linear order?  
> Hmm, I wonder, what does FIEMAP even mean when the file spreads across 
> multiple disks?  Maybe it doesn't apply here.  Really what I'm looking for 
> is a way to list which blocks have changed between two snapshots for easy 
> incremental backups (eg, `btrfs send`).

Yeah, fiemap works. I don't remember if there's any provisions in fiemap for
multiple devices.

We'll have real send/receive at some point though - we've got a version number
field in struct bkey, so we'll have a "send all keys greater than version number
foo".

> I'm excited about checksum support.  If an SSD bitflips, will it fail the 
> whole disk, or just report an error and attempt to re-read from another 
> volume?  

It'll fail that individual IO, and whether or not it fails the entire device
should be configurable (don't believe it is yet).

It should reread from another replica if available but I'm not sure if that's
done yet - I haven't looked at what's left with replication in quite awhile.

> Right now btrfs/zfs is the only viable checksum filesystem with recovery, 
> and there aren't any viable blockdevice checksumming implementations 
> (dm-csum didn't take off and the PoC academic example splicing into md 
> raid isn't really ready either).

Maybe I'll start working more on the replication stuff, it would be nice to get
that stuff finished off... Are you chipping in on Patreon? :)
