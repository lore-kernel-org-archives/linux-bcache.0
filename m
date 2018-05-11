From: Kent Overstreet <kent.overstreet@gmail.com>
Subject: Re: [PATCH 1/2] bcachefs: On disk data structures
Date: Fri, 11 May 2018 18:04:00 -0400
Message-ID: <20180511220400.GA10215@moria.home.lan>
References: <20180508221800.2642-1-kent.overstreet@gmail.com>
 <20180508221800.2642-2-kent.overstreet@gmail.com>
 <20180511083233.GX23861@dastard>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20180511083233.GX23861@dastard>
Sender: linux-kernel-owner@vger.kernel.org
To: Dave Chinner <david@fromorbit.com>
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org, linux-bcache@vger.kernel.org, Dave Chinner <dchinner@redhat.com>, "Darrick J . Wong" <darrick.wong@oracle.com>, hare@suse.com
List-Id: linux-bcache@vger.kernel.org

On Fri, May 11, 2018 at 06:32:33PM +1000, Dave Chinner wrote:
> Hi Kent,
> 
> I haven't really had time to digest this in any real detail,
> but I've noticed a couple of things that worry me...
> 
> On Tue, May 08, 2018 at 06:17:59PM -0400, Kent Overstreet wrote:
> > Signed-off-by: Kent Overstreet <kent.overstreet@gmail.com>
> > ---
> >  fs/bcachefs/bcachefs_format.h | 1448 +++++++++++++++++++++++++++++++++
> >  1 file changed, 1448 insertions(+)
> >  create mode 100644 fs/bcachefs/bcachefs_format.h
> > 
> > diff --git a/fs/bcachefs/bcachefs_format.h b/fs/bcachefs/bcachefs_format.h
> > new file mode 100644
> > index 0000000000..0961585c7e
> > --- /dev/null
> > +++ b/fs/bcachefs/bcachefs_format.h
> > @@ -0,0 +1,1448 @@
> > +#ifndef _BCACHEFS_FORMAT_H
> > +#define _BCACHEFS_FORMAT_H
> .....
> > +/* Btree keys - all units are in sectors */
> > +
> > +struct bpos {
> > +	/* Word order matches machine byte order */
> > +#if defined(__LITTLE_ENDIAN)
> > +	__u32		snapshot;
> > +	__u64		offset;
> > +	__u64		inode;
> > +#elif defined(__BIG_ENDIAN)
> > +	__u64		inode;
> > +	__u64		offset;		/* Points to end of extent - sectors */
> > +	__u32		snapshot;
> > +#else
> 
> Mostly my concerns are about these endian constructs - is the on
> disk structure big endian or little endian, and how do you ensure
> that everything you read and write to the on-disk format is in the
> correct endian notation? I think your on-disk format is little
> endian (from the definitions later in the file) but these don't look
> like endian neutral structures....

Darrick already commented on struct bpos too, I added a big comment explaining
what's going on there :)

The majority is little endian/endian neutral. For struct bpos, I'll quote the                                                                         
comment I wrote earlier:

/*
 * Word order matches machine byte order - btree code treats a bpos as a
 * single large integer, for search/comparison purposes
 *
 * Note that wherever a bpos is embedded in another on disk data
 * structure, it has to be byte swabbed when reading in metadata that
 * wasn't written in native endian order:
 */

With the way the core lookup code in bset.c works, this really the only sane way
of doing it - bcache doesn't work on big endian machines, and because within a
key word order does not match machine byte order I tried and gave up trying to
fix it there. I spent a lot of time getting this right when I broke the on disk
format :)

The byte swabbing we have to do when reading in metadata from a different endian
machine is dead simple:

void bch2_bpos_swab(struct bpos *p)
{
	u8 *l = (u8 *) p;
	u8 *h = ((u8 *) &p[1]) - 1;

	while (l < h) {
		swap(*l, *h);
		l++;
		--h;
	}
}

void bch2_bkey_swab_key(const struct bkey_format *_f, struct bkey_packed *k)
{
	const struct bkey_format *f = bkey_packed(k) ? _f : &bch2_bkey_format_current;
	u8 *l = k->key_start;
	u8 *h = (u8 *) (k->_data + f->key_u64s) - 1;

	while (l < h) {
		swap(*l, *h);
		l++;
		--h;
	}
}

