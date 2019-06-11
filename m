From: Matthew Wilcox <willy@infradead.org>
Subject: Re: bcachefs status update (it's done cooking; let's get this sucker
 merged)
Date: Tue, 11 Jun 2019 07:26:45 -0700
Message-ID: <20190611142644.GC32656@bombadil.infradead.org>
References: <20190610191420.27007-1-kent.overstreet@gmail.com>
 <CAHk-=wi0iMHcO5nsYug06fV3-8s8fz7GDQWCuanefEGq6mHH1Q@mail.gmail.com>
 <20190611011737.GA28701@kmo-pixel>
 <CAHk-=wizTF+NbMrSRG-bc-LyuT7PUJ1QRAR8q_anOd6mY+9Z4A@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <CAHk-=wizTF+NbMrSRG-bc-LyuT7PUJ1QRAR8q_anOd6mY+9Z4A@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Kent Overstreet <kent.overstreet@gmail.com>, Dave Chinner <dchinner@redhat.com>, Waiman Long <longman@redhat.com>, Peter Zijlstra <peterz@infradead.org>, Linux List Kernel Mailing <linux-kernel@vger.kernel.org>, linux-fsdevel <linux-fsdevel@vger.kernel.org>, linux-bcache@vger.kernel.org, "Darrick J . Wong" <darrick.wong@oracle.com>, Zach Brown <zach.brown@ni.com>, Jens Axboe <axboe@kernel.dk>, Josef Bacik <josef@toxicpanda.com>, Alexander Viro <viro@zeniv.linux.org.uk>, Andrew Morton <akpm@linux-foundation.org>, Tejun Heo <tj@kernel.org>
List-Id: linux-bcache@vger.kernel.org

On Mon, Jun 10, 2019 at 06:55:15PM -1000, Linus Torvalds wrote:
> On Mon, Jun 10, 2019 at 3:17 PM Kent Overstreet
> <kent.overstreet@gmail.com> wrote:
> > > Why does the regular page lock (at a finer granularity) not suffice?
> >
> > Because the lock needs to prevent pages from being _added_ to the page cache -
> > to do it with a page granularity lock it'd have to be part of the radix tree,
> 
> No, I understand that part, but I still think we should be able to do
> the locking per-page rather than over the whole mapping.
> 
> When doing dio, you need to iterate over old existing pages anyway in
> that range (otherwise the "no _new_ pages" part is kind of pointless
> when there are old pages there), so my gut feel is that you might as
> well at that point also "poison" the range you are doin dio on. With
> the xarray changes, we might be better at handling ranges. That was
> one of the arguments for the xarrays over the old radix tree model,
> after all.

We could do that -- if there are pages (or shadow entries) in the XArray,
replace them with "lock entries".  I think we'd want the behaviour of
faults / buffered IO be to wait on those entries being removed.  I think
the DAX code is just about ready to switch over to lock entries instead
of having a special DAX lock bit.

The question is what to do when there are _no_ pages in the tree for a
range that we're about to do DIO on.  This should be the normal case --
as you say, DIO users typically have their own schemes for caching in
userspace, and rather resent the other users starting to cache their
file in the kernel.

Adding lock entries in the page cache for every DIO starts to look pretty
painful in terms of allocating radix tree nodes.  And it gets worse when
you have sub-page-size DIOs -- do we embed a count in the lock entry?
Or delay DIOs which hit in the same page as an existing DIO?

And then I start to question the whole reasoning behind how we do mixed
DIO and buffered IO; if there's a page in the page cache, why are we
writing it out, then doing a direct IO instead of doing a memcpy to the
page first, then writing the page back?

IOW, move to a model where:

 - If i_dio_count is non-zero, buffered I/O waits for i_dio_count to
   drop to zero before bringing pages in.
 - If i_pages is empty, DIOs increment i_dio_count, do the IO and
   decrement i_dio_count.
 - If i_pages is not empty, DIO is implemented by doing buffered I/O
   and waiting for the pages to finish writeback.

(needs a slight tweak to ensure that new DIOs can't hold off a buffered
I/O indefinitely)
