From: Kent Overstreet <kent.overstreet@gmail.com>
Subject: Re: bcachefs: can bcachefs export block devices?
Date: Wed, 25 May 2016 14:51:13 -0800
Message-ID: <20160525225113.GA20180@kmo-pixel>
References: <alpine.LRH.2.11.1605251440480.24690@mx.ewheeler.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-bcache-owner@vger.kernel.org>
Received: from mail-pf0-f180.google.com ([209.85.192.180]:35989 "EHLO
	mail-pf0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751577AbcEYWvR (ORCPT
	<rfc822;linux-bcache@vger.kernel.org>);
	Wed, 25 May 2016 18:51:17 -0400
Received: by mail-pf0-f180.google.com with SMTP id f144so10232017pfa.3
        for <linux-bcache@vger.kernel.org>; Wed, 25 May 2016 15:51:16 -0700 (PDT)
Content-Disposition: inline
In-Reply-To: <alpine.LRH.2.11.1605251440480.24690@mx.ewheeler.net>
Sender: linux-bcache-owner@vger.kernel.org
List-Id: linux-bcache@vger.kernel.org
To: Eric Wheeler <bcache@lists.ewheeler.net>
Cc: linux-bcache@vger.kernel.org

On Wed, May 25, 2016 at 02:47:29PM -0700, Eric Wheeler wrote:
> 
> I have a few bcachefs questions that pertain to its use with block 
> devices.  
> 
> Does bcachefs's implementation reuse and update the existing 
> bcache code such that the block device driver inherits the bcachefs 
> improvements?  I understand the cache superblock changed, maybe the cached 
> dev super too.

Yes, all of the existing functionality is still there (though some of it's
broken at the moment because I haven't been running those tests; if you're
interested in using bcache-dev for the old style caching (there are performance
and robustness improvements) it wouldn't take me long to get it working again).

> Can bcachefs provide /dev/bcacheN devices without loop.ko?  
> 
> If so, are these simply filesystem objects (files)?

No, at least not currently - the "export a block device" code and the filesystem
code are effectively thin wrappers around the core bcache IO path (bch_read()
and bch_write()) - but the two different interfaces don't have anything to do
with each other.

The way it works is the first 4096 inode numbers are owned by the block device
interface - inodes in that range are for either cached devices or thin
provisioned volumes. The filesystem code owns inode numbers >= 4096.

So while blockdev volumes/cached data do have inodes, they're not reachable via
the filesystem because there will never be dirents that point to them (also,
they use a different inode type with extra fields for the UUID/label).

However - there isn't anything preventing us from writing a bit of new code and
hooking it up to an ioctl or sysfs interface to say "look up this path and
create a block device for that file". The only remotely tricky bit would be
pagecache cache coherency, but I think you get the new block device to just use
the same address_space (pagecache cache for an inode) as the filesystem inode.

So, probably doable in ~100 lines of code or so.