> That's apart from the fact all the endian defines make the code
> really hard to read, and probably a pain to maintain, and it doubles
> the test matrix because any on-disk change has to be validate on
> both little endian and big endian machines....

The testing does kind of suck, but it needs to happen anyways, not just for the
structures playing weird endianness games. I just finished fixing ktest's
foreign architecture support, so I'm going to be testing on 32 bit big endian
mips as soon as I finish getting bcachefs-tools to build (I've tested all the
stuff you've pointed out with powerpc virtual machines, but that was ages ago
and the on disk format has had other additions since then).

> > +union bch_extent_entry {
> > +#if defined(__LITTLE_ENDIAN) ||  __BITS_PER_LONG == 64
> > +	unsigned long			type;
> > +#elif __BITS_PER_LONG == 32
> > +	struct {
> > +		unsigned long		pad;
> > +		unsigned long		type;
> > +	};
> > +#else
> 
> This is another worry - using "long" in the on disk structure
> definition. If this is in-meory structures, then use
> le64_to_cpu/cpu_to_le64 to convert the value from the on-disk value
> to the in-memory, cpu order value....

bch_extent is a more debatable use of fancy endianness/byte swabbing tricks...
it's not necessary for any fundamental algorithmic reasons here like it is with
bpos/bkey, it's mainly because as extents are the biggest fraction of total
metadata I was trying to optimize space efficiency as much as possible, without
having the cost of a pack/unpack (like I have for inodes now, which is actually
a bit painful). That and I really hate the KEY_INODE()/SET_KEY_INODE() style
accessors bcache uses.

I'm not sure I'll do that again in the future though, when I wrote that the byte
swabbing for bpos/bkey was my "hey, look at this fancy new hammer!" moment.

I'm not entirely satisfied with the extent encoding anyways though, it's not
really extensible enough and it would be really good to be able to have multiple
checksums at a smaller granularity per extent. Since bch_extent is behind a bkey
type tag though it's pretty straightforward to add a new on disk extent
encoding (I've been working, off and on, on a new format for btree pointer keys
so this isn't theoretical, I've already seen what code has to change to
accomodate this sort of thing).

So basically the bch_extent stuff shouldn't be considered set in stone - it's
been tested and it works and it's good enough for now, but eventually it'll
probably be legacy garbage.

------------

Ok, for the actual explanation of what's going on with bch_extent_entry - like
bkey/bpos it's byte swabbed into native endianness when reading it in, but the
byte swabbing is always over 8 byte words. That is important, because when we do
byte swabbing we don't know what the type tags for the extent entries.

Then, the way the type tag works is it's the position of the first set bit
within an 8 byte word. I did it that way so the type tag in bch_extent_ptr would
only need 1 bit, since it's the most constrained. Probably should have just
added a second bch_extent_ptr type for when the offset won't fit into the
regular one.

So - that block if #ifdefs in bch_extent_entry could be replaced with a single
u64, except then 32 bit big endian machines would need to use __ffs64() to get
the type of an extent entry instead of __ffs().

I will at least add a comment :)

------------

On the subject of fancy encodings... that header doesn't say much about packed
inodes... (don't worry, it's not as bad as extents, I promise).

The first few fields in bch_inode are normal fixed size little endian integers,
but everything else is encoded as variable length integers. There are no type
tags, it's just a straight list of fields. The integer encoding is custom, but
loosely based on utf8:

https://evilpiepirate.org/git/bcachefs.git/tree/fs/bcachefs/inode.c?id=c196a516ecd616fb519514701fbfc30de0b4d448

It's relatively simple, works well enough, but...

 - inode pack/unpack is more expensive than I'd like. It's not huge, but I've
   seen some profiles where it's noticable.

 - I've been adding more options for the IO path, and these new options can be
   filesystem wide or set on a per inode basis. I anticipate the list of options
   to keep growing, so at some point having the fields be a straight list of
   integers with no type tag is going to become an issue (if one inode field is
   set, every field before it must be present; they'll only take up one byte if
   they were all zero, but if an inode has a single option set, and it's the
   80th option... bleh).

Like extents, this stuff is all behind a bkey type tag so it'll be completely
straightforward to introduced a redesigned inode encoding in the future - a lot
easier for inodes than extents since there's less code that touches inodes. So
I'm not in any rush to change the existing inode encoding, but I would like to
start collecting ideas for a bch_inode_v2.
