From: Kent Overstreet <kent.overstreet@gmail.com>
Subject: [PATCH 0/2] bcachefs: on disk data structures, ioctl interface - review requested for upstreaming
Date: Tue,  8 May 2018 18:17:58 -0400
Message-ID: <20180508221800.2642-1-kent.overstreet@gmail.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org, linux-bcache@vger.kernel.org
Cc: Kent Overstreet <kent.overstreet@gmail.com>, Dave Chinner <dchinner@redhat.com>, "Darrick J . Wong" <darrick.wong@oracle.com>, hare@suse.com
List-Id: linux-bcache@vger.kernel.org

So, a few weeks ago I finally showed up at LSF to talk about this filesystem
I've been working on - as well as upstreaming it - and really the whole thing
was surprisingly uneventful; the general response was "start sending out
patches".

Background for anyone who hasn't heard about bcachefs:
https://www.spinics.net/lists/linux-fsdevel/msg121577.html
https://bcachefs.org

Git repo:
https://evilpiepirate.org/git/bcachefs.git

Dave suggested I start out by sending out just the on disk format and ioctl
interface since the whole thing is over 50k lines, so that's what I'm doing
here. I just wrote a new overview of the on disk data structures, which is at
the top of that patch.

More documentation on the internals is up at the bcachefs website:
https://bcachefs.org/Architecture/

I would definitely appreciate feedback on documentation, and in particular what
kind of documentation would be useful to add.
And if anyone can think of anything critical I might have m

---

Regarding upstreaming status, there's not a whole lot left that I can think of
on my end.

As I mentioned at LSF I've pretty much run out of decent reasons for breaking
the on disk format, so that's one of the big motivations for popping up to talk
about upstreaming this thing now. I've been focusing on polishing and bug fixing
for quite awhile at this point - there are lots of features left that would be
really great to have, but they're not blocking people from using it, people are
finding bcachefs useful right now. The code is - alas - not bug free or perfect
yet, but it is definitely more solid and reliable than a filesystem generally
ought to be at this point in its development and deployment.

I have some patches to core code I'll be sending out shortly, but it's mostly
relatively minor stuff - one of the things Ted asked at LSF was if bcachefs was
going to be making new weird assumptions that the VM has to contend with, and
really no - bcachefs is pretty self contained, no weird page forking or anything
like that.

---

Re bcache: one of the things we talked about at LSF (with Hannes in particular)
is that it would be good to provide an upgrade path to bcache users - the bcache
code is not without issues (i.e. lack of big endian support, which is non
trivial to add without on disk format changes - changes I did do for bcachefs).

Bcachefs is partly just a vastly improved version of bcache, minus the block
layer interface and plus a filesystem interface - but the majority of the code
doesn't know or care about which interface is used, and for most of bcachefs
development I did maintain the bcache block layer interface in parallel with the
filesystem interface.

So providing that upgrade path is one of the goals with upstreaming bcachefs.
How exactly it happens is still undecided, but we've got plenty of options -
since with bcache can detach a cache from a backing device and use it in
passthrough mode at runtime, we don't actually have to teach bcachefs to read
the bcache on disk format, except for the backing device superblock (which be
really hard).

Kent Overstreet (2):
  bcachefs: On disk data structures
  bcachefs: Ioctl interface

 fs/bcachefs/bcachefs_format.h | 1448 +++++++++++++++++++++++++++++++++
 fs/bcachefs/bcachefs_ioctl.h  |  182 +++++
 2 files changed, 1630 insertions(+)
 create mode 100644 fs/bcachefs/bcachefs_format.h
 create mode 100644 fs/bcachefs/bcachefs_ioctl.h

-- 
2.17.0
