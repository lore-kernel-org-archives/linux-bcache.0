From: Ming Lin <mlin@kernel.org>
Subject: Re: [ANNOUNCE] bcachefs!
Date: Tue, 14 Jul 2015 23:11:29 -0700
Message-ID: <1436940689.6520.1.camel@hasee>
References: <20150714005825.GA24027@kmo-pixel>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-bcache-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.136]:56741 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751597AbbGOGLc (ORCPT <rfc822;linux-bcache@vger.kernel.org>);
	Wed, 15 Jul 2015 02:11:32 -0400
In-Reply-To: <20150714005825.GA24027@kmo-pixel>
Sender: linux-bcache-owner@vger.kernel.org
List-Id: linux-bcache@vger.kernel.org
To: Kent Overstreet <kent.overstreet@gmail.com>
Cc: linux-bcache@vger.kernel.org, sviatoslavpestov@gmail.com, mrubin@google.com, adam.berkan@gmail.com, zab@zabbo.net, rickyb@google.com

On Mon, 2015-07-13 at 17:58 -0700, Kent Overstreet wrote:
> Short announcement, because I'm in the process of moving - but I wanted to get
> this out there because the code is up and I think it's reasonably stable right
> now.
> 
> Bcachefs is a posix filesystem that I've been working towards for - well, quite
> awhile now: it's intended as a competitor/replacement for ext4/xfs/btrfs.
> 
> Current features
>  - multiple devices
>  - replication
>  - tiering
>  - data checksumming and compression (zlib only; also the code doesn't work with
>    tiering yet)
>  - most of the normal posix fs features (no fallocate or quotas yet)
> 
> Planned features:
>  - snapshots!
>  - erasure coding
>  - more
> 
> There will be a longer announcement on LKML/linux-fs in the near future (after
> I'm finished moving) - but I'd like to get it a bit more testing from a wider
> audience first, if possible.
> 
> You need the bcache-dev branch, and the new bcache tools - be warned, this code
> is _not_ compatible with the upstream bcache on disk format:
> 
> $ git clone -b bcache-dev http://evilpiepirate.org/git/linux-bcache.git
> $ git clone -b dev http://evilpiepirate.org/git/bcache-tools.git
> 
> Then do the usual compiling...
> 
> # bcacheadm format -C /dev/sda1
> # mount /dev/sda1 /mnt

How to mount it?

root@afa03:~# bcacheadm format -C /dev/sdt
UUID:			87b0f1e2-e0dc-4453-b0c0-6afca64d402c
Set UUID:		b5f3bc6a-2aab-4fe1-a8db-e35cc763388c
version:		6
nbuckets:		143051
block_size:		1
bucket_size:		4096
nr_in_set:		1
nr_this_dev:		0
first_bucket:		3

root@afa03:~# mount /dev/sdt /mnt/
mount: mount(2) failed: No such file or directory

root@afa03:~# mount -t bcache /dev/sdt /mnt/
mount: mount(2) failed: No such file or directory
