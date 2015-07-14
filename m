From: Kent Overstreet <kent.overstreet@gmail.com>
Subject: [ANNOUNCE] bcachefs!
Date: Mon, 13 Jul 2015 17:58:25 -0700
Message-ID: <20150714005825.GA24027@kmo-pixel>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-bcache-owner@vger.kernel.org>
Received: from mail-pa0-f51.google.com ([209.85.220.51]:33717 "EHLO
	mail-pa0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751767AbbGNA6a (ORCPT
	<rfc822;linux-bcache@vger.kernel.org>);
	Mon, 13 Jul 2015 20:58:30 -0400
Received: by padck2 with SMTP id ck2so51246427pad.0
        for <linux-bcache@vger.kernel.org>; Mon, 13 Jul 2015 17:58:30 -0700 (PDT)
Content-Disposition: inline
Sender: linux-bcache-owner@vger.kernel.org
List-Id: linux-bcache@vger.kernel.org
To: linux-bcache@vger.kernel.org
Cc: sviatoslavpestov@gmail.com, mrubin@google.com, adam.berkan@gmail.com, zab@zabbo.net, rickyb@google.com

Short announcement, because I'm in the process of moving - but I wanted to get
this out there because the code is up and I think it's reasonably stable right
now.

Bcachefs is a posix filesystem that I've been working towards for - well, quite
awhile now: it's intended as a competitor/replacement for ext4/xfs/btrfs.

Current features
 - multiple devices
 - replication
 - tiering
 - data checksumming and compression (zlib only; also the code doesn't work with
   tiering yet)
 - most of the normal posix fs features (no fallocate or quotas yet)

Planned features:
 - snapshots!
 - erasure coding
 - more

There will be a longer announcement on LKML/linux-fs in the near future (after
I'm finished moving) - but I'd like to get it a bit more testing from a wider
audience first, if possible.

You need the bcache-dev branch, and the new bcache tools - be warned, this code
is _not_ compatible with the upstream bcache on disk format:

$ git clone -b bcache-dev http://evilpiepirate.org/git/linux-bcache.git
$ git clone -b dev http://evilpiepirate.org/git/bcache-tools.git

Then do the usual compiling...

# bcacheadm format -C /dev/sda1
# mount /dev/sda1 /mnt

The usual caveats apply - it might eat your data, the on disk format has _not_
been stabilized yet, etc. But it's been reasonably stable for me, and passes all
but 2-3 of the supported xfstests.

Try it out and let me know how it goes!

Also, programmers please check out the bcache guide - feedback is appreciated:

http://bcache.evilpiepirate.org/BcacheGuide/

Thanks!
