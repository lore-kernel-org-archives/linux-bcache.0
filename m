From: Kent Overstreet <kent.overstreet@gmail.com>
Subject: bcachefs status update (it's done cooking; let's get this sucker merged)
Date: Mon, 10 Jun 2019 15:14:08 -0400
Message-ID: <20190610191420.27007-1-kent.overstreet@gmail.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org, linux-bcache@vger.kernel.org
Cc: Kent Overstreet <kent.overstreet@gmail.com>, Dave Chinner <dchinner@redhat.com>, "Darrick J . Wong " <darrick.wong@oracle.com>, Zach Brown <zach.brown@ni.com>, Peter Zijlstra <peterz@infradead.org>, Jens Axboe <axboe@kernel.dk>, Josef Bacik <josef@toxicpanda.com>, Alexander Viro <viro@zeniv.linux.org.uk>, Andrew Morton <akpm@linux-foundation.org>, Linus Torvalds <torvalds@linux-foundation.org>, Tejun Heo <tj@kernel.org>
List-Id: linux-bcache@vger.kernel.org

Last status update: https://lkml.org/lkml/2018/12/2/46

Current status - I'm pretty much running out of things to polish and excuses to
keep tinkering. The core featureset is _done_ and the list of known outstanding
bugs is getting to be short and unexciting. The next big things on my todo list
are finishing erasure coding and reflink, but there's no reason for merging to
wait on those.

So. Here's my bcachefs-for-review branch - this has the minimal set of patches
outside of fs/bcachefs/. My master branch has some performance optimizations for
the core buffered IO paths, but those are fairly tricky and invasive so I want
to hold off on those for now - this branch is intended to be more or less
suitable for merging as is.

https://evilpiepirate.org/git/bcachefs.git/log/?h=bcachefs-for-review

The list of non bcachefs patches is:

closures: fix a race on wakeup from closure_sync
closures: closure_wait_event()
bcache: move closures to lib/
bcache: optimize continue_at_nobarrier()
block: Add some exports for bcachefs
Propagate gfp_t when allocating pte entries from __vmalloc
fs: factor out d_mark_tmpfile()
fs: insert_inode_locked2()
mm: export find_get_pages()
mm: pagecache add lock
locking: SIX locks (shared/intent/exclusive)
Compiler Attributes: add __flatten

Most of the patches are pretty small, of the ones that aren't:

 - SIX locks have already been discussed, and seem to be pretty uncontroversial.

 - pagecache add lock: it's kind of ugly, but necessary to rigorously prevent
   page cache inconsistencies with dio and other operations, in particular
   racing vs. page faults - honestly, it's criminal that we still don't have a
   mechanism in the kernel to address this, other filesystems are susceptible to
   these kinds of bugs too.

   My patch is intentionally ugly in the hopes that someone else will come up
   with a magical elegant solution, but in the meantime it's an "it's ugly but
   it works" sort of thing, and I suspect in real world scenarios it's going to
   beat any kind of range locking performance wise, which is the only
   alternative I've heard discussed.
   
 - Propaget gfp_t from __vmalloc() - bcachefs needs __vmalloc() to respect
   GFP_NOFS, that's all that is.

 - and, moving closures out of drivers/md/bcache to lib/. 

The rest of the tree is 62k lines of code in fs/bcachefs. So, I obviously won't
be mailing out all of that as patches, but if any code reviewers have
suggestions on what would make that go easier go ahead and speak up. The last
time I was mailing things out for review the main thing that came up was ioctls,
but the ioctl interface hasn't really changed since then. I'm pretty confident
in the on disk format stuff, which was the other thing that was mentioned.

----------

This has been a monumental effort over a lot of years, and I'm _really_ happy
with how it's turned out. I'm excited to finally unleash this upon the world.
