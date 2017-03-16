From: Kent Overstreet <kent.overstreet@gmail.com>
Subject: Bcachefs - encryption, fsck, and more
Date: Wed, 15 Mar 2017 16:01:53 -0800
Message-ID: <20170316000153.anljwi2sbipd5uxk@moria.home.lan>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-bcache-owner@vger.kernel.org>
Received: from mail-pg0-f67.google.com ([74.125.83.67]:35495 "EHLO
        mail-pg0-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750877AbdCPAIz (ORCPT
        <rfc822;linux-bcache@vger.kernel.org>);
        Wed, 15 Mar 2017 20:08:55 -0400
Content-Disposition: inline
Sender: linux-bcache-owner@vger.kernel.org
List-Id: linux-bcache@vger.kernel.org
To: linux-bcache@vger.kernel.org, linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org

It's been far too long since the last announcement - lots of stuff has been
happening. The biggest milestone has been all the breaking on disk format
changes finally landing, but there's been lots of other stuff going on, too.

On the subject of the breaking on disk format changes - there's an excellent
chance this'll be the last breaking change, so if you're thinking about trying
out bcachefs this is an excellent time. Also, if you have a filesystem in the
old format, code to read your filesystem is available in the bcachefs-v0 braches
of both linux-bcache and bcache-tools.

More information on getting started with bcachefs is available on the wiki:
https://bcache.evilpiepirate.org/Bcachefs/

What all has changed since the last announcement:

Related to the on disk format changes, we have...
 - Encryption

   We now have whole filesystem encryption - and this is modern authenticated
   encrypted, using ChaCha20 and Poly1305. Bcachefs's encryption isn't a direct
   competitor to ext4's encryption - unlike ext4, we can't currently encrypt
   only part of the filesystem, and then mount and use the rest of the
   filesystem without providing the encryption key. It's more of a better
   dm-crypt - block layer encryption is somewhat of a pile of hacks [1] and it's
   not possible to do authenticated encryption at the block layer, but it is in
   a copy on write filesystem.

   In my (relatively brief) performance testing, bcachefs's encryption performs
   for me almost identically to dm-crypt (which I was surprised by, given that
   they're using completely different ciphers).

   Before you go out and switch to bcachefs encryption though - please be aware,
   the encryption design and code has seen some outside review but it really
   does need more before I'd trust it with anything critical.

   [1] https://sockpuppet.org/blog/2014/04/30/you-dont-want-xts/
 
 - Backup superblocks

   This has been badly needed since our superblocks are now often > 4k and thus
   torn writes leading to checksum failures are a real issue.

 - New inode format

   The new inode format is both more compact and more easily extensible than the
   old one - average real world inode size is now 50-60 bytes. You know what
   makes a filesystem feel fast? Being able to fit all your metadata in ram :)

 - Lots of small changes for better support for multiple devices and replication

   Multiple device support (including caching/tiering) is getting to be pretty
   robust and usable (and people are sucessfully using it for their root
   filesystems - for awhile now, actually). The tooling is getting better, the
   main priority at this point needs to be documentation.

   For replication (i.e. raid1/10), the core functionality all works - you can
   create a replicated filesystem, write data to it, and take one of the drives
   offline while the filesystem is in use - it keeps working, and you can keep
   writing data to it. However, there's still quite a few things that need to be
   finished before it will actually be useful for protecting your data - we need
   to add better tracking for which drives have data and how that data is
   replicated (so we know whether we can take a drive offline or mount without
   it without losing data), as well as replication aware disk space accounting
   and rereplication/scrubbing. But it's coming.


Most of the activity lately has actually been happening in the userspace
tooling, though:

We now have a userspace fsck: we've actually had most of fsck implemented for
quite awhile, but it was implemented in the kernel so it was only possible to
run it at mount time (it runs by default on every mount, because I err towards
paranoia). The new userspace fsck is much more convenient though - it takes all
the normal options (e.g. -n for dry run) and is able to prompt if it finds an
inconsistency.

We didn't get a whole new fsck tool that runs in userspace - what's actually new
here is that I wrote a shim layer to build almost all the bcachefs code in
userspace as part of bcache-tools, which uses it as a library.

This is really cool, and it's made it easy to write some other very useful
tools/subcommands: One is "bcache dump", which takes a filesystem and dumps all
the metadata to a sparse qcow2 image. This is really useful for debugging - if
your bcachefs filesystem gets into a bad state and fsck isn't able to fix it,
dump the metadata and send it to me and I'll debug it from that. We've already
used it for exactly that - and for me the developer, it was a hell of a lot
easier to debug and teach fsck to fix that particular issue that way instead of
having to either get remote access, or debug by sending him patches and waiting
for him to test them. So of the recent changes this might be the one I'm
happiest about :)

We can also now migrate filesystems to bcachefs in place! The bcache migrate
command takes an existing filesystem, fallocates a big file in it, creates a new
filesystem (in userspace) on the block device but using only the space reserved
by that file it fallocated - and then walks the contents of the original
filesystem creating pointers to all your existing data.

You can then mount that new filesystem and verify that everything is correct
without overwriting anything in the existing filesystem (by passing mount the
offset where bcache migrate put the superblock) - and you can even mount both
the old and the new filesystems at the same time (use mount -o noexcl when
mounting the bcachefs filesystem) and use rsync --itemize-changes to verify that
the filesystems really are identical, which is how I test it.

Aside from all that, there's been numerous fixes and performance improvements -
we're still looking for benchmarks/workloads where bcachefs lags other
filesystems, and as we find them they get fixed. Good rigorous performance
testing with new benchmarks is always appreciated.

----------

If you're interested in helping out - come join us in the #bcache IRC channel,
on OFTC. We're trying to get a new website together and get some more
documentation written, so if you have skills in either of those areas (us kernel
programmers don't really do web design) your help would be greatly appreciated.

And as usual, I still need more funding - if you can chip in that's always
greatly appreciated - https://www.patreon.com/bcachefs - or if you're a company
that might be interested in making use of bcachefs, contact me.
